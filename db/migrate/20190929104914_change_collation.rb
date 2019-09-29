class ChangeCollation < ActiveRecord::Migration
  def up
    %w(clicks shortened_urls).each do |t|
      execute "ALTER TABLE #{t} CONVERT TO CHARACTER SET utf8mb4"
    end
  end

  def down
    raise "Can't rollback"
  end
end
