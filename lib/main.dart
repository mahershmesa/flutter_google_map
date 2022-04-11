//import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_map/pharmacy_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

 // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const MyHomePage(),
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




 List<Marker> allmarker=[];

late PageController _pageController;
late int prevPage;

@override
void initState() {
  super.initState();
  for (var element in pharmacys) {
  allmarker.add(Marker(markerId: MarkerId(element.shName),
  draggable: false,
  infoWindow: InfoWindow(
  title: element.shName,snippet: element.address
  ),
  position: element.locationCoords
  ));
}  

_pageController = PageController(initialPage: 1,viewportFraction: 0.8)
..addListener(_onScroll);
}

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      moveCamera();
    }
  }



_csList(index){
  return AnimatedBuilder(
    animation: _pageController,
      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      builder: (BuildContext context, Widget ){
        double value=1;
        if (_pageController.position.haveDimensions){
        value = (_pageController.page! - index);
         value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        pharmacys[index].thumbNail),
                                      fit: BoxFit.cover))),
                          const SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pharmacys[index].shName,
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  pharmacys[index].address,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 170.0,
                                  child: Text(
                                    pharmacys[index].description,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Maps'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                    target: LatLng(40.7128, -74.0060), zoom: 12.0),
                markers: Set.from(allmarker),
                onMapCreated: mapCreated,
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: SizedBox(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pharmacys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _csList(index);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: pharmacys[_pageController.page!.toInt()].locationCoords,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}