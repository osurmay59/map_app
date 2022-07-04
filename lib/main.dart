import'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/blocs/blocs.dart';
import 'package:map_app/screens/screens.dart';


void main(){
  runApp(
    
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(create: (context) => MapBloc()),

      ],
      child: const MapApp(),
    )
  
  );

}

class MapApp extends StatelessWidget{
  const MapApp({Key?key}):super(key:key);
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner:false,
      title:'MapApp',
      home: LoadingScreen(),
    );// MaterialApp
  }
}