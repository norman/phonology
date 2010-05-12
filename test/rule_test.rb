require File.expand_path("../test_helper", __FILE__)

class RuleTest < Test::Unit::TestCase

  include Phonology

  test "should delegate to current sound" do
    assert_rule "amta", "anta" do
      add :alveolar if nasal? and precedes :alveolar
    end
  end

  test "should delete sound" do
    assert_rule "amta", "ama" do
      delete if alveolar? and follows :nasal
    end
  end

  test "should insert sound" do
    assert_rule "pta", "pata" do
      insert "a" if plosive? and precedes :plosive
    end
  end

  test "should voice" do
    assert_rule "bta", "pta" do
      devoice if plosive? and precedes(:plosive, :unvoiced)
    end
  end

  private

  def assert_rule(given, expected, &block)
    rule = Rule.new &block
    sounds = given.split('').map {|ipa| Sound.new(ipa)}
    assert_equal expected, rule.apply(sounds).compact.map(&:symbol).join
  end


end
