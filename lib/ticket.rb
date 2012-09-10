class Ticket
  def initialize(zendesk, number)
    @zendesk = zendesk
    @number = number
    @ticket = @zendesk.tickets.find(:id => number)
  end
end
