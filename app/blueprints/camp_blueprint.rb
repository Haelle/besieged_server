class CampBlueprint < Blueprinter::Base
  identifier :id

  association :castle,         blueprint: CastleBlueprint
  association :characters,     blueprint: CharacterBlueprint
  association :siege_machines, blueprint: SiegeMachineBlueprint
end
