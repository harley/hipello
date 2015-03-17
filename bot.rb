require_relative 'lib/hipello'

if ENV['DEV']
  require 'dotenv'
  Dotenv.load # make sure you have a .env file. see .env.sample
end

# require 'hipbot-plugins/github'
# require 'hipbot-plugins/google'
# check out more plugins on https://github.com/netguru/hipbot-plugins

$stdout.sync = true
Hipello::HipchatHandle.new.start_bot!
