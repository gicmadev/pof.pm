require 'test_helper'

class ShortenedUrlsControllerTest < ActionController::TestCase
  setup do
    @urls = shortened_urls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shortened_urls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shortened_url" do
    assert_difference('ShortenedUrl.count') do
      post :create, :shortened_url => { :description => @urls.description, :shortcode => @urls.shortcode, :title => @urls.title, :url => @urls.url }
    end

    assert_redirected_to url_path(assigns(:shortened_url))
  end

  test "should show shortened_url" do
    get :show, :id => @urls
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @urls
    assert_response :success
  end

  test "should update shortened_url" do
    put :update, :id => @urls, :shortened_url => { :description => @urls.description, :shortcode => @urls.shortcode, :title => @urls.title, :url => @urls.url }
    assert_redirected_to url_path(assigns(:shortened_url))
  end

  test "should destroy shortened_url" do
    assert_difference('ShortenedUrl.count', -1) do
      delete :destroy, :id => @urls
    end

    assert_redirected_to shortened_urls_path
  end
end
