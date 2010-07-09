module Phonology

  # An inventory of Phonological feature sets.
  class Inventory

    # A Hash with a set of features as keys, and UTF-8 codepoints for IPA
    # letters as values.
    attr :sets

    # Get an instance, building its set from a list IPA characters.
    def self.from_ipa(*chars)
      chars = chars.flatten.map {|char| char.unpack("U*")}
      new Hash[Features::SETS.select {|key, val| chars.include? val}]
    end

    def initialize(sets)
      @sets = sets
    end

    if RUBY_VERSION < "1.9"
      # Given an IPA symbol, return a corresponding set of distinctive features.
      def features(symbol)
        @sets.index(symbol.unpack("U*"))
      end
    else
      def features(symbol)
        @sets.key(symbol.unpack("U*"))
      end
    end

    # Given a set of features, return an IPA symbol
    def symbol(*features)
      codepoints(features).pack("U*")
    end

    def symbols
      @sets.values.map {|symbol| symbol.pack("U*")}.to_set
    end

    # Given a set of features, return an array of UTF-8 codepoints.
    def codepoints(*features)
      features = setify(*features)
      @sets[features] || (raise FeatureError, "No such set #{features.inspect}")
    end

    # Return an instance of Sounds whose sets include any of the given
    # features.
    def with(*features)
      pos, neg = mangle_args(*features)
      self.class.new(Hash[@sets.select do |key, val|
        !key.intersection(pos).empty?
      end]).without_any(neg)
    end

    # Return feature sets that include all of the given features
    def with_all(*features)
      pos, neg = mangle_args(*features)
      self.class.new(Hash[@sets.select do |key, val|
        pos.subset?(key)
      end]).without_any(neg)
    end

    # Return an instance of Sounds whose sets exclude any of the given
    # features.
    def without(*features)
      features = setify(*features)
      self.class.new Hash[@sets.select {|key, val| !features.subset?(key)}]
    end

    # Return an instance of Sounds whose sets exclude all of the given
    # features.
    def without_any(*features)
      features = setify(*features)
      self.class.new Hash[@sets.select {|key, val| key.intersection(features).empty?}]
    end

    private

    def mangle_args(*args)
      pos = setify(*args)
      neg = extract_negations(pos)
      [pos.select {|f| f.to_s !~ /\A(non_|un)/}.compact.to_set, neg]
    end

    def setify(*args)
      Features.expand(args.first.kind_of?(Set) ? args.shift : args.flatten.to_set)
    end

    def extract_negations(set)
      val = Features.expand(*set.map {|feat| feat.to_s =~ /\A(non_|un)([a-z_]*)\z/ && $2.to_sym}.compact)
    end

  end

end
