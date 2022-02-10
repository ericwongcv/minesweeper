require_relative "tile"
require "byebug"

class Board

    attr_reader :bomb_coord, :grid

    def new_grid
        grid = Array.new(9) do |row|
            Array.new(9) { |col| Tile.new(self, [row, col]) }
        end
        grid
    end

    def initialize
        @grid = new_grid
        @bomb_coords = gen_bomb
    end

    def gen_bomb
        @bomb_coords = []
        until @bomb_coords.count == 10
            row_coord = rand(8)
            col_coord = rand(8)
            bomb_pos = [row_coord, col_coord]
            @bomb_coords << bomb_pos if !@bomb_coords.include?(bomb_pos)
        end

        @bomb_coords.each do |coord|
            self[coord].plant_bomb
        end
    end

    def [](pos)
        x = pos[0]
        y = pos[1]
        @grid[x][y]
    end

    def render
        puts
        puts "   #{(0..8).to_a.join(" ")}"
        puts
        @grid.each_with_index do |row, i|
            print_row = row.map do |tile|
                # debugger
                tile.render
            end
            puts "#{i}  #{print_row.join(" ")}"
        end
    end

end

board = Board.new
# board.render
pos = [1,2]
pos2 = [5,4]
pos3 = [7,8]
board[pos].explore
board[pos2].explore
board[pos3].explore
board.render
