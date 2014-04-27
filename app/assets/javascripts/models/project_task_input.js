CresponApp.Models.ProjectTaskInput = Backbone.Model.extend({
	
	urlRoot: '/api/project_task_inputs',

	project_color: null,

  // Defines a color for this project
  color: function()
  {
  	var projectName = this.attributes.project_name;
  	// Extrapolate a color from the project name
  	var color = "#";
  	for (var i = 0; i < 7; i++) color += projectName.charCodeAt(i).toString()[0];

  	return color;
  }

});
