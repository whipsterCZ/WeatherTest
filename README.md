# WheaterTest
STRV Test Project
=================

Description: Simple App displaying current weather and forecast in locations managable by user.

Features:
========
- App will set your current location via CoreLocation and add it to user managable locationList
- App can show current weather and forcast for next 5 days ( limit for FREE API ) -  via World Weather Online AP  
   - App automaticaly updates weather with NSTimer
- App is written in SWIFT
- App is fully configurable with config.plist  ( Weather API, weather update interval, default settings... )
- App uses Storyboards and AutoLayout, NSNotificationCenter, Dependecy Injection ( @see DI.swift ), Design patterns, Lazy initialization etc..
- App has user settings of length & tempreature unit - stored via NSUserDefaults
- App can search locations via World Weather Online AP
   - Searched term is highlighted in found locations ( even in the middle of  )
- App has user defined list of locations - stored via NSUserDefauls and NSKeydArchiver
   - using CoreData is not recommended in this scenario. 
   - A) There is few items
   - B) We require more than one 'ManagedObjectContext', becasuse we don't want to manage locations found via location search - these are only temporary record.  Marging found item to managed locationList is too complicated
- Custom TableCell animation for location view controller     
    - it can be fixed, but it is on expense of unresponsive UI for short ammount of time
- Another custom TableCell animation location search view controller
- Another TableCell animation fot Forecast view controller   
   - There are presented some additional (duplicate) rows here ( for demo purpose - it can be easily turned of in method 'TableView:NumberOfRowsInSection:' )


Roadmap: 
=======
- Sharing is not fully implemented, becasuse it is not crucial for this kind of app. Moreover i doesnt make sense to share weather via another service than Twitter and Facebook... 
- There are missing many images for weather (Icon_Big.png) - so i display only Windy, Cloudy, Sunny and Storm 
- RTLabel (3dparty class) causes some warning with 64bit iOS Devices (  )

Dependencies:
-----------
- AFNetworking
- RTLabel - can format 