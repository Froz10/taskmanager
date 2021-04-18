FactoryBot.define do
  factory :task do
    name { 'MyString' }
    status { 'MyStatus'}
    priority { 'MyPriority'}
    deadline { '12.12.2020' }
    user
    project
  end
end