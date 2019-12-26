class HomeController < ApplicationController
  def index
    if logged_in?
      @posts = Post.all
    end
  end
end
