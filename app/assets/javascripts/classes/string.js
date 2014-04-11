/***********************************************************************
* 
* Common extensions for the String class
*
************************************************************************/

// Cuts the string from the left to n characters
//
// @param n Characters to be allowed
// @return Cutted string
String.prototype.left = function(n)
{
	return this.substring(0, n);
}


// Cuts the string from the right to n characters
//
// @param n Characters to be allowed
// @return Cutted string

String.prototype.right = function(n)
{
  return this.slice(this.length - n);
}

//
// Converts the string to an int
// @return int
//
String.prototype.toInteger = function()
{
	return parseInt(this);
}

//
// Determines if the string is a wrapped number
// @return 	true if it is
//
String.prototype.isNumeric = function() 
{
  return !isNaN(parseFloat(this)) && isFinite(this);
}

//
// Given a string it cuts it to n characters and adds a "..." to make
// evident that there are more characters. If the string is shorter
// than n characters it returns the string unaltered.
// 
// @return string shorten string
//
String.prototype.shorten = function(n)
{
	if (this.length <= n) return this;

	return this.left(n) + "...";
},

//
// Capitalizes the first letter in the string and returns the string
//
String.prototype.capitalize = function() 
{
	return this.charAt(0).toUpperCase() + this.slice(1);
}