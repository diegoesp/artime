class RegistrationsController < Devise::RegistrationsController
 
  def new
  	@plans = Plan.where(active:true)
    build_resource({})
    self.resource.company = Company.new
    respond_with self.resource
  end
  
  def create
  	@plans = Plan.where(active:true)
    super
  end

end