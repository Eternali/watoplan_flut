import 'package:watoplan/data/models.dart';

List<T> quicksort<T>(List<T> arr, int left, int right, SortCmp<T> cmp) {
  int idx = partition(arr, left, right, cmp);
  if (left < idx - 1) quicksort(arr, left, idx-1, cmp);
  if (right > idx) quicksort(arr, idx, right, cmp);
  // return arr;
  // if (arr.length <= 1) return arr;
  
  // T pivot = arr[0];
  // List<T> left = <T>[];
  // List<T> right = <T>[];
  
  // for (T a in arr) {
  //   cmp(a, pivot) ? left.add(a) : right.add(a);
  // }

  // return new List<T>.from(quicksort(left, cmp))..add(pivot)..addAll(quicksort(right, cmp));
}

int partition<T>(List<T> arr, int left, int right, SortCmp<T> cmp) {
  T pivot = arr[((left + right) / 2).floor()];
  int i = left;
  int j = right;
  while (i <= j) {
    while (cmp(arr[i], pivot)) i++;
    while (!cmp(arr[j], pivot)) j--;
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

typedef List<Activity> ActivitySort(List<Activity> activities);
typedef bool SortCmp<T>(T a, T b);

class ActivitySorters {

  static List<Activity> byStartTime(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);
    var arr = [5,1,2,8,2,];
    quicksort(arr, 0, arr.length-1, (a, b) => a < b);
    print(arr);

    return activities;
    // return quicksort(
    //   newActivities,
    //   (a, b) => a.data['start'].millisecondsSinceEpoch < b.data['start'].millisecondsSinceEpoch
    // );
  }

  static List<Activity> byEndTime(List<Activity> activities) {
    List<Activity> newActivities = new List.from(activities);

    // return quicksort(
    //   newActivities,
    //   (Activity a, Activity b) => a.data['end'].millisecondsSinceEpoch < b.data['end'].millisecondsSinceEpoch
    // );
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
