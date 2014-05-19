CresponApp.Collections.Tasks = Backbone.Collection.extend({

	type: "RegularTask",

  url: function() 
  {
    return "/api/tasks?type=" + this.type;
  },

	comparator: "name",
	
  model: CresponApp.Models.Task,

	initialize: function(hash)
	{
		this.type = hash.type;
	}  
});