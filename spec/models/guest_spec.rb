require 'rails_helper'

RSpec.describe Guest, type: :model do
  let(:name) { 'guest model' }

  describe "Associations" do
    # this class has_many or has_ones
    it { should have_many(:reservations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
