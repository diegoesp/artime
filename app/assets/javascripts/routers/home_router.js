CresponApp.Routers.Home = Backbone.Router.extend ({

	routes:
	{
		"": "index"
	},

	index: function()
	{
		var view  = new CresponApp.Views.HomeIndex();
		$("#template").html(view.render().el);
	}

});