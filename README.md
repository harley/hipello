# hipbot-example

Deploy your own hipbot to heroku in 5 easy steps:

0) Create an user on hipchat for your hipbot

1) Clone this repo

```
git clone git@github.com:netguru/hipbot-example.git
```

2) Set up heroku app

```
heroku apps:create
heroku ps:scale worker=1
```

3) Set up the credentials

( find your bot's JID on https://hipchat.com/account/xmpp )

```
heroku config:set HIPBOT_JID=bot@chat.hipchat.com
heroku config:set HIPBOT_PASSWORD=password
```

4) Deploy!

```
git push heroku master
```

You can now customize the responses in bot.rb for fun and profit!

Also, check out some of the plugins included ( https://github.com/netguru/hipbot-plugins#hipbot-plugins ).
