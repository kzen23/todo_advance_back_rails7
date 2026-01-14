module Tasks
  class CreateService
    def initialize(params)
      @params = params
    end

    def call
      task = Task.create(normalized_params)

      if task.persisted?
        ServiceResult.success(data: task)
      else
        ServiceResult.failure(errors: task.errors.full_messages)
      end
    end

    private

    def normalized_params
      {
        name: @params[:name],
        explanation: @params[:explanation],
        status: @params[:status],
        priority: @params[:priority],
        genre_id: @params[:genreId],
        deadline_date: @params[:deadlineDate]
      }.compact
    end
  end
end
