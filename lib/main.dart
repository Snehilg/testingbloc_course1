import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math
    show Random; //i only want random to be shown/accesed ..hide is also there

void main() {
  runApp(MaterialApp(
    title: "Flutter Ex1",
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

//list of names
const names = ["foo", "bar", "mnn"];

//function for random picking, extension on iterable
//extension is used to enhance the functionality of any existing library

extension PickRandom<T> on Iterable<T> {
  T getRandomName() => elementAt(
      math.Random().nextInt(length)); //length -> size of the passed iterable
}

//creating cubit with state as string, to pick random name or produce state
class NamesCubit extends Cubit<String?> {
  //we can also pass initial state as null to constructor
  NamesCubit() : super(null);
  //string as state
  void pickRandomName() =>
      emit(names.getRandomName()); //using iterable without class name
} //NamesCubit

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit; //gonna be initialise before it gets used

  //cubit is like one layer over streams, hence as we initialise & dispose streams
  //we will do the same for cubit
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initialising cubit
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //closing cubit
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(
        title: const Text("Flutter Ex1"),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<String?>(
        //string as state
        stream: cubit.stream,
        //button inside builder-> call cubit to pick value
        //that value will be picked by cubit stream -> will reach to builder again
        //snapshot belongs to dart
        builder: (context, snapshot) {
          //button for using cubit
          final button = TextButton(
            onPressed: () => cubit.pickRandomName(),
            child: const Text("Pick Name"),
          );

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;

            case ConnectionState.waiting:
              return button;
            //active state means listening state

            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ""),
                  button,
                ],
              );

            //state will only be done once scaffold is closed
            //so code is never gonna reach here
            case ConnectionState.done:
              return SizedBox();
          }
        },
      ),
    );
  }
}
