CresponApp.Routers.Tasks = Backbone.Router.extend ({

	routes:
	{
		"tasks": "index",
		"tasks/:id": "edit"
	},

	index: function()
	{
		var view  = new CresponApp.Views.TasksIndex();
		$("#template").html(view.render().el);
	},

	edit: function(id)
	{
		var view = new CresponApp.Views.TasksIndex();
		$("#template").html(view.render().el);	
		view.edit(id);
	}


});