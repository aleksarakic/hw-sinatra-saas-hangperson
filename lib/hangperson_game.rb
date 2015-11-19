class HangpersonGame
  attr_accessor :word, :correct_guesses, :wrong_guesses
  
  def word_with_guesses
    @word_with_guesses
  end
  
  def initialize(word)
    @word = word
    @correct_guesses = ""
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
    update_word_with_guesses char
    if  !char || char =~ /([^a-z]|^$)/i
      raise ArgumentError
    end
    char.downcase!
    if @word.include? char
      @wrong_guesses = ''
      @correct_guesses = char
    else
      @correct_guesses = ''
      @wrong_guesses = char
    end
    return false if @guessed.include? char
    @count_wrong += 1 if @wrong_guesses != ''
    @guessed << char
    
  end
  
  def check_win_or_lose
    return :lose if @count_wrong >= 7
    return :win if @word == @word_with_guesses
    :play
  end
  
  private
  def update_word_with_guesses char
    cur_word_list = @word_with_guesses.split '' #trenutna word lista = @word pretvorena u crtice pa splitovana, znaci array crtica
    (0...@word.length).each do |idx| # word length puta 
      cur_word_list[idx] = @word[idx] if @word[idx] == char # crtica[njen index] = Word[index] ako word[index] == char(slovo koje je zadato za pogadjanje)
      # u loopu: prva crtica = prvo slovo ako je prvo slovo == zadato slovo; 
    end
    @word_with_guesses = cur_word_list.join #
  end
end
