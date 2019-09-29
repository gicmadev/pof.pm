class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :title
      t.string :url
      t.string :description
      t.string :shortcode

      t.timestamps
    end
  end
end
