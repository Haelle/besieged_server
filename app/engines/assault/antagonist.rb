class Assault::Antagonist
  include ActiveModel::Model
  include Assault::Alive
  include Assault::Taggable

  attr_accessor :name, :damages, :damage_range

  def initialize(damages:, **args)
    @result = {}
    @remaining_damages = damages
    super
  end

  protected

  def dispatch_damages_to(targets)
    result = Assault::DamageDispatcher.call(
      total_damages: @remaining_damages,
      damage_range: @damage_range,
      targets: targets
    )

    @remaining_damages -= result.values.sum

    merge_result_with result
  end

  def merge_result_with(intermediary_result)
    @result.merge! intermediary_result
  end
end
