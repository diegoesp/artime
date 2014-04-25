CresponApp.Collections.Tasks = Backbone.Collection.extend({
  
  url: function() 
  {
    return "/api/tasks"
  },

	comparator: "name",
	
  model: CresponApp.Models.Task
  
});