require "open-uri"

class GamesController < ApplicationController
  def new
    letters = ("A".."Z").to_a
    @letters = Array.new(10) { letters.sample }
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)

    if @included && @english_word
      @result = "10, Brilliant!"
    else
      @result = "0, not an english word"
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.parse("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
