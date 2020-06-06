require_relative '../modules/terminal'

class Player
  START_BALANCE = 100

  attr_accessor :name, :avail_commands, :balance, :hide_cards, :cards

  def initialize(name = 'Player')
    @balance = START_BALANCE
    @name = name
  end

  def interface_param(param)
    params = {
      print_name_y_coord: 12,
      print_score_coords: [52, 20],
      print_score_text: 'Сумма очков вашей руки: %i',
      print_top_card_y_coord: 14,
      avail_commands: {
        take: 'Взять карту',
        show: 'Открыть карты',
        skip: 'Пропустить ход'
      },
      hide_cards: false
    }

    params[param]
  end

  def soft_reset
    self.cards = []
    self.hide_cards = interface_param(:hide_cards)
    self.avail_commands = interface_param(:avail_commands)
  end

  def hard_reset
    self.balance = START_BALANCE
    soft_reset
  end

  def take(deck)
    take_card(deck, false)
    delete_command(:take)
  end

  def print_name
    y_coord = interface_param(:print_name_y_coord)

    Terminal.print_text_with_origin(' ' * 78, 2, y_coord)
    Terminal.print_text_center_with_origin("#{name}: $#{balance}", 40, y_coord)
  end

  def print_score
    x_coord, y_coord = interface_param(:print_score_coords)
    text = interface_param(:print_score_text)

    Terminal.print_text_with_origin(format(text, score), x_coord, y_coord)
  end

  def delete_command(command)
    avail_commands.delete(command)
  end

  def score
    score_sum = 0

    cards.sort_by { |card| card.score.is_a?(Array) ? card.score[1] : card.score }
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

  def print_top_card(index)
    y_coord = interface_param(:print_top_card_y_coord)

    top_left_card = 8 * index + 7
    Terminal.cursor_goto(top_left_card, y_coord)

    print '┌────┐'

    Terminal.cursor_back_in(6)
    Terminal.goto_n_line_down(1)
  end

  def print_middle_card(card)
    print "│ #{card.dig.to_s.ljust(2)} │"

    Terminal.cursor_back_in(6)
    Terminal.goto_n_line_down(1)

    print "│  #{card.suit} │"
  end

  def print_bottom_card
    Terminal.cursor_back_in(6)
    Terminal.goto_n_line_down(1)

    print '└────┘'
  end

  def print_cards
    cards.each_with_index do |card, index|
      print_top_card(index)
      print_middle_card(card)
      print_bottom_card
    end
  end

  def take_card(deck, delay = true)
    cards << deck.take_one
    sleep(1.fdiv(3)) if delay
    print_cards
    print_score unless hide_cards
  end
end