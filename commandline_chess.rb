class Game
    attr_accessor :board, :player_white, :player_black

    def initialize
        @board = [[[],[],[],[],[],[],[],[]],
                [[],[],[],[],[],[],[],[]],
                [[],[],[],[],[],[],[],[]],
                [[],[],[],[],[],[],[],[]],
                [[],[],[],[],[],[],[],[]],
                [[],[],[],[],[],[],[],[]],
                [[],[],[],[],[],[],[],[]],
                [[],[],[],[],[],[],[],[]]]

        @player_white = Player.new(self)
        @player_black = Player.new(self)
        create_peices()        
    end

    # create peices, populate display, and add them to player_white/player_black's "peices" array
    def create_peices
        # target location 0 == row, target_location 1 == columns; it is backwards due to the board

        # add pawns
        n = 0
        8.times do 
            # pawn = WhitePawn.new([1, n], "♙", self.player_white)
            # board[1][n] = pawn
            # player_white.peices << pawn

            # pawn = BlackPawn.new([6, n], "♟", self.player_black)
            # board[6][n] = pawn
            # player_black.peices << pawn

            # n+=1
        end
        
        # add knights
        n = 1
        2.times do 
            knight = Knight.new([0, n],"♘", self.player_white)
            board[0][n] = knight
            player_white.peices << knight
            
            knight = Knight.new([7, n],"♞", self.player_black)
            board[7][n] = knight
            player_black.peices << knight

            n += 5
        end

        # add rooks
        n = 0
        2.times do
            rook = Rook.new([0, n], "♖", self.player_white)
            board[0][n] = rook
            player_white.peices << rook

            rook = Rook.new([7, n], "♜", self.player_black)
            board[7][n] = rook
            player_black.peices << rook

            n += 7
        end

        # add bishops
        n = 2
        2.times do
            bishop = Bishop.new([0,n], "♗", self.player_white)
            board[0][n] = bishop
            player_white.peices << bishop

            bishop = Bishop.new([7,n], "♝", self.player_black)
            board[7][n] = bishop
            player_black.peices << bishop

            n+=3
        end

        # add queens
        queen = Queen.new([0,4], "♕", self.player_white)
        board[0][4] = queen
        player_white.peices << queen

        queen = Queen.new([7,4], "♛", self.player_black)
        board[7][4] = queen
        player_black.peices << queen

        # add kings
        king = King.new([0,3], "♔", self.player_white)
        board[0][3] = king
        player_white.peices << king

        king = King.new([7,3], "♚", self.player_black)
        board[7][3] = king
        player_black.peices << king
    end

    def print_display(player)
        puts 
        if player == player_white 
            row_number = 7

            self.board.reverse.each do |row|
                # labels for rows
                print "#{row_number} "
                row_number -= 1

                row.each do |space|
                    if space == []
                        print "   "
                    else
                        print " #{space.ascii_display} "
                    end
                end
                puts
                puts 
            end
        else
            row_number = 0

            self.board.each do |row|
                # labels for rows
                print "#{row_number} "
                row_number += 1

                row.each do |space|
                    if space == []
                        print "   "
                    else
                        print " #{space.ascii_display} "
                    end
                end
                puts
                puts 
            end
        end
        # column labels
        puts "   0  1  2  3  4  5  6  7 "
        puts
    end

    def gameloop
        print_display(self.player_white)
        player_turn(self.player_white)
        print_display(self.player_black)
        player_turn(self.player_black)
        gameloop()
    end

    def player_turn(player)    
        peice_to_move = choose_peice()

        # check if the peice is part of the player's collection
        if check_if_peice_is_present(player, peice_to_move) == false
            puts "Peice not present, please choose another."
            # call self until player chooses a valid peice
            player_turn(player)
            return
        end

        # check if the move is legal (aka, if the taget_location is empty or filled with opposing player's peice)
        target_location = move_peice_to()
        
        while legal_move?(target_location[0], target_location[1], player, peice_to_move) == false
            target_location = move_peice_to()
        end

        # if the target location is not empty, delete that peice from the 
        if self.board[target_location[0]][target_location[1]] != []
            delete_peice(target_location)
        end

        # update current_location // update possible_moves for that peice
        peice_to_move.current_location = target_location

        # update board to show changes
        self.board[target_location[0]][target_location[1]] = peice_to_move
    end
    
    def move_peice_to()
        print "Column to move to: "
        column = gets.chomp.to_i
        print "Row to move to: "
        row = gets.chomp.to_i  
        return [row, column]
    end  
    
    # Choose peice, then populate peice's array_of_possible_moves.
    def choose_peice
        print "Column of peice to move: "
        column = gets.chomp.to_i
        print "Row of peice to move: "
        row = gets.chomp.to_i

        peice = self.board[row][column]

        if peice == nil || peice == []
        # function will call itself until a valid location is given
        puts "Please choose a valid location."
        choose_peice()
        else
        # populate peice's array with all possible moves
        peice.possible_moves(peice.current_location)

        # remove peice from old location, and erase current location so it can be replaced with a new location
        peice.current_location = nil
        self.board[row][column] = []
        puts
        return peice
        end
    end

    def check_if_peice_is_present(player, peice_to_move)
        counter = 0
        player.peices.each do |peice| 
            if peice == peice_to_move
             counter += 1
            end

            if counter > 0
                return true
            end
        end
        
        return false
    end

    def legal_move?(row, column, player, peice)

        if peice.array_of_possible_moves.include? [row, column]
            if self.board[row][column] != []
                # if the space is not empty but is part of the current player's peices,
                # choose another move.
                if player.peices.include? self.board[row][column]
                    puts "You cannot take your own peice, choose another location."
                    return false
                else
                    return true
                end
            end
        else
            puts "This move is illegal, please choose a legal move."
            # move choose function outside of move
            return false
        end
    end

    def delete_peice(coords_of_peice_to_delete)
        self.player_black.peices.each do |peice, index|
            if peice == self.board[coords_of_peice_to_delete[0]][coords_of_peice_to_delete[1]]
                self.board[coords_of_peice_to_delete[0]][coords_of_peice_to_delete[1]].owner.peices.delete(self.board[coords_of_peice_to_delete[0]][coords_of_peice_to_delete[1]])
            end
        end
    end
end

class Player
    attr_accessor :peices
    attr_reader :game
    def initialize(game)
        @game = game
        @peices = []
    end
end

class WhitePawn
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :beginning_location, :ascii_display

    # locations are [row, column]
    def initialize(location, display, player)
        @owner = player
        # location at start of the game, used to determine if pawn can move two peices or not.
        @beginning_location = location
        # location of the pawn currently
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = []
        # add a link back to parent element?
    end

    def possible_moves(location)
        possible_moves = []

        # check if the pawn can move forward
        if self.owner.game.board[location[0] + 1][location[1]] == []
            possible_moves << [location[0] + 1, location[1]]
        end

        # check for if there are peices the pawn can take
        if self.owner.game.board[location[0] + 1][location[1] + 1] != [] && self.owner.game.board[location[0] + 1][location[1] + 1] != nil
            possible_moves << [location[0] + 1, location[1] + 1]
        end
        if self.owner.game.board[location[0] + 1][location[1] - 1] != [] && self.owner.game.board[location[0] + 1][location[1] - 1] != nil
            possible_moves << [location[0] + 1, location[1] - 1]
        end

        self.array_of_possible_moves = possible_moves
    end

end

class BlackPawn
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :beginning_location, :ascii_display

    # locations are [row, column]
    def initialize(location, display, player)
        @owner = player
        # location at start of the game, used to determine if pawn can move two peices or not.
        @beginning_location = location
        # location of the pawn currently
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = []
        # add a link back to parent element?
    end

    def possible_moves(location)
        possible_moves = []

        # check if the pawn can move forward
        if self.owner.game.board[location[0] - 1][location[1]] == []
            possible_moves << [location[0] - 1, location[1]]
        end
        
        # check for if there are peices the pawn can take
        if self.owner.game.board[location[0] - 1][location[1] - 1] != [] && self.owner.game.board[location[0] - 1][location[1] - 1] != nil
            possible_moves << [location[0] - 1, location[1] - 1]
        end
        if self.owner.game.board[location[0] - 1][location[1] + 1] != [] && self.owner.game.board[location[0] - 1][location[1] + 1] != nil
            possible_moves << [location[0] - 1, location[1] + 1]
        end

        self.array_of_possible_moves = possible_moves
    end

end

class Knight
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :ascii_display

    # locations are [row, column]
    def initialize(location, display, player)
        @owner = player
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = []
        # possible_moves(location2)
        # add a link back to parent element?
    end

    # remember moves are written row and then column
    def possible_moves(location)
        possible_moves = []

        possible_move = location
        possible_moves << [possible_move[0] + 1, possible_move[1] + 2]
        possible_moves << [possible_move[0] - 1, possible_move[1] + 2]
        possible_moves << [possible_move[0] + 1, possible_move[1] - 2]
        possible_moves << [possible_move[0] - 1, possible_move[1] - 2]
        possible_moves << [possible_move[0] + 2, possible_move[1] +1]
        possible_moves << [possible_move[0] - 2, possible_move[1] +1]
        possible_moves << [possible_move[0] + 2, possible_move[1] -1]
        possible_moves << [possible_move[0] - 2, possible_move[1] -1]
        
        self.array_of_possible_moves = possible_moves
    end
end

class Rook
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :ascii_display

    # locations are [row, column]
    def initialize(location, display, player)
        @owner = player
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = []
        # add a link back to parent element?
    end

    # remember moves are written row and then column
    def possible_moves(location)
        possible_moves = []
        board = self.owner.game.board

        # add possible right side moves
        # starting index == spot directly to the right of the peice
        index = location[1] + 1
        index += 1 until board[location[0]][index] != []
        while index > location[1]
            possible_moves << [location[0], index]
            index -= 1
        end

        # new index == spot directly to the left of the peice
        index = location[1] - 1
        index -= 1 until board[location[0]][index] != []
        while index < location[1]
            possible_moves << [location[0], index]
            index += 1
        end

        # new index == column of the current peice
        # find highest vertical point the rook is able to move to
        # if the peice is already at 7, do not look for moves higher
        if location[0] != 7
            row = location[0] + 1
            row += 1 until board[row][location[1]] != [] || row + 1 > 7
            while location[0] < row
                possible_moves << [row, location[1]]
                row -= 1
            end
        end

        # find lowest vertical point the rook is able to move to
        row = location[0] - 1
        row -= 1 until board[row][location[1]] != []
        while location[0] > row
            possible_moves << [row, location[1]]
            row += 1
        end
        
        self.array_of_possible_moves = possible_moves
        # puts possible_moves
    end
end

class Bishop
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :ascii_display

    def initialize(location, display, player)
        @owner = player       
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = []
    end   

    def possible_moves(location)
        possible_moves = []
        board = self.owner.game.board

        #  + +
        if location[0] < 7 && location[1] < 7
            index = location[1] + 1
            row = location[0] + 1
            while board[row][index] == [] && index < 7 && row < 7
                possible_moves << [row, index]
                index += 1
                row += 1 
            end
            if row <= 7 || index <= 7
                possible_moves << [row, index]
            end
        end

        # #  - +
        if location[0] > 0 && location[1] < 7
            index = location[1] + 1
            row = location[0] - 1
            while board[row][index] == [] && index < 7 && row > 0
                possible_moves << [row, index]
                index += 1
                row -= 1
            end
            if row >= 0 && index <= 7
                possible_moves << [row, index]
            end
        end

        # #  - -
        if location[0] > 0 && location[1] > 0
            index = location[1] - 1
            row = location[0] - 1
            while board[row][index] == [] && index > 0 && row > 0
                possible_moves << [row, index]
                index -= 1
                row -= 1
            end
            if row >= 0 || index >= 0
                possible_moves << [row, index]
            end
        end
        
        # #  + -
        if location[0] < 7 && location[1] > 0
            index = location[1] - 1
            row = location[0] + 1
            while board[row][index] == [] && index > 0 && row < 7
                possible_moves << [row, index]
                index -= 1
                row += 1
            end
            if row <= 7 || index >= 0
                possible_moves << [row, index]
            end
        end
        
        # add all possible moves to the bishop class variable "array_of_possible_moves"
        self.array_of_possible_moves = possible_moves
        print possible_moves
    end
end

class Queen
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :ascii_display

    def initialize(location, display, player)
        @owner = player
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = []
        # add a link back to parent element?
    end

    def possible_moves(location)
        possible_moves = []
        board = self.owner.game.board
        # DIAGONALS
        # # + +
        if location[0] < 7 && location[1] < 7
            index = location[1] + 1
            row = location[0] + 1
            while board[row][index] == [] && index < 7 && row < 7
                possible_moves << [row, index]
                index += 1
                row += 1 
            end
            if row <= 7 || index <= 7
                possible_moves << [row, index]
            end
        end

        # #  - +
        if location[0] > 0 && location[1] < 7
            index = location[1] + 1
            row = location[0] - 1
            while board[row][index] == [] && index < 7 && row > 0
                possible_moves << [row, index]
                index += 1
                row -= 1
            end
            if row >= 0 && index <= 7
                possible_moves << [row, index]
            end
        end

        # #  - -
        if location[0] > 0 && location[1] > 0
            index = location[1] - 1
            row = location[0] - 1
            while board[row][index] == [] && index > 0 && row > 0
                possible_moves << [row, index]
                index -= 1
                row -= 1
            end
            if row >= 0 || index >= 0
                possible_moves << [row, index]
            end
        end
        
        # #  + -
        if location[0] < 7 && location[1] > 0
            index = location[1] - 1
            row = location[0] + 1
            while board[row][index] == [] && index > 0 && row < 7
                possible_moves << [row, index]
                index -= 1
                row += 1
            end
            if row <= 7 || index >= 0
                possible_moves << [row, index]
            end
        end

        ## HORIZONTALS / VERITCALS
        # right
        index = location[1] + 1
        index += 1 until board[location[0]][index] != []
        while index > location[1]
            possible_moves << [location[0], index]
            index -= 1
        end

        # left
        index = location[1] - 1
        index -= 1 until board[location[0]][index] != []
        while index < location[1]
            possible_moves << [location[0], index]
            index += 1
        end

        # up
        if location[0] != 7
            row = location[0] + 1
            row += 1 until board[row][location[1]] != [] || row + 1 > 7
            while location[0] < row
                possible_moves << [row, location[1]]
                row -= 1
            end
        end

        # down
        row = location[0] - 1
        row -= 1 until board[row][location[1]] != []
        while location[0] > row
            possible_moves << [row, location[1]]
            row += 1
        end

        self.array_of_possible_moves = possible_moves
        print possible_moves
    end
end

class King 
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :ascii_display

    def initialize(location, display, player)
        @owner = player
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = []
        # add a link back to parent element?
        @check_status = in_check?()
    end

    def possible_moves(location)
        possible_moves = []
        # up
        possible_moves << [location[0] + 1, location[1]] if location[0] != 7
        # down
        possible_moves << [location[0] - 1, location[1]] if location[0] != 0
        # right
        possible_moves << [location[0], location[1] + 1] if location[1] != 7
        # left
        possible_moves << [location[0], location[1] - 1] if location[1] != 0
        # up right
        possible_moves << [location[0] + 1, location[1] + 1] if location[0] < 7 && location[1] < 7
        # down right
        possible_moves << [location[0] - 1, location[1] + 1] if location[0] > 0 && location[1] < 7
        # up left
        possible_moves << [location[0] + 1, location[1] - 1] if location[0] < 7 && location[1] > 0
        # down left
        possible_moves << [location[0] - 1, location[1] - 1] if location[0] > 0 && location[1] > 0

        print possible_moves
        self.array_of_possible_moves = possible_moves
    end

    def in_check?

        return false
    end
end

# add change peice input
    # option 1: if input == "c" -- recall self
    # option 2: put both functions in a recusive loop that says until true, have then have c == return false


gameboard = Game.new
gameboard.gameloop