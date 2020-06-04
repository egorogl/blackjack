require_relative 'terminal'

module Prompt
  class << self

    def choice(*args)
      index = 0

      loop do
        Terminal.cursor_back_in(80)
        Terminal.erase_line

        print_menu(index, *args)

        key = Terminal.read_char
        case key
        when 'right'
          index += 1
          index = 0 if index > args.size - 1
        when 'left'
          index -= 1
          index = args.size - 1 if index.negative?
        when 'enter', 'space'
          break
        else
          next
        end
      end
    end

    def print_menu(index, *args)
      args.each_with_index do |q, i|
        print "[#{index == i ? 'x' : ' '}] #{q}   "
      end
    end

  end
end