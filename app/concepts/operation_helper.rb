module OperationHelper
  def belong_to_same_camp?(_, camp:, character:, **)
    camp == character.camp
  end

  def error_does_not_belong(ctx, camp:, character:, **)
    ctx[:error] = "character (#{character.id}) does not belong to the camp (#{camp.id})"
  end
end
