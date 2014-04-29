CresponApp.Views.HomeInputs = Backbone.View.extend ({

	template: JST["home/home_inputs"],

	events:
	{
	},

	initialize: function()
	{
	},

	render: function()
	{
		var inputData = 
		[
			{
				value: 70,
				color:"#FF6B6B"
			},
			{
				value: 30,
				color: "#fdfdfd"
			}
		];
		$(this.el).html(this.template());
		var inputChart = new Chart(this.$("#inputchart")[0].getContext("2d")).Doughnut(inputData, {animation: false});	
		return this;
	}
	
});