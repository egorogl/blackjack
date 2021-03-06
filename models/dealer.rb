# frozen_string_literal: true

require_relative 'player'

# dealer class
class Dealer < Player
  @params = {
    print_name_y_coord: 2,
    print_score_coords: [51, 10],
    print_score_text: 'Сумма очков руки дилера: %i',
    print_top_card_y_coord: 4,
    available_commands: {
      take: 'Взять карту'
    },
    hide_cards: true
  }

  def initialize(name = 'Dealer')
    super
  end

  def turn(deck)
    if score < 17 && avail_commands.include?(:take)
      take_card(deck)
      delete_command(:take)
    end
  end

  def print_middle_card(card)
    if hide_cards
      print '│ \\/ │'

      Terminal.cursor_back_in(6)
      Terminal.goto_n_line_down(1)

      print '│ /\\ │'
    else
      super
    end
  end

  def show
    self.hide_cards = false
    print_cards
    print_score
  end
end
