import random
import signal

FLAG = open("../flag.txt").read()


class GiftShop:
    # TODO: design better giftcard generator and validator

    def __init__(self, name: str) -> None:
        self.mod = lambda x: x % 256
        self.Hm = self.mod(sum(name.encode()))

    def generate_giftcard(self) -> str:
        r = random.randbytes(15)
        s = int.to_bytes(self.mod(self.Hm - self.mod(sum(r))))
        signature = r + s
        return signature.hex()

    def validate_giftcard(self, giftcard: str) -> bool:
        signature = bytes.fromhex(giftcard)
        return len(signature) == 16 and self.mod(sum(signature)) == self.Hm


class Challenge:
    def __init__(self, name):
        self.name = name
        self.balance = 100
        self.items = {
            "bread": {"price": 33, "callable": self.__get_bread},
            "giftcard": {"price": 50, "callable": self.__get_giftcard},
            "flag": {"price": 420, "callable": self.__get_flag},
        }
        self.redeemed_giftcard = set()
        self.gift_shop = GiftShop(self.name)

    def greet(self):
        msg = ""
        msg += f"\nWelcome, {self.name}!"
        msg += f"\nOption:"
        msg += f"\n  [1] Check available items"
        msg += f"\n  [2] Buy item"
        msg += f"\n  [3] Redeem giftcard"
        msg += f"\n  [9] Input admin code"
        print(msg)

    def __get_bread(self):
        return chr(0x1F35E)

    def __get_giftcard(self):
        return self.gift_shop.generate_giftcard()

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

    def redeem_giftcard(self, giftcard):
        if giftcard in self.redeemed_giftcard:
            return "Your giftcard is already used"

        if not self.gift_shop.validate_giftcard(giftcard):
            return "Your giftcard is invalid"

        value = random.randint(30, 60)
        self.balance += value
        self.redeemed_giftcard.add(giftcard)
        return f"You got ${value} from the giftcard"

    def admin_code(self, code):
        if code != FLAG:
            return "Incorrect code"

        self.balance += self.items["flag"]["price"]
        return "Correct code"


def user_input(s):
    inp = input(s).strip()
    assert len(inp) < 256
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
                giftcard = user_input("Giftcard: ")
                print(challenge.redeem_giftcard(giftcard))
            case 9:
                code = user_input("Code: ")
                print(challenge.admin_code(code))
            case _:
                print("Invalid option")
                break


if __name__ == "__main__":
    signal.alarm(60)
    main()
