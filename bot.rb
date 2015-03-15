require_relative 'lib/hipello'
require 'dotenv'
Dotenv.load

# require 'hipbot-plugins/github'
# require 'hipbot-plugins/google'
# check out more plugins on https://github.com/netguru/hipbot-plugins

# test trello
# @trello = Hipello::TrelloHandler.new.add_card("make sure this shows up: #{Time.now}")

# test hipchat
$stdout.sync = true
Hipello::HipchatHandler.new.test_start!
