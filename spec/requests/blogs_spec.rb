require 'spec_helper'

describe "Blogs" do
  shared_examples_for "an existing page" do
    its(:status_code) { should == 200 }
  end

  subject { page }

  describe "GET /blogs" do
    before do
      visit blogs_path
    end

    it_should_behave_like "an existing page"
  end

  describe "GET /blogs/:id" do
    before do
      @blog = FactoryGirl.create(:blog)
      visit blog_path(:id => @blog.id)
    end

    it_should_behave_like "an existing page"

    it do
      should have_content(@blog.title)
    end
  end
end
