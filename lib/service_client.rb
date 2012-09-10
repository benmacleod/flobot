require 'trello'
require 'github_api'
require 'zendesk_api'
require 'active_support/core_ext/hash'
require 'andand'
require 'lib/task'
require 'lib/card'
require 'lib/issue'
require 'lib/ticket'

class ServiceClient
  include Trello
  include Trello::Authorization

  Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
  OAuthPolicy.consumer_credential = OAuthCredential.new ENV['TRELLO_API_KEY'],
                                                        ENV['TRELLO_API_SECRET']
  OAuthPolicy.token = OAuthCredential.new ENV['TRELLO_API_ACCESS_TOKEN_KEY'], nil

  @board = Trello::Board.find(ENV['TRELLO_BOARD_ID'])
  @github = Github.new basic_auth: "#{ENV['GITHUB_USER']}:#{ENV['GITHUB_PASSWORD']}",
                       user: ENV['GITHUB_ORGANIZATION'], repo: ENV['GITHUB_REPO']
  @zendesk = ZendeskAPI::Client.new do |config|
    config.url = ENV['ZENDESK_URL']
    config.username = ENV['ZENDESK_USERNAME']
    config.password = ENV['ZENDESK_PASSWORD']
  end

  def self.task(number)
    card = ::Card.new(@board, number)
    issue = ::Issue.new(@github, number)
    zendesk_number = card.links.find{ |link| link[:url] =~ /support/ }.andand[:text] # FIXME - search on correct Zendesk URL from ENV['ZENDESK_URL']
    ticket = ::Ticket.new(@zendesk, zendesk_number) if zendesk_number
    ::Task.new number, :card => card, :issue => issue, :ticket => ticket
  end
end
