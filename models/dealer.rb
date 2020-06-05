class Dealer
  attr_accessor :name, :avail_commands, :hide_cards
  attr_reader :balance

  def initialize(name = 'Dealer')
    @balance = 100
    @name = name
    @cards = []
    @hide_cards = true

    @avail_commands = {
      take: 'Взять карту',
      skip: 'Пропустить ход',
      show: 'Открыть карты'
    }
  end

  def print_name
    Terminal.print_text_center_with_origin("#{name}: $#{balance}", 40, 2)
  end

  def print_cards
    @cards.each_with_index do |card, index|
      top_left_card = 8 * index + 7
      Terminal.cursor_goto(top_left_card, 4)

      print '┌────┐'

      Terminal.cursor_back_in(6)
      Terminal.goto_n_line_down(1)

      if hide_cards
        print '│ \\/ │'

        Terminal.cursor_back_in(6)
        Terminal.goto_n_line_down(1)

        print '│ /\\ │'
      else
        print "│ #{card.dig.to_s.ljust(2)} │"

        Terminal.cursor_back_in(6)
        Terminal.goto_n_line_down(1)

        print "│  #{card.suit} │"
      end

      Terminal.cursor_back_in(6)
      Terminal.goto_n_line_down(1)

      print '└────┘'
    end
  end

  def take_card(deck)
    @cards << deck.take_one
    print_cards
  end

  def show
    self.hide_cards = false
    print_cards
  end
end