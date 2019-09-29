class ChangeIpTypeInClicks < ActiveRecord::Migration
  def up
    execute "ALTER TABLE `clicks` CHANGE `ip` `ip` TEXT;"
  end

  def down
    execute "ALTER TABLE `clicks` CHANGE `ip` `ip` VARCHAR(255)"
  end
end
