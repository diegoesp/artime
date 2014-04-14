CresponApp.Views.InputsIndex = Backbone.View.extend ({

  	template: JST["inputs/inputs_index"],

	events:
	{
	},

	initialize: function()
	{

	},

	render: function()
	{
		$(this.el).html(this.template());

		var taskData = [
			{
				value: 30,
				color:"#F7464A"
			},
			{
				value : 50,
				color : "#E2EAE9"
			},
			{
				value : 100,
				color : "#D4CCC5"
			},
			{
				value : 40,
				color : "#949FB1"
			},
			{
				value : 120,
				color : "#4D5360"
			}
		];
		new Chart(this.$("#taskschart")[0].getContext("2d")).Doughnut(taskData);


		var billableData = [
			{value: 70, color:"#FF6B6B"},
			{value: 30, color : "#E2EAE9"}
		];
		new Chart(this.$("#billablechart")[0].getContext("2d")).Doughnut(billableData);

		return this;
	}
});