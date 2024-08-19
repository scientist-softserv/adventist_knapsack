class AddAllowsAccessGrantToWorkflow < ActiveRecord::Migration[6.1]
  def change
    add_column :sipity_workflows, :allows_access_grant, :boolean
  end
end
