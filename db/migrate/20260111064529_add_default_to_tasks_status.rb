class AddDefaultToTasksStatus < ActiveRecord::Migration[7.1]
  def change
    # status: 0=not_started(default), 1=in_progress, 2=completed
    change_column_default :tasks, :status, from: nil, to: 0
    change_column_null :tasks, :status, false, 0
  end
end
