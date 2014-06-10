CresponApp.Views.HomeIntro = Backbone.View.extend ({

	template: JST["home/home_intro"],

	events:
	{
	},

	initialize: function()
	{
	},

	render: function()
	{	
		$(this.el).html(this.template());
		return this;
	}
		
});