CresponApp.Views.UserManagerEdit = Backbone.View.extend ({

	template: JST["users/user_manager_edit"],

	events:
	{
		"click #save": "save",
		"click #cancel": "cancel",
		"click #delete": "delete"
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
		var self = this;

		var data = this.$("#userForm").serializeObject();
		if(this.model === null)
		{
			this.collection.create(data, { success: function() {
				AlertMessage.show_success("User was created successfully. Default password is 'password' (without quotes). Ask the user to change it as soon as possible");
				self.hide();
			}});
		}
		else
		{
			this.model.save(data, { success: function() {
				self.hide();
			}});
		}
	},

	delete: function()
	{
		var self = this;

		this.model.destroy({ wait: true, success: function() {
			self.hide();
		}});
	},

	// Hide the modal
	hide: function()
	{
		$("#userFormModal").modal("hide");
	}
});