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

		this.listenTo(this.project, "sync", this.refreshProject);
		this.listenTo(this.project, "destroy", this.refreshProject);

		this.listenTo(this.projectTasksCollection, "sync", this.refreshProjectTasks);
		this.listenTo(this.projectTasksCollection, "destroy", this.refreshProjectTasks);
	},

	render: function()
	{
		$(this.el).html(this.template_project_edit());
		this.$("[data-toggle='switch']").bootstrapSwitch();

		this.$('.date-picker').datepicker({ 
			format: 'yyyy-mm-dd',
			autoclose: true,
    	todayHighlight: true
    });

		this.$("#client_id").populateSelect("/api/clients");

		this.$("#users").populateSelect("/api/users");

		this.$("#users").chosen({
			placeholder_text_multiple: "Select one or more members...",
			width: "100%"}
		);

		// Fill tasks empty (since this is a new project)
		this.$("#tasks").html(this.template_project_task_list({ projectTasksCollection: [] }));

		// It it is an update, fill the necessary info
		if (this.project.id !== null)
		{			
			this.project.fetch({ async: true })
			this.projectTasksCollection.fetch({ async: true })
		}

		return this;
	},

	refreshProject: function()
	{
		this.$("#project_form").populateForm(this.project);
	},

	refreshProjectTasks: function()
	{
		this.$("#tasks").html(this.template_project_task_list({ projectTasksCollection: this.projectTasksCollection }));
	},

	newTask: function(event)
	{
		event.preventDefault();

		if (this.project.id === null)
		{
			AlertMessage.show_warning("Please save the project before adding new tasks");
			return;
		}

		var view = new CresponApp.Views.ProjectTaskModal({ projectTasksCollection: this.projectTasksCollection, id: null });
		$("#modals").html(view.render().el);

		return this;
	},

	showTask: function(event)
	{
		event.preventDefault();
		var taskId = $(event.currentTarget).data("task-id");

		var view = new CresponApp.Views.ProjectTaskModal({ projectTasksCollection: this.projectTasksCollection, id: taskId });
		$("#modals").html(view.render().el);

		return this;
	},

	saveButton: function()
	{
		var data = $("#project_form").serializeObject();

		var self = this;

		this.project.save(data, { wait: true, success: function(project) {
			AlertMessage.show_info("Project was saved successfully");
			self.projectTasksCollection.projectId = project.id;
		}});
	},

	cancelButton: function()
	{
		Backbone.history.navigate("/projects", true);
	}
});