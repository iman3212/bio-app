
import 'dart:convert';
import 'package:bio/view/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


import '../network/server.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({Key key}) : super(key: key);

  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {

  List convertList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [

          SizedBox(height: 4,),

          if(isLoading)...[
            Expanded(child: Center(child: SizedBox(width: 25,height: 25,child: CircularProgressIndicator(color: Colors.white70,strokeWidth: 1.2,))))
          ]  else if(convertList.isEmpty) ...[
            Expanded(child: Center(child: Text('No Item', style: TextStyle(color: Colors.white70),)))
          ] else ... [
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var item = convertList[index];
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16,right: 16,top: 14),
                      child: new ExpansionTile(
                        collapsedBackgroundColor: Color(0xFF525078),
                        collapsedIconColor: Color(0xFFE9AA43),
                        collapsedTextColor: Color(0xFFE9AA43),
                        iconColor: Color(0xFFE9AA43),
                        textColor: Colors.white,
                        title: new Text(
                          '${item['title']}',
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(fontSize: 19, color: Colors.white),
                        ),
                        backgroundColor: Color(0xFF525078),
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              '${item['status'] == true ? 'Converted to G-code' : 'In progress...'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                  fontSize: 19,color: item['status']
                                  ? Colors.green
                                  : Colors.red, fontWeight: FontWeight.w600),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: new Text(
                              '${item['created_at'].toString().substring(0, 25)}',
                              style: TextStyle(color: Colors.white70,fontSize: 12),
                            ),
                          ),

                          item['status'] == true
                              ? Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFE9AA43),
                              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // downloadData(item['stl_file_name']
                                    //     .toString()
                                    //     .substring(
                                    //     0,
                                    //     item['stl_file_name']
                                    //         .toString()
                                    //         .indexOf('.')));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
                                    child: Text(
                                      'Send to printer',
                                      style: TextStyle(color: Colors.white,fontSize: 17, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : SizedBox()
                        ],
                      ),
                    ),
                  );
                },
                itemCount: convertList.length,
              ),
            ),
          ],

          SizedBox(height: 16,),

        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: new Color(0xFFE57373),
            onPressed: () async{
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadScreen()));
              if(result != null){
                fetchData();
              }
            }
        ),
      ),
    );
  }

  void fetchData() async {

    setState(() {
      isLoading = true;
    });
    var respons = SendData().getData('uplodeFile');
    respons.then((value) {
      var jsonRespoinse = jsonDecode(utf8.decode(value.bodyBytes));
      print(jsonRespoinse);

      convertList = [];
      convertList.clear();

      for (var item in jsonRespoinse['data']) {
        // print(item['stl_sfile_name']);
        convertList.add(item);
      }
      setState(() {
        isLoading = false;
      });

    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    });
  }

}
