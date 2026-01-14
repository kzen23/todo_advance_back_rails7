module Tasks
  class DuplicateService
    def self.call(task)
      new(task).call
    end

    def initialize(task)
      @task = task
    end

    def call
      duplicated = @task.duplicate

      if duplicated.save
        ServiceResult.success(data: duplicated)
      else
        ServiceResult.failure(errors: duplicated.errors.full_messages)
      end
    end
  end
end
