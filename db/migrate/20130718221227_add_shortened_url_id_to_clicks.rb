class AddShortenedUrlIdToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :shortened_url_id, :integer
  end
end
