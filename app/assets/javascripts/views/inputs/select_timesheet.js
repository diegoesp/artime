CresponApp.Views.SelectTimesheet = Backbone.View.extend ({

	template: JST["inputs/select_timesheet"],

	events:
	{
		"click #ok": "ok"
	},

	caller: null,

	// Expects a "caller" member that includes the following:
	//
	// 1: timesheet, containing all timesheet lines
	// 2: render, called when the timesheet needs updating
	initialize: function(hash)
	{
		this.caller = hash.caller;
	},

	render: function()
	{
		$(this.el).html(this.template());
		this.$("#users").populateSelect("/api/users")
		this.$("#users").chosen({ width: "100%" });
		this.$("#selectTimesheetModal").modal("show");
		return this;
	},

	ok: function()
	{
		event.preventDefault();
		this.caller.user_id = $("#users").val();
		this.caller.render();
		$("#selectTimesheetModal").modal("hide");
	}
});