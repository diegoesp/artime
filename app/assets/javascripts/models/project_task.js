CresponApp.Models.ProjectTask = Backbone.Model.extend({
	
	projectId: null,
  id: null,

  url: function() 
  {
  	if (this.projectId === null) throw new Error("Must set projectId property first");
  	
  	var id = this.id;
  	if (id === null) id = "";
    return "/api/projects/" + this.projectId + "/project_tasks/" + id;
  },

  initialize: function(hash)
  {
  	if (hash.projectId !== undefined) this.projectId = hash.projectId;
    if (hash.id !== undefined) this.id = hash.id;
  },

	// If hours_spent_percentage is superior to 100, returns 100
	// If not, returns the same as hours_spent_percentage
	hours_spent_percentage_top_100: function()
	{
		var hours_spent_percentage = this.hours_spent_percentage();
		if (hours_spent_percentage > 100) hours_spent_percentage = 100;
		return hours_spent_percentage;
	},

	hours_spent_percentage: function()
	{
		return Math.round(this.attributes.hours_spent_percentage * 100);
	}
});
