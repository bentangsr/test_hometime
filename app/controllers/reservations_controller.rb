class ReservationsController < ApplicationController
  def create
    if params[:reservation_code].present?
      reservation_params = airbnb_params
    else
      reservation_params = booking_params
    end
    create_reservation_process = BuildReservation::CreateData.new(reservation_params: reservation_params)
    create_reservation_process.run

    render json: create_reservation_process.res
  end

  private

  def airbnb_params
    params.permit(:reservation_code, :start_date,
                  :end_date, :nights, :guests, :adults,
                  :children, :infants, :status,
                  :currency, :payout_price,
                  :security_price, :total_price, guest: {}).merge(type: 'airbnb')
  end

  def booking_params
    params.require(:reservation).permit(:code, :start_date, :end_date, :expected_payout_amount,
      :guest_email, :guest_first_name, :guest_last_name,
      :listing_security_price_accurate, :host_currency, :nights,
      :number_of_guests, :status_type, :total_paid_amount_accurate,
      guest_details: {}, guest_phone_numbers: []).merge(type: 'booking')
  end

end