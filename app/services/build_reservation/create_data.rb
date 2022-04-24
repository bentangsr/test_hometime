module BuildReservation
  class CreateData
    def initialize(reservation_params:)
      @reservation_params = reservation_params
      @res = nil
      @messages = []
    end

    attr_reader :res

    def run
      if @reservation_params[:type].eql?('airbnb')
        save_data(payload_reservation: payload_reservation_airbnb, payload_guest: payload_guest_airbnb)
      elsif @reservation_params[:type].eql?('booking')
        save_data(payload_reservation: payload_reservation_booking, payload_guest: payload_guest_booking)
      end

      finish_and_return_messages
    end

    private

    def save_data(payload_reservation:, payload_guest:)
      guest = Guest.find_by(email: payload_guest[:email]) || Guest.new
      guest.email = payload_guest[:email]
      guest.first_name = payload_guest[:firt_name]
      guest.last_name = payload_guest[:last_name]
      guest.phone_numbers = payload_guest[:phone_numbers]

      unless guest.save
        @messages.push(guest.errors.full_messages)
      end

      if guest.id.present? && payload_reservation[:code].present?
        reservation = Reservation.find_by(code: payload_reservation[:code], guest_id: guest.id) || Reservation.new
        reservation.guest_id = guest.id
        reservation.code = payload_reservation[:code]
        reservation.start_date = payload_reservation[:start_date]
        reservation.end_date = payload_reservation[:end_date]
        reservation.nights = payload_reservation[:nights]
        reservation.guests = payload_reservation[:guests]
        reservation.adults = payload_reservation[:adults]
        reservation.children = payload_reservation[:children]
        reservation.infants = payload_reservation[:infants]
        reservation.status = payload_reservation[:status]
        reservation.currency = payload_reservation[:currency]
        reservation.payout_price = payload_reservation[:payout_price]
        reservation.security_price = payload_reservation[:security_price]
        reservation.total_price = payload_reservation[:total_price]
        unless reservation.save
          @messages.push(reservation.errors.full_messages)
        end
      end
    end

    def payload_reservation_airbnb
      {
        code: @reservation_params[:reservation_code],
        start_date: @reservation_params[:start_date],
        end_date: @reservation_params[:end_date],
        nights: @reservation_params[:nights],
        guests: @reservation_params[:guests],
        adults: @reservation_params[:adults],
        children: @reservation_params[:children],
        infants: @reservation_params[:infants],
        status: @reservation_params[:status],
        currency: @reservation_params[:currency],
        payout_price: @reservation_params[:payout_price],
        security_price: @reservation_params[:security_price],
        total_price: @reservation_params[:total_price]
      }
    end

    def payload_reservation_booking
      {
        code: @reservation_params[:code],
        start_date: @reservation_params[:start_date],
        end_date: @reservation_params[:end_date],
        nights: @reservation_params[:nights],
        guests: @reservation_params[:number_of_guests],
        adults: @reservation_params[:guest_details][:number_of_adults],
        children: @reservation_params[:guest_details][:number_of_children],
        infants: @reservation_params[:guest_details][:number_of_infants],
        status: @reservation_params[:status_type],
        currency: @reservation_params[:host_currency],
        payout_price: @reservation_params[:expected_payout_amount],
        security_price: @reservation_params[:listing_security_price_accurate],
        total_price: @reservation_params[:total_paid_amount_accurate]
      }
    end

    def payload_guest_booking
      {
        email: @reservation_params[:guest_email],
        first_name: @reservation_params[:guest_first_name],
        last_name: @reservation_params[:guest_last_name],
        phone_numbers: @reservation_params[:guest_phone_numbers]
      }
    end

    def payload_guest_airbnb
      phone_numbers = []
      phone_numbers.push(@reservation_params[:guest][:phone])
      {
        email: @reservation_params[:guest][:email],
        first_name: @reservation_params[:guest][:first_name],
        last_name: @reservation_params[:guest][:last_name],
        phone_numbers: phone_numbers
      }
    end

    def finish_and_return_messages
      if @messages.present?
        message = @messages.flatten.uniq.join(', ')
        success = false
        error_code = 422
      else
        message = 'Reservation has been Submitted successfully'
        success = true
        error_code = 200
      end
      @res = {
        "success": success,
        "message": message ,
        "error_code": error_code
      }
    end

  end
end