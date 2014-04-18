# CurrencyKing
A system-tray resident currency converter which converts between Euro (€), Pounds (£) and Dollars (US) ($), developed in Delphi.

## Notes
This is an old project, and is certainly not perfect. Pulls currency rates from Appspot and saves them to an INI in the application directory.
It was built largely as a personal project, and is aimed at users who's primary currency is EUR.

## Using the software
Usage is simple - input the value to convert (with the currency symbol):
	$20.99
into the left-hand text box, and the resulting value (in €) will be output to the right-hand textbox. Entering a EUR value in the left hand textbox will output both the GBP and USD values in the right hand text box.

To update the currency rates, simply click the text that says when the exchange rates were last updated (alternatively, select "update rates" from the Tray icon). Note that this is not run in a seperate thread so the UI will lock up momentarily during the Update.

To Exit, use the Tray icon's exit option, as the "X" button simply hides the form.

Released under the BSD license - see LICENSE.md for more details.
Copyright (c) 2014 Sean Phillips