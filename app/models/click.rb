class Click < ActiveRecord::Base
  belongs_to :shortened_url, counter_cache: true
end
