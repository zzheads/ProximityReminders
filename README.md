# [ProximityReminders](https://teamtreehouse.com/projects/proximity-reminders)
<img src="reminders.png" width="250">

[![Platform](https://img.shields.io/cocoapods/p/SwiftLocation.svg?style=flat)](http://cocoadocs.org/docsets/SwiftLocation)
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-orange.svg?style=flat" alt="Swift 3 compatible" /></a>
[![StackShare](https://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](https://stackshare.io/zzheads/zzheads-at-gmail-com) [![Build Status](https://travis-ci.org/Jintin/Swimat.svg?branch=master)](https://travis-ci.org/Jintin/Swimat)



- [ ] The main screen is a table view with reminders. You can tap to add a new reminder.
- [ ] When adding a reminder the user can choose to be reminded of when leaving or entering the hard-coded location.
- [ ] When the user is about to leave or enter the location they must be prompted with a location notification of the reminder.
- [ ] App layout is exceptionally creative.
- [ ] Add the ability to add a location when creating the reminder (see the stock Reminder app for functionality).
- [ ] Add the ability to search and associate a location when creating the reminder.
- [ ] Add the ability to display the location on the map.
- [ ] Add the ability to display a geo-fenced circle around the location.
- [ ] Exceptional code quality.


<img src="/ProximityReminders/Assets.xcassets/shot_01.imageset/shot_01.png" width="250">
<img src="/ProximityReminders/Assets.xcassets/shot_02.imageset/shot_02.png" width="250">

iOS app built for users who needs have reminder/reminders when get in some defined location area or get out from it.
You can have any number of such reminders/locations. Process of creating location or reminder is pretty easy, 
for create location you can enter address/placemark/coordinates (latitude, longitude) to determine location. 
Program, if search was successfull, will draw that defined location on map. After that, all you need is give that location
the title and press "Done" to save it for future using in your reminders. Reminder is location plus notification, 
which will be pushed when user getin/getout to/from that location.

<img src="/ProximityReminders/Assets.xcassets/shot_04.imageset/shot_04.png" width="250">
<img src="/ProximityReminders/Assets.xcassets/shot_05.imageset/shot_05.png" width="250">

######Application uses Realm mobile database engine.[More info about it](https://realm.io)
