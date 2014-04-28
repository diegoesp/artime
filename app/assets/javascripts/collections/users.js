CresponApp.Collections.Users = Backbone.Collection.extend({

	url: "/api/users",

	comparator: "name",

  	model: CresponApp.Models.User

});
