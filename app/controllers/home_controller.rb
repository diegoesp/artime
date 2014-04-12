class HomeController < ApplicationController

	def index 

		unless user_signed_in?
		  render :landing, layout: false
		end

	end
end
