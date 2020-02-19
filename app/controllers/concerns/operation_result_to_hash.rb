module OperationResultToHash
  extend ActiveSupport::Concern

  def camp_hash
    CampBlueprint.render_as_hash @operation_result[:camp]
  end

  def castle_hash
    CastleBlueprint.render_as_hash @operation_result[:castle]
  end

  def weapon_hash
    SiegeMachineBlueprint.render_as_hash @operation_result[:siege_machine]
  end
end
