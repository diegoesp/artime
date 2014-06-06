CresponApp.Views.HomeIndex = Backbone.View.extend ({

  template: JST["home/home_index"],
  home_intro_template: JST["home/home_intro"],

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
    var projectsCollection = new CresponApp.Collections.Projects();
    var data = { active: true, internal: false };
    projectsCollection.fetch({ data: data, async: true, success: this.renderHomeProjects });

    var company = new CresponApp.Models.Company({ id: "mine" });
    company.fetch({ async: true, success: this.renderMetrics });

    return this;
  },

  // Renders the dashboard screen
  renderHomeProjects: function(projectsCollection)
  {
    // Should I render the dashboard... or the intro video ?
    if (projectsCollection.length > 0)
    {
      var projectsView  = new CresponApp.Views.HomeProjects({ projectsCollection: projectsCollection });
      this.$("#projects_chart_div").html(projectsView.render().el);
    }
    else
    {
      var homeIntroView  = new CresponApp.Views.HomeIntro();
      this.$("#projects_chart_div").html(homeIntroView.render().el);
    }
  },

  renderMetrics: function(company)
  {
    var usersView  = new CresponApp.Views.HomeUsers({ company: company });
    this.$("#pending_users_div").html(usersView.render().el);

    var inputsView  = new CresponApp.Views.HomeInputs({ company: company });
    this.$("#inputs_chart_div").html(inputsView.render().el);
  }

});