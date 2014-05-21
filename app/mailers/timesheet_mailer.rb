class TimesheetMailer < ActionMailer::Base
  default from: "info@artimeapp.com"

  def mail_task_added(project_task, adder_user, manager_user)
    @project_task = project_task
    @adder_user = adder_user
    @manager_user = manager_user
    
    mail to: manager_user.email, subject: "News from artimeapp.com"
  end

end