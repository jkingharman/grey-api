# frozen_string_literal: true

module Grey
  module Models
    class Spot < ActiveRecord::Base
      belongs_to :spot_type

      validates_presence_of :name, :slug, :spot_type
      validates_uniqueness_of :name, :slug

      scope(:random, lambda do
        order(Arel.sql('RANDOM()')).includes(:spot_type).limit(25).all
      end)

      scope(:latest, lambda do
        order(:created_at).includes(:spot_type).limit(25).all.reverse
      end)
    end
  end
end
