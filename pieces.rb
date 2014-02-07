# encoding: utf-8


require "./invalid_move_exception"
require 'colorize'

class Piece

  MOVEUP = [[-1, -1], [-1, 1]]
  MOVEDOWN = [[1, 1], [1, -1]]

  attr_accessor :king, :color, :pos

  def initialize(pos, color, board = nil)
    @board = board
    @pos = pos
    @color = color
    @king = false
  end

  def image
    @king ?  d = "王" : d = "☼"
    @color == 'r' ? d.red : d.blue
  end

  def move_dir
    if self.king
      MOVEDOWN + MOVEUP
    else
      @color == 'r' ? MOVEUP : MOVEDOWN
    end
  end

  def at_opponents_home?
    if self.color == 'b' && self.pos[0] == 7
      true
    elsif self.color == 'r' && self.pos[0] == 0
      true
    else
      false
    end
  end


  def maybe_turn_king
    self.king = true if self.at_opponents_home?
  end

  def valid_spot?(pos)
    pos.all? { |cordinate| (0..7).cover?(cordinate) }
  end

  def all_possible_slides
    x, y = @pos
    moves = move_dir.map do |ver, hor|
      [x + ver, y + hor]
    end

    moves.select do |move|
      valid_spot?(move) && @board[*move].nil?
    end
  end

  def perform_slide(end_pos)
    x, y = @pos

    if all_possible_slides.include?(end_pos)
      new_x, new_y = end_pos
      @board[new_x,new_y] = self
      @board[x,y] = nil
      self.pos = end_pos
      maybe_turn_king
      return true
    else
      return false
    end

  end

  def all_possible_jumps
    x, y = @pos
    move_dir.map do |ver, hor|
      new_spot = [x + ver*2, y + hor*2]
      next_piece = @board[x+ver,y+hor]
      next unless valid_spot?(new_spot)
      if next_piece.nil?
        next
      elsif next_piece.color != self.color && @board[x+ver*2,y+hor*2] == nil
        new_spot
      else
        next
      end
    end.compact

  end

  def perform_jump(end_pos)
    x, y = @pos
    new_x, new_y = end_pos
    middle_pos = [ (x+new_x)/2, (y+new_y)/2 ]

    if all_possible_jumps.include?(end_pos)
      @board[*end_pos] = self
      @board[x,y] = nil
      @board[*middle_pos] = nil
      self.pos = end_pos
      maybe_turn_king
      return true
    else
      return false
    end

  end


  def perform_move(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveException.new "Not a possible sequence"
    end

  end


  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      self.perform_slide(move_sequence[0]) || self.perform_jump(move_sequence[0])
    else
      move_sequence.each do |move|
        raise InvalidMoveException.new "Not possible" unless self.perform_jump(move)
      end
    end
  end

  def valid_move_seq?(move_sequence)
    duped_board = @board.dup
    mirror_piece = Piece.new(@pos, @color, duped_board)
    begin
      mirror_piece.perform_moves!(move_sequence)
    rescue InvalidMoveException => move_error
      puts move_error.message
      return false
    end

    return true
  end



end