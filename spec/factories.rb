FactoryGirl.define do
  factory :blog do
    %w[username dropbox_session].each do |attr|
      sequence(attr) do |n|
        "blog #{attr} #{n}"
      end
    end

    sequence(:dropbox_id) { |n| n }
  end

  factory :entry do
    sequence(:title) { |n| "entry title #{n}" }
  end
end
