CresponApp.Views.ClientsEdit = Backbone.View.extend ({

	template: JST["clients/clients_edit"],

	events:
	{
		"click #save": "save",
		"click #cancel": "cancel"
	},

	model: null,

	initialize: function(hash)
	{
		if(_.isNumber(hash.id))
		{
			this.model = this.collection.get(hash.id);
		}
	},

	render: function()
	{
		$(this.el).html(this.template());
		this.$('#clientForm').populateForm(this.model);
		this.$("#clientFormModal").modal("show");
		return this;
	},

	save: function()
	{
		event.preventDefault();
		var options = {wait: true, success: function() { $("#clientFormModal").modal("hide"); }};
		if(this.model === null)
		{
			this.collection.create(this.$("#clientForm").serializeObject(), options); 
		}
		else
		{
			this.model.save(this.$("#clientForm").serializeObject(), options);
		}
	}
});