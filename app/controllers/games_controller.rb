require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(15)
    @start_time = Time.now
  end

  def score
    word = params[:word]
    letters = params[:letters].upcase.gsub(/\W/, '').split('')
    attempt_letters = word.upcase.split('')
    @start_time = params[:time]
    year = params[:time][0..4]
    month = params[:time][6..7]
    day = params[:time][9..10]
    hour = params[:time][12..13]
    minute = params[:time][15..16]
    second = params[:time][18..19]
    time_elasped = Time.now - Time.new(year, month, day, hour, minute, second)
    not_repeat = check_attempt(attempt_letters, letters)
    if (attempt_letters - letters).any? || (not_repeat == false)
      @score = 'Not in the grid. Score: 0'
    else
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      word_serialized = open(url).read
      parseword = JSON.parse(word_serialized)
      time = parseword['length'] + (100 / time_elasped)
      if parseword['found'] == true
        @score = "Your score is #{time}"
      else
        @score = 'Your word is not a english word. Score: 0'
      end
    end
  end

  def check_attempt(attempt, grid)
    # returns boolean
    a = true
    grid.each do |item|
      attempt.each do |char|
        a = false if item == char && (attempt.count(char) > grid.count(item))
      end
    end
    a
  end
end
