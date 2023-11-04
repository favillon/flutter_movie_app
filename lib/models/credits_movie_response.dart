import 'dart:convert';

class CastMovieResponse {
  int id;
  List<Cast> cast;
  List<Cast> crew;

  CastMovieResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CastMovieResponse.fromRawJson(String str) => CastMovieResponse.fromJson(json.decode(str));

  factory CastMovieResponse.fromJson(Map<String, dynamic> json) => CastMovieResponse(
    id: json["id"],
    cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
    crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
  );
}

class Cast {
  bool adult;
  int gender;
  int id;
  Department knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  int? castId;
  String? character;
  String creditId;
  int? order;
  String? job;

  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    required this.creditId,
    this.order,
    this.job,
  });

  get fullProfilePath {
    return (profilePath == null)
    ? 'https://i.stack.imgur.com/GNhxO.png' : 'https://image.tmdb.org/t/p/w500/$profilePath';
  }

  factory Cast.fromRawJson(String str) => Cast.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
    adult: json["adult"],
    gender: json["gender"],
    id: json["id"],
    knownForDepartment: departmentValues.map[json["known_for_department"]]!,
    name: json["name"],
    originalName: json["original_name"],
    popularity: json["popularity"]?.toDouble(),
    profilePath: json["profile_path"],
    castId: json["cast_id"],
    character: json["character"],
    creditId: json["credit_id"],
    order: json["order"],
    job: json["job"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "gender": gender,
    "id": id,
    "known_for_department": departmentValues.reverse[knownForDepartment],
    "name": name,
    "original_name": originalName,
    "popularity": popularity,
    "profile_path": profilePath,
    "cast_id": castId,
    "character": character,
    "credit_id": creditId,
    "order": order,
    "job": job,
  };
}

enum Department {
  acting,
  art,
  camera,
  costumeMakeUp,
  crew,
  directing,
  editing,
  lighting,
  production,
  sound,
  visualEffects,
  writing
}

final departmentValues = EnumValues({
  "Acting": Department.acting,
  "Art": Department.art,
  "Camera": Department.camera,
  "Costume & Make-Up": Department.costumeMakeUp,
  "Crew": Department.crew,
  "Directing": Department.directing,
  "Editing": Department.editing,
  "Lighting": Department.lighting,
  "Production": Department.production,
  "Sound": Department.sound,
  "Visual Effects": Department.visualEffects,
  "Writing": Department.writing
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
