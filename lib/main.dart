import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({ Key? key, required String title }) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   Completer<GoogleMapController> _controller = Completer();
//   late GoogleMapController controller;
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//   late List<Marker>allmarker=[];

//     @override
//   void initState() {
//     super.initState();
//     allmarker.add(Marker(markerId: MarkerId("my marker"),
//     draggable: false,
//     onTap:(){
//     print("marker tapeed");
//     } ,
//     position: LatLng(37.42796133580664, -122.085749655962)
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       child: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         markers: Set.from(allmarker),//EXPORT
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // MyHomePage({Key? key, String title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -50.0,
            child: GoogleMap(
          initialCameraPosition:CameraPosition(
            target: LatLng(37.42796133580664, -122.085749655962),
            zoom: 14.4746,
          ),
          onMapCreated:MapCreated ,
            ),
          )
        ],
      ),
    );
  }
  void MapCreated(controller){
    setState(() {
      _controller = controller;
    });
  }
}