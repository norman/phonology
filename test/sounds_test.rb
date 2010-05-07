require File.expand_path("../test_helper", __FILE__)

class SoundsTest < Test::Unit::TestCase

  def setup
    @sounds = Phonology.sounds
  end

  def small_set
    Phonology::Sounds.from_ipa("b", "p", "d", "t", "m", "n")
  end

  test "should return feature set for symbol" do
    assert_equal [:voiced, :bilabial, :nasal].to_set, @sounds.features("m")
  end

  test "#with should return a set of sets that include any of the given features" do
    assert_equal ["p", "b", "m", "n"].to_set, small_set.with(:bilabial, :nasal).symbols
  end

  test "#without should return a set of sets that exclude any of the given features" do
    assert_equal ["p", "b", "n", "d", "t"].to_set, small_set.without(:bilabial, :nasal).symbols
  end

  test "#with_all should return a set of sets that include any of the given features" do
    assert_equal ["m"].to_set, small_set.with_all(:bilabial, :nasal).symbols
  end

  test "#without_any should return a set of sets that exclude all of the given features" do
    assert_equal ["d", "t"].to_set, small_set.without_any(:bilabial, :nasal).symbols
  end

end
