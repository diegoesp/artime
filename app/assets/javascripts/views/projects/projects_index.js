CresponApp.Views.ProjectsIndex = Backbone.View.extend ({

 	template: JST["projects/projects_index"],

	events:
	{
		"click #new": "new",
		"click .project-link": "edit"
	},

	initialize: function()
	{
	},

	render: function()
	{
		$(this.el).html(this.template());
		this.$("#customer").chosen({width: "100%"});
		this.$('.date-picker').datepicker({ 
			format: 'mm-dd-yyyy',
			autoclose: true,
    		todayHighlight: true
        });
		return this;
	},

	new: function(event)
	{	
		event.prevetDefault();
		Backbone.history.navigate("projects/new", true);
	},

	edit: function(event)
	{
		event.preventDefault();
		var id = $(event.currentTarget).data("model-id");
		Backbone.history.navigate("projects/" + id, true);
	}
	
});