class Tile

    def initialize(board, pos) # board instance and pos array 
        @board = board
        @pos = pos
        @flagged = false
        @revealed = false
        @bomb = false
    end

    def bomb?
        @bomb
    end

    def plant_bomb
        @bomb = true
    end

    def revealed?
        @revealed # = @value == "*" ? false : true
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
        surround
    end

    def render
        if revealed? && !flagged?
            return neighbor_bomb_count == 0 ? "_" : neighbor_bomb_count.to_s
        elsif flagged?
            return "F"
        else
            return "*"
        end
    end

    def neighbor_bomb_count
        count = 0

        neighbors.each do |pos|
            count += 1 if board[pos].bomb?
        end

        count
    end

    def explored?
        @explore = true
    end

end

# a = Tile.new(1, [2,5])
# p a.render