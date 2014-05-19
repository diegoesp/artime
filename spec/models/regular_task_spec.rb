# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  billable   :boolean          default(TRUE), not null
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)      default("RegularTask"), not null
#

require 'spec_helper'

describe RegularTask do
  before(:each) do
  	@regular_task = build(:regular_task)
  end

  it "should give me average estimated hours" do
    client = create(:client, company: @regular_task.company)
    project = create(:project, client: client)

    # Have to save so project task company and task company can be checked to be the same
    @regular_task.save!

    3.times do
      project_task = create(:project_task, project: project, task: @regular_task, hours_planned: 8)
    end

    @regular_task.average_planned_hours.should eq 8
  end

  it "should give me the last 5 projects this task was used and how it perform" do

    @regular_task.save!

    client = create(:client, company: @regular_task.company)    

    project_1 = create(:project, client: client)
    project_2 = create(:project, client: client)
    project_3 = create(:project, client: client)

    project_1.project_tasks << create(:project_task, project: project_1, task: @regular_task, hours_planned: 40)
    project_2.project_tasks << create(:project_task, project: project_2, task: @regular_task, hours_planned: 24)
    project_3.project_tasks << create(:project_task, project: project_3, task: @regular_task, hours_planned: 62)

    project_1.project_tasks.first.inputs << create(:input, project_task: project_1.project_tasks.first, hours: 10)
    project_2.project_tasks.first.inputs << create(:input, project_task: project_2.project_tasks.first, hours: 12)
    project_3.project_tasks.first.inputs << create(:input, project_task: project_3.project_tasks.first, hours: 14)
    project_3.project_tasks.first.inputs << create(:input, project_task: project_3.project_tasks.first, hours: 6)

    last_projects_report = @regular_task.last_projects_report
    last_projects_report.length.should eq 3
    last_projects_report.first.hours_planned.should eq 62
    last_projects_report.first.hours_spent.should eq 20
  end
end