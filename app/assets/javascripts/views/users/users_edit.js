CresponApp.Views.UsersEdit = Backbone.View.extend ({

	template: JST["users/users_edit"],

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
		this.$('#userForm').populateForm(this.model);
		this.$("#role_code").chosen({width:'100%'});
		this.$("#userFormModal").modal("show");
		return this;
	},

	save: function()
	{
		event.preventDefault();
		var options = {wait: true, success: function() { $("#userFormModal").modal("hide"); }};
		var data = this.$("#userForm").serializeObject();
		if(this.model === null)
		{
			this.collection.create(data, options); 
		}
		else
		{
			this.model.save(data, options);
		}
	}
});