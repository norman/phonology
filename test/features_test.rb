require File.expand_path("../test_helper", __FILE__)

class FeaturesTest < Test::Unit::TestCase

  test "should expand feature groups" do
    assert_equal [:dental, :alveolar, :postalveolar, :retroflex, :velar].to_set,
        Phonology::Features.expand(:coronal, :dental, :velar)
  end

end
