class AddAnalyzedAtToAnalyses < ActiveRecord::Migration
  def change
    add_column :analyses, :analyzed_at, :datetime
  end
end
