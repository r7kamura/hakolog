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

    it_should_behave_like "an existing page"

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
      before do
        @entry = FactoryGirl.create(:entry, :blog_id => blog.id)
        visit url_for(blog)
      end
      it { should have_content(@entry.title) }
    end
  end

  describe "GET /blogs/:id/entries/new" do
    before do
      visit url_for(new_blog_entry_path(:blog_id => blog.id))
    end

    it_should_behave_like "an existing page"

    it do
      within("#create_entry_form") do
        should have_css("input#title")
        should have_css("textarea#body")
        should have_css("input[type=submit]")
      end
    end
  end

  describe "POST /blogs/:id/entries" do
    before do
      pending "not implemented"
      @title = "title 1"
      @body  = "body 1"
    end

    it_should_behave_like "an existing page"

    it "should create entry" do
      visit url_for(new_blog_entry_path(:blog_id => blog.id))
      fill_in :title, @title
      fill_in :body, @body
      click "OK"
      visit blogs_path

      should have_content(@title)
      should have_content(@body)
    end
  end
end
