CresponApp.Views.InputsEdit = Backbone.View.extend ({

	template: JST["inputs/inputs_edit"],

	events:
	{
		"click #add": "add",
		"click #cancel": "cancel"
	},

	caller: null,

	// Expects a "caller" member that includes the following:
	//
	// 1: timesheet, containing all timesheet lines
	// 2: updateTimesheet(), called when the timesheet needs updating
	initialize: function(hash)
	{
		this.caller = hash.caller;
	},

	render: function()
	{
		$(this.el).html(this.template());
		this.$("#tasks").populateSelect("/api/timesheets/tasks")
		this.$("#tasks").chosen({ width: "100%" });
		this.$("#inputsEditModal").modal("show");
		return this;
	},

	add: function()
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