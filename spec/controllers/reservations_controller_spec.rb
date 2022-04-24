require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do

  # this must be a model class which will be used on the template
  let(:model_reservation) { Reservation }
  let(:model_guest) { Guest }
  let(:name) { 'reservations controller' }
  let(:valid_booking_attributes) do
    {
      reservation: {
        code: 'XXX12345678',
        start_date: '2021-03-12',
        end_date: '2021-03-16',
        expected_payout_amount: '3800.00',
        guest_details: {
          localized_description: '4 guests',
          number_of_adults: 2,
          number_of_children: 2,
          number_of_infants: 0
        },
        guest_email: 'wayne_woodbridge@bnb.com',
        guest_first_name: 'Wayne',
        guest_last_name: 'Woodbridge',
        guest_phone_numbers: [
          '639123456789',
          '639123456789'
        ],
        listing_security_price_accurate: '500.00',
        host_currency: 'AUD',
        nights: 4,
        number_of_guests: 4,
        status_type: 'accepted',
        total_paid_amount_accurate: '4300.00'
      }
    }
  end

  let(:valid_airbnb_attributes) do
    {
      reservation_code: 'YYY12345678',
      start_date: '2021-04-14',
      end_date: '2021-04-18',
      nights: 4,
      guests: 4,
      adults: 2,
      children: 2,
      infants: 0,
      status: 'accepted',
      guest: {
        first_name: 'Wayne',
        last_name: 'Woodbridge',
        phone: '639123456789',
        email: 'wayne_woodbridge@bnb.com'
      },
      currency: 'AUD',
      payout_price: '4200.00',
      security_price: '500',
      total_price: '4700.00'
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'successfully create reservation with payload from booking.com' do
        expect {
          post :create, params: valid_booking_attributes
        }.to change(model_reservation, :count).by(1)
      end

      it 'successfully create/update reservation with payload from airbnb' do
        expect {
          post :create, params: valid_airbnb_attributes
        }.to change(model_reservation, :count).by(1)
      end

      it 'also create a new guest record' do
        expect {
          post :create, params: valid_booking_attributes
        }.to change(model_guest, :count).by(1)
      end

      it 'return format json with key success true' do
        post :create, params: valid_airbnb_attributes
        res = JSON.parse(response.body)
        expect(res['success']).to eq true
      end
    end

    context 'with invalid params' do
      it 'return format json with key success false' do
        invalid_attributes = valid_airbnb_attributes.merge(nights: "string")
        post :create, params: invalid_attributes
        res = JSON.parse(response.body)
        expect(res['success']).to eq false
      end
    end
  end
end