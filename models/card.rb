class Card
  attr_reader :dig, :suit

  def initialize(dig, suit)
    @dig = dig
    @suit = suit
  end

  def score
    case dig
    when ->(x) { x.is_a?(Integer) } then dig
    when ->(x) { x != 'A' } then 10
    else [1, 11]
    end
  end
end
