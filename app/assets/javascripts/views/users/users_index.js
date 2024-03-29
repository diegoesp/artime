CresponApp.Views.UsersIndex = Backbone.View.extend ({

 	template: JST["users/users_index"],
 	template_table: JST["users/users_index_table"],

	events:
	{
		"click .edit-link": "editEntry",
		"click #newUser": "newEntry"
	},

	collection: null,

	initialize: function()
	{
		this.collection = new CresponApp.Collections.Users();
		this.listenTo(this.collection, "sync", this.refreshTable);
		this.listenTo(this.collection, "destroy", this.refreshTable);
	},

	remove: function()
	{
    // custom cleanup or closing code, here

    // call the base class remove method 
    Backbone.View.prototype.remove.apply(this, arguments);
  },

	render: function()
	{
		$(this.el).html(this.template());
		this.collection.fetch({ async: true });
		return this;
	},

	// Draws the contents of the clients table
	refreshTable: function()
	{
		this.collection.sort();
		this.$("#users_table").html(this.template_table({collection: this.collection}));
	},

	editEntry: function(event)
	{
		event.preventDefault();		
		var id = $(event.currentTarget).data("model-id");
		view = new CresponApp.Views.UserManagerEdit( { id: id, collection: this.collection });
		$("#modals").html(view.render().el);
		return this;
	},

	newEntry: function(event)
	{
		view = new CresponApp.Views.UserManagerEdit( { id: null, collection: this.collection });
		$("#modals").html(view.render().el);
		return this;
	}

});