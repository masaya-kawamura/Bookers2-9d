class RemoveImpressionsCountFromBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :impressions_count, :integer
  end
end
