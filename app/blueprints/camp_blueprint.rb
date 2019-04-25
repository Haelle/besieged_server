class CampBlueprint < Blueprinter::Base
  identifier :id

  association :castle,        blueprint: CastleBlueprint
  association :characters,    blueprint: CharacterBlueprint
  association :siege_weapons, blueprint: SiegeWeaponBlueprint
end
