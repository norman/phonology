module Phonology

  module RulesDSL

    def method_missing(sym, *args, &block)
      curr_sound.__send__(sym, *args, &block)
    end

    def curr_sound
      array[@index]
    end

    def next_sound(offset = 1)
      array[@index + offset]
    end

    def prev_sound(offset = 1)
      array[@index - offset]
    end

    def precedes(*features)
      features.flatten.each {|f| return false unless next_sound.send(:"#{f}?")}
      true
    end

    def follows(*features)
      features.flatten.each {|f| return false unless prev_sound.send(:"#{f}?")}
      true
    end

    def initial?
      @index == 0
    end

    def final?
      !next_sound
    end

  end

  class Rules

    include RulesDSL

    attr :array
    attr_accessor :rules

    def initialize(&block)
      @rules = block
    end

    def apply(array)
      @array = array.flatten
      @max = array.length
      array.each_index.map do |index|
        @index = index
        instance_eval(&rules)
      end.flatten.compact
    ensure
      @max = 0
      @index = nil
    end

  end
end
