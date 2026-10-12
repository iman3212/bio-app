
// Color.fromRGBO(234, 170, 68, 1)

import 'package:flutter_blue/flutter_blue.dart';

import '../res/strings.dart';
import '../res/styles.dart';
import 'package:flutter/material.dart';

class PairedDevices extends StatefulWidget {
  @override
  _PairedDevicesState createState() => _PairedDevicesState();
}

class _PairedDevicesState extends State<PairedDevices> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FlutterBlue.instance
        .startScan(timeout: Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color.fromRGBO(49, 55, 96, 1),
                const Color.fromRGBO(83, 66, 105, 1),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          children: <Widget>[

            SizedBox(height: 42),

            Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: (){
                  Navigator.pop(context);
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 6,left: 8),
                  child: Text(Strings.pairedDevices,style: Styles.h0StyleWhite,),
                ),
              ],
            ),

            SizedBox(height: 16),
            RefreshIndicator(
              onRefresh: () =>
                  FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    StreamBuilder<List<BluetoothDevice>>(
                      stream: Stream.periodic(Duration(seconds: 2))
                          .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                      initialData: [],
                      builder: (c, snapshot) => Column(
                        children: snapshot.data
                            .map((d) => ListTile(
                          title: Text(d.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20)),
                          subtitle: Text(d.id.toString()),
                          trailing: StreamBuilder<BluetoothDeviceState>(
                            stream: d.state,
                            initialData: BluetoothDeviceState.disconnected,
                            builder: (c, snapshot) {
                              if (snapshot.data ==
                                  BluetoothDeviceState.connected) {
                                return RaisedButton(
                                  child: Text('OPEN'),
                                  onPressed: () => Navigator.pop(context,d),
                                );
                              }
                              return Text(snapshot.data.toString());
                            },
                          ),
                        ))
                            .toList(),
                      ),
                    ),

                    StreamBuilder<List<ScanResult>>(
                      stream: FlutterBlue.instance.scanResults,
                      initialData: [],
                      builder: (c, snapshot) => Column(
                        children: snapshot.data
                            .map(
                              (r) => ScanResultTile(
                            result: r,
                            onTap: () => Navigator.pop(context,r.device),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop,color: Color.fromRGBO(234, 170, 68, 1),),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.white,
            );
          } else {
            return FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(Icons.search,color: Color.fromRGBO(234, 170, 68, 1)),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }

}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, @required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),
          ),
          Text(
            result.device.id.toString(),
            style: TextStyle(color: Colors.white,fontSize: 12),
          )
        ],
      );
    } else {
      return Text(result.device.id.toString(),style: TextStyle(color: Colors.white),);
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      trailing: RaisedButton(
        child: Text('CONNECT'),
        color: Colors.transparent,
        textColor: Colors.white,
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
    );
  }
}

