CresponApp.Models.User = Backbone.Model.extend({
	urlRoot: '/api/users',

	getRole: function(){
		switch(this.attributes.role_code) 
		{
			case 10: 
				return "Developer";
			case 20:
				return "Manager";
			case 30:
				return "Company";
			case 40:
				return "Administrator";
		}
		return this.attributes.role_code;
	}
});
