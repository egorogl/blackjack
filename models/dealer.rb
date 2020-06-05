class Dealer
  attr_accessor :name, :hide_cards, :balance
  attr_reader :cards

  def initialize(name = 'Dealer')
    @balance = 100
    @name = name
  end

  def soft_reset
    @cards = []
    self.balance -= 10
    @hide_cards = true

    @avail_commands = {
      take: 'Взять карту'
    }
  end

  def turn(deck)
    if score < 17 && @avail_commands.include?(:take)
      take_card(deck)
      @avail_commands.delete(:take)
    end
  end

  def print_name
    Terminal.print_text_center_with_origin("#{name}: $#{balance}", 40, 2)
  end

  def print_score
    Terminal.print_text_with_origin("Сумма очков руки дилера: #{score}", 51, 10)
  end

  def score
    score_sum = 0

    @cards.sort_by { |card| card.score.is_a?(Array) ? card.score[1] : card.score }
      .each do |card|
      score = card.score

      if score.is_a?(Array)
        if score_sum + score[1] > 21
          score_sum += score[0]
        else
          score_sum += score[1]
        end
      else
        score_sum += score
      end
    end

    score_sum
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

  def take_card(deck, delay = true)
    @cards << deck.take_one
    sleep(1.fdiv(2)) if delay
    print_cards
  end

  def show
    self.hide_cards = false
    print_cards
    print_score
  end
end