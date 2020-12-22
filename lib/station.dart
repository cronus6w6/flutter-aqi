class Station {
  String siteName;
  String aqi_status;
  int aqi;
  String pm25;
  String pm10;
  String windSpeed;

  Station({this.siteName});

  Station.fromJson(Map<String, dynamic> json) {
    siteName = json['SiteName'];
    aqi = int.tryParse(json['AQI']) ?? -1;
    aqi_status = json['Status'];
    pm25 = json['PM2.5'] ?? "無";
    pm10 = json['PM10'] ?? "無";
    windSpeed = json["WindSpeed"] ?? '無';
  }
}
