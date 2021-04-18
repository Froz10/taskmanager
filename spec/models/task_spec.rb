require "rails_helper"

RSpec.describe Task, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :priority }
  it { should validate_presence_of :status }
  it { should validate_presence_of :deadline }
  it { should belong_to(:user) }
end
