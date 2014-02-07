require "./invalid_move_exception"

class HumanPlayer

  ALPHAHASH = {

    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7,
    'q' => 8
  }


  attr_accessor :color, :name

  def initialize(name, color)
    @color = color
    @name = name
  end

  def gets_input
    user_input = gets.chomp
    return ['q0'] if user_input == 'q'
    user_input.scan(/[a-h][1-8]/)
  end

  def choose_start
    coord = choose_spot.flatten
    if coord.length == 2 && coord.all? { |pos| (0..7).cover?(pos) }
      return coord
    else
      raise InvalidMoveException.new "Not even on the board. COMON!"
    end
  end

  def choose_spot
    user_input = gets_input
    user_input.map do |pos|
      y, x = pos.split(//)
      x = x.to_i - 1
      y = ALPHAHASH[y]
      [x,y]
    end
  end

end