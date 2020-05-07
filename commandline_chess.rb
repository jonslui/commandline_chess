class Board
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

        @player_white = Player.new
        @player_black = Player.new
        create_peices()        
    end

    def create_peices
        # target location 0 == row, target_location 1 == columns; it is backwards due to the board

        n = 0
        8.times do 
            # change here to add black/white pawn
            pawn = WhitePawn.new([1, n], "♙", [1, n], self.player_white)
            board[1][n] = pawn
            player_white.peices << pawn

            pawn = BlackPawn.new([6, n], "♟", [6, n], self.player_black)
            board[6][n] = pawn
            player_black.peices << pawn

            n+=1
        end
        
        n = 1
        2.times do 
            knight = Knight.new([0, n],"♘", [0, n], self.player_white)
            board[0][n] = knight
            player_white.peices << knight
            
            knight = Knight.new([7, n],"♞", [7, n], self.player_black)
            board[7][n] = knight
            player_black.peices << knight

            n += 5
        end
        
        # add kings

        # add queens
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
        print_display(self.player_white)
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
        # target_location2 is used to update possible moves
        target_location, target_location2  = move_peice_to()
        while legal_move?(target_location[0], target_location[1], player, peice_to_move) == false
            target_location, target_location2 = move_peice_to()
        end

        # if the target location is not empty, delete that peice from the 
        if self.board[target_location[0]][target_location[1]] != []
            delete_peice(target_location)
        end

        # update current_location // update possible_moves for that peice
        peice_to_move.current_location = target_location
        peice_to_move.possible_moves(target_location2)

        # update board to show changes
        self.board[target_location[0]][target_location[1]] = peice_to_move
    end


    def move_peice_to()
        print "Column to move to: "
        column = gets.chomp.to_i
        print "Row to move to: "
        row = gets.chomp.to_i    
        return [row, column], [row, column]
    end
    

    def choose_peice
        print "Column of peice to move: "
        column = gets.chomp.to_i
        print "Row of peice to move: "
        row = gets.chomp.to_i    
        peice = self.board[row][column]

        # remove peice from old location, and erase current location so it can be replaced with a new location
        peice.current_location = nil
        self.board[row][column] = []

        return peice
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
    def initialize
        @peices = []
    end
end

class WhitePawn
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :beginning_location, :ascii_display

    # locations are [row, column]
    def initialize(location, display, location2, player)
        @owner = player
        # location at start of the game, used to determine if pawn can move two peices or not.
        @beginning_location = location
        # location of the pawn currently
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = possible_moves(location2)
        # add a link back to parent element?
    end

    def possible_moves(location)
        possible_moves = []
        possible_move = location
        possible_move[0] += 1
        possible_moves << possible_move

        self.array_of_possible_moves = possible_moves
    end

end

class BlackPawn
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :beginning_location, :ascii_display

    # locations are [row, column]
    def initialize(location, display, location2, player)
        @owner = player
        # location at start of the game, used to determine if pawn can move two peices or not.
        @beginning_location = location
        # location of the pawn currently
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = possible_moves(location2)
        # add a link back to parent element?
    end

    def possible_moves(location)
        possible_moves = []

        possible_move = location
        possible_move[0] -= 1
        possible_moves << possible_move
        
        self.array_of_possible_moves = possible_moves
    end

end

class Knight
    attr_accessor :current_location, :array_of_possible_moves, :owner
    attr_reader :beginning_location, :ascii_display

    # locations are [row, column]
    def initialize(location, display, location2, player)
        @owner = player
        # location at start of the game, used to determine if pawn can move two peices or not.
        @beginning_location = location
        # location of the pawn currently
        @current_location = location
        # what is displayed on the board
        @ascii_display = display
        # an array of all possible moves the player can choose from
        @array_of_possible_moves = possible_moves(location2)
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


# decide whether to do store possible moves ahead of time, or calculate before each move.
# for pawns, have to have a seperate value. because they can only take diagonally
# rook,bishops,king,queen
# king can store a value such as "in_check"


gameboard = Board.new
gameboard.gameloop
