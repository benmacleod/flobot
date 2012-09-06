class Card
  attr_reader :board
  extend Forwardable
  def_delegators :@card, :list, :list=, :name

  def initialize(board, number)
    @board = board
    @number = number
    @card = @board.refresh!.cards.detect { |c| c.name =~ /^#{number}\b/ } or raise "Couldn't find card for task #{number}"
  end

  def location
    list.name
  end
end
