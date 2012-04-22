require 'spec_helper'

describe "Blogs" do
  describe "GET /blogs" do
    it do
      get blogs_path
      response.status.should be(200)
    end
  end
end
