FactoryBot.define do
  factory :project do
    name { Faker::Company.name + " Project" }
    
    trait :not_started do
      status { :not_started }
    end

    trait :in_progress do
      status { :in_progress }
    end

    trait :on_hold do
      status { :on_hold }
    end

    trait :completed do
      status { :completed }
    end
  end
end 