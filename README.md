# Blackjack Game in Bash

## Project Overview

This project implements a command-line blackjack card game using Bash scripting. The game follows traditional blackjack rules where players compete against the dealer. The implementation demonstrates various Bash scripting techniques including arrays, functions, control structures, and user input handling.

## Features

- Traditional blackjack gameplay (player versus dealer)
- Card drawing system with values 1-10, J, Q, K (all face cards worth 10)
- Blackjack detection (natural 21 with first two cards)
- Ace handling (can be counted as 1 or 11 depending on hand)
- Betting system with cash management
- Win conditions based on standard blackjack rules (closest to 21 without going over)
- Options to hit (draw more cards) or stand
- Dealer follows standard rules (must hit until 16 or higher)
- Clear user interface with card visualization and ASCII logo
- Input validation and error handling
- Game state tracking and reporting

## Installation

1. Download the game script:
   ```
   git clone https://github.com/Briannn0/blackjack-bash.git
   cd blackjack-bash
   ```

2. Make the script executable:
   ```
   chmod +x game.sh
   ```

3. Run the game:
   ```
   ./game.sh
   ```

## How to Play

1. The game begins with the player having $1000.
2. At the start of each round, the player places a bet.
3. The player and dealer each receive two cards. One of the dealer's cards is hidden.
4. The player can choose to:
   - Hit: Take another card
   - Stand: Keep current hand and end turn
5. If the player's hand exceeds 21, they bust and lose the bet.
6. Once the player stands, the dealer reveals their hidden card and must hit until their hand totals 16 or higher.
7. The winner is determined by comparing card totals:
   - The hand closest to 21 without exceeding it wins
   - If the dealer busts, the player wins
   - If both have the same total, it's a push (tie)
8. Winning pays 1:1 (bet is doubled). Blackjack (21 with first two cards) pays 3:2.
9. The game continues until the player runs out of money or chooses to quit.

## Technical Implementation

### Major Components

- **Player and Dealer Management**: Functions to handle player and dealer data including hands and cash balance
- **Card Generation**: System to generate random cards with values between 1-10 (and face cards as 10)
- **Game Logic**: Main loop handling turns, card drawing, and win conditions
- **User Interface**: Display functions for cards, scores, and game status with ASCII art
- **Input Validation**: Ensures all user inputs are valid and within acceptable ranges

### Key Functions

- `initialize_game`: Sets up player with starting cash and initializes dealer
- `draw_card`: Generates a random card (values 1-10, with face cards converted to 10)
- `get_card_name`: Converts card values to descriptive names (e.g., Ace, King)
- `deal_initial_cards`: Deals starting cards to player and dealer
- `calculate_hand`: Calculates the total value of a hand, accounting for Aces as 1 or 11
- `check_for_blackjack`: Determines if a hand is a blackjack (21 with exactly 2 cards)
- `display_status`: Shows current game state including cards and scores
- `player_turn`: Handles player's decisions to hit or stand
- `dealer_turn`: Executes dealer's turn following standard rules (hit until 16+)
- `determine_winner`: Evaluates hands to determine the winner
- `adjust_balance`: Manages betting transactions based on game outcomes
- `get_bet`: Handles player bet input with validation

## Future Enhancements

- Enhanced visual display with ASCII card art
- Save/load game functionality
- Statistics tracking across multiple games

## License

[MIT License](LICENSE)

## Author

Nguyen Dao Tuan Anh

---

*This project was developed as a bonus assignment for the OPS245 course at Seneca College.*