import random
import time
import pok

FLAG = open("../flag.txt", "r").read()

TICKET_PRICE = {
    "normal": 2,
    "premium": 5,
    "VIP": 10,
    "FLAG": 100,
}

TICKET_VALUE = {
    "normal": 1,
    "premium": 3,
    "VIP": 5,
}


class Ticketer:
    def __init__(self, username: str):
        pk, vk = pok.keygen(username.encode())
        self.username = username
        self.proving_key = pk
        self.verifying_key = vk
        self.balance = 10
        self.used_tickets = []
        self.issued_tickets = {}

    def buy_ticket(self, ticket_type):
        price = TICKET_PRICE.get(ticket_type)
        if self.balance >= price:
            self.balance -= price
            new_ticket_id = int.to_bytes(random.getrandbits(128), 16, "big").hex()
            self.issued_tickets[new_ticket_id] = ticket_type
            ticket = pok.prove(new_ticket_id.encode(), self.proving_key)

            if ticket_type == "FLAG":
                print(FLAG)
            else:
                print(f"Your ticket: {new_ticket_id+ticket.hex()}")
        else:
            print("[ERROR] Insufficient balance")

    def refund_ticket(self):
        try:
            ticket = input("Input ticket: ")
            ticket_id, proof = ticket[:32], bytes.fromhex(ticket[32:])

            if pok.verify(ticket_id.encode(), self.verifying_key, proof):
                if ticket_id in self.issued_tickets and ticket not in self.used_tickets:
                    ticket_type = self.issued_tickets.get(ticket_id)
                    value = TICKET_VALUE.get(ticket_type, 0)
                    self.balance += value
                    self.used_tickets.append(ticket)
                    print("Ticket succesfully refunded!")
                else:
                    print("[ERROR] Invalid ticket")
            else:
                print("[ERROR] Invalid ticket")
        except Exception:
            print("[ERROR] Invalid ticket")

    def checker_menu(self):
        self.balance = 150

    def menu(self):
        print("[1] Buy normal ticket      ($2)")
        print("[2] Buy premium ticket     ($5)")
        print("[3] Buy VIP ticket         ($10)")
        print("[4] Buy FLAG ticket        ($100)")
        print("[5] Refund ticket")
        print("[6] Exit")
        print("")
        print(f"Your balance: ${self.balance}")


def main():

    username = input("Username: ")
    ticketer = Ticketer(username)

    while True:
        time.sleep(0.5)
        ticketer.menu()
        option = input("$> ")
        if option == "1":
            ticketer.buy_ticket("normal")
        elif option == "2":
            ticketer.buy_ticket("premium")
        elif option == "3":
            ticketer.buy_ticket("VIP")
        elif option == "4":
            ticketer.buy_ticket("FLAG")
        elif option == "5":
            ticketer.refund_ticket()
        elif option == FLAG:
            ticketer.checker_menu()
        else:
            break


if __name__ == "__main__":
    main()
