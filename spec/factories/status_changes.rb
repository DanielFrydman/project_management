FactoryBot.define do
  factory :status_change do
    project
    user
    old_status { 'not_started' }
    new_status { 'in_progress' }
  end
end
