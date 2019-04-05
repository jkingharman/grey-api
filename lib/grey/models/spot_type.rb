# frozen_string_literal: true

module Grey
  module Models
    class SpotType < ActiveRecord::Base
      include PgSearch
      has_many :spots

      validates_presence_of :name, :slug
      validates_uniqueness_of :name, :slug

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
