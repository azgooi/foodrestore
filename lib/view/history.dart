import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:foodrestore/service/route.dart';
import 'package:foodrestore/view/status.dart';


class HistoryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Request'),
      ),
      body: StreamBuilder (
          stream: getUsersRequestsStreamSnapshots(context),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData) return Text("No Record Found!");

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildListView(context, snapshot.data!.docs[index])
            );
          }
      ),
    );
  }

  Stream<QuerySnapshot> getUsersRequestsStreamSnapshots(BuildContext context) async* {
    DateTime now = DateTime.now();
    DateTime ytd = DateTime.utc(now.year,now.month,now.day -1);
    final uid = await Provider.of(context)!.auth.getCurrentUID();
    yield* FirebaseFirestore.instance.collection('userData').doc(uid)
        .collection('requests').where('date',isLessThanOrEqualTo: ytd).snapshots();
  }

  Widget buildListView(BuildContext context, DocumentSnapshot requests) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 2,
        color: Colors.blueAccent.shade400,
        child: ListTile(
          leading: SizedBox(
            width: 80,
            height: 80,
            child: GetImage(
              image: requests['imageUrl'],
              type: requests['type'],
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
                    requests['name'],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )
                )
            ),
          ),
          subtitle: Center(
              child: Text(
                  "${DateFormat('dd-MM-yyyy').format(requests['date'].toDate()).toString()}" + ", " + requests['timeslot'],
                  style: TextStyle(
                      color: Colors.lightBlueAccent.shade100,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  )
              )
          ),
          trailing: Icon(
            Icons.check_circle,
            color: Colors.lightBlueAccent.shade100,
            size: 25,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatusPage(requests: requests))
            );
          },
        ),
      ),
    );
  }
}

//Get Image for request
class GetImage extends StatelessWidget {
  final String image;
  final String type;

  const GetImage({required this.image, required this.type});

  @override
  Widget build(BuildContext context) {

    //Define food type
    getType(String index) {
      switch(index){
        case "Bread & Pastries":
          return Image.asset('assets/images/food/bread.png', fit: BoxFit.contain);
        case "Fruits & Vegetables":
          return Image.asset('assets/images/food/fruits.png', fit: BoxFit.contain);
        case "Fish & Poultry":
          return Image.asset('assets/images/food/fish.png', fit: BoxFit.contain);
        case "Cooked Food":
          return Image.asset('assets/images/food/cooked.png', fit: BoxFit.contain);
        case "Non perishable & Canned":
          return Image.asset('assets/images/food/canned.png', fit: BoxFit.contain);
        case "Beverages":
          return Image.asset('assets/images/food/beverages.png', fit: BoxFit.contain);
        default:
          return Text("NO IMAGE FOUND");
      }
    }

    //Return image if not empty
    if(image.isNotEmpty){
      return Image.network(
        image,
        fit: BoxFit.cover,
      );
    }
    //Return icon if empty
    if(image.isEmpty){
      return getType(type);
    }
    return CircularProgressIndicator();
  }
}

