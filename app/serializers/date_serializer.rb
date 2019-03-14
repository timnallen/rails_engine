class DateSerializer
  include FastJsonapi::ObjectSerializer
  attributes :created_at
end
