# encoding: utf-8
require 'dispel'
require './game'
require 'colorize'

p1 = HumanPlayer.new('weyman', 'r')
p2 = HumanPlayer.new('malcolm', 'b')

Game.new(p1,p2).play

# Dispel::Screen.open do |screen|
#   ttt = Game.new(p1,p2)
#    screen.draw "#{ttt.board.draw}"
#
#   Dispel::Keyboard.output do |key|
#     case key
#     when :up then ttt.move(0,-1)
#     when :down then ttt.move(0,1)
#     when :right then ttt.move(1,0)
#     when :left then ttt.move(-1,0)
#     when "q" then break
#     when "r" then ttt = Game.new
#     end
#     screen.draw "#{ttt.board.draw}"
#   end
# end