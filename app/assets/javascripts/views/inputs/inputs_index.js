CresponApp.Views.InputsIndex = Backbone.View.extend ({

  	template: JST["inputs/inputs_index"],

	events:
	{
	},

	projectTaskInputsCollection: null,

	current_moment: null,

	initialize: function()
	{
		this.projectTaskInputsCollection = new CresponApp.Collections.ProjectTaskInputs();

		// Last sunday as first day
		this.current_moment = moment().subtract("day", moment().day);
	},

	render: function()
	{
		var self = this;

		var date_from = this.current_moment.format("YYYY-MM-DD");

		this.projectTaskInputsCollection.fetch({ data: { date_from: date_from }, async: true, success: function(projectTaskInputsCollection)
		{
			$(self.el).html(self.template({ current_moment: self.current_moment, projectTaskInputsCollection: self.projectTaskInputsCollection} ));

			var billableData = [
				{value: 70, color:"#FF6B6B"},
				{value: 30, color : "#E2EAE9"}
			];
			new Chart(this.$("#billablechart")[0].getContext("2d")).Doughnut(billableData);
		}});

		return this;
	}
});