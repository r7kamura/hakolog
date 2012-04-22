require 'spec_helper'

describe "Blogs" do
  shared_examples_for "an existing page" do
    it "should return status code of 200" do
      response.status.should be(200)
    end
  end

  describe "GET /blogs" do
    before do
      get blogs_path
    end
    it_should_behave_like "an existing page"
  end

  describe "GET /blogs/:id" do
    before do
      blog = FactoryGirl.create(:blog)
      get blog_path(:id => blog.id)
    end
    it_should_behave_like "an existing page"
  end
end
