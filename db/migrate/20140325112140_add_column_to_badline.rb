class AddColumnToBadline < ActiveRecord::Migration
  def change
    add_reference :badlines, :user, index: true
  end
end
