/** 
 * Contains many useful Date utilities.
 *
 * @deprecated Use the moment() object instead
 */
DateUtils = 
{
  getDaysInMonth: function (month, year) 
  {
    var daysInMonth = [31, (year % 4 == 0) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month];
  },

  getDaysInPreviousMonth: function (month, year) 
  {
    var daysInMonth = [31, 31, (year % 4 == 0) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30];
    return daysInMonth[month];
  },

  getWeekDays: function() 
  {
     return ["D", "L", "M", "M", "J", "V", "S"];
  },

  getMonthNames: function() 
  {
    return ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
  },

  formatDate: function(fulldate)
  {
    return fulldate.substring(0,10);
  },

  formatDatetime: function(fulldate)
  {
    return this.formatDate(fulldate) + " " + fulldate.substring(11,16);
  },

  /**
   * Given a moment() object, it studies it and returns a new moment that
   * points to the first earliest possible monday for this month, prioritizing
   * Monday over 1st day of the month.
   *
   * This means: if we have a month whose day 1 is Wednesday, the call  will
   * backtrack a couple of days. So, if previous month has 31 days, it will
   * return a month pointing to Monday 30th for the previous month.
   *
   * Very useful to draw calendars
   */
  earliestMondayInMonth: function(moment)
  {
    var first_day_in_month = moment.clone().date(1);
    // First possible case: the first day in the month is Tue, Wed, Thu, Fri or Sat
    if (first_day_in_month.day() > 1)
    {
      return first_day_in_month.subtract("day", first_day_in_month.day() - 1);
    }

    // Second possible case: the first day in month is Sunday
    if (first_day_in_month.day() == 0)
    {
      return first_day_in_month.subtract("day", 6);
    }
    
    // Third possible case: the first day in month IS Monday, so nothing to do
    return first_day_in_month;
  }
};