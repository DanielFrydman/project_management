require 'rails_helper'

RSpec.describe StatusChange, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:status_change)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:old_status) }
    it { should validate_presence_of(:new_status) }

    describe 'status values' do
      let(:valid_statuses) { Project.statuses.keys }

      it { should validate_inclusion_of(:old_status).in_array(valid_statuses) }
      it { should validate_inclusion_of(:new_status).in_array(valid_statuses) }
    end
  end

  describe 'behavior' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:status_change) { build(:status_change, user: user, project: project) }

    it 'associates with the correct user and project' do
      status_change.save!
      expect(status_change.user).to eq(user)
      expect(status_change.project).to eq(project)
    end

    context 'with invalid status values' do
      it 'is invalid with non-existent old_status' do
        status_change.old_status = 'invalid_status'
        expect(status_change).not_to be_valid
        expect(status_change.errors[:old_status]).to include('is not included in the list')
      end

      it 'is invalid with non-existent new_status' do
        status_change.new_status = 'invalid_status'
        expect(status_change).not_to be_valid
        expect(status_change.errors[:new_status]).to include('is not included in the list')
      end
    end

    context 'when statuses are the same' do
      it 'is invalid' do
        status_change.old_status = 'in_progress'
        status_change.new_status = 'in_progress'
        expect(status_change).not_to be_valid
        expect(status_change.errors[:new_status]).to include("can't be the same as the old status")
      end
    end

    context 'when required associations are missing' do
      it 'is invalid without a user' do
        status_change.user = nil
        expect(status_change).not_to be_valid
        expect(status_change.errors[:user]).to include('must exist')
      end

      it 'is invalid without a project' do
        status_change.project = nil
        expect(status_change).not_to be_valid
        expect(status_change.errors[:project]).to include('must exist')
      end
    end
  end
end
