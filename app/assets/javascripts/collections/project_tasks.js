CresponApp.Collections.ProjectTasks = Backbone.Collection.extend({

  projectId: null,
  
  url: function() 
  {
  	if (this.projectId === null) throw new Error("Must set projectId property first");
    return "/api/projects/" + this.projectId + "/project_tasks"
  },

	comparator: "name",
	
  model: CresponApp.Models.ProjectTask,

  initialize: function(hash)
  {
  	if (hash.projectId !== undefined) this.projectId = hash.projectId;
  }
});