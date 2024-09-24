from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA
import os
import random
import signal
import base64

FLAG = open("../flag.txt").read()


class GiftShop:
    def __init__(self, name: str) -> None:
        self.key = RSA.generate(1024)
        self.Hm = SHA256.new(name.encode()).digest()
        self.prefix = b"\x00\x02"
        self.null = b"\x00"

    def generate_voucher(self) -> str:
        message = self.prefix + os.urandom(93) + self.null + self.Hm
        voucher = pow(int.from_bytes(message, "big"), self.key.d, self.key.n)
        return base64.b64encode(int.to_bytes(voucher, 128, "big")).decode()

    def validate_voucher(self, voucher: str) -> bool:
        voucher = int.from_bytes(base64.b64decode(voucher.encode()), "big")
        message = int.to_bytes(pow(voucher, self.key.e, self.key.n), 128, "big")
        return (
            voucher.bit_length() <= 1024
            and message.startswith(self.prefix)
            and message.endswith(self.null + self.Hm)
        )


class Challenge:
    def __init__(self, name):
        self.name = name
        self.balance = 100
        self.items = {
            "bread": {"price": 33, "callable": self.__get_bread},
            "voucher": {"price": 50, "callable": self.__get_voucher},
            "flag": {"price": 420, "callable": self.__get_flag},
        }
        self.redeemed_voucher = set()
        self.gift_shop = GiftShop(self.name)

    def greet(self):
        msg = ""
        msg += f"\nWelcome, {self.name}!"
        msg += f"\nOption:"
        msg += f"\n  [1] Check available items"
        msg += f"\n  [2] Buy item"
        msg += f"\n  [3] Redeem voucher"
        msg += f"\n  [9] Input admin code"
        print(msg)

    def __get_bread(self):
        return self.gift_shop.key.public_key().export_key().decode().replace('-', chr(0x1F35E))

    def __get_voucher(self):
        return self.gift_shop.generate_voucher()

    def __get_flag(self):
        return FLAG

    def check_available(self):
        msg = ""
        msg += f"\nAvailable items:"
        for item_name, item_info in self.items.items():
            item_price = item_info["price"]
            msg += f"\n  [+] {item_name} (${item_price})"
        return msg

    def buy_item(self, item):
        if item not in self.items.keys():
            return f"Item {item} is not available"

        if self.balance < self.items[item]["price"]:
            return f"Insufficient balance"

        self.balance -= self.items[item]["price"]
        return self.items[item]["callable"]()

    def redeem_voucher(self, voucher):
        if voucher in self.redeemed_voucher:
            return "Your voucher is already used"

        if not self.gift_shop.validate_voucher(voucher):
            return "Your voucher is invalid"

        value = random.randint(30, 60)
        self.balance += value
        self.redeemed_voucher.add(voucher)
        return f"You got ${value} from the voucher"

    def admin_code(self, code):
        if code != FLAG:
            return "Incorrect code"

        self.balance += self.items["flag"]["price"]
        return "Correct code"


def user_input(s):
    inp = input(s).strip()
    assert len(inp) < 1024
    return inp


def main():
    name = user_input("Name: ")
    challenge = Challenge(name)
    challenge.greet()

    while True:
        print(f"\nCurrent balance: ${challenge.balance}")
        match int(user_input("> ")):
            case 1:
                print(challenge.check_available())
            case 2:
                item = user_input("Item: ")
                print(challenge.buy_item(item))
            case 3:
                voucher = user_input("Voucher: ")
                print(challenge.redeem_voucher(voucher))
            case 9:
                code = user_input("Code: ")
                print(challenge.admin_code(code))
            case _:
                print("Invalid option")
                break


if __name__ == "__main__":
    signal.alarm(60)
    main()
