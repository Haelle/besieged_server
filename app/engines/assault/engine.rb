class Assault::Engine
  include ActiveModel::Model
  attr_accessor :round_count, :assaulters, :defenders

  def assault_on(defenders)
    @defenders = defenders
    @assaulters.each { |a| a.attack @defenders }
    @defenders.each  { |d| d.counter_attrack @assaulters }
  end
end
