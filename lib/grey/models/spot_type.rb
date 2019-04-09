# frozen_string_literal: true

module Grey
  module Models
    class SpotType < ActiveRecord::Base
      include PgSearch
      has_many :spots
      before_validation { self.slug = self.slug.downcase }

      validates_presence_of :name, :slug
      validates_uniqueness_of :name, :slug
      validates :slug, format: { with: /^[a-z0-9][a-z0-9-]*[a-z0-9]$/,
        message: "Invalid slug", multiline: true }

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
