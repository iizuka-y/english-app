class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :ranking_user, only: [:show, :evaluated]
  before_action :set_post_tags_to_gon, only: [:edit]
  before_action :set_available_tags_to_gon, only: [:new, :edit]
  after_action :edit_star_count, only: [:destroy]

  def show
    @post = Post.find(params[:id])
    @comment = current_user.comments.build
    @comments = @post.comments.page(params[:page]).per(10)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url
      flash[:success] = "投稿しました！"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = "投稿を更新しました"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "投稿を削除しました！"
    redirect_to root_url
  end

  def autocomplete
    available_tags = []
    tags = Post.tags_on(:tags).pluck(:name, :taggings_count)
    tags.each do |tag|
      name = tag[0] + '(' + tag[1].to_s + "件" + ')'
      available_tags.push(name)
    end
    @available_tags_selected = available_tags.select { |item| item.include?(params[:term]) }
    render json: @available_tags_selected.to_json
  end

  def evaluated
    @post = Post.find(params[:id])
    evaluations = @post.evaluations.order(created_at: :desc)
    @users =  Kaminari.paginate_array(evaluations.map{|evaluation| evaluation.user}).page(params[:page]).per(10)
  end


  private
    def post_params
      params.require(:post).permit(:keyword, :content, :information, :image, :image_cache, :remove_image, :tag_list)
    end

    # beforeアクション
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

    def ranking_user
      @ranking_users = User.limit(10).order('star_count DESC')
    end

    def set_post_tags_to_gon
      @post = Post.find(params[:id])
      gon.post_tags = @post.tag_list
    end

    def set_available_tags_to_gon
      gon.available_tags = []
      tag_list = Post.tags_on(:tags).pluck(:name, :taggings_count)
      tag_list.each do |tag|
        name = tag[0] + '(' + tag[1].to_s + "件" + ')'
        gon.available_tags.push(name)
      end
    end

    # afterアクション
    def edit_star_count
      user = @post.user
      user.star_count = sum_stars(user.posts)
      user.save
    end
end
