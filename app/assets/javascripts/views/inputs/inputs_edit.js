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
		this.$("#tasks").populateSelect("/api/timesheets/tasks?project_id=" + project_id);
		this.$("#tasks").chosen({ width: "100%" });
		this.$('#tasks').trigger('chosen:updated');
	},

	add: function(event)
	{
		event.preventDefault();
		var id = $("#tasks").val();

		var self = this;

		$.ajax(
		{
			url: "api/timesheets/" + id,
			type: "GET",
			async: true,
			success: function(input)
			{
				self.caller.timesheet.push(input);
				self.caller.updateTimesheet();
				$("#inputsEditModal").modal("hide");
			}
		});
	}
});