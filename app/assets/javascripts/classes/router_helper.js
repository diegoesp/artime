// Helper for creating routes on backbone.js based on the querystrings
// This helper helps the programmer to avoid passing parameters all
// over different layers extracting those parameters from the querystring
// itself
RouterHelper = {

  // Given a full path in the form "/#buildings/1/amenities/4/booking/1" it can
  // get the id for the parameter asked. For example: if given as a parameter
  // "buildings" it would get "1". If given as a parameter "amenities" it would
  // get "4".
  //
  // If the URL does not contain this parameter or it is malformed in any way
  // the helper throws an Error
  getParameter: function(parameter)
  {
    var href = window.location.href
    var hrefArray = href.split(parameter);

    // It should get me at least two portions: first is the parameter and second its value
    if (hrefArray.length < 2) throw new Error("querystring " + href + " does not contain " + parameter);
    valueDirty = hrefArray[1];

    // It got something like this "/1/amenities/4"
    valueDirtyArray = valueDirty.split("/") 

    // My second position should be my id. If no second position exists then the href is malformed
    if (valueDirtyArray.length < 2) throw new Error("querystring " + href + " is malformed");

    return valueDirtyArray[1];
  },

  // Does the same as getParameter but returns null if the parameter does not exists
  getParameterOrNull: function(parameter)
  {
    try
    {
      return this.getParameter(parameter);
    }
    catch(e)
    {
      return null;
    }
  },

  // Gets the current route without the origin (aka http://www.domain.com) component and also
  // cuts out any ending slash. Form is always like this:
  //
  // /buildings/1/bookingRules
  getRoute: function()
  {
    var href = window.location.href;
    // Eliminate www header
    href = href.replace(window.location.origin, "")

    // Cut out any last slashes
    if (href.right(1) === "/")
    {
      href = href.left(href.length - 1);
    }

    // Cut out any beginning hashes
    if (href.left(2) === "/#")
    {
      href = "/" + href.right(href.length - 2);
    }

    return href;
  },
   
  // Takes the present route (sth like "https://xx/#buildings/1/bookingRules/1/edit") and gets 
  // you up one level. This is tipically used when doing CRUDs and you have to go back on your
  // route so you avoid duplicating it in the code.
  //
  // Typical cases for REST routes are:
  // 
  // /buildings/1/bookingRules/new
  // /buildings/1/bookingRules/2/edit
  // /buildings/1/bookingRules/2/destroy
  // /buildings/1/bookingRules/2/show
  //
  // All these return /buildings/1/bookingRules when passed through this function.
  up: function()
  {
    var href = this.getRoute();

    hrefArray = href.split("/");

    // I can have three kinds of REST routes:
    // 1 - Create: /buildings/new
    // 2 - Action: /buildings/1/ACTION
    // 3 - Index:  /buildings

    // For the second case I cut out the id and action
    if (hrefArray[hrefArray.length - 2].isNumeric())
    {
      for (var i = 0; i < 2; i++) href = this.cutLastSlash(href)
      return href;
    }

    // For the first and third case I cut the last slash
    return this.cutLastSlash(href);
  },

  // Given a string with this form "/buildings/1/string/2/edit" it cuts out
  // the last slash and everything that comes after it, returning sth like
  // "/buildings/1/string/2"
  //
  // If no slash is detected it throws an error
  cutLastSlash: function(string)
  {
    lastSlashPosition = string.lastIndexOf("/");
    if (lastSlashPosition == -1) throw new Error("Slash not found");
    return string.left(lastSlashPosition);
  }
}