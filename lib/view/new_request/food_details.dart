import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:string_validator/string_validator.dart';

import 'package:foodrestore/models/Food.dart';
import 'pickup_details.dart';

class FoodDetailsPage extends StatefulWidget {
  final Food food;
  const FoodDetailsPage({Key? key, required this.food}) : super(key: key);

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final units = ['Kilogram','Gram','Litre','Millilitre'];
  final temp = ['Room Temperature', 'Chilled', 'Frozen'];

  String? valueUnit, valueTemp;
  File? file;

  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _amountcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

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
                      "Enter Food Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _namecontroller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          labelText: 'Food Name*',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter food name';
                          }
                          if (value.length > 25){
                            return 'The name is too long!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _amountcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  labelText: 'Amount*',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an amount';
                                  }
                                  if (!isFloat(value)){
                                    return 'Please enter number value';
                                  }
                                  return null;
                                },
                              ),
                          ),
                          Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)
                                ),
                                width: 150,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(enabledBorder: InputBorder.none),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select an unit';
                                    }
                                    return null;
                                  },
                                  hint: Text("Unit*"),
                                  value: valueUnit,
                                  isExpanded: true,
                                  items: units.map(buildMenuItem).toList(),
                                  onChanged: (value) => setState(() => this.valueUnit = value),
                                ),
                              )
                          )
                        ],
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
                              return 'Please select a temperature';
                            }
                            return null;
                          },
                          hint: Text("Temperature*"),
                          value: valueTemp,
                          isExpanded: true,
                          items: temp.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(() => this.valueTemp = value),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonWidget(
                        text: 'Upload Food Photo',
                        icon: Icons.attach_file,
                        onClicked: selectFile,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        fileName,
                        style: TextStyle(color: Colors.grey),
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
                      widget.food.name = _namecontroller.text;
                      widget.food.amount =
                          _amountcontroller.text + " " + valueUnit!;
                      widget.food.temperature = valueTemp!;
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              PickupDetailsPage(food: widget.food, image: file,))
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

  //Build DropdownMenu Item
  DropdownMenuItem<String> buildMenuItem(String unit) => DropdownMenuItem(
    value: unit,
    child: Text(unit)
  );

  //File Picker
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg','png'],
    );

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }
}

//Upload File Button Widget
class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({required this.icon, required this.text, required this.onClicked,});

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(55),
        primary: Colors.lightBlueAccent.shade400,
      ),
      onPressed: onClicked,
      child: buildContent()
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size:28),
      SizedBox(width: 16),
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      )
    ],
  );
}
