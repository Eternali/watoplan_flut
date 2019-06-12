## [0.10.0]

### New Features
- Added ability to filter by activity type, and type parameters.
- Added ability to order by creation time.
- Redesigned `ActivityCard` widget.
- Consolidated ways to create new activities by redesigning the creation floating action menu.
- Added support for flutter desktop embedding (i.e. WAToPlan can now be run as a desktop app!)
- Added ability to export database as a JSON file for backup.

## [0.9.11]

### Bugs Fixed:
- __CALENDAR__ is back and fixed (sorry for the barrage of issues)
- (__0012__) Parameter types have been completely reworked under the hood (automatic migration of the app db should work) and now notification editing across activities shouldn't be linked.

## [0.9.10]

### Bugs Fixed:
- (__0016__) Activities with a notification parameter could not be edited after creation (introduced in 0.9.9)
- homeLayout names are now backwards compatible (data can now be retained between updates)

## [0.9.9]

### New Features:
- The _CALENDAR_ home layout is here! you can now see all your time sensitive activities in a easy to read calendar view that supports both weekly and monthly views. There are still a few kinks to be worked out, but it works as intended for the most part.
- A check has been put in place so that if the database schema is detected to mismatch (due to a breaking update), the user can still access the menu to reset the app to its defaults.
- Small UI updates to improve consistency.

### Bugs Fixed:
- (__0014__ & __0015__) Push notifications now work as intended (they are deleted when the activity is deleted, and past notifications no longer show on reboot).
- (__0011__) The floating action menu animation duration length should always be consistent now (no more resets to 0).

### Modifications:
- Home layout system has been reworked under the hood.
- Drawer menu has been reworked to use custom radio buttons.

## [0.9.8]

### Modifications due to feedback:
- All app screens are now wrapped with a SafeArea to ensure notches do not hind content.
- 'SCHEDULE' was renamed to 'ORDER BY' in app drawer, hopefully to clear some confusion (note that I do intend to have different home layouts in the future, so hopefully this is just a temporary fix).

### New Features:
- An option was added to settings that enables the user to reset the app to defaults. The main use case for this is that if a bug in the app causes the database to get in an irrecoverable state, the user doesn't have to reinstall the app or manually delete the database file to get it back in a working order.

## [0.9.7]

### New Features:
- A new parameter type has been added that enables longer descriptions that support markdown for more detailed and structured notes.
  - A TODO type has been added to the default activity types that uses the new long description parameter (and some others have been updated to utilise it as well).

### Bugs Fixed:
- (__0013__) When activity types continue off the settings screen, the user is unable to add new types because the scrolling mechanic is overriden by the type listview.
- (__0014__) The activity type editing screen will allow the user to save even if the data is invalid, leading to an irrecoverable database state.

## [0.9.6]

### Bugs Fixed:
- (__0012__) When adding a new type, the appbar title is empty.

### New Features:
- A snackbar has been added that will slide into view upon deletion of an activity or activity type, it displays a summary of the deletion and provides an "undo" action that allows you to restore any data that was deleted.

### Minor Tweaks:
- Small changes to the activity card animation.
- The paddingon activity type cards is now matching.

## [0.9.5]

### Bugs Fixed:
- (__0010__) When changing or adding an activity, the home page sorting won't be updated until it is visited for a second time.

### Dev Additions:
- A refresh mechanism was added to the app state so if an untracked modification occurs, we can manually trigger an update to the widget tree.

## [0.9.4]

### Bugs Fixed:
- If an activity type that has attached activities is removed, the app will get into an irreversible bad state.

## [0.9.3]

### Bugs Fixed:
- Notifications are now updated when the activity time changes, and all notification changes now correctly reschedule themselves.

## [0.9.2]

### Bugs Fixed:
- Notifications now will display in their proper units (no longer just minutes)
