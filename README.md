# Keep code consistent:

- Follow Dart style guide [Effective Dart](https://dart.dev/guides/language/effective-dart)
- We are using [Pedantic](https://pub.dev/packages/pedantic) to check "lints". Fix any warning or lint error before
commit 

# State management:

- This project use [Flutter Bloc](https://pub.dev/packages/flutter_bloc) to handle state.

# State management:

- This project use [Firebase](https://console.firebase.google.com/u/0/project/liv-social/overview) to manage database, remote storage and authentication.

- Request the following mail guiller.dlco@gmail.com to add you to the firebase project

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