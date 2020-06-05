require_relative 'terminal'

module Prompt
  class << self

    def choice(args)
      index = 0
      Terminal.cursor_goto(0, 23)
      Terminal.erase_line

      x = 40 -
          ((args.reduce(0) { |len, str| len + str.length } +
              (args.size * 8)) / 2)

      loop do
        Terminal.cursor_goto(x, 23)

        print_menu(index, args)

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
        when 'ctrl-c'
          exit 0
        else
          next
        end
      end

      index
    end

    def print_menu(index, args)
      args.each_with_index do |q, i|
        print "[#{index == i ? 'x' : ' '}] #{q}    "
      end
    end

  end
end