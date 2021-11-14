import 'package:flutter/material.dart';

import 'package:foodrestore/models/Food.dart';
import 'food_details.dart';

class RequestPage extends StatelessWidget {
  final Food food;
  const RequestPage({Key? key, required this.food}) : super(key: key);

  //Get food icons from assets
  Widget getImage(int index) {
    switch(index){
      case 0:
        return Image.asset('assets/images/food/bread.png', scale:6);
      case 1:
        return Image.asset('assets/images/food/fruits.png', scale:6);
      case 2:
        return Image.asset('assets/images/food/fish.png', scale:6);
      case 3:
        return Image.asset('assets/images/food/cooked.png', scale:6);
      case 4:
        return Image.asset('assets/images/food/canned.png', scale:6);
      case 5:
        return Image.asset('assets/images/food/beverages.png', scale:6);
      default:
        return Text("NO IMAGE FOUND");
    }
  }

  Widget build(BuildContext context) {
    final foodTypes = food.types();
    var foodKeys = foodTypes.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick-up Request'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Select Food Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  )
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(15),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  primary: false,
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: List.generate(foodTypes.length, (index) {
                    return TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue.shade100)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          getImage(index),
                          SizedBox(height: 5,),
                          Text(
                            foodKeys[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: ()  {
                        food.type = foodKeys[index];
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FoodDetailsPage(food: food))
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
