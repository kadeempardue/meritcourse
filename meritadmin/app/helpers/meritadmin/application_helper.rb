module Meritadmin
  module ApplicationHelper
    include ::ApplicationHelper

    def oauth_state
      "#{request.base_url}/admin/integrations/stripe_connected"
    end

    def stripe_express_redirect_url
      "#{request.base_url}/admin/plans"
    end

    def element_from_url_file_format(url)
      case File.extname(url) # =~ /^(.png|.gif|.jpg|.jpeg)$/
      when ".png", ".gif", ".jpg", ".jpeg"
        "<img uk-img data-src=\"#{url}\">".html_safe
      when ".doc", ".docx"
        "<i class='uk-block icon-xxlarge icon-line-awesome-file-word-o'></i>".html_safe
      when ".csv"
        "<i class='uk-block icon-xxlarge icon-feather-file-text'></i>".html_safe
      when ".pdf"
        "<i class='uk-block icon-xxlarge icon-line-awesome-file-pdf-o'></i>".html_safe
      when ".mp3"
        "<i class='uk-block icon-xxlarge icon-feather-music'></i>".html_safe
      end
    end

    def s3_url(key)
      "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3.amazonaws.com/#{key.gsub(' ', '+')}"
    end
  end
end
