module Duplicatable
  extend ActiveSupport::Concern

  def duplicate
    dup.tap do |duplicated|
      duplicated.name = "#{name}(コピー)"
      duplicated.status = :not_started
      duplicated.deadline_date = nil
    end
  end
end
