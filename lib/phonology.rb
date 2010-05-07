require "set"
require File.expand_path("../phonology/features", __FILE__)
require File.expand_path("../phonology/sounds", __FILE__)
require File.expand_path("../phonology/sound", __FILE__)

module Phonology

  extend self

  def sounds
    @sounds ||= Sounds.new(Features::SETS).freeze
  end

  def symbol_for(*args)
    sounds.symbol(*args)
  end

  def features_for(*args)
    sounds.features(*args)
  end

end
