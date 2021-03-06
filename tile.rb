require "byebug"
require "colorize"

class Tile

    def initialize(board, pos) # board instance and pos array 
        @board = board
        @pos = pos
        @flagged = false
        @revealed = false
        @bomb = false
    end

    def end_game
        @end_game = true
    end

    def bomb?
        @bomb
    end

    def plant_bomb
        @bomb = true
    end

    def reveal
        @revealed = true
    end

    def revealed?
        @revealed
    end

    def flag
        @flagged = !@flagged
    end

    def flagged?
        @flagged
    end

    def neighbors
        surround_delta = [
            [-1, -1],
            [-1, 0],
            [-1, 1],
            [0, -1],
            [0, 1],
            [1, -1],
            [1, 0],
            [1, 1]
        ]
        surround = surround_delta.map do |delta|
            x_delta = @pos[0] + delta[0]
            y_delta = @pos[1] + delta[1]
            [x_delta, y_delta]
        end
        surround.select { |pos| pos[0].between?(0,8) && pos[1].between?(0,8)}
    end

    def render
        if revealed? && !flagged? && !bomb?
            return neighbor_bomb_count == 0 ? "_" : neighbor_bomb_count.to_s.blue
        elsif flagged?
            return "F".red
        elsif bomb? && revealed?
            return "B".red
        else
            return "*"
        end
    end

    def neighbor_bomb_count
        count = 0

        neighbors.each do |pos|
            count += 1 if @board[pos].bomb?
        end

        count
    end

    def explore
        return @revealed = true if neighbor_bomb_count != 0 
        
        if !revealed?
            @revealed = true
            neighbors.each do |pos|
                @board[pos].explore
            end
        end
    end

end

# a = Tile.new(1, [1,1])
# p a.explore