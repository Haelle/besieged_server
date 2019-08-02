class Assault::Defender < Assault::Antagonist
  def counter_attack(assaulters)
    return @result if wall?

    dispatch_damages_to assaulters

    # TODO: Sentry

    @result
  end
end
