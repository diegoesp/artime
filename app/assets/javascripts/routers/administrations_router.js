CresponApp.Routers.Administrations = Backbone.Router.extend ({

	routes:
	{
		"administrations/index": "index",
		"administrations/new": "newEntry",
		"administrations/:id": "showEntry"
	},

	index: function()
	{
		var view  = new CresponApp.Views.AdministrationsIndex();
		$("#template").html(view.render().el);
	},

	newEntry: function()
	{
		var view = new CresponApp.Views.AdministrationsShow({ id: null });
		$("#template").html(view.render().el);
	},

	showEntry: function(id)
	{
		var view  = new CresponApp.Views.AdministrationsShow({ id: id });
		$("#template").html(view.render().el);
	}

});