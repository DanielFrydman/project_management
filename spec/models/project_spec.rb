require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
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