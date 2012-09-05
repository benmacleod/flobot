$: << File.dirname(__FILE__)

require 'cinch'
require 'trello'
require 'state_machine'
require 'lib/trello_client'
require 'lib/task'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = ENV['IRC_SERVER']
    c.nick = ENV['IRC_BOT_NAME']
    c.channels = eval ENV['IRC_CHANNELS']
  end

  on :message, /^(\w+) (\d+)/ do |m, action, number|
    task = TrelloClient.task(number)
    task.send "do_#{action}".to_sym
    m.reply "Moved task \"#{task.card.name}\" to \"#{task.card.list.name}\""
  end
end

bot.start
