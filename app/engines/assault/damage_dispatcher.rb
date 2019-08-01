class Assault::DamageDispatcher
  def self.call(total_damages:, damage_range:, targets:)
    new(total_damages, damage_range, targets.shuffle).send(:internal_call)
  end

  private

  def initialize(total_damages, damage_range, targets)
    @remaining_damages = total_damages
    @damage_range = damage_range
    @targets = targets
    @result = {}
  end

  def internal_call
    while @remaining_damages > 0
      break if survivors.empty?

      survivors.each do |target|
        break if @remaining_damages.zero?

        current_damage = random_damage
        @remaining_damages -= current_damage

        damage target, current_damage
      end
    end

    @result
  end

  def survivors
    @targets.select(&:alive?)
  end

  def random_damage
    [rand(@damage_range), @remaining_damages].min
  end

  def damage(target, damage)
    real_damage = target.damage damage
    key = target.name
    @result[key] = (@result[key] || 0) + real_damage
  end
end
