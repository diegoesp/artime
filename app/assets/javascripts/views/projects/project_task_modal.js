CresponApp.Views.ProjectTaskModal = Backbone.View.extend ({

	project_task_modal_template: JST["projects/project_task_modal"],

	events:
	{
		"click #save": "save",
		"click #delete": "delete"
	},

	projectTask: null,

	initialize: function(hash)
	{
		if (hash.projectTask === undefined) throw new Error("project task must be specified");

		this.projectTask = hash.projectTask;
	},

	render: function()
	{
		$(this.el).html(this.project_task_modal_template());
		this.$("#task_id").populateSelect("/api/tasks");
		this.$("#task_id").chosen({width: "100%"});
		this.$("#projectTaskModal").modal("show");

		this.$("#projectTaskForm").populateForm(this.projectTask);
		return this;
	},

	delete: function()
	{
		event.preventDefault();

		this.project.destroy();

		AlertMessage.show_info("Task was removed successfully");

		$("#projectTaskModal").modal("hide");
	},

	save: function()
	{
		event.preventDefault();

		var data = $("#projectTaskForm").serializeObject();

		this.projectTask.save(data, { wait: true, success: function() {
			AlertMessage.show_info("Task was saved successfully");
			$("#projectTaskModal").modal("hide");
		}});

		/*
		if(this.model === null)
		{
			this.collection.create(this.$("#roleForm").serializeObject(), {
				wait: true,
				success: function()
				{
					$("#roleFormModal").modal("hide");
				}
			}); 
		}
		else
		{
			this.model.save(this.$("#roleForm").serializeObject(), {
				wait: true,
				success: function()
				{
					$("#roleFormModal").modal("hide");
				}
			}); 
		}
		*/
	}
});