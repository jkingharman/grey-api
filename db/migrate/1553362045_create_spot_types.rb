# frozen_string_literal: true

class CreateSpotTypes < ActiveRecord::Migration[5.2]
  create_table :spot_types do |t|

    t.string :name, unique: true, null: false
    t.string :slug, unique: true, null: false
    t.timestamps
  end
end
