import ctypes
from ctypes.util import find_library
from random import randbytes
from typing import Any

from unicorn import Uc, UcError, x86_const
from unicorn.unicorn_const import UC_ARCH_X86, UC_HOOK_INSN, UC_MODE_64

MAX_NOTES = 16

engine = Uc(UC_ARCH_X86, UC_MODE_64)
notes = [0 for _ in range(MAX_NOTES)]
libc = ctypes.CDLL(find_library("c"))


def find_empty():
    for i in range(MAX_NOTES):
        if notes[i] == 0:
            return i
    return -1


def syscall(uc: Uc, data: Any):
    rax = uc.reg_read(x86_const.UC_X86_REG_RAX)
    rdi = uc.reg_read(x86_const.UC_X86_REG_RDI)
    rsi = uc.reg_read(x86_const.UC_X86_REG_RSI)
    rdx = uc.reg_read(x86_const.UC_X86_REG_RDX)

    def create(size):
        idx = find_empty()
        if idx == -1:
            uc.reg_write(x86_const.UC_X86_REG_RAX, -1)
            return

        notes[idx] = libc.malloc(size)

        uc.reg_write(x86_const.UC_X86_REG_RAX, idx)
        return

    def edit(idx, buf, size):
        if notes[idx] == 0:
            uc.reg_write(x86_const.UC_X86_REG_RAX, -1)
            return

        ubuf = uc.mem_read(buf, size)
        ctypes.memmove(
            notes[idx],
            ctypes.create_string_buffer(bytes(ubuf)),
            size,
        )

        uc.reg_write(x86_const.UC_X86_REG_RAX, 0)
        return

    def delete(idx):
        if notes[idx] == 0:
            uc.reg_write(x86_const.UC_X86_REG_RAX, -1)
            return

        libc.free(notes[idx])
        notes[idx] = 0

        uc.reg_write(x86_const.UC_X86_REG_RAX, 0)
        return

    def view(idx, buf, size):
        if notes[idx] == 0:
            uc.reg_write(x86_const.UC_X86_REG_RAX, -1)
            return

        libc.puts(notes[idx])

        kbuf = ctypes.string_at(notes[idx], size)
        uc.mem_write(buf, kbuf)

        uc.reg_write(x86_const.UC_X86_REG_RAX, 0)
        return

    def dbg():
        print(f"RAX {uc.reg_read(x86_const.UC_X86_REG_RAX):#x}")
        print(f"RBX {uc.reg_read(x86_const.UC_X86_REG_RBX):#x}")
        print(f"RCX {uc.reg_read(x86_const.UC_X86_REG_RCX):#x}")
        print(f"RDX {uc.reg_read(x86_const.UC_X86_REG_RDX):#x}")
        print(f"RDI {uc.reg_read(x86_const.UC_X86_REG_RDI):#x}")
        print(f"RSI {uc.reg_read(x86_const.UC_X86_REG_RSI):#x}")
        print(f"R8  {uc.reg_read(x86_const.UC_X86_REG_R8):#x}")
        print(f"R9  {uc.reg_read(x86_const.UC_X86_REG_R9):#x}")
        print(f"R10 {uc.reg_read(x86_const.UC_X86_REG_R10):#x}")
        print(f"R11 {uc.reg_read(x86_const.UC_X86_REG_R11):#x}")
        print(f"R12 {uc.reg_read(x86_const.UC_X86_REG_R12):#x}")
        print(f"R13 {uc.reg_read(x86_const.UC_X86_REG_R13):#x}")
        print(f"R14 {uc.reg_read(x86_const.UC_X86_REG_R14):#x}")
        print(f"R15 {uc.reg_read(x86_const.UC_X86_REG_R15):#x}")
        print(f"RBP {uc.reg_read(x86_const.UC_X86_REG_RBP):#x}")
        print(f"RSP {uc.reg_read(x86_const.UC_X86_REG_RSP):#x}")
        print(f"RIP {uc.reg_read(x86_const.UC_X86_REG_RIP):#x}")

    if rax == 1:
        create(rdi)
    elif rax == 2:
        edit(rdi, rsi, rdx)
    elif rax == 3:
        delete(rdi)
    elif rax == 4:
        view(rdi, rsi, rdx)
    elif rax == 5:
        dbg()
    else:
        uc.emu_stop()
        raise ValueError("invalid syscall number")


def main():
    code_sz = 8 << 20  # 8MB
    base = 0x400000
    engine.mem_map(base, code_sz)

    stack_sz = 2 << 20  # 2MB
    stack = int.from_bytes(randbytes(5), "big") & ~0xFFF
    stack = 0x7FF0_00000000 | stack
    engine.mem_map(stack, stack_sz)

    engine.hook_add(UC_HOOK_INSN, syscall, None, 1, 0,
                    x86_const.UC_X86_INS_SYSCALL)

    while True:
        try:
            code = input("Code (in hex): ")
            sc = bytes.fromhex(code)[:code_sz]
            break
        except ValueError:
            pass

    engine.reg_write(x86_const.UC_X86_REG_RSP, stack + stack_sz - 0x1000)

    engine.mem_write(base, sc)

    try:
        engine.emu_start(base, base + code_sz, 30_000)  # 30s
    except (ValueError, UcError) as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
