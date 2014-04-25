/**
 * Given a plugged form object, it takes all html objects inside and
 * serializes them to an array useful for backbone.js calls
 * @returns array
 */
$.fn.serializeObject = function()
{
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() 
	{
		if (o[this.name] !== undefined) 
		{
			if (!o[this.name].push) 
			{
					o[this.name] = [o[this.name]];
			}
			o[this.name].push(this.value || '');
		} 
		else 
		{
			o[this.name] = this.value || '';
		}
	});

	// For checkboxes it assigns the checked status as a value. 
	$('input[type=checkbox]').map(function(){o[this.name]=this.checked});
	return o;
};

/**
 * Populates the form plugged using the model given as a parameter
 * model: Model to be used as data source
 * prefix: Optional. If specified it is used to generate names for the controls
 *  following a two dimensional array, i.e. param[user] (param would be the prefix)
 */
$.fn.populateForm = function(model, prefix)
{
		if(model != null) 
		{
			var self = this;
			_.each(model.attributes, function (value, field) 
			{
				// Transform any booleans to string
				if (_.isBoolean(value)) value = value.toString();

				if (_.isString(value) || _.isNumber(value))
				{
						// Look for the control that we have to fill
					var control_finder = (prefix) ? '[name="' + prefix + '[' + field + ']"]' : '[name="' + field + '"]';
					var control = $(control_finder, self);
					// And react differently based on the type of control: radio, checkbox, input, etc
					var control_type = control.attr("type");
					if(control_type === "radio" || control_type === "checkbox")
					{
						control.each(function() 
						{
							if($(this).attr('value') == value) 
							{  
								$(this).attr("checked", value); 
							} 
						}); 
					}
					else if(control_type === "file")
					{
						//skip input file type
					}
					else 
					{
						control.val(value);
					}
				}
				else if(_.isObject(value) && value.hasOwnProperty("id"))
				{
					$('[name="' + field + '_id"]', self).val(value.id);
				}
			});
	 }
};

$.fn.selectCollection = function(collection)
{
	collection.fetch({async: false});
	collection.sort();
	var $select = this;
	$.each(collection.models, function(index,item)
	{
		$select.append(
				$('<option/>')
					.text(item.attributes.name)
					.val(item.attributes.id)
				);
	})
};

// Populates a given select tag with a remote REST call
//
// url: REST call URL
// key: Optional. Field to be used as id. Default is "id"
// value: Optional. Field to be used as value. Default "name"
// prefix: Optional. If provided, it is assumed that the call returns a two 
// dimensional array and this is used as the first dimension
$.fn.populateSelect = function(url, key, value, prefix)
{
		
		if(!key) key="id";
		if(!value) value="name";
		var $select = this;
		$.ajax(
		{
			url: url,
			dataType:'JSON',
			async: false,
			success:function(data)
			{
				//iterate over the data and append a select option
				$.each(data, function(index,item)
				{
					//support child elements  
					option_value = (prefix) ? item[prefix][key] : item[key];
					option_text = (prefix) ? item[prefix][value] : item[value];
					
					//prevent duplicates
					if($select.has("[value=" + option_value + "]").length == 0)
					{
						$select.append(
							$('<option/>')
								.text(option_text)
								.val(option_value)
							);
					}
				})
			},
			error:function(request, status, error)
			{
				//if there is an error append a 'none available' option
				AlertMessage.show_error(error);
			}
		});
};

$.fn.populateVisibility = function(buildingId)
{
	rolesForBuilding = CresponApp.rolesForBuilding(buildingId);

	var maxValue = 0;
	for(var roleCode in rolesForBuilding)
	{
		var roleDescription = rolesForBuilding[roleCode];
		var option = sprintf("<option value='%s'>%s</option>", roleCode, roleDescription);
		this.append(option);
		if (maxValue < roleCode) maxValue = roleCode;
	} 
	// by default select the max level
	this.val(maxValue);
};

/**
 * Function to convert select control to bootstrap dropdown button
 * This function receives an optional parameter glyphicon to add an
 * icon as bootstrap button-group before the text
 */
$.fn.select2Button = function(glyphicon)
{
	this.hide().removeClass('select');
	var current = this.find('option:selected').html() || '&nbsp;';
	var val   =   this.find('option:selected').attr('value');
	var name  =   this.attr('name') || '';

	this.after('<div class="btn-group" id="select-group-' + this.attr("id") + '" />');
	var select = this.parent().find('#select-group-' + this.attr("id"));
	var html = "";
	if(glyphicon) {
		html +=  '  <button type="button" class="btn ' + this.attr('class') + '" style="min-width:10px"><span class="glyphicon '+ glyphicon +'"></span></button>';
		html +=  '  <div class="btn-group">';
	}
	html +=  '     <button class="selector btn ' + this.attr('class') + ' dropdown-toggle" type="button" data-toggle="dropdown">' + current + '</button>';
	html +=  '     <ul class="dropdown-menu"></ul><input type="hidden" value="' + val + '" name="' + name + '" id="' + this.attr('id') + '" class="' + this.attr('class') + '" />';
	if(glyphicon) {
		html +=  '  </div>';
	}
	select.html(html);
	this.find('option').each(function(o,q) {
			select.find('.dropdown-menu').append('<li><a href="#" data-value="' + $(q).attr('value') + '">' + $(q).html() + '</a></li>');
	});
	select.find('.dropdown-menu a').click(function(e) {
			select.find('input[type=hidden]').val($(this).data('value')).change();
			select.find('.selector').html($(this).html());
			e.preventDefault();
	});
	this.remove();
};

$.fn.autocompleteCollection = function(collection, queryAttr)
{
		input = this;

		// Fix it hidde original input control (with id value) and create a new one to autocomplete
		newInput = $("<input type='text' />");
		newInput.attr("id", this.attr("id") + "_autocomplete");
		newInput.attr("class", this.attr("class"));
		newInput.attr("placeholder", this.attr("placeholder"));

		input.attr("type","hidden");
		input.after(newInput);
		
		options = {
			serviceUrl: collection.url,
			noCache: true,
			paramName: queryAttr,
			// Fix issue with proportional input width
			onSearchComplete: function(query) {
				$(".autocomplete-suggestions").css("width", newInput.css("width"));
			},
			// Fix select id instead of displayValue 
			onSelect: function (suggestion) {
				input.val(suggestion.data);
			},
			transformResult: function(response) {
				return {
						suggestions: $.map($.parseJSON(response), function(dataItem) {
								return { data: dataItem.id, value: dataItem[queryAttr] };
						})
				};
			}
		};
		newInput.autocomplete(options);
} 

$.fn.userLookup = function(params)
{
		params = params || {};
		input = this;
		// Fix it hidde original input control (with id value) and create a new one to autocomplete
		newInput = $("<input type='text' />");
		newInput.attr("id", this.attr("id") + "_autocomplete");
		newInput.attr("class", this.attr("class"));
		newInput.attr("placeholder", this.attr("placeholder"));

		group = $('<div class="input-group"></div>');
		icon = $('<span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>');
		group.append(newInput);  
		group.append(icon);		

		input.attr("type","hidden");
		input.after(group);
		
		options = {
			serviceUrl: "/api/users",
			noCache: true,
			paramName: "query",
			params: {building: params.building_id},
			// Fix issue with proportional input width
			onSearchComplete: function(query) {
				$(".autocomplete-suggestions").css("width", newInput.css("width"));
			},
			// Fix select id instead of displayValue 
			onSelect: function (suggestion) {
				input.val(suggestion.data);
			},
			transformResult: function(response) {
				return {
					suggestions: $.map($.parseJSON(response), function(dataItem) {
						display = dataItem.name + " (" + dataItem.email + ")";
						return { data: dataItem.id, value: display };
					})
				};
			}
		};
		newInput.autocomplete(options);

		if(input.val() !== ""){
			var user = new CresponApp.Models.User({id: input.val()});
			user.fetch( { async: false } );
			newInput.val( user.attributes.name + " (" + user.attributes.email + ")");
		}
} 
