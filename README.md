# Pilot Assistance System

This program, written in the [ADA SPARK](https://www.adacore.com/sparkpro) language, emulates a pilot assistance system that is responsible for checking that a number of pre and post conditions are met before an action can be taken, either by the pilot or the autopilot.

The program addresses the following points:

* The plane cannot take off without the cockpit door and all external doors shut
and locked.
* The plane cannot take off if there is not a minimum amount of fuel onboard.
* Once in flight, the system will warn of low fuel.
* Once in “normal” flight mode, airspeed and altitude must be within certain
limits.
* When in “landing/takeoff” mode, the landing gear must be lowered below a
certain altitude.
* The engines must be turned off whilst under tow.
* Warning lights inform the pilot of any deviations from normal operating limits.

It was implemented using [GNAT Community IDE](https://www.adacore.com/community).

