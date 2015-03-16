# Hipello - Create Trello cards from Hipchat

## Background

Trello is listed on https://www.hipchat.com/integrations and this integration
allows Trello updates to show up in Hipchat rooms.

Hipello is a Hipchat bot that can do the opposite:
- Allow Hipchat users to create a Trello card via a chat message
- The chat message can mention people and can specify the board to create the card in

Heads up: work in progress.

## Dependencies
- [hipbot](https://github.com/pewniak747/hipbot)
- [ruby-trello](https://github.com/jeremytregunna/ruby-trello)

## Setup
We store config in ENV vars (per http://12factor.net/config). The `.env.sample` file should tell you the what. See below for the how.

### Environment variables
- How to get Trello keys:
  - Create a bot user on Trello
  - Sign in to Trello as bot
  - Get TRELLO_KEY by going to https://trello.com/app-key and use the value under Key
  - Use the above TRELLO_KEY to create the following URL to obtain TRELLO_MEMBER_TOKEN:
    ```
    https://trello.com/1/authorize?key=YOUR_TRELLO_KEY&name=trello-cli&expiration=never&response_type=token&scope=read,write
    ```
    (this requests a token for read/write member token)
- How to get Hipchat keys:
  - Create a bot user in your Hipchat organization
  - Go to https://hipchat.com/account/xmpp to get your HIPBOT_JID
  - Use the bot account password for HIPBOT_PASSWORD
- Create mapping from hashtags to Trello cards
  - Obtain the board id from a board url on Trello. You just need the `:board_id` part in `https://trello.com/b/:board_id/:board_name`
  - Say if you want to use `#request` for board with id `xAyBzC`, set the following env variable `BOARD_ID_FOR_REQUEST=xAyBzC`
  - You can set as many mappings as desired using the `BOARD_ID_FOR_` prefix, such as board with id `BOARD_ID_FOR_BUGS` to catch messages containing the `#bugs` tag

### Local
- `cp .env.sample .env` and fill out the keys in `.env` (see above on how to get the keys)

### Heroku
- Clone this repo
  ```
  git clone https://github.com/harley/hipello
  ```

- Create a heroku app and push the code to it
- Set ENV variables via `heroku config:set --app <your_app_name> TRELLO_KEY=... HIPBOT_JID=... <and-other-keys>`
(You can also edit config vars on your app's settings tab on the Heroku Dashboard) ![heroku dashboard](https://s3.amazonaws.com/heroku.devcenter/heroku_assets/images/389-original.jpg)
