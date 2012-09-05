class Task
  attr_reader :card, :board
  def initialize(card)
    @card = card
    @board = card.board
    @state = Task.state_from card
  end

  state_machine :state do
    [:dev, :review, :test, :deploy, :finished].each do |state|
      event "do_#{state}".to_sym do
        transition any => state
      end
    end

    after_transition any => any do |task, transition|
      task.card.list = task.board.lists.detect{|list| list.name =~ /#{transition.to}/i}
    end
  end

  def self.state_from card
    card.list.name.split(/\s/).last.downcase.to_sym
  end


end
