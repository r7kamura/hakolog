FactoryGirl.define do
  factory :blog do
    sequence(:username) { |n| "username #{n}" }
    sequence(:dropbox_session) { |n| "dropbox_session #{n}" }
    sequence(:dropbox_id) { |n| n }
  end

  factory :entry do
    sequence(:title) { |n| "entry title #{n}" }
  end
end
