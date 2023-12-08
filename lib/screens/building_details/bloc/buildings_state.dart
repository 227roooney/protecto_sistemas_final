class BuildingStates {}

class InitialState extends BuildingStates {}

class UpdateState extends BuildingStates {
  List<dynamic> data = [];
  UpdateState(this.data);
}