window.CresponApp =
{
	Models: {},
	Collections: {},
	Views: {},
	Routers: {},

	cachedSession: null,
	cachedSessionUpdatedAt: null,

	initialize: function()
	{
		window.document.title = "Greentime";

		// Set client-side locale. Server side locale is set at application_controller.rb
		I18n.locale = "en";

		this.initializeBackbone();		
		this.initializeAjaxErrorManagement();

		// If you want to use this plugin 
		// this.initializeTimeAgoPlugin();

		// If you want to use the chat
		// Chat.initialize();

	},

	initializeBackbone: function()
	{
		this.Routers = 
		{
			administrationRouter: new CresponApp.Routers.Administrations(),
			homeRouter: new CresponApp.Routers.Home()
		};

		// You can link all routers to an action whenever they route something
		for (var key in this.Routers)
		{
			var router = this.Routers[key];
			router.bind("route", function(trigger, args) 
			{
				// Action
			});
		}

		Backbone.history.start();
	},

	initializeTimeAgoPlugin: function()
	{
		jQuery.timeago.settings.strings = I18n.t("timeago");
	},

	// Catches all ajax errors and shows a message
	initializeAjaxErrorManagement: function()
	{
		$(document).ajaxError(function(event, jqxhr, settings, exception ) 
		{
			if(jqxhr.status == 401)
			{
				console.log("Sesión inexistente en el servidor");
				alert("Su sesion de usuario ha sido finalizada. Debe autenticarse nuevamente");
				// Prevent showing broken code 
				$(".container").hide(); 
				document.location.href = "/users/sign_in";
			}
			else
			{
				if(jqxhr.status === 422)
				{
					AlertMessage.show_error(jqxhr.responseJSON.errors);
				}
				else
				{
					var message = ""
					message += "Ha habido un error inesperado al hacer una llamada al servidor. "
					message += "Por favor reinicie la aplicacion presionando F5. Si el error persiste "
					message += "y no le permite operar contactenos para que podamos asistirlo."

					AlertMessage.show_error(message);
					console.log(jqxhr);
				}
			}
		});
	},

	// Can be passed to a backbone function for default behaviour when
	// there's an error 
	// 
	// Default behaviour is:
	// 1) Just displays the error on the screen in an alert message
	// 2) Sync fetching or updating
	//
	// @param route If specified, after success backbone redirects to that URL
	backboneOptions: function(route)
	{
		options = 
		{
			wait: true,
			error: function(model, error)
			{
				error_text = $.parseJSON(error.responseText).errors;
				// Do not show an error if fails. The ajaxError function already does this
				// AlertMessage.show_error(error_text);
				console.log(error_text); 
			}
		}
		if(route)
		{
			options.success = function() 
			{ 
				AlertMessage.show_success("Operación realizada con éxito");
				Backbone.history.navigate(route, true)
			}
		}
		return options;
	}

};

window.onerror = function(errorMessage, url, lineNumber)
{	 
	var message = ""
	message += "Ha habido un error inesperado en la aplicacion. "
	message += "Por favor reinicie la misma presionando F5. Si el error persiste "
	message += "y no le permite operar contactenos para que podamos asistirlo."

	AlertMessage.show_error(message);

	console.log("There was an error: " + errorMessage + " in " + url + " for " + lineNumber);
};

$(document).ready(function()
{
	CresponApp.initialize();
});