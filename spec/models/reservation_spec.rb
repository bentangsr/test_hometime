require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:name) { 'reservation model' }

  describe "Associations" do
    # this class has_many or has_ones
    it { should belong_to(:guest) }
  end

  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }

    [
      :nights, :guests, :adults, :children, :infants, :payout_price, :security_price, :total_price
    ].each do |att|
      it { should validate_numericality_of(att) }
    end

    describe 'custom validation' do
      it 'will validate format date' do
        @reservation = Reservation.new(start_date: 'asdasdsd')
        @reservation.valid?
        expect(@reservation.errors.full_messages).to include('Start date is invalid')
      end
    end
  end
end
