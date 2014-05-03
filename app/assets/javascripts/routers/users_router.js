CresponApp.Routers.Users = Backbone.Router.extend ({

	routes:
	{
		"users": "index",
		"users/:id": "showEntry",
		"users/:id/edit": "editProfile",
		"users/:id/edit/:action": "editEntry"
	},

	initialize: function()
	{
		
	},

	index: function()
	{
		var view  = new CresponApp.Views.UsersIndex();
		$("#template").html(view.render().el);
	},

	showEntry: function(id)
	{
		var view  = new CresponApp.Views.UsersShow({ id: id });
		$("#template").html(view.render().el);
	},

	editProfile: function(id)
	{
		this.editEntry(id, "profile");
	},

	editEntry: function(id, action)
	{
		var view  = new CresponApp.Views.UsersEdit({ id: id, action: action });
		$("#template").html(view.render().el);
	}

});