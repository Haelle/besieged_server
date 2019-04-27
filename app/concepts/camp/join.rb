class Camp
  class Join < Trailblazer::Operation
    step :save
    fail :log_errors
    step :set_action_result

    def save(ctx, account:, camp:, pseudonyme:, **)
      ctx[:character] = Character.create(
        account: account,
        camp: camp,
        pseudonyme: pseudonyme
      )

      ctx[:character].persisted?
    end

    def log_errors(ctx, character:, **)
      ctx[:error] = character.errors.messages.values.join(', ')
    end

    def set_action_result(ctx, character:, **)
      ctx[:action_result] = { character: character }
    end
  end
end
