module Phonology

  # Raised for any attempt to access an invalid feature.
  class FeatureError < StandardError; end

  # Distinctive features.
  module Features

    # Pulmonic consonants
    PULMONIC = [:nasal, :plosive, :fricative, :approximant, :trill, :flap,
      :lateral, :bilabial, :labiodental, :dental, :alveolar, :postalveolar,
      :retroflex, :palatal, :velar, :uvular, :pharyngeal, :epiglottal, :glottal]

    # Non-pulmonic consonants
    NON_PULMONIC = [:click, :implosive, :ejective]

    # Vocalic features
    VOCALIC = [:close, :near_close, :close_mid, :mid, :open_mid, :near_open, :open,
      :front, :near_front, :central, :near_back, :back, :rounded]

    # Consontal features
    CONSONANTAL = (PULMONIC + NON_PULMONIC).to_set

    # All features classes
    ALL = ([:voiced] + PULMONIC + NON_PULMONIC + VOCALIC).to_set

    # Manner of articulation features
    MANNER = [:nasal, :plosive, :fricative, :approximant, :trill, :flap, :lateral_fricative,
      :lateral_approximant, :lateral_flap] + NON_PULMONIC

    # Place of articulation features
    PLACE = CONSONANTAL.to_a - MANNER

    # Vowel height
    HEIGHT = [:close, :near_close, :close_mid, :mid, :open_mid, :near_open, :open]

    # Vowel backness
    BACKNESS = (VOCALIC.to_set - HEIGHT - [:rounded])

    # Feature classes
    CLASSES = {
      :labial       => [:bilabial, :labiodental].to_set,
      :coronal      => [:dental, :alveolar, :postalveolar, :retroflex].to_set,
      :dorsal       => [:palatal, :velar, :uvular].to_set,
      :radical      => [:pharyngeal, :epiglottal].to_set,
      :lateral      => [:lateral_fricative, :lateral_approximant, :lateral_flap],
      :vocalic      => VOCALIC + [:rounded],
      :non_pulmonic => NON_PULMONIC,
      :pulmonic     => PULMONIC,
      :consonantal  => CONSONANTAL
    }

    # IPA diacritics for some sound modifiers such as devoicing, affricitization, etc.
    DIACRITICS = {
      :affricate => [0x0361]
    }

    # Sets of distinctive features mapped to an IPA symbol
    SETS = {
      [:voiced, :bilabial, :nasal].to_set                       => [0x006d],
      [:voiced, :labiodental, :nasal].to_set                    => [0x0271],
      [:voiced, :alveolar, :nasal].to_set                       => [0x006e],
      [:voiced, :retroflex, :nasal].to_set                      => [0x0273],
      [:voiced, :palatal, :nasal].to_set                        => [0x0272],
      [:voiced, :velar, :nasal].to_set                          => [0x014b],
      [:voiced, :uvular, :nasal].to_set                         => [0x0274],
      [:bilabial, :plosive].to_set                              => [0x0070],
      [:voiced, :bilabial, :plosive].to_set                     => [0x0062],
      [:labiodental, :plosive].to_set                           => [0x0070, 0x032a],
      [:voiced, :labiodental, :plosive].to_set                  => [0x0062, 0x032a],
      [:alveolar, :plosive].to_set                              => [0x0074],
      [:voiced, :alveolar, :plosive].to_set                     => [0x0064],
      [:retroflex, :plosive].to_set                             => [0x0288],
      [:voiced, :retroflex, :plosive].to_set                    => [0x0256],
      [:palatal, :plosive].to_set                               => [0x0063],
      [:voiced, :palatal, :plosive].to_set                      => [0x025f],
      [:velar, :plosive].to_set                                 => [0x006b],
      [:voiced, :velar, :plosive].to_set                        => [0x0261],
      [:uvular, :plosive].to_set                                => [0x0071],
      [:voiced, :uvular, :plosive].to_set                       => [0x0262],
      [:voiced, :epiglottal, :plosive].to_set                   => [0x02a1],
      [:voiced, :glottal, :plosive].to_set                      => [0x0294],
      [:bilabial, :fricative].to_set                            => [0x0278],
      [:voiced, :bilabial, :fricative].to_set                   => [0x03b2],
      [:labiodental, :fricative].to_set                         => [0x0066],
      [:voiced, :labiodental, :fricative].to_set                => [0x0076],
      [:dental, :fricative].to_set                              => [0x03b8],
      [:voiced, :dental, :fricative].to_set                     => [0x00f0],
      [:alveolar, :fricative].to_set                            => [0x0073],
      [:voiced, :alveolar, :fricative].to_set                   => [0x007a],
      [:postalveolar, :fricative].to_set                        => [0x0283],
      [:voiced, :postalveolar, :fricative].to_set               => [0x0292],
      [:retroflex, :fricative].to_set                           => [0x0282],
      [:voiced, :retroflex, :fricative].to_set                  => [0x0290],
      [:palatal, :fricative].to_set                             => [0x00e7],
      [:voiced, :palatal, :fricative].to_set                    => [0x029d],
      [:velar, :fricative].to_set                               => [0x0078],
      [:voiced, :velar, :fricative].to_set                      => [0x0263],
      [:uvular, :fricative].to_set                              => [0x03c7],
      [:voiced, :uvular, :fricative, :approximant].to_set       => [0x0281],
      [:pharyngeal, :fricative].to_set                          => [0x0127],
      [:voiced, :pharyngeal, :fricative, :approximant].to_set   => [0x0295],
      [:epiglottal, :fricative].to_set                          => [0x029c],
      [:voiced, :epiglottal, :fricative, :approximant].to_set   => [0x02a2],
      [:glottal, :fricative, :approximant].to_set               => [0x0068],
      [:voiced, :glottal, :fricative, :approximant].to_set      => [0x0266],
      [:voiced, :bilabial, :approximant].to_set                 => [0x03b2, 0x031e],
      [:voiced, :labiodental, :approximant].to_set              => [0x028b],
      [:voiced, :alveolar, :approximant].to_set                 => [0x0279],
      [:voiced, :retroflex, :approximant].to_set                => [0x027b],
      [:voiced, :palatal, :approximant].to_set                  => [0x006a],
      [:voiced, :velar, :approximant].to_set                    => [0x0270],
      [:voiced, :bilabial, :trill].to_set                       => [0x0299],
      [:voiced, :alveolar, :trill].to_set                       => [0x0072],
      [:voiced, :uvular, :trill].to_set                         => [0x0280],
      [:voiced, :epiglottal, :trill].to_set                     => [0x044f],
      [:voiced, :bilabial, :flap].to_set                        => [0x2c71, 0x031f],
      [:voiced, :labiodental, :flap].to_set                     => [0x2c71],
      [:voiced, :alveolar, :flap].to_set                        => [0x027e],
      [:voiced, :retroflex, :flap].to_set                       => [0x027d],
      [:voiced, :uvular, :flap].to_set                          => [0x0262, 0x0306],
      [:voiced, :epiglottal, :flap].to_set                      => [0x02a1, 0x032f],
      [:alveolar, :lateral_fricative].to_set                    => [0x026c],
      [:voiced, :alveolar, :lateral_fricative].to_set           => [0x026e],
      [:voiced, :alveolar, :lateral_approximant].to_set         => [0x006c],
      [:voiced, :retroflex, :lateral_approximant].to_set        => [0x026d],
      [:voiced, :palatal, :lateral_approximant].to_set          => [0x028e],
      [:voiced, :velar, :lateral_approximant].to_set            => [0x029f],
      [:voiced, :alveolar, :lateral_flap].to_set                => [0x027a],
      [:voiced, :palatal, :lateral_flap].to_set                 => [0x028e, 0x032f],
      [:voiced, :velar, :lateral_flap].to_set                   => [0x029f, 0x0306],
      [:voiced, :close, :front].to_set                          => [0x0069],
      [:voiced, :close, :front, :rounded].to_set                => [0x0079],
      [:voiced, :close, :central].to_set                        => [0x0268],
      [:voiced, :close, :central, :rounded].to_set              => [0x0289],
      [:voiced, :close, :back].to_set                           => [0x026f],
      [:voiced, :close, :back, :rounded].to_set                 => [0x0075],
      [:voiced, :near_close, :near_front].to_set                => [0x026a],
      [:voiced, :near_close, :near_front, :rounded].to_set      => [0x028f],
      [:voiced, :near_close, :near_back, :rounded].to_set       => [0x028a],
      [:voiced, :close_mid, :front].to_set                      => [0x0065],
      [:voiced, :close_mid, :front, :rounded].to_set            => [0x00f8],
      [:voiced, :close_mid, :central].to_set                    => [0x0258],
      [:voiced, :close_mid, :central, :rounded].to_set          => [0x0275],
      [:voiced, :close_mid, :back].to_set                       => [0x0264],
      [:voiced, :close_mid, :back, :rounded].to_set             => [0x006f],
      [:voiced, :mid, :central].to_set                          => [0x0259],
      [:voiced, :open_mid, :front].to_set                       => [0x025b],
      [:voiced, :open_mid, :front, :rounded].to_set             => [0x0153],
      [:voiced, :open_mid, :central].to_set                     => [0x025c],
      [:voiced, :open_mid, :central, :rounded].to_set           => [0x025e],
      [:voiced, :open_mid, :back].to_set                        => [0x028c],
      [:voiced, :open_mid, :back, :rounded].to_set              => [0x0254],
      [:voiced, :near_open, :front].to_set                      => [0x00e6],
      [:voiced, :near_open, :central].to_set                    => [0x0250],
      [:voiced, :open, :front].to_set                           => [0x0061],
      [:voiced, :open, :front, :rounded].to_set                 => [0x0276],
      [:voiced, :open, :back].to_set                            => [0x0251],
      [:voiced, :open, :back, :rounded].to_set                  => [0x0252],
      [:voiced, :retroflex, :lateral_fricative].to_set          => [0xa78e],
      [:voiced, :palatal, :lateral_fricative].to_set            => [0xf267],
      [:voiced, :velar, :lateral_fricative].to_set              => [0xf268],
      [:voiced, :retroflex, :lateral_flap].to_set               => [0xf269],
      [:voiced, :bilabial, :velar, :approximant].to_set         => [0x0077],
      [:bilabial, :velar, :approximant].to_set                  => [0x268d],
      [:voiced, :bilabial, :palatal, :approximant].to_set       => [0x0265],
      [:voiced, :velar, :alveolar, :lateral_approximant].to_set => [0x026b],
      [:palatal, :alveolar, :fricative].to_set                  => [0x0255],
      [:voiced, :palatal, :alveolar, :fricative].to_set         => [0x0291],
      [:palatal, :velar, :fricative].to_set                     => [0x0267]
    }
    SETS.each {|k, v| k.freeze}

    class << self
      # Return the set corresponding to the kind of feature: manner or place of
      # articulation, or height or backness.
      def set(feature)
        [MANNER, PLACE, BACKNESS, HEIGHT].each {|kind| return kind if kind.include? feature}
        nil
      end

      # Given a Ruby :symbol feature class such as :coronal, return the
      # corresponding features. If a single feature is given, just return the
      # feature.
      def expand(*args)
        args = args.inject([].to_set) do |memo, obj|
          memo << (CLASSES[obj] || obj)
        end.flatten.to_set
      end

    end

  end
end
