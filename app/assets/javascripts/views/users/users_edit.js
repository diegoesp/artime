CresponApp.Views.UsersEdit = Backbone.View.extend ({

	templates: 
	{
		core:         JST["users/users_edit"],
		profile:      JST["users/users_edit_profile"],
		avatar:       JST["users/users_edit_avatar"],
		config: 	  JST["users/users_edit_config"]
	},

	events:
	{
		"click #browseAvatar": "browseAvatar",
		"click #removeAvatar": "removeAvatar",
		"click #user-tabs li": "renderAction",
		"click #saveUser": "saveUser",
		"click #saveConfig": "saveUser"
	},

	action: null,
	model: null,

	initialize: function(hash)
	{
		this.action = hash.action;	
		if (hash.id !== null)
		{
			this.model = new CresponApp.Models.User({id: hash.id});
		}
	},

	render: function()
	{
		self = this;
		this.model.fetch({async: false});
		$(this.el).html(this.templates["core"]({model: this.model}));
		this.$("#authenticity_token").val($("meta[name=csrf-token]").attr('content'));
		this.$('a[data-target="' + this.action + '"]', this.el).tab("show");
		this.renderAction();
		return this;
	},

	renderAction: function(e)
	{
		self = this;
		if(e) this.action = e.target.dataset.target;
		this.$("#action-div").html(this.templates[this.action]({model: this.model}));
		this.$('#profileForm').populateForm(this.model);
		this.$('#avatar').fileupload({
			dataType: 'json',
			done: function (e, data) {
				self.model.set(data.result);
				AlertMessage.show_success("Avatar cambiado con éxito");
				self.reloadAvatar();
			},
		});
		this.$('input[type=checkbox]').bootstrapSwitch();
	},

	browseAvatar: function(){
		$('#avatar').trigger('click');
	},

	reloadAvatar: function(){
		$("#avatar-preview").attr("src", this.model.attributes.avatar);
		$("#user-avatar").attr("src", this.model.attributes.avatar);
	},

	removeAvatar: function(){
		self = this;
		avatar = new CresponApp.Models.UserAvatar({id: this.model.attributes.id});
		avatar.destroy(
		{
			wait:true,
			success: function(model, response)
			{
				self.model.set(response);
				AlertMessage.show_success("Avatar removido con éxito");
				self.reloadAvatar(); 
			}
		});
	},

	saveUser: function()
	{
		this.model.save( $('#profileForm').serializeObject(),
		{
		  wait: true,
		  success: function()
		  {
			AlertMessage.show_success("Usuario actualizado con éxito");
			Backbone.history.navigate("users/me", true);
		  }
		});	
	}

});