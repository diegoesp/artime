CresponApp.Collections.Projects = Backbone.Collection.extend({

	url: "/api/projects",

	comparator: "name",
	
  model: CresponApp.Models.Project

});
