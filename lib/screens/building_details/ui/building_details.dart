import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_map/screens/building_details/bloc/buildings_bloc.dart';
import 'package:uni_map/screens/building_details/bloc/buildings_event.dart';
import 'package:uni_map/screens/building_details/bloc/buildings_state.dart';
import 'package:uni_map/screens/building_details/widgets/building_home_card.dart';

class BuildingDetails extends StatefulWidget {
  const BuildingDetails({super.key});

  @override
  State<BuildingDetails> createState() => _BuildingDetailsPageState();
}

class _BuildingDetailsPageState extends State<BuildingDetails> {
  @override
  Widget build(BuildContext context) {
    final buildingBloc = BlocProvider.of<BuildingBloc>(context);

    return BlocListener<BuildingBloc, BuildingStates>(
      listener: (context, state) {
        print('success');
      },
      child: BlocBuilder<BuildingBloc, BuildingStates>(
        builder: (context, state) {
          if (state is InitialState) {
            final loginBloc = BlocProvider.of<BuildingBloc>(context);
            loginBloc.add(ApiBuildingEvent());
            return _buildSkeletonLoader();
          } else if (state is UpdateState) {
            return getDetail(state.data);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  Center getDetail(List<dynamic> data) {
    var bodyDetail = Center(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return BuildingHomeCard(
            requestId: data[index]['id'],
            name: data[index]['name'],
          );
        },
      ),
    );
    return bodyDetail;
  }
}
