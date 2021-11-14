import 'package:flutter/material.dart';

class Food {
  String type;
  String name;
  String amount;
  String temperature;
  String remarks;
  DateTime date;
  String timeslot;
  String location;
  String address;
  String imageUrl;

  Food(
      this.type,
      this.name,
      this.amount,
      this.temperature,
      this.remarks,
      this.date,
      this.timeslot,
      this.location,
      this.address,
      this.imageUrl,
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
    'amount': amount,
    'temperature': temperature,
    'remarks': remarks,
    'date': date,
    'timeslot': timeslot,
    'location': location,
    'address': address,
    'imageUrl': imageUrl,
  };

  Map<String, Image> types() => {
    "Bread & Pastries": Image.asset('assets/images/food/bread.png'),
    "Fruits & Vegetables": Image.asset('assets/images/food/bread.png'),
    "Fish & Poultry": Image.asset('assets/images/food/bread.png'),
    "Cooked Food": Image.asset('assets/images/food/bread.png'),
    "Non perishable & Canned": Image.asset('assets/images/food/bread.png'),
    "Beverages": Image.asset('assets/images/food/bread.png'),
  };
}