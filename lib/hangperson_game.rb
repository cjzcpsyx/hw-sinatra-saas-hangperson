class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_set = word.split('').uniq()
    @guess_count = 0
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(word)
    if word.nil? || word.empty? || word =~ /\A[^a-zA-Z]\z/
      raise ArgumentError
    end
    word.downcase!
    if (@guesses.include? word) || (@wrong_guesses.include? word)
      return false
    else
      if @word_set.delete word
        @guesses += word
      else
        @guess_count += 1
        @wrong_guesses += word
      end
      return true
    end
  end
  
  def word_with_guesses
    result = ''
    @word.split('').each do |w|
      if @guesses.include? w
        result += w
      else
        result += '-'
      end
    end
    result
  end
  
  def check_win_or_lose
    status = :win
    if @guess_count >= 7
      return :lose
    else
      @word.split('').each do |w|
        if !@guesses.include? w
          status = :play
        end
      end
    end
    return status
  end

end
