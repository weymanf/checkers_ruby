
require_relative 'board'
require_relative 'player'

class Game

  attr_accessor :position, :board

  def initialize(player1, player2)
    @p1 = player1
    @p2 = player2
    @board = Board.new
    @position = [0,0]
  end

  def next_player(player)
    @p1 == player ? @p2 : @p1
  end


  def play
    player = @p1
    while true
      system('clear')
      begin
        puts "#{player.name}'s turn"
        @board.display
        puts "Please choose your starting piece i.e (a1 or a2)"
        start_pos = player.choose_start
        @board.correct_color?(start_pos, player.color)
        piece = @board[*start_pos]
        puts "Your move sequence please: "
        move_seq = player.choose_spot
        piece.perform_move(move_seq)
      rescue InvalidMoveException => move_error
        puts move_error.message
        retry
      end
      player = next_player(player)
      if @board.over?(player.color)
        puts "#{next_player(player).name} has won. The Game is over"
        break
      end
    end
  end

  #--------------- Just for fun ----------
  def move(x,y)
    @position = [@position[0] + x, @position[1] + y]
  end

end