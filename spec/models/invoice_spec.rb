require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it {should validate_presence_of :customer}
    it {should validate_presence_of :merchant}
    it {should validate_presence_of :status}
  end

  describe 'relationships' do
    it {should have_many :invoice_items}
    it {should have_many :items}
    it {should have_many :transactions}
    it {should belong_to :customer}
    it {should belong_to :merchant}
  end
end
