CresponApp.Models.Project = Backbone.Model.extend({
	urlRoot: '/api/projects',

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
	}
});
