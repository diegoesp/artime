CresponApp.Views.ProjectEdit = Backbone.View.extend ({

 	template: JST["projects/project_edit"],
 	template_tasks: JST["projects/project_task_list"],

	events:
	{
		"click #newTask": "newTask",
		"click .task-name": "showTask"
	},

	initialize: function()
	{

	},

	render: function()
	{
		$(this.el).html(this.template());
		this.$("#tasks").html(this.template_tasks());
		this.$("[data-toggle='switch']").bootstrapSwitch();
		this.$("#member_ids").chosen({
			placeholder_text_multiple: "Select one or more members...",
			width: "100%"}
		);
		this.$('.date-picker').datepicker({ 
			format: 'mm-dd-yyyy',
			autoclose: true,
    		todayHighlight: true
        });
		return this;
	},

	newTask: function(event)
	{
		event.preventDefault();
		var id = $(event.currentTarget).data("model-id");
		var view = new CresponApp.Views.ProjectTaskModal({ id: null, collection: this.collection });
		$("#modals").html(view.render().el);
		return this;
	},

	showTask: function(event)
	{
		event.preventDefault();
		var id = $(event.currentTarget).data("model-id");
		var view = new CresponApp.Views.ProjectTaskModal({ id: id, collection: this.collection });
		$("#modals").html(view.render().el);
		return this;
	}
	
});