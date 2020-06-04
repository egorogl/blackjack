require_relative '../extensions/string'
require_relative '../models/deck'
require_relative '../modules/terminal'
require_relative '../modules/prompt'

class Game
  class << self
    attr_reader :interface
  end

  @interface = %q(
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
|                                                                              |
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

  def run
    Terminal.clear
    Terminal.hide_cursor

    Terminal.print_animate_text("- Привет. Рад тебя видеть в нашем казино. Как тебя зовут?\n- ")

    Terminal.show_cursor
    name = gets.chomp.truncate(68)
    Terminal.hide_cursor

    Terminal.print_animate_text("- Приятно познакомиться, #{name}. Ну что, присаживайся за стол. Начнем игру!")

    sleep(2)

    Terminal.clear

    print self.class.interface

    Terminal.print_text_center_with_origin("#{name}: $100", 40, 13)

    Terminal.cursor_goto(0, 79)

    Prompt.choice('Взять карту', 'Пропустить ход', 'Открыть карты')

    Terminal.read_char

    Terminal.show_cursor
  end
end