# frozen_string_literal: true

module Grey
  module Models
    class Spot < ActiveRecord::Base
      include PgSearch

      belongs_to :spot_type

      validates_presence_of :name, :slug, :spot_type
      validates_uniqueness_of :name, :slug

      scope(:random, lambda do
        order(Arel.sql('RANDOM()')).includes(:spot_type).limit(25).all
      end)

      scope(:latest, lambda do
        order(:created_at).includes(:spot_type).limit(25).all.reverse
      end)

      pg_search_scope(:search_by_name, lambda do |query|
        {
          against: name,
          query: query,
          using: {
            tsearch: {
              tsvector_column: 'tsv'
            }
          }
        }
      end)
    end
  end
end
