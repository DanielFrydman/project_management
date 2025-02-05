require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:status_changes).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should have_secure_password }

    context 'email format' do
      it 'accepts valid email addresses' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user = build(:user, email: valid_address)
          expect(user).to be_valid, "#{valid_address.inspect} should be valid"
        end
      end

      it 'rejects invalid email addresses' do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          user = build(:user, email: invalid_address)
          expect(user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
        end
      end
    end
  end

  describe 'callbacks' do
    context 'before validation' do
      it 'downcases email' do
        user = create(:user, email: 'USER@EXAMPLE.COM')
        expect(user.email).to eq('user@example.com')
      end

      it 'titleizes name' do
        user = create(:user, name: 'john doe')
        expect(user.name).to eq('John Doe')
      end
    end
  end

  describe 'authentication' do
    let(:user) { create(:user, password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
end
