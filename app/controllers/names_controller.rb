require 'name_generator'

class NamesController < ApplicationController
  def generate
    generator = NameGenerator::Main.new
    render json: { name: generator.next_name(syllables_count) }
  end

  private

  def syllables_count
    params[:syllables_count].to_i
  end
end
