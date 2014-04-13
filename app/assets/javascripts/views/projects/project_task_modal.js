CresponApp.Views.ProjectTaskModal = Backbone.View.extend ({

	template: JST["projects/project_task_modal"],

	events:
	{
		"click #save": "save",
		"click #delete": "delete",
		"click #cancel": "cancel"
	},

	initialize: function(hash)
	{
	},

	render: function()
	{
		$(this.el).html(this.template());
		//this.$("#task_id").selectCollection(new CresponApp.Collections.Apartments());
		this.$("#task_id").chosen({width: "100%"});
		//this.$('#roleForm').populateForm(this.model);
		this.$("#projectTaskModal").modal("show");
		return this;
	},

	save: function()
	{
		event.preventDefault();
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
	}
});