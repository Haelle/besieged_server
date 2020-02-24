class Character
  class Operate < Trailblazer::Operation
    step Wrap(WithinTransaction) {
      step :lock
      step :character_not_exhausted?
      fail :log_character_exhausted, fail_fast: true
      step :decrement_character_points
      fail :log_decrement_failed, fail_fast: true
      step :execute_callback
      fail :log_callback_failed, fail_fast: true
      step :persist_current_action
      fail :log_persist_action_failed, fail_fast: true
    }

    def lock(_, character:, target:, **)
      character.lock!
      target.lock!
    end

    def character_not_exhausted?(_, character:, **)
      !character.exhausted?
    end

    def decrement_character_points(_, **)
      # TODO: when character have points
      true
    end

    def execute_callback(_, target:, params:, callback:, **)
      callback.call(target, params)
    end

    # rubocop:disable Metrics/ParameterLists
    def persist_current_action(ctx, character:, action_type:, target:, params:, **)
      ctx[:action] = CharacterAction.create(
        camp: character.camp,
        character: character,
        action_type: action_type,
        action_params: params,
        target: target
      )
    end

    def log_character_exhausted(ctx, character:, **)
      ctx[:error] = "#{character.pseudonym} is exhausted, wait to get more points"
    end

    def log_decrement_failed(_, character:, **)
      Rails.logger.error "#{character.pseudonym} (#{character.id}) decrement failed (points: ??)"
    end

    def log_callback_failed(ctx, action_type:, character:, target:, **)
      ctx[:error] = "An error occurred during #{action_type}"

      Rails.logger.error "#{action_type} by #{character.pseudonym} (#{character.id}) on #{target.class} (#{target.id}) failed"
    end

    def log_persist_action_failed(ctx, action_type:, params:, character:, target:, **)
      ctx[:error] = 'Cannot execute action, unexpected behavior'

      Rails.logger.error "CharacterAction persist failed (character: #{character.id}, action type: #{action_type}, params: #{params}, target: #{target.class} - #{target.id})"
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
