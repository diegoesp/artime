CresponApp.Models.Company = Backbone.Model.extend({
		
	url: function()
	{
		var id = this.id;
		if (id === undefined || id === null) id = "";

		return "/api/companies/" + id;
	}

});
