require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
    it {should validate_presence_of :item}
    it {should validate_presence_of :invoice}
  end

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end
end
