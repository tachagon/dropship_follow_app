class String
	def |(what)
	  self.strip.blank? ? what : self
	end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  	# convert UTF 8 URL to ASCII URL
  	url = URI.escape params[:url]
  	@page = Nokogiri::HTML(open(url))
  	@product_images = @page.css(".detail-img img").to_a
  	# @root = "root_path(url: params[:url])"
  	@root = "/?url=#{params[:url]}"
  end
end
