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
