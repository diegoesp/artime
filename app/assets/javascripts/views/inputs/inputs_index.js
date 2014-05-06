CresponApp.Views.InputsIndex = Backbone.View.extend ({

 	template: JST["inputs/inputs_index"],

	events:
	{
		"blur .input-hours": "updateTotals",
		"click #previous_week": "previousWeekClick",
		"click #this_week": "thisWeekClick",
		"click #next_week": "nextWeekClick",
		"click #save_timesheet": "saveTimesheetClick",
		"click #add_task": "addTaskClick",
		"click #pick_user": "pickUserClick"
	},

	// The timesheet being shown right now
	timesheet: null,

	// The date that is being shown right now
	currentMoment: null,

	// If specified then the timesheet for this user is shown (only managers)
	user_id: null,

	initialize: function()
	{
		// Last sunday as first day
		this.currentMoment = moment().subtract("day", moment().weekday());
	},

	render: function()
	{
		var self = this;

		var date_from = this.currentMoment.format("YYYY-MM-DD");

		$.ajax(
		{
			url: "api/timesheets",
			type: "GET",
			dataType:'JSON',
			async: true,
			data: { user_id: this.user_id, date_from: date_from },
			success: function(timesheet)
			{
				self.timesheet = timesheet;
				self.updateTimesheet();
			}
		});

		return this;
	},

	saveTimesheetClick: function(event)
	{
		event.preventDefault();

		// Get all inputs...
		var timesheetTasks = $("[name='timesheet_task']");
		// ...iterate each one, saving the results...
		for (var i = 0; i < timesheetTasks.length; i++)
		{	
			var timesheetTask = timesheetTasks[i];
			var hours = timesheetTask.value;
			var weekDay = timesheetTask.getAttribute("data-weekday");
			var index = timesheetTask.getAttribute("data-index");
			this.timesheet[index].week_input[weekDay] = hours;
		}

		// ... and the, send all the data back to the server for updating
		var data = { user_id: this.user_id, timesheet: this.timesheet, date_from: this.currentMoment.format("YYYY-MM-DD") };

		// Note that I serialize the data manually to JSON. This is because JQuery has a faulty
		// JSON serialization for arrays => it includes the index in the serialization. That breaks
		// the controller. I could handle it on the controller but the tidiest option is to
		// create syntactically correct JSON. For that purpose I use contentType + JSON.stringify
		var self = this;
		$.ajax(
		{
			url: "api/timesheets/none",
			type: "PUT",
			contentType: "application/json",
			async: true,
			data: JSON.stringify(data),
			success: function()
			{
				self.updateMetrics();
				AlertMessage.show_success("Timesheet was updated successfully");
			}
		});
	},

	// Updates the timesheet table + metrics using the state of the view
	updateTimesheet: function()
	{
		// Ensure that the timesheet is sort
		this.timesheet.sort(function(a, b)
		{
			name1 = a.project_name + " " + a.task_name;
			name2 = b.project_name + " " + b.task_name;

			return name1.localeCompare(name2);
		});

		// Prevent duplicates
		for (var i = 0; i < this.timesheet.length; i++)
		{
			if (i === 0) continue;

			if (this.timesheet[i].id === this.timesheet[i - 1].id)
			{
				this.timesheet.splice(i, 1);
				i--;
			}
		}
		
		// Update the timesheet
		$(this.el).html(this.template({ user_id: this.user_id, current_moment: this.currentMoment, timesheet: this.timesheet }));

		this.updateTimesheetUsername();
		this.updateMetrics();
	},

	// Updates the timesheet username using the user_id field
	updateTimesheetUsername: function()
	{
		// Update the timesheet user name
		if (this.user_id === null)
		{
			$("#timesheetUsername").text(CresponApp.session().name);
		}
		else
		{
			var user = new CresponApp.Models.User({ id: this.user_id });
			user.fetch({ async: true, success: function(user) {
				$("#timesheetUsername").text(user.attributes.name);
			}});
		}
	},

	updateMetrics: function()
	{
		this.updateTotals();
		this.updateInputMessage();
		this.updateBillableChart();
	},

	updateTotals: function()
	{
		// This will hold the total for both columns
		var total = 0;

		// Update totals for weekdays
		for (var i = 0; i < 7; i++)
		{
			var selector = sprintf(".input-hours[data-weekday='%s']", i);
			var textboxArray = $(selector);
			var hoursWeekdays = 0;
			for (var j = 0; j < textboxArray.length; j++)
			{
				var textbox = textboxArray[j];
				hours = $(textbox).val();
				// Fix any invalid values
				if (hours.toString().isNumeric() === false)
				{
					$(textbox).val("0");
					hours = 0;
				}
				hoursWeekdays += hours.toString().toInteger();
			}
			selector = sprintf(".day-total[data-weekday='%s']", i);
			$(selector).text(hoursWeekdays);
			total += hoursWeekdays;
		}

		// Update totals per line (task)
		for (var i = 0; i < this.timesheet.length; i++)
		{
			var selector = sprintf(".input-hours[data-index='%s']", i);
			var textboxArray = $(selector);
			var hoursLine = 0;
			for (var j = 0; j < textboxArray.length; j++)
			{
				var textbox = textboxArray[j];
				hoursLine += $(textbox).val().toInteger();
			}
			selector = sprintf(".task-total[data-index='%s']", i);
			$(selector).text(hoursLine);
		}

		$(".week-total").text(total);
	},

	previousWeekClick: function()
	{
		this.currentMoment.subtract("day", 7);
		this.render();
	},

	thisWeekClick: function()
	{
		this.currentMoment = moment().subtract("day", moment().weekday());
		this.render();
	},

	nextWeekClick: function()
	{
		this.currentMoment.add("day", 7);
		this.render();
	},

	updateInputMessage: function()
	{
		// Default message
		var message = "Your input is just fine ! You have completed your week. Keep up with the good stuff :)";

		missingWeekdays = [];
		// Do not check saturday or sundays by default
		for (i = 1; i < 6; i++)
		{
			var selector = sprintf(".day-total[data-weekday='%s']", i);
			dayTotalTd = $(selector);
			if (dayTotalTd.text().toInteger() <= 0) missingWeekdays.push(i);
		}
		
		if (missingWeekdays.length > 0)
		{
			message = "You're missing input in the following days: ";

			for (var i = 0; i < missingWeekdays.length; i++)
			{
				message += moment().day(missingWeekdays[i]).format("dddd") + " ";
			}
		}

		$("#inputDiv").text(message)
	},

	updateBillableChart: function()
	{
		var self = this;

		$.ajax(
		{
			url: "api/timesheets/billable_hours",
			type: "GET",
			dataType:'JSON',
			async: true,
			data: { user_id: this.user_id, date_from: this.currentMoment.format("YYYY-MM-DD") },
			success: function(percentage)
			{
				percentage = percentage * 100;
				
				var billableData = 
				[
					{value: percentage, color:"#FF6B6B"},
					{value: 100 - percentage, color : "#E2EAE9"}
				];
				new Chart(self.$("#billablechart")[0].getContext("2d")).Doughnut(billableData, {animation: false});
			}
		});
	},

	addTaskClick: function(event)
	{
		event.preventDefault();	
		var view = new CresponApp.Views.InputsEdit({ caller: this });
		$("#modals").html(view.render().el);
		// Set focus on the chosen
		$(".chosen-search")[0].children[0].focus();
		return this;
	},

	pickUserClick: function(event)
	{
		event.preventDefault();	
		var view = new CresponApp.Views.SelectTimesheet({ caller: this });
		$("#modals").html(view.render().el);
		// Set focus on the chosen
		$(".chosen-search")[0].children[0].focus();
		return this;
	}
});