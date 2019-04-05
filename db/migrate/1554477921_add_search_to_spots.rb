# frozen_string_literal: true

class AddSearchToSpots < ActiveRecord::Migration[5.2]
  def up
    # Add col to cache lexemes and search against.
    add_column :spots, :tsv, 'TSVector'

    # Add GIN index to col for search speed.
    execute <<-SQL
      CREATE INDEX spots_tsv_gin ON spots \
      USING GIN(tsv);
    SQL

    # First, create tsv trigger. Then use pg built-in trigger to
    # update tsvector on changes.
    execute <<-SQL
      CREATE TRIGGER spots_ts_tsv \
      BEFORE INSERT OR UPDATE ON spots \
      FOR EACH ROW EXECUTE PROCEDURE \
      tsvector_update_trigger(tsv, 'pg_catalog.english', name);
    SQL

    execute <<-SQL
      UPDATE spots SET tsv=to_tsvector(name);
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER spots_ts_tsv ON spots \
      DROP INDEX spots_tsv_gin;
    SQL

    drop_column :spots, :tsv
  end
end
