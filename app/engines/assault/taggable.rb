module Assault::Taggable
  attr_accessor :tags

  TAGS = %i[citizen defense_structure wall infantry archer].freeze

  # if citizen? is called
  # checks if its a valid tag & if tag is found
  def method_missing(name, *args)
    name_s = name.to_s
    tag = name_s.delete('?').to_sym
    if name_s.last == '?' && TAGS.include?(tag)
      tags.include? tag
    else
      super
    end
  end

  def respond_to_missing?(name, include_private)
    name_s = name.to_s
    tag = name_s.delete('?').to_sym
    tag_method = name_s.last == '?' && TAGS.include?(tag)
    tag_method || super
  end
end
