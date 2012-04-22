require "spec_helper"

describe "Blogs" do
  shared_examples_for "an existing page" do
    its(:status_code) { should == 200 }
  end

  subject { page }

  describe "GET /blogs" do
    before { visit blogs_path }
    it_should_behave_like "an existing page"
  end

  describe "GET /blogs/:id" do
    before { visit url_for(blog) }

    describe "status code" do
      let(:blog) { FactoryGirl.create(:blog) }
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
        let(:blog) { FactoryGirl.create(:blog) }
        it_should_behave_like("it has title")
      end
    end
  end
end
