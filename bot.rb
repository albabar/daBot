require 'yaml'
require './wordplay'

class Bot
  attr_reader :name

  def initialize(options)
    @name = options[:name] || "daBot"

    begin
      @data = YAML.load(File.read(options[:data_file]))
    rescue
      raise "Can't load bot data."
    end
    @responses = @data[:responses]
  end

  def greeting
    random_message(:greeting)
  end

  def farewell
    random_message :farewell
  end

  def response_to text
    prepared_text = preprocess(text.downcase)
    sentence = best_sentence(prepared_text)
    responses = possible_responses(sentence)

    responses[rand(responses.length)]
  end

  private

  def random_message(key)
    rand_index = rand(@responses[key].length)
    @responses[key][rand_index].gsub(/\[name\]/, @name)
  end

  def preprocess text
    perform_substitution text
  end

  def perform_substitution text
    @data[:presubs].each { |s| text.gsub!(s[0], s[1]) }
    text
  end

  def best_sentence text
    hot_words = @responses.keys.select do |k|
      k.class == String && k =~ /^\w+$/
    end

    WordPlay.best_sentence(text.sentences, hot_words)
  end

  def possible_responses sentence
    responses = []

    @responses.keys.each do |pattern|
      next unless pattern.is_a?(String)

      # Search for a match. Remove asterisk sign before searching.
      # Save all responses to the `responses` array.
      if sentence.match('\b' + pattern.gsub(/\*/, '') + '\b')
        # If pattern contains asterisk/placeholder substitute it with desired text
        if pattern.include?('*')
          responses << @responses[pattern].collect do |phrase|
            #Remove everything before placeholder to get the desired part
            matching_selection = sentence.sub(/^.*#{pattern}\s+/, '')

            #Now switch original text along with Pronouns switching
            phrase.sub('*', WordPlay.switch_pronouns(matching_selection))
          end
        else
          # In case of no placeholder, simply insert the matches into `responses` array
          responses << @responses[pattern]
        end
      end
    end

    # Add default messages in case of no match
    responses << @responses[:default] if responses.empty?

    # Return a flat/Single Dimensional array of `responses`
    responses.flatten
  end

end