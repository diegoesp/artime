CresponApp.Views.HomeUsers = Backbone.View.extend ({

	template: JST["home/home_users"],

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