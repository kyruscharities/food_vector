class RemoveResolutionFromAnalysis < ActiveRecord::Migration
  def change
    remove_column :analyses, :resolution_mi
  end
end
