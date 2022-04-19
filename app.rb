require 'telegram/bot'
require 'yaml'
require_relative 'english_word_list'

token = YAML.load(File.open('secrets.yml'))['secret_key_bot']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      word_list = EnglishWordList.new
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      bot.api.send_message(chat_id: message.chat.id, text: "#{word_list.description}")
      word_list.call(bot, message.chat.id)
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end

# {
#    "message_id":307,
#    "from":{"id":225646729,"is_bot":false,"first_name":"Денис","last_name":"Левченко","username":"leva8426","language_code":"ru"},
#    "date":1650368539,
#    "chat":{"id":225646729,"type":"private","username":"leva8426","first_name":"Денис","last_name":"Левченко"},
#    "text":"sdbfgb",
#    "entities":[],
#    "photo":[],
#    "caption_entities":[],
#    "new_chat_members":[],
#    "new_chat_photo":[]
#  }
