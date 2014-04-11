CresponApp.Collections.Administrations = Backbone.Collection.extend({

  // Will search on the index call for the administrations controller
	url: "/api/administrations",

  model: CresponApp.Models.Administration

});
