namespace :dropbox do
  desc "Sync all blogs with Dropbox"
  task :sync => :environment do
    Blog.all.each do |blog|
      blog.sync_with_dropbox
    end
  end
end
