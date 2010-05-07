require File.expand_path("../test_helper", __FILE__)

class PhonologyTest < Test::Unit::TestCase

  test "sounds should return an instance of Sounds" do
    assert_equal Phonology::Sounds, Phonology.sounds.class
  end

  test "should return feature set for symbol" do
    assert_equal [:voiced, :bilabial, :nasal].to_set, Phonology.features_for("m")
  end

  test "should return a symbol for a feature set" do
    assert_equal "d", Phonology.symbol_for(:voiced, :alveolar, :plosive)
  end

end
