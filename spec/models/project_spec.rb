require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:project)).to be_valid
    end

    context 'with status traits' do
      it 'creates project with not_started status' do
        expect(create(:project, :not_started)).to be_not_started
      end

      it 'creates project with in_progress status' do
        expect(create(:project, :in_progress)).to be_in_progress
      end

      it 'creates project with on_hold status' do
        expect(create(:project, :on_hold)).to be_on_hold
      end

      it 'creates project with completed status' do
        expect(create(:project, :completed)).to be_completed
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:status_changes).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(not_started: 0, in_progress: 1, on_hold: 2, completed: 3).with_default(:not_started) }
  end

  describe 'state tracking' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }

    describe '#handle_status_change' do
      context 'when changing to a different status' do
        before do
          allow(Current).to receive(:user).and_return(user)
        end

        it 'creates a status change record' do
          expect {
            project.update(status: :in_progress)
          }.to change(project.status_changes, :count).by(1)

          status_change = project.status_changes.last
          expect(status_change.old_status).to eq('not_started')
          expect(status_change.new_status).to eq('in_progress')
          expect(status_change.user).to eq(user)
        end
      end

      context 'when trying to update with the same status' do
        before do
          allow(Current).to receive(:user).and_return(user)
        end

        it 'does not create a status change record' do
          current_status = project.status
          expect {
            project.update(status: current_status)
          }.not_to change(project.status_changes, :count)
        end
      end

      context 'when the record is new' do
        it 'does not create a status change' do
          new_project = build(:project, user: user)
          expect {
            new_project.save
          }.not_to change(StatusChange, :count)
        end
      end
    end

    describe '#add_comment' do
      it 'creates a new comment' do
        expect {
          project.add_comment(user, 'Test comment')
        }.to change(project.comments, :count).by(1)

        comment = project.comments.last
        expect(comment.content).to eq('Test comment')
        expect(comment.user).to eq(user)
      end
    end
  end
end
