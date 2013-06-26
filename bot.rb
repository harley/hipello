require 'hipbot'

class MyHipbot < Hipbot::Bot
  configure do |c|
    c.name      = ENV['HIPBOT_NAME']
    c.jid       = ENV['HIPBOT_JID']
    c.password  = ENV['HIPBOT_PASSWORD']
    # optional configuration
    # c.plugins   = [ PluginClass ]
    # c.teams     = { vip: ['John', 'Mike'] }
    # c.rooms     = { project_rooms: ['Project 1', 'Project 2'] }
  end

  desc 'this is a simple response'
  on(/hello hipbot/) do
    reply('hello human')
  end

  desc 'this is a response with arguments'
  on(/my name is (\w+) (\w+)/) do |first_name, last_name|
    reply("nice to meet you, #{first_name} #{last_name}!")
  end
end

MyHipbot.start!
