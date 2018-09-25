module Boolify
  def to_bool
    ActiveModel::Type::Boolean.new.cast(self)
  end
end

class Object; include Boolify; end
