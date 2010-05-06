require File.expand_path("../test_helper", __FILE__)

class SoundTest < Test::Unit::TestCase

  include Phonology

  test "should return an IPA symbol" do
    assert_equal "m", Sound.new(:voiced, :bilabial, :nasal).symbol
  end

  test "should instantiate from IPA symbol" do
    assert_equal [:voiced, :bilabial, :nasal].to_set, Sound.new("m").features
  end

  test "should indicate individual features" do
    assert Sound.new("n").nasal?
  end

  test "should indicate feature classes" do
    assert Sound.new("n").coronal?
    assert Sound.new("n").consonantal?
    assert !Sound.new("n").vocalic?
  end

  test "should add/remove voice" do
    sound = Sound.new("p")
    sound << :voiced
    assert_equal "b", sound.symbol
    sound >> :voiced
    assert_equal "p", sound.symbol
  end

  test "should add/remove rounding" do
    sound = Sound.new("a")
    sound << :rounded
    assert_equal "\u0276", sound.symbol
    sound >> :rounded
    assert_equal "a", sound.symbol
  end

  test "should change manner of articulation" do
    sound = Sound.new("m")
    sound << :plosive
    assert_equal "b", sound.symbol
  end

  test "should change place of articulation" do
    assert_equal "n", Sound.new("m").add(:alveolar).symbol
  end

  test "should change backness" do
    assert_equal "u", Sound.new("y").add(:back).symbol
  end

  test "should change height" do
    assert_equal "i", Sound.new("a").add(:close).symbol
  end

  test "should get place of articulation" do
    assert_equal :alveolar, Sound.new("r").place.first
  end

  test "should get manner of articulation" do
    assert_equal :trill, Sound.new("r").manner.first
  end

  test "should get height" do
    assert_equal :close_mid, Sound.new("e").height.first
  end

  test "should get backness" do
    assert_equal :front, Sound.new("e").backness.first
  end

  test "should indicate if sound exists" do
    assert !Sound.new(:front, :plosive).exists?
    assert Sound.new(:bilabial, :plosive).exists?
  end

  test "should move sounds backwards" do
    assert_equal "n", Sound.new("m").backward.backward.symbol
  end

end
