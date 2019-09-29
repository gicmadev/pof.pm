class AddCacheCounterToShortenedUrls < ActiveRecord::Migration
  def change
    add_column :shortened_urls, :clicks_count, :integer
  end
end
