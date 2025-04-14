#!/bin/bash

# game.sh
# Game's Name: Blackjack Game
#
# USAGE: ./game.sh
#
# Author: Nguyen Dao Tuan Anh
# Date: April 13, 2025


# Global variables
player_cash=1000
current_bet=0
player_hand=()
dealer_hand=()
player_hand_total=0
dealer_hand_total=0
dealer_hidden_card=0

# Logo of the game
logo="
    .------.             _     _            _    _            _    
    |A_  _ |.           | |   | |          | |  (_)          | |   
    |( \\\/).-----.      | |__ | | __ _  ___| | ___  __ _  ___| | __
    | \\  /|K /\\  |      | '_ \\| |/ _\` |/ __| |/ / |/ _\` |/ __| |/ /
    |  \\/ | /  \\ |      | |_) | | (_| | (__|   <| | (_| | (__|   < 
    \`-----| \\  / |      |_.__/|_|\\__,_|\\___|_|\\_\\ |\\__,_|\\___|_|\\_\\\\
          |  \\/ K|                            _/ |                
          \`------'                           |__/           
"

# Function to initialize the game
initialize_game() 
{
	player_cash=1000
	clear 
	echo "$logo"
	echo "Welcome to Blackjack Game!"
	echo "You have $"$player_cash" cash to play with."
	echo ""
	read -p "Press Enter to start playing..." dummy
}


# Function to draw a random card (1 to 10)
draw_card() 
{
	# Generate a random number between 1 and 13 (representing cards 1-10, J, Q, K)
	local card=$((RANDOM % 13 + 1))

	# Convert face cards to value 10
	if [ $card -gt 10 ]; then
		card=10
	fi

	return $card
}

# Function to get the name of a card
get_card_name() 
{
	local card_value=$1
	local card_name

	if [ $card_value -eq 1 ]; then
		card_name="Ace (1/11)"
	elif [ $card_value -eq 11 ]; then
		card_name="Jack (10)"
	elif [ $card_value -eq 12 ]; then
		card_name="Queen (10)"
	elif [ $card_value -eq 13 ]; then
		card_name="King	(10)"
	else	
		card_name="$card_value"
	fi

	echo "$card_name" 
}


# Function to deal initial cards
deal_initial_cards()
{
	# Reset hands
	player_hand=()
	dealer_hand=()

	# Deal two cards to player
	for i in {1..2}; do
		draw_card
		local card=$?
		player_hand+=($card)
	done

	# Deal two cards to dealer (one visible, one hidden)
	draw_card
	dealer_hand+=($?)

	draw_card
	dealer_hidden_card=$?
	dealer_hand+=($dealer_hidden_card)

	# Calculate initial totals
	calculate_hand "player"
	calculate_hand "dealer" "hidden"
}


# Function to calculate the value of a hand
calculate_hand()
{
	local hand_type=$1
	local visibility=$2
	local total=0
	local hand
	local ace_count=0

	if [ "$hand_type" == "player" ]; then
		hand=("${player_hand[@]}")
	else # dealer
		hand=("${dealer_hand[@]}")

		# If hidden mode, only count the first card
		if [ "$visibility" == "hidden" ]; then 
			if [ ${hand[0]} -eq 1 ]; then # If first card is Ace
				total=11 # Count as 11 initially
			else
				total=${hand[0]}
			fi
			dealer_hand_total=$total
			return
		fi
	fi

	# Count aces and calculate total
	for card in "${hand[@]}"; do
		if [ $card -eq 1 ]; then # Ace
			ace_count=$((ace_count + 1))
			total=$((total + 11)) # Count as 11 initially
		else
			total=$((total + card))
		fi
	done

	# Convert Aces From 11 to 1 as needed to avoid busting
	while [ $ace_count -gt 0 ] && [ $total -gt 21 ]; do
		total=$((total - 10)) # Convert one Ace from 11 to 1
		ace_count=$((ace_count - 1))
	done

	# Update the global variable
	if [ "$hand_type" == "player" ]; then
		player_hand_total=$total
	else
		dealer_hand_total=$total
	fi
}


# Function to display current game status
display_status()
{
	local visibility=$1
	clear
    echo "========================================"
    echo "             BLACKJACK                 "
    echo "========================================"
    echo "Your cash: $player_cash | Current bet: $current_bet"
    echo "----------------------------------------"

	echo "Your hand:"
    for card in "${player_hand[@]}"; do
        echo "  [$(get_card_name $card)]"
    done
    echo "Your total: $player_hand_total"
    echo "----------------------------------------"
    
    echo "Dealer's hand:"
    if [ "$visibility" == "hidden" ]; then
        echo "  [$(get_card_name ${dealer_hand[0]})]"
        echo "  [Hidden]"
        echo "Dealer's visible total: ${dealer_hand[0]}"
    else
        for card in "${dealer_hand[@]}"; do
            echo "  [$(get_card_name $card)]"
        done
        echo "Dealer's total: $dealer_hand_total"
    fi
    echo "========================================"
}


# Function to handle player's turn
player_turn()
{
	local choice=""

	while true; do
		display_status "hidden"

		# Check if player busts
		if [ $player_hand_total -gt 21 ]; then
			echo "Bust! Your total is over 21"
			sleep 2
			return
		fi

		# Ask for player's choice
		echo "What would you like to do?"
		echo "1. Hit (take another card)"
		echo "2. Stand (end your turn)"
		read -p "Enter your choice (1 or 2): " choice

		if [ "$choice" = "1" ]; then # Hit
			draw_card
			local new_card=$?
			player_hand+=($new_card)
			calculate_hand "player"
			echo "You drew a $(get_card_name $new_card)."
			sleep 1
		elif [ "$choice" = "2" ]; then # Stand
			echo "You choose to stand."
			sleep 1
			return
		else # Invalid Choice
			echo "Invalid choice. Please only enter 1 or 2."
			sleep 1
		fi
	done
}


# Function to handle dealer's turn
dealer_turn()
{
	# Reveal dealer's hidden card
	calculate_hand "dealer"
	display_status "visible"
	echo "Dealer reveals hidden card: $(get_card_name $dealer_hidden_card)"
	sleep 2

	# Dealer hits until 16 or higher
	while [ $dealer_hand_total -lt 16 ]; do
		draw_card
		local new_card=$?
		dealer_hand+=($new_card)
		calculate_hand "dealer"

		display_status "visible"
		echo "Dealer draws: $(get_card_name $new_card)"
		echo "Dealer's total is now: $dealer_hand_total"
		sleep 2
	done

	if [ $dealer_hand_total -gt 21 ]; then
		echo "Dealer busts!"
		sleep 2
	else
		echo "Dealer stands with $dealer_hand_total."
		sleep 2
	fi
}


# Function to determine the winner
determine_winner()
{
	display_status "visible"

	# Player busts
	if [ $player_hand_total -gt 21 ]; then
		echo "You busts! Dealer wins."
		return 0
	fi

	# Dealer busts
	if [ $dealer_hand_total -gt 21 ]; then
		echo "Dealer busts! You win!"
		return 1
	fi

	# Compare totals
	if [ $player_hand_total -gt $dealer_hand_total ]; then
		echo "Your $player_hand_total beats dealer's $dealer_hand_total. You win!"
		return 1
	elif [ $player_hand_total -lt $dealer_hand_total ]; then
		echo "Dealer's $dealer_hand_total beats your $player_hand_total. Dealer wins!"
		return 0
	else 
		echo "It's a tie! Push."
		return 2
	fi
}


# Function to adjust player balance based on outcome
adjust_balance()
{
	local result=$1

	if [ $result -eq 0 ]; then # Player loses
		echo "You lost $current_bet."
	elif [ $result -eq 1 ]; then # Player wins
		player_cash=$((player_cash + current_bet * 2))
		echo "You won $"$current_bet"!"
	elif [ $result -eq 2 ]; then # Push
		player_cash=$((player_cash + current_bet))
		echo "Push. Bet returned"
	fi

	sleep 2
}

# Function to get bet from player
get_bet()
{
	local valid_bet=0
	local bet_amount=0

	while [ $valid_bet -eq 0 ]; do
		clear
		echo "========================================"
        echo "             BLACKJACK                 "
        echo "========================================"
        echo "Your current cash: $player_cash"
        echo "----------------------------------------"
        read -p "Enter your bet (1-$player_cash, or 0 to quit): " bet_amount

		# Check if input is a number
		if [[ ! $bet_amount =~ ^[0-9]+$ ]]; then
			echo "Invalid input. please enter a number."
			sleep 1
			continue
		fi

		# Check if user wants to quit
		if [ $bet_amount -eq 0 ]; then
			echo "Thanks for playing!"
			exit 0
		fi

		# Validate bet amount
		if [ $bet_amount -gt $player_cash ]; then
			echo "You don't have enough cash! Please bet a smaller amount"
			sleep 1
		elif [ $bet_amount -lt 1 ]; then
			echo "Minimum bet is 1. Please bet at least 1."
			sleep 1
		else 
			valid_bet=1
			current_bet=$bet_amount
			player_cash=$((player_cash - current_bet))
		fi
	done
}

# Function check for blackjack
check_for_blackjack()
{
	# Check if hand has exactly 2 cards totaling 21
	local hand=("$@")

	if [ ${#hand[@]} -eq 2 ]; then
		# Check if hand has an Ace and a 10 card
		if ([ ${hand[0]} -eq 1 ] && [ ${hand[1]} -eq 10 ]) || ([ ${hand[0]} -eq 10 ] && [ ${hand[1]} -eq 1 ]); then
			return 0 # Blackjack
		fi
	fi

	return 1 # Not Blackjack
}

# Main game loop
main()
{
	initialize_game

	while [ $player_cash -gt 0 ]; do
		# Get player's bet
		get_bet

		# Deal initial cards
		deal_initial_cards

		# Calculate complete dealer hand 
		calculate_hand "dealer"

		# Check for blackjack
		player_has_blackjack=false
		dealer_has_blackjack=false

		if check_for_blackjack "${player_hand[@]}"; then
			player_has_blackjack=true
		fi

		if check_for_blackjack "${dealer_hand[@]}"; then
			dealer_has_blackjack=true
		fi

		# Handle blackjack scenarios
		if [ "$player_has_blackjack" = true ] || [ "$dealer_has_blackjack" = true ]; then
			display_status "visible" # Show all cards

			if [ "$player_has_blackjack" = true ] && [ "$dealer_has_blackjack" = true ]; then
				echo "Both you and dealer have Blackjack! Push."
				player_cash=$((player_cash + current_bet)) # Return bet
				sleep 2
			elif [ "$player_has_blackjack" = true]; then
				echo "Blackjack! You win with a natural 21!"
				player_cash=$((player_cash + current_bet + current_bet / 2)) #3:2 payout
				echo "You won $((current_bet + current_bet / 2))!"
				sleep 2
			else # Only dealer has blackjack
				echo "Dealer has Blackjack! You lose."
				echo "You lost $current_bet."
				sleep 2
			fi
		else
			# Player's turn
			player_turn

			# Dealer's turn (if player didn't bust)
			if [ $player_hand_total -le 21 ]; then
				dealer_turn
			fi

			# Determine winner and adjust balance 
			determine_winner
			adjust_balance $?
		fi

		# Ask to play again
		read -p "Press Enter to play again or 'q' to quit: " choice
		if [ "$choice" = "q" ]; then
			echo "Thanks for playing! You left with $"$player_cash" cash."
			exit 0
		fi
	done

	echo "Game over! You've run out of money."
	exit 0
}

# Start the game
main