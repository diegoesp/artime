CresponApp.Views.AdministrationsTable = Backbone.View.extend ({

  template: JST["administrations/administrations_table"],

  events:
  {
    "click .show-button": "showEntry",
    "click .destroy-button": "destroyEntry",
    "click #deleteConfirm": "deleteConfirm"
  },

  administrationsCollection: null,

  initialize: function(hash)
  {
    this.administrationsCollection = hash.administrationsCollection;
  },

  showEntry: function(event)
  {
    var modelId = $(event.target).data("modelid");
    Backbone.history.navigate("administrations/" + modelId, true);
  },

  destroyEntry: function(event)
  {
    event.preventDefault();

    var modelId = $(event.target).data("modelid");

    $("#delete_modal").data("modelid", modelId);
    $("#delete_modal").modal("show");
  },

  deleteConfirm: function(event)
  {
    event.preventDefault();

    var modelId = $("#delete_modal").data("modelid");
    this.administrationsCollection.get(modelId).destroy();
  },

  render: function()
  {
    $(this.el).html(this.template({ administrationsCollection: this.administrationsCollection }));
    return this;
  }

});