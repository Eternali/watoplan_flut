import 'package:flutter/foundation.dart';

import 'package:watoplan/data/activity.dart';

final Map<String, ActivitySort> validSorts = {
  'edited': ActivitySorters.byEdited,
  'creation': ActivitySorters.byCreation,
  'start': ActivitySorters.byStartTime,
  'end': ActivitySorters.byEndTime,
  'priority': ActivitySorters.byPriority,
  'progress': ActivitySorters.byProgress,
  'type': ActivitySorters.byType,
};

typedef List<Activity> ActivitySort(List<Activity> activities, [ bool rev ]);

class ActivitySorters {

  static void printUnsorted(String name, List<Activity> unsorted) {
    debugPrint('${name.toUpperCase()}: Left ${unsorted.length} activities unsorted.');
  }

  static List<Activity> byEdited(List<Activity> activities, [ bool rev = false ]) {
    return activities..sort((Activity a, Activity b) {
      final int sort = a.edited == b.edited ? 0 : a.edited > b.edited ? -1 : 1;
      return rev ? -sort : sort;
    });
  }

  static List<Activity> byCreation(List<Activity> activities, [ bool rev = false ]) {
    return activities..sort((Activity a, Activity b) {
      final int sort = a.creation == b.creation ? 0 : a.creation > b.creation ? 1 : -1;
      return rev ? -sort : sort;
    });
  }

  static List<Activity> byStartTime(List<Activity> activities, [ bool rev = false ]) {
    return activities..sort((Activity a, Activity b) {
      // if the activity does not contain the sort parameter, make sure it moves towards the end of the list.
      if (!a.data.containsKey('start')) return 1;
      else if (!b.data.containsKey('start')) return -1;

      final sort = a.data['start'].millisecondsSinceEpoch - b.data['start'].millisecondsSinceEpoch;
      return rev ? -sort : sort;
    });
  }

  static List<Activity> byEndTime(List<Activity> activities, [ bool rev = false ]) {
    return activities..sort((Activity a, Activity b) {
      // if the activity does not contain the sort parameter, make sure it moves towards the end of the list.
      if (!a.data.containsKey('end')) return 1;
      else if (!b.data.containsKey('end')) return -1;

      final sort = a.data['end'].millisecondsSinceEpoch - b.data['end'].millisecondsSinceEpoch;
      return rev ? -sort : sort;
    });
  }

  static List<Activity> byPriority(List<Activity> activities, [ bool rev = false ]) {
    return activities..sort((Activity a, Activity b) {
      // if the activity does not contain the sort parameter, make sure it moves towards the end of the list.
      if (!a.data.containsKey('priority')) return 1;
      else if (!b.data.containsKey('priority')) return -1;

      final sort = a.data['priority'] - b.data['priority'];
      return rev ? -sort : sort;
    });
  }

  static List<Activity> byProgress(List<Activity> activities, [ bool rev = false ]) {
    return activities..sort((Activity a, Activity b) {
      // if the activity does not contain the sort parameter, make sure it moves towards the end of the list.
      if (!a.data.containsKey('progress')) return 1;
      else if (!b.data.containsKey('progress')) return -1;

      final sort = a.data['progress'] - b.data['progress'];
      return rev ? -sort : sort;
    });
  }

  // order activities by type where type order is determined by
  // the number of activities associated with each type.
  static List<Activity> byType(List<Activity> activities, [ bool rev = false ]) {
    final typeIds = activities.map((activity) => activity.typeId);
    Map<int, int> typeOrder = Map.fromIterable(
      typeIds.map((id) => MapEntry(id, typeIds.where((i) => i == id).length)),
      key: (entry) => entry.key,
      value: (entry) => entry.value,
    );
    return activities..sort((Activity a, Activity b) {
      final sort = typeOrder[b.typeId] - typeOrder[a.typeId];
      return rev ? -sort : sort;
    });
  }

}
