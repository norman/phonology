require File.expand_path("../test_helper", __FILE__)

class RulesTest < Test::Unit::TestCase

  include Phonology

  test "should apply rules" do

    rules = Rules.new do
      if nasal? && precedes(:alveolar)
        add :alveolar
      elsif lateral_approximant?
        nil
      elsif coronal? && follows(:coronal, :unvoiced)
        delete :voiced
      else
        curr_sound
      end
    end

    assert_equal "at",  rules.apply([Sound.new("a"), Sound.new("l"), Sound.new("t")]).map(&:symbol).join
    assert_equal "ant", rules.apply([Sound.new("a"), Sound.new("m"), Sound.new("t")]).map(&:symbol).join
    assert_equal "ast", rules.apply([Sound.new("a"), Sound.new("s"), Sound.new("d")]).map(&:symbol).join

  end

end
