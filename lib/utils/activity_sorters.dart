import 'package:watoplan/data/models.dart';

List<T> quicksort<T>(List<T> arr, SortCmp<T> cmp) {
  if (arr.length <= 1) return arr;
  
  T pivot = arr[0];
  List<T> left = <T>[];
  List<T> right = <T>[];
  
  for (int i = 0; i < arr.length; i++) {
    cmp(arr[i], pivot) ? left.add(arr[i]) : right.add(arr[i]);
  }

  return new List<T>.from(quicksort(left, cmp))..add(pivot)..addAll(quicksort(right, cmp));
}

typedef List<Activity> ActivitySort(List<Activity> activities);
typedef bool SortCmp<T>(T a, T b);

class ActivitySorters {

  static List<Activity> byStartTime(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    return quicksort(
      newActivities,
      (Activity a, Activity b) => a.data['start'].millisecondsSinceEpoch < b.data['start'].millisecondsSinceEpoch
    );
  }

  static List<Activity> byEndTime(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    return quicksort(
      newActivities,
      (Activity a, Activity b) => a.data['end'].millisecondsSinceEpoch < b.data['end'].millisecondsSinceEpoch
    );
  }

  static List<Activity> byPriority(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    return newActivities;
  }

  static List<Activity> byProgress(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    return newActivities;
  }

  static List<Activity> byType(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    return newActivities;
  }

}
