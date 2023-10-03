class Meritadmin::ArticlesController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    records = Article.all
    @articles =
      if params[:q].present?
        DbTextSearch::FullText.new(records, :title).search(params[:q]).or(
          DbTextSearch::FullText.new(records, :body).search(params[:q]).or(
            DbTextSearch::FullText.new(records, :category).search(params[:q])
          )
        )
      else
        records
      end.page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE)
  end

  def new
    @article = Article.new
    @category_names = Article.pluck(:category).uniq
  end

  def show
    @article = Article.friendly.find(params[:id])
  end

  def create
    @article = Article.create(whitelisted_params)
    if @article.valid?
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @article.id)
      return redirect_to article_path(@article)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to new_article_path(Article.new)
  end

  def edit
    @article = Article.friendly.find(params[:id])
    @category_names = Article.pluck(:category).uniq
  end

  def update
    @article = Article.friendly.find(params[:id])
    if @article&.update(whitelisted_params)
      flash[:notice] = t("messages.successful_save")
      response.set_header('X-Resource-ID', @article.id)
      return redirect_to article_path(@article)
    end

    flash[:error] = t("messages.failed_save")
    redirect_to edit_article_path(@article)
  end

  def destroy
    @article = Article.friendly.find(params[:id])
    @article&.destroy
    response.set_header('X-Resource-ID', @article&.id)
    respond_to do |format|
      format.html  do
        flash[:notice] = t("messages.successful_destroy")
        redirect_to root_path
      end
      format.json  { render json: { notice: t("messages.successful_destroy"), id: @article&.id.to_s } }
    end
  end

  private

  def whitelisted_params
    params.require(:article).permit(:title, :category, :featured_image, :body, :post_status)
  end
end
