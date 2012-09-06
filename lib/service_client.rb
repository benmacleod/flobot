require 'trello'
require 'github_api'
require 'lib/task'
require 'lib/card'
require 'lib/issue'

class ServiceClient
  include Trello
  include Trello::Authorization

  Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
  OAuthPolicy.consumer_credential = OAuthCredential.new ENV['TRELLO_API_KEY'], ENV['TRELLO_API_SECRET']
  OAuthPolicy.token = OAuthCredential.new ENV['TRELLO_API_ACCESS_TOKEN_KEY'], nil

  @board = Trello::Board.find(ENV['TRELLO_BOARD_ID'])
  @github = Github.new basic_auth: "#{ENV['GITHUB_USER']}:#{ENV['GITHUB_PASSWORD']}", :user => ENV['GITHUB_ORGANIZATION'], :repo => ENV['GITHUB_REPO']

  def self.task(number)
    ::Task.new number, ::Card.new(@board, number), ::Issue.new(@github, number)
  end
end
