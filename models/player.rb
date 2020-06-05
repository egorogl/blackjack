require_relative '../modules/terminal'

class Player
  attr_accessor :name, :avail_commands
  attr_reader :balance

  def initialize(name = 'Player')
    @balance = 100
    @name = name
    @cards = []

    @avail_commands = {
      take: 'Взять карту',
      skip: 'Пропустить ход',
      show: 'Открыть карты'
    }
  end

  def take(deck)
    take_card(deck)
    @avail_commands.delete(:take)
  end

  def print_name
    Terminal.print_text_center_with_origin("#{name}: $#{balance}", 40, 12)
  end

  def print_score
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

    Terminal.print_text_with_origin("Сумма очков вашей руки: #{score_sum}", 52, 20)
  end

  def print_cards
    @cards.each_with_index do |card, index|
      top_left_card = 8 * index + 7
      Terminal.cursor_goto(top_left_card, 14)

      print '┌────┐'

      Terminal.cursor_back_in(6)
      Terminal.goto_n_line_down(1)

      print "│ #{card.dig.to_s.ljust(2)} │"

      Terminal.cursor_back_in(6)
      Terminal.goto_n_line_down(1)

      print "│  #{card.suit} │"

      Terminal.cursor_back_in(6)
      Terminal.goto_n_line_down(1)

      print '└────┘'
    end
  end

  def take_card(deck)
    @cards << deck.take_one

    print_cards
  end
end