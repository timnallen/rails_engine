class RevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object|
    '%.2f' % (object.total_revenue.to_f/100)
  end
end
