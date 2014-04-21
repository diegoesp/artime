CresponApp.Models.Project = Backbone.Model.extend({
	
	url: function()
	{
		var id = this.id;
		if (id === undefined || id === null) id = "";

		return "/api/projects/" + id;
	},

	weeks_left: function()
	{
		var weeks_left = this.attributes.weeks_left;
		if (weeks_left > 0)
		{
			return sprintf("%s weeks of %s left", weeks_left, this.attributes.total_weeks);
		}
		
		if (weeks_left == 0)
		{
			"Delivery is this week !";
		}

		if (weeks_left == 1)
		{
			return "Overrun by 1 week";
		}

		return sprintf("Overrun by %s weeks", weeks_left)
	},

	weeks_spent_percentage: function()
	{
		return Math.round(this.attributes.weeks_spent_percentage * 100);
	},

	hours_spent_percentage: function()
	{
		return Math.round(this.attributes.hours_spent_percentage * 100);
	},

	hours_spent_percentage_string: function()
	{
		return this.hours_spent_percentage() + " %";
	},

	// Returns the status display
	completed: function()
	{
		if (this.attributes.completed) return "Closed";
		return "Open";
	},

	// Returns the name of the CSS label to be used for this project
	// depending on his state
	label: function()
	{
		if (this.attributes.completed) return "label-success";
		return "label-danger";
	}
});
