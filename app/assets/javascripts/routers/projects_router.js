CresponApp.Routers.Projects = Backbone.Router.extend ({

	routes:
	{
		"projects/index": "index",
		"projects/new": "create",
		"projects/:id": "edit"
	},

	index: function()
	{
		var view  = new CresponApp.Views.HomeIndex();
		$("#template").html(view.render().el);
	},

	create: function()
	{
		var view = new CresponApp.Views.ProjectEdit({id:null});
		$("#template").html(view.render().el);	
	},

	edit: function(id)
	{
		var view = new CresponApp.Views.ProjectEdit({id:id});
		$("#template").html(view.render().el);	
	}


});