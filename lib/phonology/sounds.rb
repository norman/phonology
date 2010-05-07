module Phonology

  # An inventory of Phonological feature sets.
  class Sounds

    # A Hash with a set of features as keys, and UTF-8 codepoints for IPA
    # letters as values.
    attr :sets

    # Get an instance, building its set from a list IPA characters.
    def self.from_ipa(*chars)
      chars = chars.flatten.map {|char| char.unpack("U*")}
      new Features::SETS.select {|key, val| chars.include? val}
    end

    def initialize(sets)
      @sets = sets
    end

    # Given an IPA symbol, return a corresponding set of distinctive features.
    def features(symbol)
      @sets.key(symbol.unpack("U*"))
    end

    # Given a set of features, return an IPA symbol
    def symbol(*features)
      codepoints(features).pack("U*")
    end

    def symbols
      @sets.values.map {|symbol| symbol.pack("U*")}.to_set
    end

    # Given a set of features, return an array of UTF-8 codepoints.
    def codepoints(features)
      features = features.first.kind_of?(Set) ? features.shift : features.flatten.to_set
      @sets[features] || (raise FeatureError, "No such set #{features.inspect}")
    end

    # Return an instance of Sounds whose sets include any of the given
    # features.
    def with(*features)
      features = features.first.kind_of?(Set) ? features.shift : features.flatten.to_set
      self.class.new @sets.select {|key, val| !key.intersection(features).empty?}
    end

    # Return feature sets that include all of the given features
    def with_all(*features)
      features = features.first.kind_of?(Set) ? features.shift : features.flatten.to_set
      self.class.new @sets.select {|key, val| features.subset?(key)}
    end

    # Return an instance of Sounds whose sets exclude any of the given
    # features.
    def without(*features)
      features = features.first.kind_of?(Set) ? features.shift : features.flatten.to_set
      self.class.new @sets.select {|key, val| !features.subset?(key)}
    end

    # Return an instance of Sounds whose sets exclude all of the given
    # features.
    def without_any(*features)
      features = features.first.kind_of?(Set) ? features.shift : features.flatten.to_set
      self.class.new @sets.select {|key, val| key.intersection(features).empty?}
    end

  end

end
