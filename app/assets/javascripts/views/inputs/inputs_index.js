CresponApp.Views.InputsIndex = Backbone.View.extend ({

 	template: JST["inputs/inputs_index"],

	events:
	{
		"blur .input-hours": "updateTotals",
		"click #previous_week": "previousWeekClick",
		"click #this_week": "thisWeekClick",
		"click #next_week": "nextWeekClick",
		"click #save_timesheet": "saveTimesheet",
		"click #add_task": "addTask"
	},

	timesheet: null,

	currentMoment: null,

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
			data: { date_from: date_from },
			success: function(timesheet)
			{
				self.timesheet = timesheet;
				$(self.el).html(self.template({ current_moment: self.currentMoment, timesheet: timesheet }));
				self.updateMetrics();
			}
		});

		return this;
	},

	saveTimesheet: function(event)
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
		var data = { timesheet: this.timesheet, date_from: this.currentMoment.format("YYYY-MM-DD") };

		// Note that I serialize the data manually to JSON. This is because JQuery has a faulty
		// JSON serialization for arrays => it includes the index in the serialization. That breaks
		// the controller. I could handle it on the controller but the tidiest option is to
		// create syntactically correct JSON. For that purpose I use contentType + JSON.stringify
		var self = this;
		$.ajax(
		{
			url: "api/timesheets/mine",
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
			data: { date_from: this.currentMoment.format("YYYY-MM-DD") },
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
	}
});