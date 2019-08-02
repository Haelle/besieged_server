class Assault::Assaulter < Assault::Antagonist
  def attack(defenders)
    @defenders = defenders

    attack_the_wall if infantry?
    dispatch_damages_to @defenders

    # TODO: Sentry - log warnning
    # if there is remaining damages
    # and enemies standing

    @result
  end

  private

  def attack_the_wall
    walls = @defenders.select(&:wall?)
    return if walls.empty?

    dispatch_damages_to walls
  end
end
