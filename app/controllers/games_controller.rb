# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
      @end_time = Time.now
      @start_time = params[:start_time].to_time
      @attempt = params[:attempt]
      @result = { score: 0, message: '' }
      @letters = params[:letters]

      check = @attempt.upcase.chars.all? { |letter| @attempt.upcase.chars.count(letter) <= @letters.count(letter) }
      word = english?(@attempt)

      if !check then @result[:message] = 'not in the grid'
      elsif !word['found'] then @result[:message] = 'not an english word'
      else
        @result[:score] = (1 / (@end_time - @start_time)) * @attempt.length
        @result[:message] = 'Well done!'
    end
  end


private 

def english?(attempt)
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      word_serialized = open(url).read
      JSON.parse(word_serialized)
    end
end


