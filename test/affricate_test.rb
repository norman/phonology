require File.expand_path("../test_helper", __FILE__)

class AffricateTest < Test::Unit::TestCase
  include Phonology

  def setup
    @affricate = Affricate.new("t", "s")
  end

  test "should get symbol for affricate" do
    assert_equal [116, 865, 115], @affricate.symbol.unpack("U*")
  end

  test "should act like a sound" do
    assert @affricate.exists?
    assert @affricate.coronal?
    assert @affricate.plosive?
    assert @affricate.fricative?
  end

end
