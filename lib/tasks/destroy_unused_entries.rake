namespace :entries do
  desc "Destroy unused entries whose blog is already deleted"
  task :canonicalize => :environment do
    Entry.includes(:blog).each do |entry|
      entry.destroy unless entry.blog
    end
  end
end
