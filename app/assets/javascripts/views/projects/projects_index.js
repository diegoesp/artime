CresponApp.Views.ProjectsIndex = Backbone.View.extend ({

 	project_index_template: JST["projects/projects_index"],
 	project_index_table_row_template: JST["projects/projects_index_table_row"],

	events:
	{
		"click #new": "new",
		"click .project-link": "edit",
		"change #clients_select": "refreshProjectsCollection",
		"keyup #project_name": "refreshProjectsCollection"
	},

	// Caches the project collection
	projectsCollection: null,

	initialize: function()
	{
		this.projectsCollection = new CresponApp.Collections.Projects();
		this.listenTo(this.projectsCollection, "sync", this.refreshTable);
		this.listenTo(this.projectsCollection, "destroy", this.refreshTable);
	},

	render: function()
	{
		$(this.el).html(this.project_index_template());
		
		this.$("#customer").chosen({width: "100%"});
		this.$('.date-picker').datepicker({ 
			format: 'mm-dd-yyyy',
			autoclose: true,
    		todayHighlight: true
        });

		// Populate client select
		this.$("#clients_select").populateSelect("/api/clients");

		// Populate projects table
		this.projectsCollection.fetch({ async: true });

		return this;
	},

	// Refreshes the projects collection using the parameters entered in the
	// GUI filters
	refreshProjectsCollection: function()
	{
		var project_name = this.$("#project_name").val();
		if (project_name.length < 3) project_name = null;

		this.projectsCollection.fetch({
			data: 
			{
				client: this.$("#clients_select").val(),
				name: project_name
			},
			async: true 
		});
	},

	// Draws the contents of the projects table
	refreshTable: function(projectsCollection)
	{
		projectsCollection.sort();

		var tableBody = this.$("#projects_tbody");
		tableBody.html("");

		for(var i = 0; i < projectsCollection.length; i++)
		{
			var rowHTML = this.project_index_table_row_template({ project: projectsCollection.models[i] });
			tableBody.append(rowHTML);
		}
	},

	new: function(event)
	{
		event.preventDefault();
		Backbone.history.navigate("projects/new", true);
	},

	edit: function(event)
	{
		event.preventDefault();
		var id = $(event.currentTarget).data("project-id");
		Backbone.history.navigate("projects/" + id, true);
	}
	
});