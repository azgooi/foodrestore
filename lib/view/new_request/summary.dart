import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:foodrestore/models/Food.dart';
import 'package:foodrestore/service/route.dart';
import 'package:foodrestore/service/storage_service.dart';

class SummaryPage extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final Food food;

  File? image;
  UploadTask? task;
  SummaryPage({Key? key, required this.food, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick-up Request'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Request Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Column(
                  children: <Widget>[
                    buildDisplay("Type", food.type),
                    buildDisplay("Name", food.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildDisplay("Amount", food.amount.toString()),
                        buildDisplay("Temperature", food.temperature)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildDisplay("Date", DateFormat('dd-MM-yyyy').format(food.date)),
                        buildDisplay("Time", food.timeslot)
                      ],
                    ),
                    buildDisplay("Location", food.location),
                    buildDisplay("Address", food.address),
                    buildDisplay("Remarks", food.remarks),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.blueAccent,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          //Submit data to firebase
                          final uid = await Provider.of(context)!.auth.getCurrentUID();
                          await uploadFile();
                          await db.collection("userData").doc(uid).collection("requests").add(food.toJson());
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Display summary fields
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

  //Upload image file
  Future uploadFile() async {
    if (image == null) return;

    final fileName = basename(image!.path);
    final destination = 'images/$fileName';

    //Upload file into firebase
    task = Storage.uploadFile(destination, image!);

    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    //Get download url
    food.imageUrl = urlDownload;
  }
}
