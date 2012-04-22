require 'spec_helper'

describe "Blogs" do
  shared_examples_for "an existing page" do
    it "should return status code of 200" do
      page.status_code.should be(200)
    end
  end

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
  end
end
