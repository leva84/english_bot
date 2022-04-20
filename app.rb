require 'telegram/bot'
require_relative 'english_word_list'

token = ENV['SECRET_KEY_BOT']

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
