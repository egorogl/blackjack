# frozen_string_literal: true

require_relative 'card.rb'

# Playing deck with cards
class Deck
  SUITS = %w[♠ ♥ ♦ ♣].freeze
  DIGS = (2..10).to_a + %w[J Q K A]

  attr_accessor :cards

  def initialize
    @cards = []

    DIGS.each do |dig|
      SUITS.each { |suit| @cards << Card.new(dig, suit) }
    end

    @cards.shuffle!
  end

  def shuffle!
    cards.shuffle!
  end

  def take_one
    cards.shift
  end
end
