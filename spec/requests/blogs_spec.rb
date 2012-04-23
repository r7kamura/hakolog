require "spec_helper"

describe "Blogs" do
  shared_examples_for "an existing page" do
    its(:status_code) { should == 200 }
  end

  let(:blog) { FactoryGirl.create(:blog) }

  subject { page }

  describe "GET /blogs" do
    before { visit blogs_path }
    it_should_behave_like "an existing page"
  end

  describe "GET /blogs/:id" do
    before { visit url_for(blog) }

    describe "status code" do
      it_should_behave_like "an existing page"
    end

    describe "title" do
      shared_examples_for "it has title" do
        it { should have_content(blog.title) }
      end

      context "when blog has its title" do
        let(:blog) { FactoryGirl.create(:blog, :title => "blog title") }
        it_should_behave_like("it has title")
      end

      context "when blog does not have its title" do
        it_should_behave_like("it has title")
      end
    end

    describe "entries" do
      let(:blog) do
        FactoryGirl.create(:blog).tap do |blog|
          @entry = FactoryGirl.create(:entry, :blog => blog)
        end
      end
      it { should have_content(@entry.title) }
    end
  end
end
