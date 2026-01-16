class TasksController < ApplicationController
  before_action :select_task, only: %i[update destroy update_status duplicate]
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def index
    tasks_all
  end

  def create
    result = Tasks::CreateService.new(params).call
    @result = result.data
    tasks_all
  end

  def update
    @task.update(task_params)
    tasks_all
  end

  def destroy
    @task.destroy
    tasks_all
  end

  def update_status
    @task.update(status: params[:status])
    tasks_all
  end

  def duplicate
    result = Tasks::DuplicateService.call(@task)

    if result.success?
      render json: result.data, status: :created
    else
      render json: { error: result.errors }, status: :unprocessable_content
    end
  end

  private

  def task_params
    params.permit(:name, :explanation, :status, :priority).merge(genre_id: params[:genreId],
                                                                 deadline_date: params[:deadlineDate])
  end

  def select_task
    @task = Task.find(params[:id])
  end

  def tasks_all
    @tasks = Task.all
    render :all_tasks
  end

  def record_not_found
    render json: { error: 'Task not found' }, status: :not_found
  end

  def record_invalid(exception)
    render json: { error: exception.message }, status: :unprocessable_content
  end
end
