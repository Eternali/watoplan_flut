import 'package:watoplan/data/models.dart';

List<T> quicksort<T>(List<T> arr, int left, int right, SortCmp<T> cmp) {
  int idx = partition<T>(arr, left, right, cmp);
  if (left < idx - 1) quicksort(arr, left, idx - 1, cmp);
  if (right > idx) quicksort(arr, idx, right, cmp);
}

int partition<T>(List<T> arr, int left, int right, SortCmp<T> cmp) {
  T pivot = arr[((left + right) / 2).floor()];
  int i = left;
  int j = right;
  while (i <= j) {
    while (cmp(arr[i], pivot, true)) i++;
    while (cmp(arr[j], pivot, false)) j--;
    if (i <= j) {
      T tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
      i++;
      j--;
    }
  }
  return i;
}

typedef List<Activity> ActivitySort(List<Activity> activities, [ bool rev ]);
typedef bool SortCmp<T>(T a, T b, bool dir);

class ActivitySorters {

  static List<Activity> byStartTime(List<Activity> activities, [ bool rev = false ]) {
    List<Activity> newActivities = new List.from(activities);

    quicksort(
      newActivities,
      0, newActivities.length - 1,
      (a, b, dir) {
        if (a.data.containsKey('start') && b.data.containsKey('start')) {
          return rev == dir
            ? a.data['start'].millisecondsSinceEpoch < b.data['start'].millisecondsSinceEpoch
            : a.data['start'].millisecondsSinceEpoch > b.data['start'].millisecondsSinceEpoch;
        } else return !dir;
      }
    );

    return newActivities;
  }

  static List<Activity> byEndTime(List<Activity> activities, [ bool rev = false ]) {
    List<Activity> newActivities = new List.from(activities);

    quicksort(
      newActivities,
      0, newActivities.length - 1,
      (a, b, dir) {
        if (a.data.containsKey('end') && b.data.containsKey('end')) {
          return rev == dir
            ? a.data['end'].millisecondsSinceEpoch < b.data['end'].millisecondsSinceEpoch
            : a.data['end'].millisecondsSinceEpoch > b.data['end'].millisecondsSinceEpoch;
        } else return !dir;
      }
    );

    return newActivities;
  }

  static List<Activity> byPriority(List<Activity> activities, [ bool rev = false ]) {
    List<Activity> newActivities = new List.from(activities);

    quicksort(
      newActivities,
      0, newActivities.length - 1,
      (a, b, dir) {
        if (a.data.containsKey('priority') && b.data.containsKey('priority')) {
          return rev == dir
            ? a.data['priority'] < b.data['priority']
            : a.data['priority'] > b.data['priority'];
        } else return !dir;
      }
    );

    return newActivities;
  }

  static List<Activity> byProgress(List<Activity> activities, [ bool rev = false ]) {
    List<Activity> newActivities = new List.from(activities);

    quicksort(
      newActivities,
      0, newActivities.length - 1,
      (a, b, dir) {
        if (a.data.containsKey('progress') && b.data.containsKey('progress')) {
          return rev == dir
            ? a.data['progress'] < b.data['progress']
            : a.data['progress'] > b.data['progress'];
        } else return !dir;
      }
    );

    return newActivities;
  }

  // order activities by type where type order is determined by
  // the number of activities associated with each type.
  static List<Activity> byType(List<Activity> activities, [ bool rev = false ]) {
    List<Activity> newActivities = new List.from(activities);

    List<int> typeIds = newActivities.map((activity) => activity.typeId).toList();
    Map<int, int> typeOrder = new Map.fromIterable(
      typeIds.map((id) => new MapEntry(id, typeIds.where((i) => i == id).length)),
      key: (entry) => entry.key,
      value: (entry) => entry.value,
      );

    quicksort(
      newActivities,
      0, newActivities.length - 1,
      (a, b, dir) => rev == dir
        ? typeOrder[a.typeId] < typeOrder[b.typeId]
        : typeOrder[a.typeId] > typeOrder[b.typeId]
    );

    return newActivities;
  }

}
