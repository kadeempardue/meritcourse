class Meritadmin::MediaLibraryController < Meritadmin::ApplicationController
  before_action :authenticate_admin_user!

  def index
    s3_files = s3_bucket.objects(prefix: "#{@tenant&.key}/").reject { |x| x.key == "#{@tenant&.key}/" }.sort_by(&:last_modified).reverse
    @files = Kaminari.paginate_array(s3_files).page(params[:page] || Meritadmin::PER_PAGE).per(params[:scope] || Meritadmin::PER_SCOPE_8)
  end

  def create
    file_size = File.size(params[:file].tempfile)

    if file_size >= 100_000_000
      flash[:error] = I18n.t("messages.file_too_large")
      return redirect_to media_library_path
    end

    flash[:notice] = I18n.t("messages.successful_upload")

    obj = s3_bucket.object("#{@tenant&.key}/#{params[:file].original_filename}")
    obj.upload_file(params[:file].tempfile, content_type: params[:file].content_type)

    s3_client.put_object_acl(
      acl: "public-read",
      bucket: s3_bucket.name,
      key: "#{@tenant&.key}/#{params[:file].original_filename}"
    )

    redirect_to media_library_path
  rescue => e
    flash[:notice] = nil
    flash[:error] = I18n.t("messages.failed_upload")
    msg = "Failed to upload image #{@tenant&.key} #{e.message}"
    Bugsnag.notify(msg) if Rails.env.production?
    Rails.logger.error(msg)
    redirect_to media_library_path
  end

  private

  def s3_client
    @s3_client ||= Aws::S3::Client.new(region: ENV["AWS_S3_REGION"])
  end

  def s3_bucket
    @s3_bucket ||= s3_resource.bucket(ENV["AWS_S3_BUCKET_NAME"])
  end

  def s3_resource
    @s3_resource ||= Aws::S3::Resource.new(client: s3_client)
  end
end
