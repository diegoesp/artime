# Seeds the Greenmine database with information so the project can be showcased

########################################################
# Creates a project with some random data. Also needs
# a users array with available users to employ for
# entering inputs
########################################################
def create_project(name, description, users)

	project = FactoryGirl.create(
	:project,
	name: name,
	deadline: Date.today + rand(30..60), 
	description: description)
	# Tasks
	task_names = get_tasks
	tasks = []
	task_names.each do |task_name|	
		tasks << FactoryGirl.create(:task, project: project, name: task_name, hours_planned: rand(10..120))
	end
	
	# Some inputs
	inputs_count = rand(20..40)
	inputs_count.times do
		task = tasks[rand(0..(tasks.length - 1))]
		user = users[rand(0..(users.length - 1))]
		input_date = Date.today - rand(1..20)
		hours = rand(1..24)

		FactoryGirl.create(:input, task: task, user: user , input_date: input_date, hours: hours)
	end
end

#########################################################################################
# Gets an array with a list of task names. The number of tasks returned is random,
# between 10 and 18 
#########################################################################################
def get_tasks

	tasks = [
		"Storyboard",
		"Animatic",
		"Modeling",
		"Textures",
		"Materials & Shaders",
		"Illumination",
		"Render",
		"Composing",
		"Edition",
		"Design",
		"Matte",
		"Production",
		"Animation",
		"Rig",
		"Cameras",
		"Illustration",
		"Reactions",
		"Zbrush"
	]

	tasks = tasks.shuffle

	returned_tasks = []
	rand(10..18).times do
		returned_tasks << tasks.pop
	end

	returned_tasks
end

#########################################################################################
# Seeding
#########################################################################################

company = FactoryGirl.create(:company)

# Users and their roles
user_martin = FactoryGirl.create(:user, first_name: "Martin", last_name: "Dasnoy", email: "martindasnoy@gmail.com")
FactoryGirl.create(:role, company: company, user: user_martin, code: Role::COMPANY)
user_nicolas = FactoryGirl.create(:user, first_name: "Nicolas", last_name: "Rossi", email: "nrossi@gmail.com")
FactoryGirl.create(:role, company: company, user: user_nicolas, code: Role::MANAGER)
user_diego = FactoryGirl.create(:user, first_name: "Diego", last_name: "Espada", email: "diegoesp@gmail.com")
FactoryGirl.create(:role, company: company, user: user_diego, code: Role::DEVELOPER)

users = [user_martin, user_nicolas, user_diego]

# Projects
create_project("Nike Running", "Advertising for the new Nike fast running shoes", users)
create_project("Mama Luchetti Stickers", "The new advertising campaign for Mama Luchetti", users)
create_project("La Luna", "New animated short produced for the Pixar studios", users)
create_project("Metegol", "New animated movie from Juan Jose Campanella and many stars from Argentina cinema", users)
create_project("Tomb Raider", "Advertising campaign for the new Tomb Raider game", users)