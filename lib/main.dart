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
          title: Text('及時AQI查詢'),
          backgroundColor: Colors.cyan[400],
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                
              },
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
  final Map<String, Color> AQIColors = {
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
                itemBuilder: (context, index) {
                  Color AQIColor = AQIColors[snapshot.data[index].aqi_status];

                  return Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: ListTile(
                      subtitle: Text(snapshot.data[index].aqi_status),
                      title: Text(
                        snapshot.data[index].siteName,
                        style: TextStyle(fontSize: 24, color: Colors.blue[400]),
                      ),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: AQIColor,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                                width: 1.5,
                                color: AQIColor,
                                style: BorderStyle.solid)),
                        child: Center(
                            child: Text(snapshot.data[index].aqi.toString(),
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white))),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (
                              (context) => AQIDetail(snapshot.data[index], AQIColor)
                            )
                          )
                        );
                        print('$index');
                      },
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              );
            } else {}

            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 10,
              backgroundColor: Colors.teal[100],
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
            ));
          }),
    );
  }
}

class AQIDetail extends StatelessWidget {
  final Station station;
  final Color status_color;

  AQIDetail(this.station, this.status_color) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(station.siteName),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "空氣品質：",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                station.aqi_status,
                style: TextStyle(
                  color: status_color,
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}