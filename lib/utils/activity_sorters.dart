import 'package:watoplan/data/models.dart';

/* Simple, generic implementation of the QuickSort algorithm */

int partition(List array, int begin, int end) {
  int tmp;
  int pivot = begin;
  for (int i in List<int>.generate((end-begin).abs(), (i) => i + begin + 1)) {
    if (array[i] <= array[begin]) {
      pivot += 1;
      tmp = array[i];
      array[i] = array[pivot];
      array[pivot] = tmp;
    }
  }
  tmp = array[pivot];
  array[pivot] = array[begin];
  array[begin] = tmp;
  return pivot;
}

List quicksort(List arr) {
  if (arr.length <= 1) return arr;
  
  int pivot = arr[0];
  List left = [];
  List right = [];
  
  for (int i = 0; i < arr.length; i++) {
    arr[i] < pivot ? left.add(arr[i]) : right.add(arr[i]);
  }

  return quicksort(left) + [pivot] + quicksort(right);
}

List slowsexysort(List arr) {
  if (arr.length <= 1) return arr;
  return slowsexysort(
    arr.where((a) => a < arr[0]).toList() +
    arr.where((a) => a == arr[0]).toList() +
    arr.where((a) => a > arr[0]).toList()
  );
}

typedef List<Activity> ActivitySort(List<Activity> activities);

class ActivitySorters {

  static List<Activity> byStartTime(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    return newActivities;
  }

  static List<Activity> byEndTime(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    return newActivities;
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
