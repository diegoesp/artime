CresponApp.Collections.Clients = Backbone.Collection.extend({

	url: "/api/clients",

	comparator: "name",

  model: CresponApp.Models.Client

});
