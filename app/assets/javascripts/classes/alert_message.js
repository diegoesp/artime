/**
 * Static class. Allows to manage non modal alerts for the framework.
 * To use this class the page must contain a div with id="alert" and display:hidden and
 * to have Twitter bootstrap integrated.
 * The class shows and hides the div when needed and updates the message. 
 */
var AlertMessage = new function()
{
  /**
   * Shows an error
   * @param  {String} message Message to be displayed
   */
  this.show_error = function(message)
  {
    this.display_alert(message, "alert-danger");
  };

  /**
   * Shows a warning
   * @param  {String} message Message to be displayed
   */
  this.show_warning = function(message)
  {
    this.display_alert(message, "alert-danger");
  };

  /**
   * Shows an informative message
   * @param  {String} message Message to be displayed
   */
  this.show_info = function(message)
  {
    this.display_alert(message, "alert-info");
  };

  /**
   * Shows a message to the user stating that an operation was successfull
   * @param  {String} message Message to be displayed
   */
  this.show_success = function(message)
  {
    this.display_alert(message, "alert-success");
  };

  /**
   * Hides a message if it is in display at the moment
   * @param  {String} message Message to be displayed
   */
  this.hide = function()
  {
    $("[name='alert']").hide();
  };

  /**
   * (Private) displays an alert and allows to add additional styles.
   * Do not use from outside the class. Employ the other methods instead
   * @param  {String} message Message to be displayed
   * @param  {String} message Additional CSS classes to add to the message for further styling
   */
  this.display_alert = function(message, style)
  {
    if (style !== null) style = " " + style;
    $("[name='alert']").prop("class", "alert" + style);

    alert_close = "<a class=\"close\" href=\"javascript:AlertMessage.hide()\">&times;</a>";
    $("[name='alert']").prop("innerHTML", alert_close + message);
    $("[name='alert']").fadeIn();
    $("[name='alert']").delay(3000).fadeOut('slow');
  };
}