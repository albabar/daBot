class WordPlay
  def self.best_sentence(sentences, desired_words)
    ranked_sentences = sentences.sort_by do |s|
      s.words.length - (s.downcase.words - desired_words).length
    end

    ranked_sentences.last
  end

  def self.switch_pronouns(text)
    text.gsub(/\b(I am|You are|I|You|Your|My|Me)/i) do |pronoun|
      case pronoun.downcase
        when "i", "me"
          "you"
        when "you"
          "me"
        when "i am"
          "you are"
        when "you are"
          "I am"
        when "your"
          "my"
        when "my"
          "your"
      end
    end.sub(/^me\b/i, 'I')
  end
end

class String
  def sentences
    gsub(/\n|\r/, ' ').split(/[\.\?!]+\s*/)
  end

  def words
    scan(/\w[\w\'\-']*/)
  end
end

