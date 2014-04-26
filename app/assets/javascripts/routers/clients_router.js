CresponApp.Routers.Clients = Backbone.Router.extend ({

	routes:
	{
		"clients": "index"
	},

	index: function()
	{
		var view  = new CresponApp.Views.ClientsIndex();
		$("#template").html(view.render().el);
	}

});