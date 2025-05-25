class Run {
  int? runId;
  String? runLocation;
  double? runDistance;
  int? runTime;

  Run({this.runId, this.runLocation, this.runDistance, this.runTime});

  Run.fromJson(Map<String, dynamic> json) {
    runId = json['runId'];
    runLocation = json['runLocation'];
    runDistance = json['runDistance'];
    runTime = json['runTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['runId'] = this.runId;
    data['runLocation'] = this.runLocation;
    data['runDistance'] = this.runDistance;
    data['runTime'] = this.runTime;
    return data;
  }
}
