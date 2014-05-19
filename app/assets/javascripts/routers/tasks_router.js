CresponApp.Routers.Tasks = Backbone.Router.extend ({

	routes:
	{
		"tasks": "index"
	},

	index: function()
	{
		var view  = new CresponApp.Views.TasksIndex({ type: "RegularTask"});
		$("#template").html(view.render().el);
	}

});