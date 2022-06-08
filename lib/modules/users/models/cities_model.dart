class CitySuggestions {
  List<Predictions>? predictions;
  String? status;

  CitySuggestions({this.predictions, this.status});

  CitySuggestions.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(new Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  @override
  String toString() {
    return 'CitySuggestions{predictions: $predictions, status: $status}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.predictions != null) {
      data['predictions'] = this.predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CitySuggestions &&
          runtimeType == other.runtimeType &&
          predictions == other.predictions &&
          status == other.status;

  @override
  int get hashCode => predictions.hashCode ^ status.hashCode;
}

class Predictions {
  String? description;
  String? placeId;
  String? reference;
  List<String>? types;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Predictions &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          placeId == other.placeId &&
          reference == other.reference &&
          types == other.types;

  @override
  int get hashCode =>
      description.hashCode ^
      placeId.hashCode ^
      reference.hashCode ^
      types.hashCode;

  Predictions({this.description, this.placeId, this.reference, this.types});

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];

    placeId = json['place_id'];
    reference = json['reference'];

    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;

    data['place_id'] = this.placeId;
    data['reference'] = this.reference;

    data['types'] = this.types;
    return data;
  }

  @override
  String toString() {
    return 'Predictions{description: $description, placeId: $placeId, reference: $reference, types: $types}';
  }
}
