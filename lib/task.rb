require 'state_machine'

class Task
  extend Forwardable
  def_delegators :@card, :name, :list, :list=, :board, :location
  def_delegators :@issue, :comments

  def initialize(number, card, issue)
    @number = number
    @card = card
    @issue = issue
    @state = card.list.name.split(/\s/).last.downcase.to_sym
  end

  state_machine :state do
    [:dev, :review, :test, :deploy, :finished].each do |state|
      event "do_#{state}".to_sym do
        transition any => state
      end
    end

    after_transition any => any do |task, transition|
      task.list = task.board.lists.detect{|list| list.name =~ /#{transition.to}/i}
    end
  end

end
