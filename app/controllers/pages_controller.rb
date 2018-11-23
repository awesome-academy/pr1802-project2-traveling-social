class PagesController < ApplicationController
  before_action :list_following, only: [:index, :statistic]

  def index
    @micro_post = MicroPost.new
    @pagy, @micro_posts = pagy_array MicroPost.all_status(current_user).decorate, 
      items: Settings.micro_posts.per_page
    @user = current_user
    return unless params[:id_status]
    @micro_post = MicroPost.find_by id: params[:id_status]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def statistic
    @cities = City.joins(:locations).select 'locations.name'
    @reviews = Review.joins(:location).select 'locations.name'
  end

  private

  def list_following
    @list_following = User.list_following current_user
  end
end
