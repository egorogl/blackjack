require_relative '../extensions/string'
require_relative '../models/deck'
require_relative '../models/player'
require_relative '../models/dealer'
require_relative '../modules/terminal'
require_relative '../modules/prompt'

class Game
  attr_reader :table_interface
  attr_accessor :player, :dealer, :deck

  def initialize
    @table_interface = create_table_interface
    @dealer = Dealer.new
    @player = Player.new
  end

  def run
    # intro
    Terminal.hide_cursor

    loop do
      Terminal.clear

      self.deck = Deck.new

      player.soft_reset
      dealer.soft_reset

      print table_interface
      player.print_name
      dealer.print_name

      player.take_card(deck)
      dealer.take_card(deck)
      player.take_card(deck)
      dealer.take_card(deck)

      round

    end

    Terminal.show_cursor
  end

  def round
    loop do
      command_index = Prompt.choice(player.avail_commands.values)

      command = player.avail_commands.to_a[command_index][0]

      case command
      when :take
        player.send command, deck
        sleep(1)
        dealer.turn(deck)
      when :show
        dealer.send command
        break
      when :skip
        player.delete_command(:skip)
        sleep(1)
        dealer.turn(deck)
      end

      break if player.avail_commands.size == 1
      break if player.cards.size == 3 && dealer.cards.size == 3

    end

    sleep(1)
    dealer.show
    sleep(1)

    player_win = true
    dealer_win = true

    player_win = false if player.score > 21
    dealer_win = false if dealer.score > 21

    if !player_win && !dealer_win
      player.balance += 10
      dealer.balance += 10
    elsif player_win && dealer_win
      if player.score > dealer.score
        player.balance += 20
      elsif player.score < dealer.score
        dealer.balance += 20
      else
        player.balance += 10
        dealer.balance += 10
      end
    elsif player_win && !dealer_win
      player.balance += 20
    elsif !player_win && dealer_win
      dealer.balance += 20
    end

    player.print_name
    dealer.print_name

    sleep(1)

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