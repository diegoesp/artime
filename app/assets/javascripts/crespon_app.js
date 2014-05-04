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
		window.document.title = "Artime";

		// Set client-side locale. Server side locale is set at application_controller.rb
		I18n.locale = "en";

		this.initializeBackbone();		
		this.initializeAjaxErrorManagement();
		this.initializeSidebar();

		$(".go-top").click(function(event)
		{ 
			event.preventDefault();
			$("html, body").animate({ scrollTop: $("#main-content").offset().top }, 500);
		});

		// If you want to use this plugin 
		// this.initializeTimeAgoPlugin();

		// If you want to use the chat
		// Chat.initialize();

	},

	initializeSidebar: function()
	{
	    $(function() {
	        function responsiveView() {
	            var wSize = $(window).width();
	            if (wSize <= 768) {
	                $('#container').addClass('sidebar-close');
	                $('#sidebar > ul').hide();
	            }

	            if (wSize > 768) {
	                $('#container').removeClass('sidebar-close');
	                $('#sidebar > ul').show();
	            }
	        }
	        $(window).on('load', responsiveView);
	        $(window).on('resize', responsiveView);
	    });

	    $('.fa-bars').click(function () {
	        if ($('#sidebar > ul').is(":visible") === true) 
	        {
	            $('#main-content').animate({'margin-left': '0px'},500);
	            $('#sidebar').animate({'margin-left': '-210px'},500);
	            $('#sidebar > ul').hide();
	            $("#container").addClass("sidebar-closed");
	        } 
	        else 
	        {
	            $('#main-content').animate({'margin-left': '210px'},500);
	            $('#sidebar > ul').show();
	            $('#sidebar').animate({'margin-left': '0'},500);
	            $("#container").removeClass("sidebar-closed");
	        }
	    });

	},

	initializeBackbone: function()
	{
		this.Routers = 
		{
			administrationRouter: new CresponApp.Routers.Administrations(),
			homeRouter: new CresponApp.Routers.Home(),
			projectsRouter: new CresponApp.Routers.Projects(),
			tasksRouter: new CresponApp.Routers.Tasks(),
			inputsRouter: new CresponApp.Routers.Inputs(),
			clientsRouter: new CresponApp.Routers.Clients(),
			usersRouter: new CresponApp.Routers.Users()
		};

		// You can link all routers to an action whenever they route something
		for (var key in this.Routers)
		{
			var router = this.Routers[key];
			router.bind("route", function(trigger, args) 
			{
				$(".sidebar-menu a").removeClass("active");
				var selector = sprintf(".sidebar-menu a[href$='%s']", window.location.hash);
				$(selector).addClass("active");
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
					console.log(event);
					console.log(jqxhr);
					console.log(settings);
					console.log(exception);
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
	},

	// Gets the user session. See example here http://localhost:3000/api/user_sessions/me
	session: function()
	{
		// By default, session is expired
		var expired = true;

		// If it was updated in the last 60 seconds, then it is not expired
		if (this.cachedSessionUpdatedAt !== null)
		{
			var lastSessionUpdate = ((new Date().getTime() - this.cachedSessionUpdatedAt) / 1000);
			if (lastSessionUpdate < 60) expired = true;
		}

		if (expired)
		{
			var response = $.ajax({
				url: "/api/user_sessions/me",
				type: "GET",
				dataType:'JSON',
				async: false
			});

			this.cachedSession = response.responseJSON;
			this.cachedSessionUpdatedAt = new Date().getTime();
		}

		return this.cachedSession;
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