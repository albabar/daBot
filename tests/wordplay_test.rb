require 'minitest/autorun'
require_relative '../wordplay'

class WordPlayTest < Minitest::Test
# class WordPlayTest < Test::Unit::TestCase

# Called before every test method runs. Can be used
# to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_fail

    # fail('Not implemented')
  end

  def test_sentences
    assert_equal(["a", "b", "c d", "e f g"], "a. b. c d. e f g.".sentences)
    assert_equal(["a", "b", "c d", "e f g"], "a. b. c d... e f g.".sentences)
    assert_equal(["a", "b", "c d", "e f g"], "a. b. c d.!. e f g.".sentences)
    assert_equal(["a", "b", "c d", "e f g"], "a. b. c d? e f g.".sentences)

    test_text = %q{Hello. This is a test
of sentence separation. This is the end
of the test.}
    assert_equal("This is the end of the test", test_text.sentences[2])
  end

  def test_words
    assert_equal(%w{this is a test}, "this is a test".words)
    assert_equal(%w{this is a test}, "this... is a test".words)
    assert_equal(%w{these are mostly words}, "these are, mostly, words.".words)
  end

  def test_sentence_choice
    assert_equal("This is a great test",
                 WordPlay.best_sentence(['This is a test',
                                         'This is another test',
                                         'This is a great test'
                                        ], %w{test great this})
    )

    assert_equal("This is a great Test", WordPlay.best_sentence(["This is a great Test"], %w{still the best}))
  end

  def test_basic_pronouns
    assert_equal("I am a robot", WordPlay.switch_pronouns("you are a robot"))
    assert_equal("you are a person", WordPlay.switch_pronouns("I am a person"))
    assert_equal("I love you", WordPlay.switch_pronouns("You love me"))
  end

  def test_mixed_pronouns
    assert_equal("you gave me life", WordPlay.switch_pronouns("I gave you life"))
    assert_equal("I am not what you are", WordPlay.switch_pronouns("you are not what I am"))
    assert_equal("I annoy your dog", WordPlay.switch_pronouns("You annoy my dog"))
  end
end