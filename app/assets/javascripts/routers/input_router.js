CresponApp.Routers.Inputs = Backbone.Router.extend ({

	routes:
	{
		"inputs": "index",
		"inputs/new": "new",
		"inputs/:id": "edit"
	},

	index: function()
	{
		var view  = new CresponApp.Views.InputsIndex();
		$("#template").html(view.render().el);
	},

	edit: function(id)
	{
		var view = new CresponApp.Views.InputEdit({id: id});
		$("#template").html(view.render().el);
	},

	new: function()
	{
		var view = new CresponApp.Views.InputEdit({id: null});
		$("#template").html(view.render().el);
	}

});