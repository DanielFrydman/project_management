require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }

    describe 'status validation' do
      let(:project) { create(:project, status: :in_progress) }

      it 'prevents updating to the same status' do
        expect(project.update(status: :in_progress)).to be false
        expect(project.errors[:status]).to include("can't be changed to the same status")
      end

      it 'prevents updating to the same status using string' do
        expect(project.update(status: 'in_progress')).to be false
        expect(project.errors[:status]).to include("can't be changed to the same status")
      end

      it 'allows updating to a different status' do
        expect(project.update(status: :completed)).to be true
      end

      it 'skips validation for new records' do
        new_project = build(:project, status: :in_progress)
        expect(new_project).to be_valid
      end
    end
  end

  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:status_changes).dependent(:destroy) }
  end

  describe 'status tracking' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    before { Current.user = user }
    after { Current.user = nil }

    context 'when creating a new project' do
      it 'does not create a status change' do
        expect {
          create(:project, status: :in_progress)
        }.not_to change(StatusChange, :count)
      end
    end

    context 'when updating status' do
      it 'creates a status change when status is updated' do
        expect {
          project.update!(status: :in_progress)
        }.to change(StatusChange, :count).by(1)

        status_change = project.status_changes.last
        expect(status_change.user).to eq(user)
        expect(status_change.old_status).to eq('not_started')
        expect(status_change.new_status).to eq('in_progress')
      end

      it 'does not create a status change when update fails' do
        expect {
          project.update(status: project.status)
        }.not_to change(StatusChange, :count)
      end

      it 'creates multiple status changes for multiple updates' do
        expect {
          project.update!(status: :in_progress)
          project.update!(status: :on_hold)
          project.update!(status: :completed)
        }.to change(StatusChange, :count).by(3)

        changes = project.status_changes.order(:created_at)
        expect(changes.map(&:old_status)).to eq(['not_started', 'in_progress', 'on_hold'])
        expect(changes.map(&:new_status)).to eq(['in_progress', 'on_hold', 'completed'])
      end
    end

    context 'when updating other attributes' do
      it 'does not create a status change when only name is updated' do
        expect {
          project.update!(name: 'New Name')
        }.not_to change(StatusChange, :count)
      end

      it 'does not create a status change when only title is updated' do
        expect {
          project.update!(title: 'New Title')
        }.not_to change(StatusChange, :count)
      end

      it 'does not create a status change when only description is updated' do
        expect {
          project.update!(description: 'New Description')
        }.not_to change(StatusChange, :count)
      end
    end

    context 'when Current.user is not set' do
      before { Current.user = nil }

      it 'raises an error when trying to update status' do
        expect {
          project.update(status: :in_progress)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when adding comments' do
      it 'does not trigger status change validation' do
        expect {
          project.add_comment(user, 'Test comment')
        }.not_to change(StatusChange, :count)
      end
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(not_started: 0, in_progress: 1, on_hold: 2, completed: 3) }
  end

  describe 'defaults' do
    it 'sets status to not_started by default' do
      project = build(:project)
      expect(project.status).to eq('not_started')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:project)).to be_valid
    end

    it 'can create projects with different statuses' do
      expect(build(:project, :not_started)).to be_valid
      expect(build(:project, :in_progress)).to be_valid
      expect(build(:project, :on_hold)).to be_valid
      expect(build(:project, :completed)).to be_valid
    end
  end
end 