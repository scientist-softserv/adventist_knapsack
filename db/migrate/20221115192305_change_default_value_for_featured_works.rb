class ChangeDefaultValueForFeaturedWorks < ActiveRecord::Migration[5.2]
  def change
    change_column_default :featured_works, :order, from: 5, to: 6
  end
end
