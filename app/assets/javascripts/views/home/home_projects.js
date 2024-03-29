CresponApp.Views.HomeProjects = Backbone.View.extend ({

	template: JST["home/home_projects"],

	events:
	{
		"click li": "editProject",
		"click #new": "newProject"
	},

	projectsCollection: null,

	// Receives an already filled projects collection
	initialize: function(hash)
	{
		this.projectsCollection = hash.projectsCollection;
	},

	render: function()
	{	
		var projectsCollection = this.projectsCollection;

		$(this.el).html(this.template({ projectsCollection: projectsCollection }));

		for(var i = 0; i < projectsCollection.length; i++)
		{
			var project = projectsCollection.models[i];

			var hours_left_percentage	= 0;
			if (project.hours_spent_percentage() < 100)
			{
				var hours_left_percentage = (100 - project.hours_spent_percentage());
			}

			var selector = sprintf("[name='progress_bar'][data-project-id='%s']", project.id);
			this.$(selector).css("width", project.weeks_spent_percentage() + "%").attr('aria-valuenow', project.weeks_spent_percentage());

			// The donut graph
			var doughnutData = 
			[
				{
					value: project.hours_spent_percentage(),
					color:"#FF6B6B"
				},
				{
					value: hours_left_percentage,
					color: "#fdfdfd"
				}
			];

			var doughnut = new Chart(this.$("[name='project_status']")[i].getContext("2d")).Doughnut(doughnutData, {animation: false});
		}

		return this;
	},

	editProject: function(event)
	{
		var projectId = $(event.currentTarget).data("project-id");
		Backbone.history.navigate("projects/" + projectId, true);
	},

	newProject: function()
	{
		Backbone.history.navigate("projects/new", true);
	}
	
});