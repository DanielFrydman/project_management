require 'rails_helper'

RSpec.describe StatusChange, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:old_status) }
    it { should validate_presence_of(:new_status) }
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe 'status validation' do
    let(:status_change) { build(:status_change) }

    it 'validates status values are valid project statuses' do
      status_change.old_status = 'invalid'
      expect(status_change).not_to be_valid

      status_change.old_status = 'not_started'
      expect(status_change).to be_valid
    end

    it 'validates old and new status are different' do
      status_change.old_status = 'in_progress'
      status_change.new_status = 'in_progress'
      expect(status_change).not_to be_valid
      expect(status_change.errors[:new_status]).to include("can't be the same as the old status")
    end
  end
end
