FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    project
    user
  end
end
