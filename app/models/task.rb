class Task < ApplicationRecord
  include Duplicatable

  belongs_to :genre

  enum :priority, { low: 0, medium: 1, high: 2 }
  enum :status, { not_started: 0, in_progress: 1, completed: 2 }

  def self.report_summary
    total = count
    counts_by_status = group(:status).count

    count_by_status = {
      not_started: counts_by_status['not_started'] || 0,
      in_progress: counts_by_status['in_progress'] || 0,
      completed: counts_by_status['completed'] || 0
    }

    completion_rate = if total.zero?
                        0.0
                      else
                        ((count_by_status[:completed].to_f / total) * 100).round(1)
                      end

    {
      total_count: total,
      count_by_status: count_by_status,
      completion_rate: completion_rate
    }
  end
end
