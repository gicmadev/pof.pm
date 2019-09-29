class ShortenedUrlController < ApplicationController
  skip_before_filter :check_password, :only => [:follow, :shorten]
  
  # GET /url
  # GET /url.json
  def index
    @urls = ShortenedUrl.order("updated_at ASC").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @urls }
    end
  end

  # GET /url/1
  # GET /url/1.json
  def show
    @url = ShortenedUrl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @url }
    end
  end

  # GET /url/new
  # GET /url/new.json
  def new
    @url = ShortenedUrl.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @url }
    end
  end

  # GET /url/1/edit
  def edit
    @url = ShortenedUrl.find(params[:id])
  end

  # POST /url
  # POST /url.json
  def create
    @url = ShortenedUrl.new(surl_params)

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, :notice => 'Shortened url was successfully created.' }
        format.json { render :json => @url, :status => :created, :location => @url }
      else
        format.html { render :action => "new" }
        format.json { render :json => @url.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /url/1
  # PUT /url/1.json
  def update
    @url = ShortenedUrl.find(params[:id])

    respond_to do |format|
      if @url.update_attributes(surl_params)
        format.html { redirect_to @url, :notice => 'Shortened url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @url.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /url/1
  # DELETE /url/1.json
  def destroy
    @url = ShortenedUrl.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.html { redirect_to shortened_url_index_url }
      format.json { head :no_content }
    end
  end
    
  def follow
    @url = ShortenedURL.find_by_shortcode(params[:id])
    if @url.nil?
      biturl = Bitly.client.expand("https://pof.pm/#{params[:id]}")
      biturl = Bitly.client.expand("https://bit.ly/#{params[:id]}") if biturl.long_url.blank?
      unless biturl.long_url.nil?
        @url = ShortenedURL.create(:shortcode => params[:id], :url => biturl.long_url, :from_bitly => true, :bitly_clicks => biturl.global_clicks)
      end
    end

    if @url.nil?
      render :nothing => true, :status => 404
    else
      @url.click!(request)
      redirect_to @url.url, :status_code => 302
    end
  end
  
  def shorten
    if params.permit(:token)[:token] == ENV["TOKEN"] && !params[:url].blank?
      @url = ShortenedURL.find_by_url(api_surl_params[:url])
      @url = ShortenedURL.create(api_surl_params) if @url.nil?
      if @url
        respond_to do |format|
          format.json { render :json => { :shortURL => "http://pof.pm/#{@url.shortcode}" } }
          format.text { render :text => "http://pof.pm/#{@url.shortcode}" }
          format.html { render :text => "http://pof.pm/#{@url.shortcode}" }
        end
      else
        render :nothing => true, :status => 400
      end
    else
      render :nothing => true, :status => 400
    end
  end

  private

 def api_surl_params
   params.permit(:shortcode, :url)
  end

 def surl_params
   params.require(:shortened_url).permit(:description, :shortcode, :title, :url)
  end
end
