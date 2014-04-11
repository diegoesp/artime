/**
 * Adds the the ajax-loading-indicator on DOM Ready
 * For this class to work the page must contain a div with id="ajax-loading-indicator"
 */
$(function() {

  ajaxIndicatorId = "#ajax-loading-indicator";

  $(document).ajaxStart(function(){
    $(ajaxIndicatorId).fadeIn();
  });
  $(document).ajaxStop(function() {
    $(ajaxIndicatorId).fadeOut();
  });
});