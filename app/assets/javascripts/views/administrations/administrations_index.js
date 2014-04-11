CresponApp.Views.AdministrationsIndex = Backbone.View.extend ({

  template: JST["administrations/administrations_index"],

	events:
	{
		"click #search": "searchEntry",
		"click #new": "newEntry",
		"click .show-button": "showEntry",
		"click .destroy-button": "destroyEntry"
	},

	table: null,

	initialize: function()
	{
		this.administrationsCollection = new CresponApp.Collections.Administrations();
		this.administrationsCollection.fetch({ async: false });

		this.listenTo(this.administrationsCollection, "sync", this.renderTable);
		this.listenTo(this.administrationsCollection, "destroy", this.renderTable);
	},

	render: function()
	{
		$(this.el).html(this.template({ administrationsCollection: this.administrationsCollection }));
		this.renderTable();

		return this;
	},

	renderTable: function()
	{
		var view = new CresponApp.Views.AdministrationsTable( { administrationsCollection: this.administrationsCollection });
		this.$("#table").html(view.render().el);

		return this;
	},

	searchEntry: function()
	{
		var name = $("#searchText").prop("value");

		this.administrationsCollection.fetch
		({
			data: { name: name }
		});
	},

	newEntry: function()
	{
		Backbone.history.navigate("administrations/new", true);
	}
	
});