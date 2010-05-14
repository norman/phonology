module Phonology

  class RulesDSL

    attr :array, :index

    def initialize(array)
      @array = array
    end

    def method_missing(sym, *args, &block)
      curr_sound.__send__(sym, *args, &block)
    end

    def apply(&block)
      array.each_index.map do |index|
        @index = index
        instance_eval(&block)
        get_result
      end
    end

    def delete(*args)
      if !args.empty?
        curr_sound.delete(*args)
      else
        array[@index] = nil
      end
    end

    def insert(*args)
      @result = [curr_sound, Sound.new(*args)]
    end

    def curr_sound
      array[@index]
    end

    def next_sound(offset = 1)
      !final? && array[@index + offset]
    end

    def prev_sound(offset = 1)
      !initial? && array[@index - offset]
    end

    def voice
      curr_sound << :voiced
    end

    def devoice
      curr_sound >> :voiced
    end

    def precedes(*features)
      return false if !next_sound
      features.flatten.each {|f| return false unless next_sound.send(:"#{f}?")}
      true
    end

    def follows(*features)
      return false if initial?
      features.flatten.each {|f| return false unless prev_sound.send(:"#{f}?")}
      true
    end

    def initial?
      @index == 0
    end

    def final?
      @index == @max
    end

    private

    def get_result
      if !@result
        curr_sound
      else
        result = @result
        @result = nil
        result
      end
    end

  end

  class Rule

    attr :rule

    def initialize(&block)
      @rule = block
    end

    def apply(sounds)
      dsl = RulesDSL.new(sounds)
      dsl.apply(&rule).flatten
    end

  end
end
