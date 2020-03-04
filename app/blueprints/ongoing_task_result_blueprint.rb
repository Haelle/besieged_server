class OngoingTaskResultBlueprint < Blueprinter::Base
  association :ongoing_task, blueprint: OngoingTaskBlueprint do |result|
    result[:ongoing_task]
  end

  field :status do |result|
    result[:ongoing_task_status]
  end

  field :target_class do |result|
    target = result[:target]
    target&.class&.name unless target.nil?
  end

  field :target_id do |result|
    target = result[:target]
    target&.id unless target.nil?
  end
end
