module ApplicationHelper
  def shortened_urls_path(*args)
    shortened_url_index_path(*args)
  end
  
  def shortened_urls_url(*args)
    shortened_url_index_url(*args)
  end
    
  def title(page_title)
    content_for(:title) { page_title }
  end
end
