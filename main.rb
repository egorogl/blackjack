# rubocop:disable all

require 'io/console'

# ♠ ♥ ♦ ♣
interface = %q(
/------------------------------------------------------------------------------\
|                               Dealer: $100                                   |
|                                                                              |
|      /----\  /----\  /----\                                                  |
|      | 10 |  | 9  |  | \/ |                                                  |
|      |  ♦ |  |  ♥ |  | /\ |                                                  |
|      \----/  \----/  \----/                                                  |
|                                                                              |
|                                                                              |
|                                                                              |
|------------------------------------------------------------------------------|
|                               Player: $100                                   |
|                                                                              |
|      /----\  /----\  /----\                                                  |
|      | 10 |  | 9  |  | \/ |                                                  |
|      |  ♦ |  |  ♥ |  | /\ |                                                  |
|      \----/  \----/  \----/                                                  |
|                                                                              |
|                                                                              |
|                                                                              |
\------------------------------------------------------------------------------/
)

# rubocop:enable all
print "\033[2J"
# loop do
#  sleep(1)
#  puts "\033[23A"
#end

# Reads keypresses from the user including 2 and 3 escape character sequences.
def read_char
  $stdin.echo = false
  $stdin.raw!

  input = $stdin.getc.chr

  if input == "\e"
    input << $stdin.read_nonblock(3) rescue nil
    input << $stdin.read_nonblock(2) rescue nil
  end
ensure
  $stdin.echo = true
  $stdin.cooked!

  return input
end

# oringal case statement from:
# http://www.alecjacobson.com/weblog/?p=75
def show_single_key
  c = read_char

  case c
  when " "
    puts "SPACE"
  when "\t"
    puts "TAB"
  when "\r"
    puts "RETURN"
  when "\n"
    puts "LINE FEED"
  when "\e"
    puts "ESCAPE"
  when "\e[A"
    puts "UP ARROW"
  when "\e[B"
    puts "DOWN ARROW"
  when "\e[C"
    puts "RIGHT ARROW"
  when "\e[D"
    puts "LEFT ARROW"
  when "\177"
    puts "BACKSPACE"
  when "\004"
    puts "DELETE"
  when "\e[3~"
    puts "ALTERNATE DELETE"
  when "\u0003"
    puts "CONTROL-C"
    exit 0
  when /^.$/
    puts "SINGLE CHAR HIT: #{c.inspect}"
  else
    puts "SOMETHING ELSE: #{c.inspect}"
  end
end

# show_single_key while(true)

print "\e[?25l"
greeting = "- Привет. Рад тебя видеть в нашем казино. Как тебя зовут?\n- "
greeting.each_char do |c|
  print c
  sleep(1.0.fdiv(24))
end
print "\e[?25h"

name = gets.chomp

print "\e[?25l"
greeting = "- Приятно познакомиться, #{name}. Ну что, присаживайся за стол. Начнем игру!"
greeting.each_char do |c|
  print c
  sleep(1.0.fdiv(24))
end

sleep(2)

print "\033[4A"

print interface

print "\e[?25l"
read_char
print "\e[?25h"