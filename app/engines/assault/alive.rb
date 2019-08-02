module Assault::Alive
  # made writtable juste to use it in initialize
  attr_accessor :health_points, :max_health_points

  def heal(value)
    return 0 if dead?

    hp_before = @health_points
    @health_points = [@health_points + value, @max_health_points].min
    @health_points - hp_before
  end
  alias repair heal

  def injure(value)
    return 0 if dead?

    hp_before = @health_points
    @health_points = [0, @health_points - value].max
    hp_before - @health_points
  end
  alias damage injure

  def alive?
    @health_points.positive?
  end
  alias working? alive?

  def full_life?
    @health_points == @max_health_points
  end

  def injured?
    !full_life?
  end
  alias damaged? injured?

  def dead?
    @health_points.zero?
  end
  alias destroyed? dead?
end
