CresponApp.Views.HomeIndex = Backbone.View.extend ({

  template: JST["home/home_index"],

  events:
  {
  },

  initialize: function()
  {
  },

  render: function()
  {
    $(this.el).html(this.template());
    this.renderWidgets();
    return this;
  },

  renderWidgets: function()
  {
    var projectsView  = new CresponApp.Views.HomeProjects();
    this.$("#projects_chart_div").html(projectsView.render().el);

    var company = new CresponApp.Models.Company({ id: "mine" });
    var self = this;
    company.fetch({ async: true, success: function() 
    {
      var usersView  = new CresponApp.Views.HomeUsers({ company: company });
      self.$("#pending_users_div").html(usersView.render().el);

      var inputsView  = new CresponApp.Views.HomeInputs({ company: company });
      self.$("#inputs_chart_div").html(inputsView.render().el);
    }});

    return this;
  }

});