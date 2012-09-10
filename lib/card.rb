class Card
  attr_reader :board, :links
  extend Forwardable
  def_delegators :@card, :list, :list=, :name, :description

  def initialize(board, number)
    @board = board
    @number = number
    @card = @board.refresh!.cards.detect { |c| c.name =~ /^#{number}\b/ } or raise "Couldn't find card for task #{number}"
    @links = []
    description.scan /\[(.+)\]\((.+)\)/ do |text, url|
      @links << {text: text, url: url}
    end
  end

  def location
    list.name
  end
end
