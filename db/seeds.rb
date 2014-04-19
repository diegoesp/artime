# Seeds the Greenmine database with information so the project can be showcased
# It uses FactoryGirl because it is supposed to be used in development
include FactoryGirl::Syntax::Methods

########################################################
# Creates a project with some random data. Also needs
# a users array with available users to employ for
# entering inputs
########################################################
def create_project(name, description)

	project = create(
	:project,
	name: name,
	start_date: Date.today - rand(0..60),
	deadline: Date.today + rand(30..60), 
	description: description)
	# Tasks
	get_tasks.each do |task|
		create(:project_task, project: project, task: task, hours_planned: rand(10..120))
	end
	
	# Some inputs
	inputs_count = rand(20..40)
	inputs_count.times do
		project_task = project.project_tasks.all.sample
		user = User.all.sample
		input_date = Date.today - rand(1..20)
		hours = rand(1..24)

		create(:input, project_task: project_task, user: user , input_date: input_date, hours: hours)
	end
end

#########################################################################################
# Gets an array with a list of tasks. The number of tasks returned is random,
# between 10 and 18 
#########################################################################################
def get_tasks

	tasks = Task.all.shuffle

	returned_tasks = []
	rand(10..18).times do
		returned_tasks << tasks.pop
	end

	returned_tasks
end

#########################################################################################
# Seeding
#########################################################################################

company = create(:company)

# Users and their roles
create(:user, first_name: "Martin", last_name: "Dasnoy", email: "martindasnoy@gmail.com", company: company, role_code: Role::COMPANY)
create(:user, first_name: "Nicolas", last_name: "Rossi", email: "nrossi@gmail.com", company: company, role_code: Role::MANAGER)
create(:user, first_name: "Diego", last_name: "Espada", email: "diegoesp@gmail.com", company: company, role_code: Role::DEVELOPER)

# Tasks
task_names = [
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

task_names.each do |task_name|
	create(:task, company: company, name: task_name)
end

# Projects
create_project("Nike Running", "Advertising for the new Nike fast running shoes")
create_project("Mama Luchetti Stickers", "The new advertising campaign for Mama Luchetti")
create_project("La Luna", "New animated short produced for the Pixar studios")
create_project("Metegol", "New animated movie from Juan Jose Campanella and many stars from Argentinian cinema")
create_project("Tomb Raider", "Advertising campaign for the new Tomb Raider game")
create_project("Despicable Me 3", "The new animated film from Dreamworks. It has more minions, yay !")
create_project("The Guardian", "Advertising campaign for The Guardian UK newspaper")
create_project("MTV 2015", "Music Television new animated campaign for 2015")
create_project("Return to Monkey Island", "New game for LucasFilm / Disney studios")