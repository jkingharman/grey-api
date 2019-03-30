# frozen_string_literal: true

module Grey
  module Models
    class Spot < ActiveRecord::Base
      belongs_to :spot_type

      validates_presence_of :name, :slug, :spot_type
    end
  end
end
