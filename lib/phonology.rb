require "set"
require File.expand_path("../phonology/features", __FILE__)
require File.expand_path("../phonology/inventory", __FILE__)
require File.expand_path("../phonology/sound", __FILE__)
require File.expand_path("../phonology/sound_sequence", __FILE__)
require File.expand_path("../phonology/orthography", __FILE__)
require File.expand_path("../phonology/rule", __FILE__)
require File.expand_path("../phonology/syllable", __FILE__)
require File.expand_path("../phonology/ipa", __FILE__)

module Phonology

  extend self

  def sounds
    @sounds ||= Inventory.new(Features::SETS).freeze
  end

  def symbol_for(*args)
    sounds.symbol(*args)
  end

  def features_for(*args)
    sounds.features(*args)
  end

end
