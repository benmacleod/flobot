class TrelloClient
  include Trello
  include Trello::Authorization

  Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
  OAuthPolicy.consumer_credential = OAuthCredential.new ENV['TRELLO_API_KEY'], ENV['TRELLO_API_SECRET']
  OAuthPolicy.token = OAuthCredential.new ENV['TRELLO_API_ACCESS_TOKEN_KEY'], nil

  @board = Trello::Board.find(ENV['TRELLO_BOARD_ID'])

  def self.task(number)
    (card = @board.refresh!.cards.detect { |c| c.name =~ /^#{number}\b/ }) or raise
      "Couldn't find card for task #{number}"
    Task.new card
  end
end
