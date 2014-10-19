# hipbot-example

[![Code Climate](https://codeclimate.com/github/netguru/hipbot-example.png)](https://codeclimate.com/github/netguru/hipbot-example)

Deploy your own hipbot to heroku in 4 easy steps:

0) Create an user on hipchat for your hipbot

1) Clone this repo

```
git clone https://github.com/netguru/hipbot-example.git
```

2) Set up heroku app

( find your bot's JID on https://hipchat.com/account/xmpp )

```
heroku apps:create
heroku config:set HIPBOT_JID=bot@chat.hipchat.com
heroku config:set HIPBOT_PASSWORD=password
```

3) Deploy!

```
git push heroku master
heroku ps:scale worker=1
```

## Usage

```ruby
hello hipbot @your_bot_name # => Hello human
my name is matz @your_bot_name # => Nice to meet you.
```

Don't forget to mention your bot username.

You can now customize the responses in bot.rb for fun and profit!

Also, check out some of the plugins included ( https://github.com/netguru/hipbot-plugins#hipbot-plugins ).
