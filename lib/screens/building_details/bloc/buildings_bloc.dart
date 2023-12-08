import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:uni_map/screens/building_details/bloc/buildings_event.dart';
import 'package:uni_map/screens/building_details/bloc/buildings_state.dart';

class BuildingBloc extends Bloc<BuildingEvents, BuildingStates> {
  List<dynamic> data = [];

  BuildingBloc() : super(InitialState()) {
    on<ApiBuildingEvent>(onApiBuilding);
  }
  void onApiBuilding(ApiBuildingEvent event, Emitter<BuildingStates> emit) async {
    final response =
        await http.get(Uri.parse('https://us-central1-uni-map-fe7c6.cloudfunctions.net/app/buildings'));

    if (response.statusCode == 200) {
      data = convert.jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
    emit(UpdateState(data));
  }
}