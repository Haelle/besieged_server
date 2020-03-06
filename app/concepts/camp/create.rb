class Camp
  class Create < Trailblazer::Operation
    step Wrap(WithinTransaction) {
      step :create_camp
      step :create_castle
      step :create_toc
      step :reload
    }

    CASTLE_DEFAULT_HEALTH_POINTS = 5_000

    def create_camp(ctx, **)
      ctx[:camp] = Camp.create
    end

    def create_castle(ctx, camp:, **)
      ctx[:castle] = Castle
        .create(
          camp: camp,
          health_points: CASTLE_DEFAULT_HEALTH_POINTS
        )
    end

    def create_toc(_, camp:, **)
      operation = Building::Create
        .call(
          camp: camp,
          type: Buildings::TacticalOperationCenter
        )

      operation.success?
    end

    def reload(_, camp:, **)
      camp.reload
    end
  end
end
