module Phonology

  # A collection of sounds
  class SoundSequence

    attr :sounds

    def method_missing(sym, *args, &block)
      @sounds.__send__(sym, *args, &block)
    end

    def initialize(arg = nil)
      # String of ipa symbols
      if arg.kind_of? String
        @sounds = arg.split('').map {|letter| Sound.new(letter)}
      else
        @sounds = arg.to_a
      end
    end

    def syllables(syllabifier)
      @syllables ||= syllabifier.syllabify(self)
    end

    def symbols
      compact.map(&:symbol).join
    end
    alias ipa symbols
    alias to_s symbols
    alias to_str symbols

    def orthography
      compact.map(&:orthography).join
    end

    # Apply rule and get a new instance of SoundSequence.
    def apply_rule(rule)
      self.class.new rule.apply(@sounds)
    end

    # Apply rule in place.
    def apply_rule!(rule)
      @sounds = rule.apply(@sounds)
      self
    end

    def sonority
      @sounds.empty? ? nil : @sounds.last.sonority
    end
  end
end
