module Phonology

  module OrthographyTranslatorDSL

    attr_accessor :last_sound, :anticipation

    def method_missing(sym, *args, &block)
      last_sound.__send__(sym, *args, &block)
    end

    def anticipate(&block)
      @anticipation = block
      nil
    end

    def curr_char
      array[@index]
    end

    def next_char(offset = 1)
      array[@index + offset]
    end

    def prev_char(offset = 1)
      array[@index - offset]
    end

    def follows(*chars)
      chars.flatten.each {|c| return true if c == prev_char}
      false
    end

    def precedes(*chars)
      chars.flatten.each {|c| return true if c == next_char}
      false
    end

    def between(before, after)
      follows(*before) && precedes(*after)
    end

    def initial?
      @index == 0
    end

    def final?
      !next_char
    end

    def get(*features)
      if features.first.kind_of?(Array)
        get_affricate(*features)
      else
        match = sounds.with_all(*features)
        return nil if match.sets.empty? || match.sets.length > 1
        @last_sound = Sound.new *match.sets.keys.first.to_a
      end
      @last_sound.orthography = curr_char
      do_anticipation
    end

    private

    def get_affricate(*features)
      @last_sound = Phonology::Affricate.new(features[0], features[1])
    end

    def do_anticipation
      if @anticipation
        @anticipation.call(last_sound)
        @anticipation = nil
      end
      return last_sound
    end

  end

  class OrthographyTranslator

    attr_accessor :rules, :scanner, :sounds, :string

    include OrthographyTranslatorDSL

    # Translate orthorgraphy to IPA
    def translate(string)
      @string = string
      @max = array.length
      array.each_index.map do |index|
        @index = index
        instance_eval(&@rules)
      end.flatten.compact
    ensure
      @max = 0
      @string = nil
      @array = nil
      @index = nil
      @last_sound = nil
    end

    def set_rules(&block)
      @rules = block
    end

    private

    def array
      @array ||= scan
    end

    def scan
      scanner ? scanner.call(string) : string.split(//u)
    end

  end

end
