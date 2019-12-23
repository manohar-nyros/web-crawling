class HomeController < ApplicationController

	skip_before_action :verify_authenticity_token

	def index;end

	def get_data
		require 'mechanize'
		require 'open-uri'
		if params[:url].present?
			default_host = params[:url]
			agent = Mechanize.new
			page = agent.get(default_host)
			SitemapGenerator::Sitemap.default_host = default_host
			SitemapGenerator::Sitemap.create do
				page.links.each do |link|
				  if link.href.present? && ((link.href.start_with? '/') || (link.href.start_with? SitemapGenerator::Sitemap.default_host))
				  	link_ref = link.href.split(SitemapGenerator::Sitemap.default_host).first
				  	if link_ref.present?
				  		add link_ref
				  	end
				  end
				end
			end
			redirect_to '/sitemap.xml.gz'
		end
	end
end
