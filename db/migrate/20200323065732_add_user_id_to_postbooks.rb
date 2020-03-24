class AddUserIdToPostbooks < ActiveRecord::Migration[5.2]
  def change
    add_column :postbooks, :user_id, :integer
  end
end
