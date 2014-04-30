CresponApp.Views.InputsIndex = Backbone.View.extend ({

 	template: JST["inputs/inputs_index"],

	events:
	{
		"keyup .input-hours": "inputHoursKeyUp",
		"click #previous_week": "previousWeekClick",
		"click #this_week": "thisWeekClick",
		"click #next_week": "nextWeekClick"
	},

	projectTaskInputsCollection: null,

	currentMoment: null,

	initialize: function()
	{
		this.projectTaskInputsCollection = new CresponApp.Collections.ProjectTaskInputs();

		// Last sunday as first day
		this.currentMoment = moment().subtract("day", moment().weekday());
	},

	render: function()
	{
		var self = this;

		var date_from = this.currentMoment.format("YYYY-MM-DD");

		this.projectTaskInputsCollection.fetch({ data: { date_from: date_from }, async: true, success: function(projectTaskInputsCollection)
		{
			$(self.el).html(self.template({ current_moment: self.currentMoment, projectTaskInputsCollection: self.projectTaskInputsCollection} ));

			self.updateMetrics();
		}});

		return this;
	},

	inputHoursKeyUp: function(event)
	{
		event.preventDefault();

		var textbox = $(event.currentTarget);

		var hours = textbox.val().toString().trim();
		if (hours === "" || hours.isNumeric() === false) return;

		this.updateMetrics();

		// Save the record at the database
		var id = textbox.data("project-task-id");
		// Get the date
		var weekday = textbox.data("weekday").toString().toInteger();
		var inputDate = this.currentMoment.clone().add("day", weekday).format("YYYY-MM-DD")
		$.ajax(
		{
			url: "/api/project_task_inputs/" + id,
			type: "PUT",
			dataType:'JSON',
			async: true,
			data: { input_date: inputDate, hours: hours }
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
				hoursWeekdays += $(textbox).val().toInteger();
			}
			selector = sprintf(".day-total[data-weekday='%s']", i);
			$(selector).text(hoursWeekdays);
			total += hoursWeekdays;
		}

		// Update totals per line (task)
		for (var i = 0; i < this.projectTaskInputsCollection.length; i++)
		{
			var selector = sprintf(".input-hours[data-line='%s']", i);
			var textboxArray = $(selector);
			var hoursLine = 0;
			for (var j = 0; j < textboxArray.length; j++)
			{
				var textbox = textboxArray[j];
				hoursLine += $(textbox).val().toInteger();
			}
			selector = sprintf(".task-total[data-line='%s']", i);
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
			url: "api/project_task_inputs/billable_hours",
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