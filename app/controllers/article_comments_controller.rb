class ArticleCommentsController < ApplicationController
  before_action :authenticate_student!, only: [:create]

  def create
    pusher_page

    @article_comment = ArticleComment.new(whitelisted_params)
    @article_comment.student = current_student

    if @article_comment.save
      response.set_header('X-Resource-ID', @article_comment.id)
      flash[:notice] = t("messages.successful_create")
      return redirect_to article_path(@article_comment.article)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to article_path(@article_comment.article)
  end

  private

  def whitelisted_params
    params.require(:article_comment).permit(:comment, :article_id)
  end
end
