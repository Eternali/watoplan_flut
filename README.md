# WAToPlan

This is the source for the WAToPlan app (currently in closed Beta on Google Play).
It's A simple, yet flexible time management app.

## Summary

WAToPlan is a flexible and unique time management solution. It allows users to define their own categories of activities they have to do. Activities such as reminders, events, meetings, and assessments are defined by default, but it is extremely simple to define your own. Categories allow you to easily group activities visually, as well as define what data they each deal with. WAToPlan also provides several different ways to sort and view your activities to make it easier than ever to see what needs to be done. If you are sick of the data constraints forced on you by other solutions, look no further.

## App Usage Guide
The main home screen displays the list of activities as such:
- Sorted according to the sorter specified by opening the app drawer and choosing an attribute to sort on.
- Each activity is displayed as such:
    - leading: activity type icon
    - title: activity name / description (if no name specified)
    - subtitle: activity description
    - trailing:
        - top: start time
        - mid: notification icon if notifications are set for the activity
        - bottom: end time
    - background:
        - color: activity type color
        - opacity: activity priority
        - border width indicates progress
- swipe an activity to delete it
- The add button (at bottom right) allows you to add new activities
    - only the 4 most used types are shown, for an entire list of the possible types, see the add button in the appbar
The about page shows app information and important links for feedback and further information
The settings page allows you to change the theme and add/change/remove activity types.
__NOTE:__ If the app ever becomes corrupted due to the database getting into an irrecoverable state, the menu in the settings appbar has an action that will completely reset the app (along with any user data) which should fix any portions of the app that may have been corrupted.

## Installation
If you do not want to go through Google Play, you can manually build the app from source:

1. clone this repository: ```git clone https://github.com/eternali/watoplan_flut.git```
2. Install Flutter from https://github.com/flutter/flutter
3. change into the app directory: ```cd watoplan_flut```
4. Build:
    - Android: ```flutter build apk --flavor free```
    - IOS: ```flutter build ios --flavor free```
        - __NOTE__: Since I don't own a mac, I am reliant on the generosity of others to let me know how the IOS version is working. So if there's something wrong with it, please let me know.
