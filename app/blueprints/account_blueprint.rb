class AccountBlueprint < Blueprinter::Base
  identifier :id
  fields :email

  association :characters, blueprint: CharacterBlueprint
end
