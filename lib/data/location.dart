class Location {
  
  double lat;
  double long;

  Location({ this.lat, this.long });

  Location.fromJson(Map<String, dynamic> jsonMap) {
    lat = jsonMap['lat'];
    long = jsonMap['long'];
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'long': long,
  };

}