CresponApp.Views.HomeInputs = Backbone.View.extend ({

	template: JST["home/home_inputs"],

	events:
	{
	},

	company: null,

	initialize: function(hash)
	{
		this.company = hash.company;
	},

	render: function()
	{
		var input_completed_percentage = Math.round(this.company.attributes.input_completed_percentage * 100);
		var inputData = 
		[
			{
				value: input_completed_percentage,
				color:"#FF6B6B"
			},
			{
				value: 100 - input_completed_percentage,
				color: "#fdfdfd"
			}
		];
		$(this.el).html(this.template());
		var inputChart = new Chart(this.$("#inputchart")[0].getContext("2d")).Doughnut(inputData, {animation: false});	

		this.$(".pending-input-chart-indicator").text(input_completed_percentage + "%");

		return this;
	}
});