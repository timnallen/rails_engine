class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :revenue

  attribute :total_revenue do |object|
    '%.2f' % (object.revenue.to_f/100)
  end
end
