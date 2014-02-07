# encoding: utf-8

require './pieces'

class Board

  attr_accessor :grid, :pos

  def initialize(fill = true)
    @grid = Array.new(8) { Array.new(8) }
    @pos = [0,0]
    fill_pieces if fill
  end


  def dup
    duped_board = Board.new(false)
    (0..7).each do |x|
      (0..7).each do |y|
        piece = @grid[x][y]
        if piece
          duped_board[x,y] = @grid[x][y].class.new([x,y], piece.color, duped_board)
        end
      end
    end
    duped_board
  end

  def [](row, column)
    self.grid[row][column]
  end

  def []=(row,column,piece)
    self.grid[row][column] = piece
  end

  def draw
     count = 0
    @grid.map do |row|
      count += 1
       pieces_ar = row.map { |piece| piece ? "#{piece.image} " : "_ " }
       pieces_ar << "#{count}"
       pieces_ar.join("")
     end.join("\n")
   end

  # #for funn---------
#   def draw
#     (0..7).map do |x|
#      (0..7.map do |y|
#         piece ? r = "#{piece.image} " : r = "_ "
#         if
#       end.join("")
#     end.join("\n")
#   end


  #for funn---------

  def correct_color?(pos, color)
    if self[*pos] && color == self[*pos].color
      return true
    else
      raise InvalidMoveException.new "This is not your piece"
    end
  end

  def display
    puts "a b c d e f g h"
    puts draw
  end

  def fill_pieces
    #fills black
    (0..2).each do |x|
      (0..7).each do |y|
        if x.even? && y.odd?
          self[x,y] = Piece.new([x,y],'b', self)
        elsif x.odd? && y.even?
          self[x,y] = Piece.new([x,y],'b', self)
        end
      end
    end
    #fills red
    (5..7).each do |v|
      (0..7).each do |z|
        if v.even? && z.odd?
          self[v,z] = Piece.new([v,z],'r', self)
        elsif v.odd? && z.even?
          self[v,z] = Piece.new([v,z],'r', self)
        end
      end
    end
  end


  def over?(color)
    @grid.flatten.compact.select { |piece| piece.color == color }.length == 0
  end


end