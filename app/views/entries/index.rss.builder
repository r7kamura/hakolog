xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@blog.username}'s Hakolog"
    xml.description "#{@blog.username}'s Hakolog"
    xml.link blog_entries_path(@blog) + ".rss"

    @entries.each do |entry|
      xml.item do
        xml.title entry.title
        xml.description entry.parsed_body
        xml.pubDate entry.modified_at.to_s(:rfc822)
        xml.link blog_entry_path(@blog, entry)
        xml.guid blog_entry_path(@blog, entry)
      end
    end
  end
end
