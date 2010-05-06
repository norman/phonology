module Phonology

  # A set of distinctive features
  class Sound

    attr_reader :features

    def initialize(*features)
      @features = if features.first.kind_of?(String)
        Phonology.features(features.shift)
      else
        features.to_set
      end
    end

    Features::ALL.each do |feature|
      class_eval(<<-EOM, __FILE__, __LINE__ +1)
        def #{feature}?
          @features.include? :#{feature}
        end
      EOM
    end

    Features::CLASSES.each do |feature_class, values|
      class_eval(<<-EOM, __FILE__, __LINE__ +1)
        def #{feature_class}?
          set = Features.expand(:#{feature_class})
          !set.intersection(@features).empty?
        end
      EOM
    end

    # Get the IPA symbol for the sound.
    def symbol
      Phonology.symbol(features)
    end

    # Add a feature, replacing either the place or manner of articulation,
    # or the height or backness. Returns self.
    def <<(feature)
      feature = feature.to_sym
      (@features -= (Features.set(feature) || [])) << feature
      self
    end
    alias add <<

    # Remove a feature, and return self.
    def >>(feature)
      @features -= [feature.to_sym]
      self
    end

    # Get the next sound, moving backwards in the mouth.
    def backward
      if consonantal?
        index = Features::PLACE.index(place.first)
        max = Features::PLACE.length
        features = @features - Features::PLACE
        until index > max do
          index = index + 1
          feature = Features::PLACE[index]
          if self.class.exists?(features + [feature])
            @features = features + [feature]
            return self
          end
        end
      end
      self
    end

    def forward
    end

    # Get the sound's place of articulation.
    def place
      @features.intersection(Features::PLACE)
    end

    # Get the sound's manner of articulation.
    def manner
      @features.intersection(Features::MANNER)
    end

    # Get the sound's height.
    def height
      @features.intersection(Features::HEIGHT)
    end

    # Get the sound's backness.
    def backness
      @features.intersection(Features::BACKNESS)
    end

    def exists?
      self.class.exists?(@features)
    end

    def self.exists?(features)
      !! Features::SETS[features]
    end

  end
end
