CresponApp.Collections.ProjectTaskInputs = Backbone.Collection.extend({
  
  url: "/api/project_task_inputs",

  model: CresponApp.Models.ProjectTaskInput
});