CresponApp.Views.InputsEdit = Backbone.View.extend ({

	template: JST["inputs/inputs_edit"],

	events:
	{
		"change #projects": "projectsChange",
		"click #add": "add"
	},

	caller: null,

	// Expects a "caller" member that includes the following:
	//
	// 1: timesheet, containing all timesheet lines
	// 2: user_id, containing the user whose tasks must be searched
	// 3: updateTimesheet(), called when the timesheet needs updating
	initialize: function(hash)
	{
		this.caller = hash.caller;
	},

	render: function()
	{
		$(this.el).html(this.template());

		var user_id = this.caller.user_id;
		if (user_id === null) user_id = "";
		this.$("#projects").populateSelect("/api/timesheets/projects?user_id=" + user_id);
		this.$("#projects").chosen({ width: "100%" });
		// Force the projects combo to populate for the first time
		this.projectsChange();
		this.$("#inputsEditModal").modal("show");
		return this;
	},

	projectsChange: function(event)
	{
		var project_id = this.$("#projects").val();
		this.$("#tasks").empty();

		// Get the tasks that are assigned to this project
		var promise = $.ajax(
		{
			url: "/api/timesheets/tasks?project_id=" + project_id,
			type: "GET",
			dataType:'JSON',
			async: true
		}).promise();

		var self = this;

		promise.done(function(tasks)
		{
			// Get them into the combo
			var options = "";
			options += "<optgroup label='Tasks in the project'>";
			for (var i = 0; i < tasks.length; i++)
			{
				var task = tasks[i];
				var option = sprintf("<option value='%s'>%s</option>", task.id, task.name);
				options += option;
			}
			options += "</optgroup>";

			// Now get the tasks that are not assigned in the project...
			var promise = $.ajax(
			{
				url: "/api/timesheets/unassigned_tasks?project_id=" + project_id,
				type: "GET",
				dataType:'JSON',
				async: true
			}).promise();

			promise.done(function(unassigned_tasks)
			{
				// ... and fill the combo with them
				options += "<optgroup label='Tasks that are not in the project'>";
				for (var i = 0; i < unassigned_tasks.length; i++)
				{
					var unassigned_task = unassigned_tasks[i];
					var option = sprintf("<option style='color:#450000' value='%s'>%s</option>", "task-" + unassigned_task.id, unassigned_task.name);
					options += option;
				}
				options += "</optgroup>";

				// Redraw the combo
				self.$("#tasks").append(options);
				self.$("#tasks").chosen({ width: "100%" });
				self.$('#tasks').trigger('chosen:updated');
			});
		});
	},

	add: function(event)
	{
		event.preventDefault();
		var id = $("#tasks").val();

		var self = this;
		if (id.indexOf("task-") >= 0)
			this.addTask(id.replace("task-", ""));
		else
			this.addTimesheet(id);
	},

	addTask: function(taskId)
	{
		projectId = $("#projects").val();

		var text = "Are you sure that you want to add a new task to this project ?";

		var self = this;
		bootbox.confirm(text, function(result) 
		{
			if (result === false) return;

			var promise = $.ajax(
			{
				url: "api/timesheets",
				type: "POST",
				async: true,
				data: { project_id: projectId, task_id: taskId }
			}).promise();

			promise.done(function(timesheet) {
				self.returnTimesheet(self, timesheet)
			});

		});
	},

	addTimesheet: function(timesheetId)
	{
	  var promise = $.ajax(
		{
			url: "api/timesheets/" + timesheetId,
			type: "GET",
			async: true
		}).promise();

	  var self = this;
		promise.done(function(timesheet) {
			self.returnTimesheet(self, timesheet)
		});
	},

	// Returns the added timesheet to the modal caller
	returnTimesheet: function(self, timesheet)
	{
		self.caller.timesheet.push(timesheet);
		self.caller.updateTimesheet();
		self.$("#inputsEditModal").modal("hide");
	}
});