class Station {
  String siteName;
  String aqi_status;
  int aqi;

  Station({this.siteName});

  Station.fromJson(Map<String, dynamic> json) {
    siteName = json['SiteName'];
    aqi = int.tryParse(json['AQI']) ?? -1;
    aqi_status = json['Status'];
  }
}
