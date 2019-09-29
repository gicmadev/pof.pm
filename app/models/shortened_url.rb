require 'digest'

class ShortenedUrl < ActiveRecord::Base
  has_many :clicks

  before_validation :generate_shortcode

  validates_presence_of :url, :message => "can't be blank"
  validates_presence_of :shortcode, :message => "can't be blank"
  validates_format_of :shortcode, :with => /\A[\w\d]+\z/, :message => "is invalid"
  validates_uniqueness_of :shortcode, :message => "must be unique"

  def click!(request)
    self.clicks.create!(:referer => request.referer, :ip => Digest::SHA512.hexdigest(request.remote_ip))
  end

  def generate_shortcode
    while self.shortcode.blank? || ShortenedURL.where("shortcode = ? AND id != ?", self.shortcode.to_s, self.id.to_i).count > 0 
      self.shortcode = (0..6).map{ rand(36).to_s(36) }.join
    end
  end

end

class ShortenedURL < ShortenedUrl
end
