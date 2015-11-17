class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses
  attr_reader :word_with_guesses
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @guessed = []
    @word_with_guesses = word.gsub(/[a-z]/i, "-")
    @count_wrong = 0
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def guess(char)
    if not char or char =~ /([^a-z]|^$)/i
      raise ArgumentError
    end
    char.downcase!
    if @word.include? char
      @wrong_guesses = ''
      @guesses = char
    else
      @guesses = ''
      @wrong_guesses = char
    end
    return false if @guessed.include? char
    @count_wrong += 1 if @wrong_guesses != ''
    update_word_with_guesses char
    @guessed << char
    
  end
  
  def check_win_or_lose
    return :lose if @count_wrong >= 7
    return :win if @word == @word_with_guesses
    :play
  end
  
  
  private
  def update_word_with_guesses char
    cur_word_list = @word_with_guesses.split ''
    (0..@word.length-1).each do |idx|
      cur_word_list[idx] = @word[idx] if @word[idx] == char
    end
    @word_with_guesses = cur_word_list.join
  end
end
