CresponApp.Views.ProjectEdit = Backbone.View.extend ({

 	template_project_edit: JST["projects/project_edit"],
 	template_project_task_list: JST["projects/project_task_list"],

	events:
	{
		"click #newTask": "newTask",
		"click .task-name": "showTask",
		"click #saveButton": "saveButton",
		"click #cancelButton": "cancelButton"
	},

	project: null,
	projectTasksCollection: null,

	initialize: function(hash)
	{
		this.project = new CresponApp.Models.Project({ id: hash.id });
		this.projectTasksCollection = new CresponApp.Collections.ProjectTasks({ projectId: hash.id });

		if (hash.id !== undefined)
		{
			// It's an update, fill the necessary info
			this.project.fetch({ async: false })
			this.projectTasksCollection.fetch({ async: false })
		}
	},

	render: function()
	{
		$(this.el).html(this.template_project_edit());
		this.$("[data-toggle='switch']").bootstrapSwitch();
		this.$("#member_ids").chosen({
			placeholder_text_multiple: "Select one or more members...",
			width: "100%"}
		);
		this.$('.date-picker').datepicker({ 
			format: 'yyyy-mm-dd',
			autoclose: true,
    	todayHighlight: true
    });

		this.$("#client_id").populateSelect("/api/clients");

		// If it is an update I have to fill the form with the project info
		if (this.project.id !== null)
		{
			this.$("#project_form").populateForm(this.project);
			this.$("#tasks").html(this.template_project_task_list({ projectTasksCollection: this.projectTasksCollection }));
		}
		else
		{
			// Fill tasks empty (since this is a new project)
			this.$("#tasks").html(this.template_project_task_list({ tasks: [] }));
		}
		return this;
	},

	newTask: function(event)
	{
		event.preventDefault();

		if (this.project.id === null)
		{
			AlertMessage.show_warning("Plase save the project before adding new tasks");
			return;
		}

		var projectTask = new CresponApp.Models.ProjectTask();

		var view = new CresponApp.Views.ProjectTaskModal({ projectTask: projectTask });
		$("#modals").html(view.render().el);

		return this;
	},

	showTask: function(event)
	{
		event.preventDefault();
		var taskId = $(event.currentTarget).data("task-id");

		var projectTask = this.projectTasksCollection.models[i];

		var view = new CresponApp.Views.ProjectTaskModal({ projectTask: projectTask });
		$("#modals").html(view.render().el);

		return this;
	},

	saveButton: function()
	{
		var data = $("#project_form").serializeObject();

		this.project.save(data, { wait: true, success: function() {
			AlertMessage.show_info("Project was saved successfully");
		}});
	},

	cancelButton: function()
	{
		Backbone.history.navigate("/projects", true);
	}
});