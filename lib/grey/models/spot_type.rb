# frozen_string_literal: true

module Grey
  module Models
    class SpotType < ActiveRecord::Base
      has_many :spots

      validates_presence_of :name, :slug
      validates_uniqueness_of :name, :slug
    end
  end
end
