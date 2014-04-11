CresponApp.Views.AdministrationsShow = Backbone.View.extend ({

  template: JST["administrations/administrations_show"],

  events:
  {
    "click #save": "save",
    "click #cancel": "cancel"
  },

  model: null,

  initialize: function(hash)
  {
    this.administrationsCollection = new CresponApp.Collections.Administrations();
    this.administrationsCollection.fetch({ async: false });

    if (hash.id !== null)
    {
      this.model = this.administrationsCollection.get(hash.id);
    }
  },

  render: function()
  {
    $(this.el).html(this.template({ administration: this.model }));
    $("#messages").prop("innerHTML", "");
    return this;
  },

  save: function()
  {
    // If it's a new object I have to create it. If not, I just have to update it.
    if (this.model === null)
    {
      this.administrationsCollection.create($('#adminForm').serializeObject(),
      {
        wait: true,
        success: function(model)
        {
          message = "A new administration has been added to the system";
          AlertMessage.show_success(message);
          Backbone.history.navigate("administrations/index", true);
        },
        error: function(model, error)
        {
          error_text = $.parseJSON(error.responseText).errors;
          AlertMessage.show_error(error_text);
        }
      });
    }
    else
    {
      this.model.save($('#adminForm').serializeObject() ,
      {
        wait: true,
        success: function()
        {
          message = "Administration was updated successfully";
          AlertMessage.show_success(message);
        },
        error: function(model, error)
        {
          error_text = $.parseJSON(error.responseText).errors;
          AlertMessage.show_error(error_text);
        }
      });
    }
  },

  cancel: function()
  {
    Backbone.history.navigate("administrations/index", true);
  }

});
