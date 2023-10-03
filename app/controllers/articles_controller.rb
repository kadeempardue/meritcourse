class ArticlesController < ApplicationController
  before_action :redirect_unless_blog_activated?

  def index
    pusher_page
    @title = setting.blog_name
    @articles = Article.published
  end

  def show
    pusher_page
    @article = Article.friendly.find(params[:id])

    @title = @article.title
    @article_comment = ArticleComment.new
  end

  private

  def redirect_unless_blog_activated?
    return redirect_to root_path unless setting.has_blog?
  end
end
