module Grey
  module Models
    class Spot < ActiveRecord::Base
      belongs_to :spot_type

      validates_presence_of :name, :slug
    end
  end
end
