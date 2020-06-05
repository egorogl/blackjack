# frozen_string_literal: true

require 'io/console'

# Module for work with console
module Terminal
  KEY_BUTTONS = {
    ' ' => 'space',
    "\r" => 'enter',
    "\e[A" => 'up',
    "\e[B" => 'down',
    "\e[C" => 'right',
    "\e[D" => 'left',
    "\u0003" => 'ctrl-c'
  }.freeze

  @cursor_hidden = false

  class << self

    def clear
      print "\033c"
      cursor_goto(0, 0)
      hide_cursor if @cursor_hidden
    end

    def hide_cursor
      print "\e[?25l"
      @cursor_hidden = true
    end

    def show_cursor
      print "\e[?25h"
      @cursor_hidden = false
    end

    def goto_n_line_up(count_line_up)
      print "\033[#{count_line_up}A"
    end

    def goto_n_line_down(count_line_down)
      print "\033[#{count_line_down}B"
    end

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

      return KEY_BUTTONS[input].nil? ? input : KEY_BUTTONS[input]
    end

    def print_animate_text(text, duration = 1.0.fdiv(60))
      text.each_char do |c|
        print c
        sleep(duration)
      end
    end

    def cursor_goto(x_coord, y_coord)
      print "\033[#{y_coord};#{x_coord}f"
    end

    def cursor_back_in(count_back)
      print "\033[#{count_back}D"
    end

    def cursor_forward_in(count_forward)
      print "\033[#{count_forward}C"
    end

    def erase_line
      print "\033[K"
    end

    def erase_all_line
      cursor_back_in(80)
      erase_line
    end

    def print_text_center_with_origin(text, x_coord, y_coord)
      x = x_coord - (text.length / 2).floor
      cursor_goto(x, y_coord)
      print text
    end

    def print_text_with_origin(text, x_coord, y_coord)
      cursor_goto(x_coord, y_coord)
      print text
    end

  end
end