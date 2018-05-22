0.9.2
-----

### Bugs Fixed:
- Notifications now will display in their proper units (no longer just minutes)

0.9.3
-----

### Bugs Fixed:
- Notifications are now updated when the activity time changes, and all notification changes now correctly reschedule themselves.

0.9.4
-----

### Bugs Fixed:
- If an activity type that has attached activities is removed, the app will get into an irreversible bad state.

0.9.5
-----

### Bugs Fixed:
- (__0010__) When changing or adding an activity, the home page sorting won't be updated until it is visited for a second time.

### Dev Additions:
- A refresh mechanism was added to the app state so if an untracked modification occurs, we can manually trigger an update to the widget tree.

0.9.6
-----

### Bugs Fixed:
- (__0012__) When adding a new type, the appbar title is empty.

### New Features:
- A snackbar has been added that will slide into view upon deletion of an activity or activity type, it displays a summary of the deletion and provides an "undo" action that allows you to restore any data that was deleted.

### Minor Tweaks:
- Small changes to the activity card animation.
- The paddingon activity type cards is now matching.

0.9.7
-----

### New Features:
- A new parameter type has been added that enables longer descriptions that support markdown for more detailed and structured notes.
    - A TODO type has been added to the default activity types that uses the new long description parameter (and some others have been updated to utilise it as well).

### Bugs Fixed:
- (__0013__) When activity types continue off the settings screen, the user is unable to add new types because the scrolling mechanic is overriden by the type listview.
- (__0014__) The activity type editing screen will allow the user to save even if the data is invalid, leading to an irrecoverable database state.