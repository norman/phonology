module Phonology

  # @abstract
  class Syllable

    attr_accessor :onset, :coda, :nucleus, :stress

    def initialize(sound = nil)
      @onset = []
      @nucleus = []
      @coda = []
      add sound if sound
    end

    def to_a
      [onset, rime].flatten
    end

    def valid?
      !nucleus.empty?
    end

    def rime
      [nucleus, coda]
    end

    def to_s
      (stress ? IPA.primary_stress : "") + to_a.map(&:symbol).join
    end

    def wants?(sound)
      onset_wants?(sound) or nucleus_wants?(sound) or coda_wants?(sound)
    end

    def onset_wants?(sound)
      raise NotImplementedError
    end

    def nucleus_wants?(sound)
      raise NotImplementedError
    end

    def coda_wants?(sound)
      raise NotImplementedError
    end

    def <<(sound)
      if onset_wants?(sound)
        @onset << sound
      elsif nucleus_wants?(sound)
        @nucleus << sound
      else
        @coda << sound
      end
    end
    alias add <<

    def empty?
      onset.empty? && nucleus.empty? && coda.empty?
    end

  end

end
