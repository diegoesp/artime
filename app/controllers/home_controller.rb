class HomeController < ApplicationController

	def index 

		unless user_signed_in?
		  render :landing, layout: "devise"
		end

	end
end
