require "spec_helper"

describe Blog do
  before do
    Blog.any_instance.stub(:create_default_files)
  end

  describe "#create" do
    subject { blog }

    let(:blog) { FactoryGirl.build(:blog, opts) }

    context "when passed valid attributes" do
      let(:opts) { {} }

      it do
        expect {
          subject.save!
        }.not_to raise_error(ActiveRecord::RecordInvalid)
      end

      it do
        should be_valid
      end
    end

    context "when passed invaid username" do
      let(:opts) { {:username => "invalid username"} }

      it do
        should_not be_valid
      end
    end
  end
end
