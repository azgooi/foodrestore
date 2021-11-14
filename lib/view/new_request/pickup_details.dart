import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:foodrestore/models/Food.dart';
import 'summary.dart';

class PickupDetailsPage extends StatefulWidget {
  final Food food;
  File? image;
  PickupDetailsPage({Key? key, required this.food, this.image}) : super(key: key);

  @override
  State<PickupDetailsPage> createState() => _PickupDetailsPageState();
}

class _PickupDetailsPageState extends State<PickupDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final time = ['8 AM - 10 AM', '10 AM - 12 PM', '12 PM - 2 PM', '2 PM - 4 PM',
    '4 PM - 6 PM', '6 PM - 8 PM', '8 PM - 10 PM', '10 PM - 12 AM'];

  String? valueTime;
  DateTime? date;

  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _addresscontroller = new TextEditingController();
  TextEditingController _remarkscontroller = new TextEditingController();

  //Display Date Picked
  String getText(){
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('EEEE, dd MMM yyyy').format(date!);
    }
  }

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
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Text(
                      "Enter Pick-up Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                            child: Text(
                              'Preferred Date*',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ButtonHeaderWidget(
                          text: getText(),
                          onClicked: () => pickDate(context),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(enabledBorder: InputBorder.none),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a timeslot';
                              }
                              return null;
                            },
                            hint: Text("Preferred Time*"),
                            dropdownColor: Colors.blue.shade50,
                            value: valueTime,
                            isExpanded: true,
                            items: time.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() => this.valueTime = value),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _namecontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            labelText: 'Location Name*',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter location name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            maxLines: 2,
                            keyboardType: TextInputType.text,
                            controller: _addresscontroller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                labelText: 'Address*',
                                hintText: 'e.g. Unit number, street name'
                            ),
                            validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter location address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                            maxLines: 2,
                            keyboardType: TextInputType.text,
                            controller: _remarkscontroller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                labelText: 'Remarks',
                                hintText: 'Condition of the food'
                            )
                        ),
                      ]
                  ),
                ),
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
                  onPressed: (){
                    if(_formKey.currentState!.validate()) {
                      widget.food.date = date!;
                      widget.food.timeslot = valueTime!;
                      widget.food.location = _namecontroller.text;
                      widget.food.address = _addresscontroller.text;
                      widget.food.remarks = _remarkscontroller.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              SummaryPage(food: widget.food, image: widget.image))
                      );
                    }
                  },
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Date picker
  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: date ?? initialDate,
        firstDate: initialDate,
        lastDate: DateTime(DateTime.now().year + 2 )
    );

    if (newDate == null) return;
    setState(() => date = newDate);
  }

  // Build DropdownMenu Item
  DropdownMenuItem<String> buildMenuItem(String unit) => DropdownMenuItem(
      value: unit,
      child: Text(unit)
  );
}

// Button Widget
class ButtonHeaderWidget extends StatelessWidget{
  final String text;
  final VoidCallback onClicked;

  const ButtonHeaderWidget({
    Key? key, required this.text, required this.onClicked
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(55),
          primary: Colors.lightBlueAccent.shade400,
        ),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
}
