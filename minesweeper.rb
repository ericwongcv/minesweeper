require_relative "board.rb"
require "colorize"
require "yaml"
require "byebug"

class Minesweeper

    def initialize
        @board = Board.new
        @grid = @board.grid
        @hit_bomb = false
    end

    def play_game
        @board.render

        until @hit_bomb || win?

            begin
                puts
                puts "Please choose action ('f' for flag, 's' for select, or 'save' to save game): "
                action = gets.chomp.downcase
                play_game if !valid_action?(action)

                if action == "save"
                    save
                    break
                end

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
        false
    end

    def turn(action, pos)
        tile = @board[pos]

        case action            
            when "f"
                if !tile.revealed? || tile.flagged?
                    @board[pos].flag
                else
                    puts "Position cannot be flagged.".red
                end
            when "s"
                if tile.revealed?
                    puts
                    puts "Tile is already revealed.".red
                elsif !tile.flagged? && !game_over?(pos)
                    tile.explore             
                elsif !tile.flagged? && game_over?(pos)
                    puts
                    puts "You hit a bomb! Game over.".red
                    @board.render
                    puts
                    return @hit_bomb = true
                else
                    puts
                    puts "Position is flagged.".red
                    play_game
                end
            when "save"
                save
            else
            play_game
        end
        @board.render
    end

    def valid_position?(pos)
        nums = (0..9).to_a
        pos_arr = pos.split(",")
        if pos.length != 3 || pos_arr.length != 2 || !pos_arr.map(&:to_i).all? { |num| nums.include?(num) }
            puts "Invalid Position.".red
            return false 
        end
        true
    end

    def valid_action?(action)
        return true if action == "f" || action == "s" || action == "save"
        puts "Invalid Action.".red
        false
    end

    def save
        puts "Enter filename to save:"
        filename = gets.chomp
    
        File.write(filename, YAML.dump(self))
    end

end

if $PROGRAM_NAME == __FILE__
    # running as script
  
    case ARGV.count
    when 0
      Minesweeper.new.play_game
    when 1
      # resume game, using first argument
      YAML.load_file(ARGV.shift).play_game
    end
end