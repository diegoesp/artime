CresponApp.Views.TasksIndex = Backbone.View.extend ({

  	template: JST["tasks/tasks_index"],
  	template_detail: JST["tasks/task_detail"],

	events:
	{
		"click .task-link": "showInfo"
	},

	initialize: function()
	{

	},

	render: function()
	{
		$(this.el).html(this.template());
		return this;
	},

	edit: function(id)
	{

	},

	showInfo: function()
	{
		event.preventDefault();
		$(".task-link").removeClass("active");
		$(event.target).addClass("active");
		$("#task-detail").html(this.template_detail());
		$("#task-detail").find(".switch").bootstrapSwitch();

		var barChartData = {
        	labels : ["Nike2014","LucchetiTV","MagazineIO","Tecnopolis2104","Metegol"],
        	datasets : [
	            {
	                fillColor : "rgba(220,220,220,0.5)",
	                strokeColor : "rgba(220,220,220,1)",
	                data : [65,59,90,81,56]
	            },
	            {
	                fillColor : "rgba(151,187,205,0.5)",
	                strokeColor : "rgba(151,187,205,1)",
	                data : [28,48,40,19,96]
	            }
        	]
    	};
    	new Chart($("#bar")[0].getContext("2d")).Bar(barChartData, {scaleOverlay : true});
	}
});