CresponApp.Views.ClientsIndex = Backbone.View.extend ({

 	template: JST["clients/clients_index"],
 	template_table: JST["clients/clients_index_table"],

	events:
	{
		"click .edit-link": "editEntry",
		"click .delete-link": "deleteEntry",
		"click #new": "newEntry"
	},

	collection: null,

	initialize: function()
	{
		this.collection = new CresponApp.Collections.Clients();
		this.listenTo(this.collection, "sync", this.refreshTable);
		this.listenTo(this.collection, "destroy", this.refreshTable);
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
		this.$("#clients_table").html(this.template_table({clients: this.collection}));
	},

	newEntry: function()
	{
		event.preventDefault();	
		view = new CresponApp.Views.ClientsEdit({ collection: this.collection});
		$("#modals").html(view.render().el);
		return this;
	},

	editEntry: function(event)
	{
		event.preventDefault();		
		var id = $(event.currentTarget).data("client-id");
		view = new CresponApp.Views.ClientsEdit( { id: id, collection: this.collection });
		$("#modals").html(view.render().el);
		return this;
	},

	deleteEntry: function(event)
	{
		var self = this;
		event.preventDefault();
		var id = $(event.currentTarget).data("client-id");
		bootbox.confirm("Are you sure ?", function(result) 
		{
		  if(result) self.collection.get(id).destroy();
		}); 
	}

});