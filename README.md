STRV Test Project
=================

Description: Simple App displaying current weather and forecast in several locations.

Features:
========
- App will set your **current location** via CoreLocation and add it to user manageable locationList
- App can show **current weather** and **forecast** for next 5 days ( limit for FREE API ) -  via World Weather Online AP  
   - App automatically updates weather with NSTimer
- App is written in **swift** and follows **STRV guideline**
- App is **fully configurable** with `config.plist`  ( Weather API, weather update interval, default settings... )
- App uses Storyboards and AutoLayout, `NSNotificationCenter`, Dependecy Injection ( *@see* `DI.swift` ), Design patterns, Lazy initialisation, secured connections via **HTTPS** etc..
- App has user settings of length & temperature unit - stored via `NSUserDefaults`
- App can search locations via World Weather Online AP
   - Searched term is **highlighted** in found locations ( even in the middle of  )
- App has user defined list of locations - stored via `NSUserDefaults` and `NSKeydArchiver`
   - using `CoreData` is not recommended in this scenario. 
   - A) There is few items
   - B) We require more than one `ManagedObjectContext`, because we don't want to manage locations found via location search - these are only temporary record.  Merging found item to managed locationList is too complicated
- Custom **TableViewCell animation** for all view controllers
- Custom **Today View animation**
`TableView:numberOfRowsInSection:` )
- TabBarController UI allow to change Tab **onSwipe left/right**
- `TodayViewController` UI allow to change selected location **onSwipe up/down**

Roadmap: 
=======
- Sharing is not fully implemented, because it is not crucial for this kind of app. Moreover i doesn’t make sense to share weather via another service than Twitter and Facebook... 
- There are missing many images for weather (`Icon_Big.png`) - so i display only Windy, Cloudy, Sunny and Storm 
- RTLabel (3rd-party library) causes some warnings on 64bit iOS Devices: NSUInteger cannot be downcast to Int ( 64bit NSUInteger > Int )
- refresh weather on device **shake**

Dependencies:
=============
- **CocoaPods**
- **AFNetworking**
- RTLabel - can format

Used tools:
-----------
- Git & GitHub 
- Photoshop
- Spark Inspector
- Dash (documentation)
- StackOverflow
- Apple Documentation
