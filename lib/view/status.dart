import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class StatusPage extends StatefulWidget {
  final DocumentSnapshot requests;

  StatusPage({Key? key,required this.requests}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Request'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Column(
                    children: <Widget>[
                      buildDisplay("Type", widget.requests['type']),
                      buildDisplay("Name", widget.requests['name']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildDisplay("Amount", widget.requests['amount'].toString()),
                          buildDisplay("Temperature", widget.requests['temperature'])
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildDisplay("Date", DateFormat('dd-MM-yyyy').format(widget.requests['date'].toDate()).toString()),
                          buildDisplay("Time", widget.requests['timeslot'])
                        ],
                      ),
                      buildDisplay("Location", widget.requests['location']),
                      buildDisplay("Address", widget.requests['address']),
                      buildDisplay("Remarks", widget.requests['remarks']),
                      SizedBox(
                        height: 15,
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Build display field
Widget buildDisplay(String title, String data) =>
    Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade300,
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                          color: Colors.blueGrey.shade300,
                          width: 1,
                        )
                    )
                ),
                child: Center(
                  child: Text(
                    data,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                )
            )
          ],
        )
    );
