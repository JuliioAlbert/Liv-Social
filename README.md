# Keep code consistent:

- Follow Dart style guide [Effective Dart](https://dart.dev/guides/language/effective-dart)
- We are using [Pedantic](https://pub.dev/packages/pedantic) to check "lints". Fix any warning or lint error before
commit 

# Generate Classes:

- Run the script to autogenerate the classes.
````
 ./generateCode.sh
````


# Firebase:

- This project use [Firebase](https://console.firebase.google.com/u/0/project/liv-social/overview) to manage database, remote storage and authentication.

- Request the following mail guiller.dlco@gmail.com to add you to the firebase project

# State management:

- This project use [Flutter Bloc](https://pub.dev/packages/flutter_bloc) to handle state.

#### Prefer using [Cubit](https://bloclibrary.dev/#/coreconcepts?id=cubit) over bloc:

````
class NameOfClassCubit extends Cubit<MyState> { }
````

#### The name of the class must end with Cubit

````
class NameOfClassCubit extends Cubit<MyState> { }
````

#### Keep the states inside the same file as your Cubit. 

Inside the file ` name_of_class_cubit.dart `

````
class NameOfClassCubit extends Cubit<MyState> { }

class MyState {}

class MyState1 extends MyState {}

class MyState2 extends MyState {}
````

# Widgets

#### Avoid functions to create widgets.  

Avoid functions to create widgets:
````
Widget buildMyButton() {
    return .....
}
````

Instead, create a class:
````
class MyButton extends StatelessWidget {

    @override
    Widget build(BuildContext context) {    
        return ... 
    }
}
````



# Localizations:

- This project use this [Google Sheet](https://docs.google.com/spreadsheets/d/1KN56XjcncJB0ApP7VuoS7CiME_o53UhB2OrkxRSRZ40/edit?usp=sharing) to handle text translations and autogenerate json file.


# Screenshots
 
 | | |
|------------|-------------| 
| <center> <img src="https://i.ibb.co/X85157n/Screenshot-2021-05-10-093535.png" width="250"></center> |  <center><img src="https://i.ibb.co/68PnX3H/Screenshot-2021-05-10-093520.png" width="250"> </center>|
| <center> <img src="https://i.ibb.co/gVvPvSX/Screenshot-2021-05-10-093504.png" width="250"></center> |  <center><img src="https://i.ibb.co/NCJc1tV/Screenshot-2021-05-10-093420.png" width="250"> </center>|
| <center> <img src="https://i.ibb.co/nDvH9BY/Screenshot-2021-05-10-093443.png" width="250"></center> |  <center><img src="https://i.ibb.co/pP23DMr/Screenshot-2021-05-10-093453.png" width="250"> </center>|
| <center> <img src="https://i.ibb.co/ZgGp8FF/Screenshot-2021-05-10-093651.png" width="250"></center> |  


# Tests

 - Pending