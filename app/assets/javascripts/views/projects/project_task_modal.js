CresponApp.Views.ProjectTaskModal = Backbone.View.extend ({

	project_task_modal_template: JST["projects/project_task_modal"],

	events:
	{
		"click #save": "save",
		"click #delete": "delete"
	},

	projectTasksCollection: null,
	projectTask: null,

	// Initializes the modal
	// Expects projectTask (the task to be created / updated) + a caller method
	// that must include a refreshProjectTasks method.
	initialize: function(hash)
	{
		if (hash.projectTasksCollection === undefined) throw new Error("project task collection must be specified");
		if (hash.id === undefined) throw new Error("id method must be specified");
		
		this.projectTasksCollection = hash.projectTasksCollection;
		
		this.projectTask = new CresponApp.Models.ProjectTask();
		this.projectTask.attributes.project_id = this.projectTasksCollection.projectId;

		var id = hash.id;
		if (id !== null) this.projectTask = this.projectTasksCollection.get(id);
	},

	render: function()
	{
		$(this.el).html(this.project_task_modal_template());
		this.$("#task_id").populateSelect("/api/tasks");
		this.$("#projectTaskForm").populateForm(this.projectTask);
		this.$("#task_id").chosen({width: "100%"});
		this.$("#projectTaskModal").modal("show");

		return this;
	},

	delete: function()
	{
		event.preventDefault();

		this.projectTask.destroy();

		AlertMessage.show_info("Task was removed successfully");

		this.hideModal();
	},

	hideModal: function()
	{
		$("#projectTaskModal").modal("hide");
		// Force to refresh any views looking this collection
		this.projectTasksCollection.fetch({ async: true });
	},

	save: function()
	{
		event.preventDefault();

		var self = this;
		var data = $("#projectTaskForm").serializeObject();

		this.projectTask.save(data, { wait: true, success: function() {
			AlertMessage.show_info("Task was saved successfully");
			self.hideModal();
		}});
	}
});