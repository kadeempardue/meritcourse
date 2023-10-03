class CatalogController < ApplicationController
  def explore
    pusher_page
    @title = "Explore Catalog"
    @subjects = Subject.all
    @programs = Program.all
    @courses = params[:q].present? ? DbTextSearch::FullText.new(Course.not_archived, :name).search(params[:q]) : Course.not_archived
  end

  # Programs grouped by Subject
  def show
    pusher_page
    @subject = Subject.friendly.find(params[:id])
    @programs = Program.find_all_from_subject(@subject)
  end

  def search
    pusher_page
    @courses = params[:q] == 'all' ? Course.not_archived : DbTextSearch::FullText.new(Course.not_archived, :name).search(params[:q])
    respond_to do |format|
      format.js
    end
  end
end
