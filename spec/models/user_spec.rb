require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(:password => 'password')
    expect(user).to be_valid
  end

  describe "Associations" do
    it { should have_many(:tasks) }
    it { should have_many(:projects) }
  end
end