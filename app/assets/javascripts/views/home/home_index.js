CresponApp.Views.HomeIndex = Backbone.View.extend ({

  template: JST["home/home_index"],

	events:
	{

	},

	initialize: function()
	{

	},

	render: function()
	{
		$(this.el).html(this.template());
		for(var i=0; i<10; i++)
		{
			var doughnutData = [
					{
						value: 70,
						color:"#FF6B6B"
					},
					{
						value : 30,
						color : "#fdfdfd"
					}
				];
			var myDoughnut = new Chart(this.$("#serverstatus")[i].getContext("2d")).Doughnut(doughnutData);
		}
		return this;
	}
	
});