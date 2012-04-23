require "spec_helper"

describe Blog do
  describe "#create" do
    it do
      expect {
        FactoryGirl.create(:blog).save!
      }.not_to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
