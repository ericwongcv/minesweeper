require_relative "board.rb"
require "byebug"

class Minesweeper

    def initialize
        @board = Board.new
        @grid = @board.grid
    end

    def play_game
        @board.render
        until win? or game_over?
            
            begin
                puts
                puts "Please choose action (f for flag and s for select): "
                action = gets.chomp.downcase
                play_game if !valid_action?(action)

                puts "Please choose a position to perform your action. eg. (3,4): "
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
        @board.bomb_coords.include?(pos)
    end

    def turn(action, pos)
        case action
            
        when "f"
            @board[pos].flag
        when "s"
            if !@board[pos].flagged? && !game_over?(pos)
                @board[pos].explore 
            elsif game_over?(pos)

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
        return false if pos.length != 3
        return false if pos_arr.length != 2 
        pos_arr.map(&:to_i).all? { |num| nums.include?(num) }
    end

    def valid_action?(action)
        return true if action == "f" || action == "s"
        false
    end

end

Minesweeper.new.play_game