require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:comment)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'behavior' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:comment) { create(:comment, user: user, project: project) }

    it 'associates with the correct user and project' do
      expect(comment.user).to eq(user)
      expect(comment.project).to eq(project)
    end

    context 'when content is empty' do
      it 'is invalid' do
        comment.content = ''
        expect(comment).not_to be_valid
        expect(comment.errors[:content]).to include("can't be blank")
      end
    end

    context 'when content is nil' do
      it 'is invalid' do
        comment.content = nil
        expect(comment).not_to be_valid
        expect(comment.errors[:content]).to include("can't be blank")
      end
    end

    context 'when user is not present' do
      it 'is invalid' do
        comment.user = nil
        expect(comment).not_to be_valid
        expect(comment.errors[:user]).to include('must exist')
      end
    end

    context 'when project is not present' do
      it 'is invalid' do
        comment.project = nil
        expect(comment).not_to be_valid
        expect(comment.errors[:project]).to include('must exist')
      end
    end
  end
end
