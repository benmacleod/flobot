$: << File.dirname(__FILE__)

require 'cinch'
require 'lib/service_client'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = ENV['IRC_SERVER']
    c.nick = ENV['IRC_BOT_NAME']
    c.channels = eval ENV['IRC_CHANNELS']
  end

  on :message, /^(\w+) (\d+)/ do |m, action, number|
    m.reply "Getting task #{number}"
    task = ServiceClient.task(number)
    m.reply "#{action.capitalize}ifying task #{number}"
    if task.state.to_s == action.to_s
      m.reply "\"#{task.name}\" already in \"#{task.location}\" - nothing to do"
    else
      task.send "do_#{action}".to_sym
      m.reply "Moved \"#{task.name}\" to \"#{task.location}\""
    end
    #task.comments.each do |comment|
    #  m.reply comment['body']
    #end
  end
end

bot.start
