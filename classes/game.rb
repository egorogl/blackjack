require_relative '../extensions/string'
require_relative '../models/deck'
require_relative '../models/player'
require_relative '../models/dealer'
require_relative '../modules/terminal'
require_relative '../modules/prompt'

class Game
  attr_reader :table_interface
  attr_accessor :player, :dealer, :deck, :bank

  def initialize
    @table_interface = create_table_interface
    @dealer = Dealer.new
    @player = Player.new
    @bank = 0
  end

  def run
    # intro
    Terminal.hide_cursor

    loop do
      Terminal.clear

      self.deck = Deck.new

      print table_interface

      player.print_name
      dealer.print_name

      player.soft_reset
      dealer.soft_reset

      10.times do
        player.balance -= 1
        dealer.balance -= 1
        self.bank += 2
        player.print_name
        dealer.print_name
        print_bank
        sleep(1.fdiv(10))
      end

      player.take_card(deck)
      dealer.take_card(deck)
      player.take_card(deck)
      dealer.take_card(deck)

      round

      if player.balance.zero? || dealer.balance.zero?
        choice = Prompt.choice(['Сыграть еще раз!', 'На сегодня хватит...'])
        if choice == 0
          player.hard_reset
          dealer.hard_reset
        else
          Terminal.show_cursor
          exit 0
        end
      end

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
        player.delete_command(:skip)
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
      split_bank
    elsif player_win && dealer_win
      if player.score > dealer.score
        add_bank_to_player
      elsif player.score < dealer.score
        add_bank_to_dealer
      else
        split_bank
      end
    elsif player_win && !dealer_win
      add_bank_to_player
    elsif !player_win && dealer_win
      add_bank_to_dealer
    end

    player.print_name
    dealer.print_name

    sleep(1)

  end

  def add_bank_to_player
    20.times do
      player.balance += 1
      self.bank -= 1
      player.print_name
      print_bank
      sleep(1.fdiv(20))
    end
  end

  def add_bank_to_dealer
    20.times do
      dealer.balance += 1
      self.bank -= 1
      dealer.print_name
      print_bank
      sleep(1.fdiv(20))
    end
  end

  def split_bank
    10.times do
      player.balance += 1
      dealer.balance += 1
      self.bank -= 2
      player.print_name
      dealer.print_name
      print_bank
      sleep(1.fdiv(10))
    end
  end

  def print_bank
    Terminal.print_text_with_origin("#{bank.to_s.ljust(2)}", 70, 11)
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
    table += ('╟' + '─' * 59 + '[ Банк: $0  ]' + '─' * 6 + "╢\n")
    table += ('║' + ' ' * 78 + "║\n") * 9
    table += '╚' + '═' * 78 + "╝\n"
    table
  end

  private

  RED = "\033[0;31m"
  GREEN = "\033[0;32m"
  NC = "\033[0m" # No Color
end

=begin
╔══════════════════════════════════════════════════════════════════════════════╗
║                                 Dealer: $90                                  ║
║                                                                              ║
║     ┌────┐  ┌────┐                                                           ║
║     │ \/ │  │ \/ │                                                           ║
║     │ /\ │  │ /\ │                                                           ║
║     └────┘  └────┘                                                           ║
║                                                                              ║
║                                                                              ╢
║                                                                              ║
╟───────────────────────────────────────────────────────────[ Банк: $20 ]──────╢
║                                 Player: $90                                  ║
║                                                                              ║
║     ┌────┐  ┌────┐                                                           ║
║     │ 2  │  │ Q  │                                                           ║
║     │  ♥ │  │  ♦ │                                                           ║
║     └────┘  └────┘                                                           ║
║                                                                              ║
║                                                                              ║
║                                                  Сумма очков вашей руки: 12  ║
╚══════════════════════════════════════════════════════════════════════════════╝
=end