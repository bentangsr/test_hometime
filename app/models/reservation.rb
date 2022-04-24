class Reservation < ApplicationRecord
  acts_as_paranoid

  belongs_to :guest

  validates :nights, :guests, :adults, :children, :infants, numericality: { only_integer: true }
  validates :payout_price, :security_price, :total_price, numericality: true
  validates :code, uniqueness: true
  validates :code, presence: true

  # custome validation
  validate :validate_start_date, :validate_end_date

  private

  def convert_date_format(val_date)
    begin
      is_date = Date.parse(val_date)
    rescue
      false
    end
  end

  def validate_start_date
    errors.add(:start_date, :invalid) unless convert_date_format(self.start_date.to_s)
  end

  def validate_end_date
    errors.add(:end_date, :invalid) unless convert_date_format(self.end_date.to_s)
  end
end
