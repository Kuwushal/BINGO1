# Bingo Game Logic

## 1. Boards

- The game uses a 5x5 board containing the numbers 1 through 25 exactly once.
- The player and computer receive different, randomly shuffled arrangements of those numbers.
- The boards are created when a new game starts and remain unchanged until the game is restarted.
- Every space contains a number and starts unmarked.

## 2. Number Calling

- The game is played in turns.
- On each turn, one number that has not been called before is selected.
- The called number is revealed to both players.
- The number is removed from the available-number pool, so it cannot be called again.
- The game ends immediately when a player wins.

## 3. Marking Numbers

- When the player calls a number, it is crossed on the player's board.
- When the computer calls a number, it is highlighted on the player's board until the player clicks it.
- The player cannot cross an uncalled number manually.
- The player must click the highlighted computer-called number to cross it.
- No space is free; every marked number must have been called.

## 4. Winning Lines

- A winning line is a complete horizontal row or vertical column.
- Diagonals do not count.
- A line is complete when every space in it is marked.
- Each completed line is counted only once, even if it remains marked on later turns.

## 5. BINGO Progression

The letters in `BINGO` represent completed lines:

| Completed lines | Letter |
| ---: | :---: |
| 1 | B |
| 2 | I |
| 3 | N |
| 4 | G |
| 5 | O |

- When a player completes a new line, the next letter is awarded in order.
- Completed lines are highlighted so the player can see their progress.
- A player wins after completing five different rows or columns and reaching `O`.

## 6. Computer Behavior

- The computer calls one unused number automatically after the player's call.
- The computer's called number is highlighted on the player's visible board.
- The computer board is hidden from the player.

## 7. Game Outcomes

- If only the player reaches five completed lines first, the result is a win.
- If only the computer reaches five completed lines first, the result is a loss.
- If both players reach five completed lines on the same call, the result is a draw.
- Once an outcome is determined, no more numbers are called until a new game begins.

## 8. New Game

Starting a new game must:

1. Create a new player board containing 1 through 25.
2. Reset the available-number pool.
3. Clear the called-number history.
4. Clear completed-line highlights and BINGO progress.
5. Set the game state back to the player's turn.