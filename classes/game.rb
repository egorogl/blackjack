require_relative '../extensions/string'
require_relative '../models/deck'
require_relative '../models/player'
require_relative '../models/dealer'
require_relative '../modules/terminal'
require_relative '../modules/prompt'

class Game
  attr_reader :table_interface, :deck
  attr_accessor :player, :dealer

  def initialize
    @table_interface = create_table_interface
    reset
  end

  def reset
    @deck = Deck.new
    @player = Player.new
    @player.take_card(@deck)
    @player.take_card(@deck)

    @dealer = Dealer.new
    @dealer.take_card(@deck)
    @dealer.take_card(@deck)
  end

  def run
    # intro
    Terminal.clear

    print table_interface

    loop do

      player.print_name
      player.print_cards
      player.print_score
      dealer.print_name
      dealer.print_cards

      command_index = Prompt.choice(player.avail_commands.values)

      command = player.avail_commands.to_a[command_index][0]

      case command
      when :take
        player.send command, deck
      when :show
        dealer.send command
      end

    end

    Terminal.show_cursor
  end

  def intro
    Terminal.clear
    Terminal.hide_cursor

    Terminal.print_animate_text("- Привет. Рад тебя видеть в нашем казино. Как тебя зовут?\n- ")

    Terminal.show_cursor
    player.name = gets.chomp.truncate(68)
    Terminal.hide_cursor

    Terminal.print_animate_text("- Приятно познакомиться, #{player.name}. Ну что, присаживайся за стол. Начнем игру!")

    sleep(2)

    Terminal.clear
  end

  def create_table_interface
    table = '╔' + '═' * 78 + "╗\n"
    table += ('║' + ' ' * 78 + "║\n") * 9
    table += ('╟' + '─' * 78 + "╢\n")
    table += ('║' + ' ' * 78 + "║\n") * 9
    table += '╚' + '═' * 78 + "╝\n"
    table
  end
end