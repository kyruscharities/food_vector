class RemoveAnalyzedAtFromAnalysis < ActiveRecord::Migration
  def change
    remove_column :analyses, :analyzed_at
  end
end
