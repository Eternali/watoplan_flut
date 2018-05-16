import 'package:flutter/foundation.dart';

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

  static void printUnsorted(String name, List<Activity> unsorted) {
    debugPrint('${name.toUpperCase()}: Left ${unsorted.length} activities unsorted.');
  }

  static List<Activity> byStartTime(List<Activity> activities, [ bool rev = false ]) {
    List sorted = <Activity>[], unsorted = <Activity>[];
    // I hate how Dart does not promote type safety or functional programming with functors
    // since all their List methods will only return an Iterable<dynamic>, which is a bitch to convert for some reason.
    activities.forEach((act) {
      if (act.data.containsKey('start')) sorted.add(act);
      else unsorted.add(act);
    });
    if (unsorted.length > 0) printUnsorted('start', unsorted);
    if (sorted.length < 1) return activities;

    quicksort(
      sorted,
      0, sorted.length - 1,
      (a, b, dir) {
        return rev == dir
          ? a.data['start'].millisecondsSinceEpoch < b.data['start'].millisecondsSinceEpoch
          : a.data['start'].millisecondsSinceEpoch > b.data['start'].millisecondsSinceEpoch;
      }
    );

    return sorted..addAll(unsorted);
  }

  static List<Activity> byEndTime(List<Activity> activities, [ bool rev = false ]) {
    List sorted = <Activity>[], unsorted = <Activity>[];
    // I hate how Dart does not promote type safety or functional programming with functors
    // since all their List methods will only return an Iterable<dynamic>, which is a bitch to convert for some reason.
    activities.forEach((act) {
      if (act.data.containsKey('end')) sorted.add(act);
      else unsorted.add(act);
    });
    if (unsorted.length > 0) printUnsorted('end', unsorted);    
    if (sorted.length < 1) return activities;    

    quicksort(
      sorted,
      0, sorted.length - 1,
      (a, b, dir) {
        return rev == dir
          ? a.data['end'].millisecondsSinceEpoch < b.data['end'].millisecondsSinceEpoch
          : a.data['end'].millisecondsSinceEpoch > b.data['end'].millisecondsSinceEpoch;
      }
    );

    return sorted..addAll(unsorted);
  }

  static List<Activity> byPriority(List<Activity> activities, [ bool rev = false ]) {
    List sorted = <Activity>[], unsorted = <Activity>[];
    // I hate how Dart does not promote type safety or functional programming with functors
    // since all their List methods will only return an Iterable<dynamic>, which is a bitch to convert for some reason.
    activities.forEach((act) {
      if (act.data.containsKey('priority')) sorted.add(act);
      else unsorted.add(act);
    });
    if (unsorted.length > 0) printUnsorted('priority', unsorted);
    if (sorted.length < 1) return activities;    

    quicksort(
      sorted,
      0, sorted.length - 1,
      (a, b, dir) {
        return rev == dir
          ? a.data['priority'] < b.data['priority']
          : a.data['priority'] > b.data['priority'];
      }
    );

    return sorted..addAll(unsorted);
  }

  static List<Activity> byProgress(List<Activity> activities, [ bool rev = false ]) {
    List sorted = <Activity>[], unsorted = <Activity>[];
    // I hate how Dart does not promote type safety or functional programming with functors
    // since all their List methods will only return an Iterable<dynamic>, which is a bitch to convert for some reason.
    activities.forEach((act) {
      if (act.data.containsKey('progress')) sorted.add(act);
      else unsorted.add(act);
    });
    if (unsorted.length > 0) printUnsorted('progress', unsorted);
    if (sorted.length < 1) return activities;
    
    quicksort(
      sorted,
      0, sorted.length - 1,
      (a, b, dir) {
        return rev == dir
          ? a.data['progress'] < b.data['progress']
          : a.data['progress'] > b.data['progress'];
      }
    );

    return sorted..addAll(unsorted);
  }

  // order activities by type where type order is determined by
  // the number of activities associated with each type.
  static List<Activity> byType(List<Activity> activities, [ bool rev = false ]) {
    if (activities.length < 1) return activities;
    List<Activity> sorted = new List.from(activities);

    List<int> typeIds = sorted.map((activity) => activity.typeId).toList();
    Map<int, int> typeOrder = new Map.fromIterable(
      typeIds.map((id) => new MapEntry(id, typeIds.where((i) => i == id).length)),
      key: (entry) => entry.key,
      value: (entry) => entry.value,
      );

    quicksort(
      sorted,
      0, sorted.length - 1,
      (a, b, dir) => rev == dir
        ? typeOrder[a.typeId] < typeOrder[b.typeId]
        : typeOrder[a.typeId] > typeOrder[b.typeId]
    );

    return sorted;
  }

}
