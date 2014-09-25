class DeleteAnalysisResultIdFromAnalyses < ActiveRecord::Migration
  def change
    remove_column :analyses, :analysis_result_id
  end
end
