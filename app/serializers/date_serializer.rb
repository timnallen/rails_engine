class DateSerializer
  include FastJsonapi::ObjectSerializer

  attribute :best_day do |object|
    object.date
  end
end
