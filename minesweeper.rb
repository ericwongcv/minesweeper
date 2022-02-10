require_relative "board.rb"
require "byebug"

class Minesweeper

    def initialize
        @board = Board.new
        @grid = @board.grid
        @hit_bomb = false
    end

    def play_game
        @board.render
        until win? || @hit_bomb
            begin
                puts
                puts "Please choose action (f for flag and s for select): "
                action = gets.chomp.downcase
                play_game if !valid_action?(action)

                puts "Please choose a position to perform your action. (ex. 3,4): "
                pos = gets.chomp
                play_game if !valid_position?(pos)
                pos = pos.split(",").map(&:to_i)                
            rescue
                puts "Did you enter your input correctly?"
            end
            turn(action, pos)
        end
    end

    def win?
        @grid.each do |row|
            return false if row.any? { |tile| !tile.revealed? && !tile.bomb? }
        end
        true
    end

    def game_over?(pos)
        if @board.bomb_coords.include?(pos)
            @board.reveal
            return true 
        end
    end

    def turn(action, pos)
        tile = @board[pos]
        case action
            
        when "f"
            if !tile.revealed? || tile.flagged?
                @board[pos].flag
            else
                puts "Position cannot be flagged."
            end
        when "s"
            if tile.revealed?
                puts
                puts "Tile is already revealed."
            elsif !tile.flagged? && !game_over?(pos)
                tile.explore             
            elsif !tile.flagged? && game_over?(pos)
                puts
                puts "You hit a bomb! Game over."
                puts
                return @hit_bomb = true
            else
                puts
                puts "Position is flagged."
                play_game
            end
        else
            play_game
        end
        
        @board.render
    end

    def valid_position?(pos)
        nums = (0..9).to_a
        pos_arr = pos.split(",")
        if pos.length != 3 || pos_arr.length != 2 || !pos_arr.map(&:to_i).all? { |num| nums.include?(num) }
            puts "Invalid Position."
            return false 
        end
        true
    end

    def valid_action?(action)
        return true if action[0] == "f" || action[0] == "s"
        puts "Invalid Action."
        false
    end

end

Minesweeper.new.play_game