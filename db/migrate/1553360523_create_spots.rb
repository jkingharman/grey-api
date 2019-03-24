# frozen_string_literal: true

class CreateSpots < ActiveRecord::Migration[5.2]
  create_table :spots do |t|
    t.references :spot_type

    t.string :name, null: false
    t.string :slug, null: false
    t.timestamps
  end
end
