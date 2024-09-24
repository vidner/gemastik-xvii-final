import hashlib
from fastecdsa import curve, ecdsa

def H(m):
    return decode(hashlib.shake_256(m).digest(128))

def encode(x):
    return int.to_bytes(x, 32, 'big')

def decode(b):
    return int.from_bytes(b, 'big') % curve.secp256k1.q

def keygen(seed):
    pk = H(seed)
    vk = pk * curve.secp256k1.G

    return pk, vk

def prove(m, pk):
    u, z = ecdsa.sign(m, pk, curve.secp256k1)
    return encode(u)+encode(z)

def verify(m, vk, proof):
    if len(proof) != 64:
        return False

    u, z = decode(proof[:32]), decode(proof[32:])
    return ecdsa.verify((u, z), m, vk, curve.secp256k1)