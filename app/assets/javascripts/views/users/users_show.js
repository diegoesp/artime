CresponApp.Views.UsersShow = Backbone.View.extend ({

	template: JST["users/users_show"],

	events:
	{
	},

	model: null,

	initialize: function(hash)
	{
		if (hash.id !== null)
		{
			this.model = new CresponApp.Models.User({id: hash.id});
		}
	},

	render: function()
	{
		this.model.fetch({async: false});
		$(this.el).html(this.template({model: this.model}));
		if(CresponApp.session().id === this.model.id)
		{
			this.$("#user_actions").removeClass("hide");
		}
		return this;
	}

});