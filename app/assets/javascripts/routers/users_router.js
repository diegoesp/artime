CresponApp.Routers.Users = Backbone.Router.extend ({

	routes:
	{
		"users": "index"
	},

	index: function()
	{
		var view  = new CresponApp.Views.UsersIndex();
		$("#template").html(view.render().el);
	}

});