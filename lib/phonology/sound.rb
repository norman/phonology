module Phonology

  module SoundBase

    attr_accessor :features, :orthography, :hints
    protected :features=, :hints=

    Features::ALL.each do |feature|
      class_eval(<<-EOM, __FILE__, __LINE__ +1)
        def #{feature}?
          features.include? :#{feature}
        end

        def non_#{feature}?
          !#{feature}?
        end
      EOM
    end

    Features::CLASSES.each do |feature_class, values|
      class_eval(<<-EOM, __FILE__, __LINE__ +1)
        def #{feature_class}?
          set = Features.expand(:#{feature_class})
          !set.intersection(features).empty?
        end

        def non_#{feature_class}?
          !#{feature_class}?
        end
      EOM
    end

    alias unvoiced? non_voiced?

    def sonority
      case
      when vocalic? then 5
      when approximant? then 4
      when liquid? then 3
      when nasal? then 2
      when fricative? then 1
      else 0
      end
    end

    # Orthography hints that can be useful to consult when applying rules.
    def hints
      @hints ||= []
    end

    # TODO set up list of valid hints
    def hint(*args)
      self.hints += args.flatten
      self
    end

    def orthography
      @orthography ||= ""
    end

    def codepoints
      raise NotImplementedError
    end

    def exists?
      raise NotImplementedError
    end

    # Get the IPA codepoints for the sound, including any diacritics.
    def symbol
      codepoints.pack("U*")
    end

    # Does the sound have more than one place of articulation?
    def coarticulated?
      place.size > 1
    end

    # Get the sound's place of articulation.
    def place
      features.intersection(Features::PLACE)
    end

    # Get the sound's manner of articulation.
    def manner
      features.intersection(Features::MANNER)
    end

    # Get the sound's height.
    def height
      features.intersection(Features::HEIGHT)
    end

    # Get the sound's backness.
    def backness
      features.intersection(Features::BACKNESS)
    end

    # Get the place groups (:coronal, :dorsal, etc). Normally there should only be one.
    def place_groups
      Features.place_groups(features)
    end

  end

  # A set of distinctive features
  class Sound

    include SoundBase

    # Does the group of features exist in human speech?
    def self.exists?(features)
      !! Features::SETS[features]
    end

    def initialize(*features)
      if features.first.kind_of?(String)
        self.features = Phonology.features_for(features.shift).clone
      else
        self.features = features.to_set
      end
    end

    # Get the IPA codepoints for the sound, excluding any diacritics.
    def codepoints
      Phonology.sounds.codepoints(features)
    end

    # Add a feature, replacing either the place or manner of articulation,
    # or the height or backness. Returns self.
    def <<(*args)
      args.to_a.flatten.each do |feature|
        features.subtract Features.set(feature).to_a
        add! feature
      end
      self
    end
    alias add <<

    # Add a feature without replacing place or manner.
    def add!(feature)
      features.add feature.to_sym
      self
    end

    # Remove a feature, and return self.
    def >>(*args)
      args.to_a.flatten.each do |feature|
        features.delete feature.to_sym
      end
      self
    end
    alias delete >>

    # Does the sound exist?
    def exists?
      self.class.exists?(features)
    end

  end


  # A sound which begins plosive and finished fricative.
  class Affricate

    include SoundBase

    attr_accessor :onset, :release
    protected :onset=, :release=

    def initialize(onset, release)
      self.onset = get_sound(onset)
      self.release = get_sound(release)
    end

    def exists?
      onset.exists? && release.exists?
    end

    def features
      onset.features + release.features
    end

    def codepoints
      [onset.codepoints, Features::DIACRITICS[:affricate], release.codepoints].flatten
    end

    private

    def get_sound(arg)
      arg.kind_of?(Sound) ? arg : Sound.new(*arg)
    end

  end

end
