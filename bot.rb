require_relative 'lib/hipello'
require 'dotenv'
Dotenv.load # make sure you have a .env file. see .env.sample

# require 'hipbot-plugins/github'
# require 'hipbot-plugins/google'
# check out more plugins on https://github.com/netguru/hipbot-plugins

# test trello
# @trello = Hipello::TrelloHandle.new.add_card("make sure this shows up: #{Time.now}")

# test hipchat
# $stdout.sync = true
# hip = Hipello::HipchatHandle.new
# hip.test_start!

# a = Hipello::TrelloHandle.new
# a.add_card_to('first-list', 'first-card')
