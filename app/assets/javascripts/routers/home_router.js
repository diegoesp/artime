CresponApp.Routers.Home = Backbone.Router.extend ({

	routes:
	{
		"home": "index"
	},

	index: function()
	{
		var view = null;
		if(CresponApp.session().manager)
		{
			view  = new CresponApp.Views.HomeIndex();
		}
		else
		{
			view = new CresponApp.Views.InputsIndex();
		}
		$("#template").html(view.render().el);
	}

});