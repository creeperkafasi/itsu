/// TimeTable Anime
class TTAnime {
  final String title;
  final String route;
  final String romaji;
  final String? english; // Made nullable
  final String native;
  final DateTime delayedFrom;
  final DateTime delayedUntil;
  final String status;
  final DateTime episodeDate;
  final int episodeNumber;
  final int? episodes; // Made nullable
  final int lengthMin;
  final bool donghua;
  final String airType;
  final List<MediaType> mediaTypes;
  final String imageVersionRoute;
  final Streams streams;
  final String airingStatus;

  TTAnime({
    required this.title,
    required this.route,
    required this.romaji,
    this.english, // Now optional
    required this.native,
    required this.delayedFrom,
    required this.delayedUntil,
    required this.status,
    required this.episodeDate,
    required this.episodeNumber,
    this.episodes, // Now optional
    required this.lengthMin,
    required this.donghua,
    required this.airType,
    required this.mediaTypes,
    required this.imageVersionRoute,
    required this.streams,
    required this.airingStatus,
  });

  factory TTAnime.fromJson(Map<String, dynamic> json) {
    return TTAnime(
      title: json['title'] as String? ?? '', // Provide default if null
      route: json['route'] as String? ?? '',
      romaji: json['romaji'] as String? ?? '',
      english: json['english'] as String?, // Can be null
      native: json['native'] as String? ?? '',
      delayedFrom: DateTime.parse(json['delayedFrom'] as String? ?? '1970-01-01'),
      delayedUntil: DateTime.parse(json['delayedUntil'] as String? ?? '1970-01-01'),
      status: json['status'] as String? ?? 'Unknown',
      episodeDate: DateTime.parse(json['episodeDate'] as String? ?? '1970-01-01'),
      episodeNumber: (json['episodeNumber'] as num?)?.toInt() ?? 0,
      episodes: (json['episodes'] as num?)?.toInt(), // Can be null
      lengthMin: (json['lengthMin'] as num?)?.toInt() ?? 0,
      donghua: json['donghua'] as bool? ?? false,
      airType: json['airType'] as String? ?? '',
      mediaTypes: (json['mediaTypes'] as List<dynamic>?)
              ?.map((x) => MediaType.fromJson(x as Map<String, dynamic>))
              .toList() ??
          <MediaType>[],
      imageVersionRoute: json['imageVersionRoute'] as String? ?? '',
      streams: Streams.fromJson(json['streams'] as Map<String, dynamic>? ?? {}),
      airingStatus: json['airingStatus'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'route': route,
      'romaji': romaji,
      'english': english,
      'native': native,
      'delayedFrom': delayedFrom.toIso8601String(),
      'delayedUntil': delayedUntil.toIso8601String(),
      'status': status,
      'episodeDate': episodeDate.toIso8601String(),
      'episodeNumber': episodeNumber,
      'lengthMin': lengthMin,
      'donghua': donghua,
      'airType': airType,
      'mediaTypes': mediaTypes.map((x) => x.toJson()).toList(),
      'imageVersionRoute': imageVersionRoute,
      'streams': streams.toJson(),
      'airingStatus': airingStatus,
    };
  }

  static List<TTAnime> parseList(List<dynamic> jsonList) {
    return jsonList.map((json) => TTAnime.fromJson(json)).toList();
  }
}

class MediaType {
  final String name;
  final String route;

  MediaType({
    required this.name,
    required this.route,
  });

  factory MediaType.fromJson(Map<String, dynamic> json) {
    return MediaType(
      name: json['name'],
      route: json['route'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'route': route,
    };
  }
}

class Streams {
  final String? crunchyroll; // Made nullable
  final String? youtube;    // Made nullable
  final String? apple;      // Made nullable

  Streams({
    this.crunchyroll,
    this.youtube,
    this.apple,
  });

  factory Streams.fromJson(Map<String, dynamic> json) {
    return Streams(
      crunchyroll: json['crunchyroll'] as String?,
      youtube: json['youtube'] as String?,
      apple: json['apple'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crunchyroll': crunchyroll,
      'youtube': youtube,
      'apple': apple,
    };
  }
}
