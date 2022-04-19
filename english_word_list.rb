# frozen_string_literal: true

require 'telegram/bot'

class EnglishWordList

  attr_reader :words_arr

  def initialize
    words_list = File.readlines("#{Dir.pwd}/data/english_word_list.txt")
    normalized_words = words_list.shuffle.map { |string| string.chomp.downcase.split(' ') }
    @words_arr = normalized_words.map { |string| { eng_word: string.shift, translation: string.join(' ') } }
    @stop = nil
  end

  def description
    <<~HEREDOC
      'программа выводит английские слова и их перевод для изучения'
    HEREDOC
  end

  def call(bot, message_id)
    words_arr.each do |w_hash|
      break(output(bot, message_id, 'Good Bye!)')) if @stop == 1

      output(bot, message_id, w_hash[:translation])

      bot.listen do |message|
        break(@stop = 1) if message.text == '/stop'

        output(bot, message.chat.id, result_translation(message.text, w_hash[:eng_word]))
        break if message.text == w_hash[:eng_word]
      end
    end
  end

  private

  def result_translation(input, eng_word)
    input == eng_word ? 'Yes !)' : "It is not right, that is right: '' #{eng_word} ''"
  end

  def output(bot, message_id, text)
    bot.api.send_message(chat_id: message_id, text: "#{text}")
  end
end
