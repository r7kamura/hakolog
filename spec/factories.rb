FactoryGirl.define do
  factory :blog do
    sequence(:username) { |n| "username#{n}" }
    sequence(:dropbox_session) { |n| "dropbox_session #{n}" }
    sequence(:dropbox_id) { |n| n }
  end

  factory :entry do
    sequence(:path) { |n| Entry::BASE_PATH + "entry_title#{n}.md" }
  end

  factory :authenticated_blog do
    sequence(:username) { |n| "autheduser#{n}" }
    sequence(:dropbox_id) { |n| 1671518 }
    sequence(:dropbox_session) { |n|
      [
        "---",
        "- izntwgemnc7zdsf",
        "- u5kpv2vr0ekwm17",
        "- 4mxsocn5e388w46",
        "- du0d79vz6plsguu",
        "- 5rq836agb1lh9ai",
        "- jrd557ov9txfv1e",
        "",
      ].join("\n")
    }
  end
end
