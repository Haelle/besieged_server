module CreateHelper
  def find_klass(ctx, type:, **)
    if type.is_a? String
      ctx[:klass] = type.constantize
    else
      ctx[:type] = type.name
      ctx[:klass] = type
    end
  rescue NameError
    false
  end

  def type_to_snake_case(ctx, type:, **)
    ctx[:snake_type] = type
      .split('::')
      .second
      .underscore
      .to_sym
  end
end
