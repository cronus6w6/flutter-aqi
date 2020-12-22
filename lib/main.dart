import 'package:HW/aqi_service.dart';
import 'package:HW/station.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('即時 AQI 查詢'),
          backgroundColor: Colors.blue[200],
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AQIList(),
    );
  }
}

class AQIList extends StatefulWidget {
  @override
  _AQIListState createState() => _AQIListState();
}

class _AQIListState extends State<AQIList> {
  final Map<String, Color> aqiColors = {
    "良好": Colors.green,
    "普通": Colors.yellow[700],
    "對敏感族群不健康": Colors.orange[700],
    "對所有族群不健康": Colors.red[900],
    "非常不健康": Colors.purple[800],
    "危害": Colors.brown
  };

  Future<List<Station>> futureStationList;

  @override
  void initState() {
    super.initState();
    futureStationList = fetchAQI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Station>>(
        future: futureStationList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(5),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Color aqiColor = aqiColors[snapshot.data[index].aqi_status];

                return Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: ListTile(
                    subtitle: Text(snapshot.data[index].aqi_status),
                    title: Text(
                      snapshot.data[index].siteName,
                      style: TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: aqiColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                            width: 1.5,
                            color: aqiColor,
                            style: BorderStyle.solid),
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data[index].aqi.toString(),
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) =>
                              AQIDetail(snapshot.data[index], aqiColor)),
                        ),
                      );
                    },
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          } else {}

          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
              backgroundColor: Colors.blue[100],
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[600]),
            ),
          );
        },
      ),
    );
  }
}

class AQIDetail extends StatelessWidget {
  final Station station;
  final Color statusColor;

  AQIDetail(this.station, this.statusColor) : super();

  @override
  Widget build(BuildContext context) {
    const detailBorder = BorderSide(width: 1.0, color: Colors.black12);
    const detailDecoration =
        BoxDecoration(border: Border(bottom: detailBorder));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text(station.siteName),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "空氣品質：",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                width: double.infinity,
                decoration: detailDecoration,
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  station.aqi_status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 40,
                  ),
                ),
              ),
              DetailRow("AQI", station.aqi.toString(), ""),
              DetailRow("PM2.5", station.pm25, "μg/m3"),
              DetailRow("PM10", station.pm10, "μg/m3"),
              DetailRow("風速", station.windSpeed, "m/sec"),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  DetailRow(this.title, this.value, this.unit) : super();

  @override
  Widget build(BuildContext context) {
    const detailBorder = BorderSide(width: 1.0, color: Colors.black12);
    const detailDecoration =
        BoxDecoration(border: Border(bottom: detailBorder));
    const detailPadding = EdgeInsets.only(top: 10, bottom: 10);
    return Container(
      width: double.infinity,
      padding: detailPadding,
      decoration: detailDecoration,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blue[900],
            ),
            child: Text(
              this.title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            this.value + " " + this.unit,
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }
}
