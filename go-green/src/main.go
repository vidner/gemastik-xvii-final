package main

import (
	"fmt"
	"os"
)

func main() {
	data, err := os.ReadFile("/flag.txt")
	if err != nil {
		fmt.Println("Error reading flag:", err)
		return
	}
	flag := string(data)
	money := 420
	choice := 0

	fmt.Println("go-green @ gemastik-xvii")

	fmt.Printf("you have $%d money\n", money)
	fmt.Println("1. donate")
	fmt.Println("2. admin")

	for {
		fmt.Print("choice? ")
		fmt.Scanln(&choice)

		switch choice {
		
		case 1:
			var donate int
			fmt.Print("how much money? ")
			fmt.Scanln(&donate)

			if donate > money {
				fmt.Println("not enough money")
				return
			}

			if donate >= 1337 {
				fmt.Println("you are a generous person")
				fmt.Println(flag)
			}

			money -= donate
			fmt.Println("thanks for your contribution to a more sustainable future")
			fmt.Printf("you have $%d money left\n", money)
		
		case 2:
			var password string
			fmt.Print("password? ")
			fmt.Scanln(&password)

			if password == flag {
				money += 1337
				fmt.Println("welcome admin")
			} else {
				fmt.Println("invalid password")
			}
		
		default:
			fmt.Println("invalid choice")
			return
		}
	}
}
