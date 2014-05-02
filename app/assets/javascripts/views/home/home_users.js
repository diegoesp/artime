CresponApp.Views.HomeUsers = Backbone.View.extend ({

	template: JST["home/home_users"],

	events:
	{
	},

	company: null,

	initialize: function(hash)
	{
		this.company = hash.company;
	},

	render: function()
	{
		$(this.el).html(this.template({ users_with_pending_input: this.company.attributes.users_with_pending_input }));
		return this;
	}
	
});