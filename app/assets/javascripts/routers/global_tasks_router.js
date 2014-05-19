CresponApp.Routers.GlobalTasks = Backbone.Router.extend ({

	routes:
	{
		"global_tasks": "index"
	},

	index: function()
	{
		var view  = new CresponApp.Views.TasksIndex({ type: "GlobalTask" });
		$("#template").html(view.render().el);
	}

});