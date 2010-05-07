require File.expand_path("../test_helper", __FILE__)

class FeaturesTest < Test::Unit::TestCase

  include Phonology

  test "should expand place groups" do
    assert_equal [:dental, :alveolar, :postalveolar, :retroflex, :velar].to_set,
        Features.expand(:coronal, :dental, :velar)
  end

  test "should contract place groups" do
    assert_equal [:coronal], Features.place_groups([:alveolar, :plosive, :postalveolar, :fricative])
    assert_equal [:coronal], Features.place_groups([:alveolar, :plosive, :postalveolar, :fricative].to_set)
    assert_equal [:coronal], Features.place_groups(:alveolar, :plosive, :postalveolar, :fricative)
  end

end
