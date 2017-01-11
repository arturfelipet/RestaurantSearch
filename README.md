Restaurant Search Project


1) Platform and Language used

I choose to implement on iOS/Objective-C because it’s the platform/language i have most knowledge.


2) How to Use ?

- First time you open the app you need to register or login
- A list of restaurants nearby will be shown, touch one of the restaurants to vote in it.
- Touch “Display Restaurants on Map” to check the location of all the restaurants in a map view
- Touch “Display chosen restaurants” to list which restaurants were chosen in the current week.
- Touch “Votes” button to check the votes on current day.
- Touch “Logout” to go back to the SignIn/Login view.


3) Logic/code writing style

I trend to try to code as much low coupling and high cohesion i can with my current knowledge and the measured time to each task.

The code is divided in 3 main blocks: UI, Business and Infrastructure.

- UI: have UI views/controllers and some design patterns that help to organize. To keep code clean i used a view factory so its easier to change screen flows if needed as no viewController knows the existence of the other views.

- Business: every business related rules are implemented and organized in some data managers and commands.

- Infrastructure: third party components and lower level base classes are normally on this block.


4) APIs

- For maps it’s used Google Maps API.
- Restaurant data comes from Google Places API.
- The cloud database is Firebase Realtime Database.

The Project started with Apple’s Core Data but like business rules needed API vote support or realtime sync cloud database for voting or use of a server. So after some research i found Firebase Realtime Database, decided to try it out and got really surprised how well it works and how easy to integrate and use it was.

Push Notification is implemented using just a local reminder of when the vote time ends each day, a couple of minutes later it is fired to remind the user to open the application to check the most voted restaurant for the day.

To use RemotePushNotification i would probably need to code a simple server to check the current firebase database to fire the remote push notification with the restaurant chosen.


5) What could be better and implemented in the future 

- The UI, it’s a really simple and not that pretty user friendly UI. The time i had was dedicated to research, implement business rules and keep code functional, clean, organized and easier to read.
- Better exceptions care.
- Implement a server to check choose restaurant and send the chosen restaurant name direct in the daily notification for each user.
- Localization Support, right now every message is hardcoded.
- Group/teams implementation so it can have more teams instead of considering just one team.
- Show more restaurant details so it’s easier to choose one.

6) Business Rules Implemented:

- Users can see a list of restaurants geographically located nearby.
- Users can see if and how many votes the restaurants appearing in the list have had on the current day.
- Users can only cast one vote per day.
- A restaurant cannot be chosen more than once on the same week.
- Users can see the most voted restaurants on the day any time on the current day, even after vote time ends.
- The votes schedule is set in Business/config/ConstantsBusiness.h. it’s set by default to accept votes from 8:00 until 12:00 and 12:15 it shows the most voted restaurant.
- Users get notified about the chosen restaurant when the daily deadline is reached.
- Tried to have support to most iOS versions possible so it supports iOS 8 above.


