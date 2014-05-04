CresponApp.Views.TasksIndex = Backbone.View.extend ({

  template: JST["tasks/tasks_index"],
  template_detail: JST["tasks/task_detail"],

	events:
	{
		"click .task-link": "show",
		"click #newTask": "newTask",
		"click #saveTask": "saveTask",
		"click #deleteTask": "deleteTask"
	},

	tasksCollection: null,

	initialize: function()
	{
		this.tasksCollection = new CresponApp.Collections.Tasks();
	},

	render: function()
	{		
		this.refreshTasks();
		this.clickFirstTask();
		
		return this;
	},

	clickFirstTask: function()
	{
		// Click on the first task by default
		var links = this.$(".task-link");
		if (links.length > 0)
		{
			this.$(links[0]).click();
		}
	},

	refreshTasks: function() 
	{
		this.tasksCollection.fetch({ async: false });
		$(this.el).html(this.template( { tasksCollection: this.tasksCollection }));
	},

	show: function(event)
	{
		event.preventDefault();

		var taskId = $(event.currentTarget).data("task-id");
		var task = this.tasksCollection.get(taskId);

		this.$(".task-link").removeClass("active");
		this.$(event.target).addClass("active");
		this.$("#task_detail").html(this.template_detail({ task: task }));
		this.$("#task_detail").find(".switch").bootstrapSwitch();

		var promise = $.ajax(
		{
			url: "/api/tasks/last_projects_report",
			type: "GET",
			dataType:'JSON',
			async: true,
			data: { id: taskId }
		}).promise();

		var self = this;

		promise.done(function (lastProjectsReport)
		{
			labels = [];
			dataPlanned = [];
			dataSpent = [];

			for (var i = 0; i < lastProjectsReport.length; i++)
			{
				var row = lastProjectsReport[i];
				labels.push(row.project_name);
				dataPlanned.push(row.hours_planned);
				dataSpent.push(row.hours_spent);
			}

			var barChartData = 
			{
	    	labels: labels,
	    	// First one is estimated hours, the second one are actuals
	    	datasets : 
	    	[
	        {
	          fillColor : "rgba(220,220,220,0.5)",
	          strokeColor : "rgba(220,220,220,1)",
	          data : dataPlanned
	        },
	        {
	          fillColor : "rgba(151,187,205,0.5)",
	          strokeColor : "rgba(151,187,205,1)",
	          data : dataSpent
	        }
	    	]
	  	};

    	new Chart(self.$("#bar")[0].getContext("2d")).Bar(barChartData, {scaleOverlay : true});
		});

		this.$("#name").focus();
	},

	newTask: function(event)
	{
		event.preventDefault();

		this.$(".task-link").removeClass("active");
		this.$("#task_detail").html(this.template_detail({ task: new CresponApp.Models.Task() }));
		this.$("#task_detail").find(".switch").bootstrapSwitch();
		this.$("#name").focus();
	},

	saveTask: function(event)
	{
		event.preventDefault();

		var taskId = $(event.currentTarget).data("task-id");
		
		var task = new CresponApp.Models.Task();
		if (taskId !== "") task = this.tasksCollection.get(taskId);

		var data = $("#task_form").serializeObject();

		var self = this;
		task.save(data, { wait: true, success: function(task)
		{
			AlertMessage.show_success("Task was saved successfully");
			self.refreshTasks();

			var selector = sprintf(".task-link[data-task-id='%s']", task.id);
			self.$(selector).click();
		}});
	},

	deleteTask: function(event)
	{
		event.preventDefault();

		var taskId = $(event.currentTarget).data("task-id");
		this.tasksCollection.get(taskId).destroy();
		this.refreshTasks();
		this.clickFirstTask();
		AlertMessage.show_success("Task was deleted successfully");
	}
});