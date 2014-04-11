RSpec tests
===========

This folder contains the RSpec tests. RSpec will be our framework of choice for implementing the different type of tests
a Rails application needs.

Implemented testing scheme is aimed to go through the full stack, that can described as follows:

HTML / JS File => Controller => Model => Database

Many subdirectories can be found in the spec directory, each one having a concrete purpose that will be detailed in that
context.

Remember that, as you move from right to left in the testing stack, 

* (bad) Tests get slower
* (good) Tests cover more functionality so therefore may catch more bugs
* (bad) Tests are more complex and harder to maintain
* (good) Tests involve more technologies in the testing stack

As a general principle, try to stick at the most right. You can start sliding to the left whenever you need to add
more tests that cover some specific features. In some cases (i.e. javascript browser testing) you have to go full left 
and you have no choice. But, in general, a good healthy test suite should be like a pyramid, having its fat base
in the "Database" layer and a thin top in the "HTML / JS" layer.

1) factories

Contains the data factories that fill the database for each test. They must be referenced inside the tests
so they are executed and fill the database.

Although they do not test functionality for themselves, they hit the database layer directly so in case any
validation is not right an exception may be thrown.

HTML / JS File => Controller => Model => Database
                                            ^
                                            |
                                            |
                                          (here)

2) models

This folder contains the model tests. These tests are positioned in here:

HTML / JS File => Controller => Model => Database
                                  ^
                                  |
                                  |
                                (here)

3) controllers

This folder contains the controllers tests. These tests are positioned in here:

HTML / JS File => Controller => Model => Database
                      ^
                      |
                      |
                    (here)

This layer is very useful for testing API calls (specially, REST APIs).

4) requests

This folder contains the tests that start at the top of the pyramid: that means the browser.
Requests can implement tests using a headless JavaScript driver (that means, no real javascript is executed) or using a real
JavaScript driver. As you would expect, a headless JavaScript driver is much faster (the real javascript driver actually 
opens a browser window) so you should try to stick to the headless driver whenever possible. 

Note that the headless JavaScript driver functionality clashes with the controllers (3) layer in most cases.
You should try to stick with the controllers layer before going for the headless JavaScript driver as a general rule.

HTML / JS File => Controller => Model => Database
      ^
      |
      |
    (here)

These tests are SLOW (specially with the full javascript driver enabled) so try to limit them. That will be hard in
certain cases like BackBone.js or AngularJS apps where you have a thick javascript layer that you need to test. In those
cases assume the hit from the beginning and try to:

1) Code tests that are fast to execute
2) Push as many testing functionality as you can to the right, or bottom of the pyramid.

A note on Capybara drivers
==========================

We have three posible "engines" or drivers to use with Capybara. Choosing one determines that Capybara uses it to
run the tests.

:rack_test => Default. Does not execute Javascript but is the fastest option
:webkit => Headless javascript engine. Faster than selenium but not 100% accurate on javascript. May fail occasionally. Beta.
selenium => 100% accurate (opens a browser to test) but very slow comparing to other two.