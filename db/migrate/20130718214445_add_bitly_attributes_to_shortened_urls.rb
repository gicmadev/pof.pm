class AddBitlyAttributesToShortenedUrls < ActiveRecord::Migration
  def change
    add_column :shortened_urls, :from_bitly, :boolean
    add_column :shortened_urls, :bitly_clicks, :integer
  end
end
