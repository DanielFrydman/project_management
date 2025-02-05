require 'rails_helper'

RSpec.describe Current, type: :model do
  describe '.user' do
    let(:user) { create(:user) }

    it 'can set and get the current user' do
      Current.user = user
      expect(Current.user).to eq(user)
    end

    it 'resets between requests' do
      Current.user = user
      Current.reset
      expect(Current.user).to be_nil
    end
  end

  describe 'thread safety' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'isolates attributes between threads' do
      thread = Thread.new do
        Current.user = user2
        expect(Current.user).to eq(user2)
      end

      Current.user = user1
      expect(Current.user).to eq(user1)

      thread.join
      expect(Current.user).to eq(user1)
    end
  end
end
