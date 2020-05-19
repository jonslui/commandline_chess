**Commandline Chess**
========

The purpose of this project was to practice OOP principles when creating a program with multiple parts. 
========

This Commandline Chess program is broken down into multiple classes. 

There is an overarching class called Game, which contains the variables:
-   board: an array made of arrays, which is printed to represent the board.
-   player_white: a pointer to a Player class.
-   player_black: a pointer to an instance of the Player class.

The Player class, which contains:
-   game: a pointer to the Game class
-   peices: an array of all peices owned by the player
-   king: a pointer ot the player's king.
-   in_check: a boolean that represents whether the player's king is in check or not.
-   checkmate: a boolean representing whether the player is in check or not.

Peice classes, each peice (ex. King, Queen, Rook) has it's own class which contains the variables: 
-   owner: which Player the peice belongs to
-   current_location: where on the board the peice is currently located
-   ascii_display: how the peice should be displayed in the terminal
-   array_of_possible_moves: all possible moves the peice could make.

When starting a game, player_white and player_black both create new instances of the Player class, and then a function called "create_peices" is called.

This function creates and adds instances of each peice class to both player_white and player_black.

Then gameloop() is called within the Game class, and each player alternates turns moving a peice and checking if they are in check/checkmate.

========


To play this game, 
1. Make sure you have Ruby installed on your system
2. Install the commandline_chess.rb file
3. Naviagte to the file's location in the terminal
4. Type "ruby commandline_chess.rb" and enter.
5. Move peices by typing in the corresponding column number, then row number.