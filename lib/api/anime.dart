const invalidDate = "0001-01-01T00:00:00Z";

class Anime {
  final String id;
  final String title;
  final String route;
  final DateTime? premier;
  final DateTime? subPremier;
  final DateTime? dubPremier;
  final String? month;
  final int? year;
  final Season? season;
  final EpisodeOverride? episodeOverride;
  final EpisodeOverride? subEpisodeOverride;
  final EpisodeOverride? dubEpisodeOverride;
  final String? delayedTimetable;
  final DateTime? delayedFrom;
  final DateTime? delayedUntil;
  final String? subDelayedTimetable;
  final DateTime? subDelayedFrom;
  final DateTime? subDelayedUntil;
  final String? dubDelayedTimetable;
  final DateTime? dubDelayedFrom;
  final DateTime? dubDelayedUntil;
  final String? delayedDesc;
  final DateTime? jpnTime;
  final DateTime? subTime;
  final DateTime? dubTime;
  final String? description;
  final List<Category> genres;
  final List<Category> studios;
  final List<Category> sources;
  final List<Category> mediaTypes;
  final int? episodes;
  final int? lengthMin;
  final String? status;
  final String? imageVersionRoute;
  final Stats? stats;
  final Days? days;
  final Names? names;
  final Relations? relations;
  final Websites? websites;

  Anime({
    required this.id,
    required this.title,
    required this.route,
    this.premier,
    this.subPremier,
    this.dubPremier,
    this.month,
    this.year,
    this.season,
    this.episodeOverride,
    this.subEpisodeOverride,
    this.dubEpisodeOverride,
    this.delayedTimetable,
    this.delayedFrom,
    this.delayedUntil,
    this.subDelayedTimetable,
    this.subDelayedFrom,
    this.subDelayedUntil,
    this.dubDelayedTimetable,
    this.dubDelayedFrom,
    this.dubDelayedUntil,
    this.delayedDesc,
    this.jpnTime,
    this.subTime,
    this.dubTime,
    this.description,
    required this.genres,
    required this.studios,
    required this.sources,
    required this.mediaTypes,
    this.episodes,
    this.lengthMin,
    this.status,
    this.imageVersionRoute,
    this.stats,
    this.days,
    this.names,
    this.relations,
    this.websites,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      route: json['route'] as String? ?? '',
      premier: json['premier'] != null
          ? DateTime.parse(json['premier'] as String)
          : null,
      subPremier: json['subPremier'] != null
          ? DateTime.parse(json['subPremier'] as String)
          : null,
      dubPremier: json['dubPremier'] != null
          ? DateTime.parse(json['dubPremier'] as String)
          : null,
      month: json['month'] as String?,
      year: json['year'] != null ? (json['year'] as num).toInt() : null,
      season: json['season'] != null
          ? Season.fromJson(json['season'] as Map<String, dynamic>)
          : null,
      episodeOverride: json['episodeOverride'] != null
          ? EpisodeOverride.fromJson(
              json['episodeOverride'] as Map<String, dynamic>,
            )
          : null,
      subEpisodeOverride: json['subEpisodeOverride'] != null
          ? EpisodeOverride.fromJson(
              json['subEpisodeOverride'] as Map<String, dynamic>,
            )
          : null,
      dubEpisodeOverride: json['dubEpisodeOverride'] != null
          ? EpisodeOverride.fromJson(
              json['dubEpisodeOverride'] as Map<String, dynamic>,
            )
          : null,
      delayedTimetable: json['delayedTimetable'] as String?,
      delayedFrom: json['delayedFrom'] != null
          ? DateTime.parse(json['delayedFrom'] as String)
          : null,
      delayedUntil: json['delayedUntil'] != null
          ? DateTime.parse(json['delayedUntil'] as String)
          : null,
      subDelayedTimetable: json['subDelayedTimetable'] as String?,
      subDelayedFrom: json['subDelayedFrom'] != null
          ? DateTime.parse(json['subDelayedFrom'] as String)
          : null,
      subDelayedUntil: json['subDelayedUntil'] != null
          ? DateTime.parse(json['subDelayedUntil'] as String)
          : null,
      dubDelayedTimetable: json['dubDelayedTimetable'] as String?,
      dubDelayedFrom: json['dubDelayedFrom'] != null
          ? DateTime.parse(json['dubDelayedFrom'] as String)
          : null,
      dubDelayedUntil: json['dubDelayedUntil'] != null
          ? DateTime.parse(json['dubDelayedUntil'] as String)
          : null,
      delayedDesc: json['delayedDesc'] as String?,
      jpnTime: json['jpnTime'] != null
          ? DateTime.parse(json['jpnTime'] as String)
          : null,
      subTime: json['subTime'] != null
          ? DateTime.parse(json['subTime'] as String)
          : null,
      dubTime: json['dubTime'] != null
          ? DateTime.parse(json['dubTime'] as String)
          : null,
      description: json['description'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((x) => Category.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      studios:
          (json['studios'] as List<dynamic>?)
              ?.map((x) => Category.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((x) => Category.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      mediaTypes:
          (json['mediaTypes'] as List<dynamic>?)
              ?.map((x) => Category.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      episodes: json['episodes'] != null
          ? (json['episodes'] as num).toInt()
          : null,
      lengthMin: json['lengthMin'] != null
          ? (json['lengthMin'] as num).toInt()
          : null,
      status: json['status'] as String?,
      imageVersionRoute: json['imageVersionRoute'] as String?,
      stats: json['stats'] != null
          ? Stats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      days: json['days'] != null
          ? Days.fromJson(json['days'] as Map<String, dynamic>)
          : null,
      names: json['names'] != null
          ? Names.fromJson(json['names'] as Map<String, dynamic>)
          : null,
      relations: json['relations'] != null
          ? Relations.fromJson(json['relations'] as Map<String, dynamic>)
          : null,
      websites: json['websites'] != null
          ? Websites.fromJson(json['websites'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'route': route,
      'premier': premier?.toIso8601String(),
      'subPremier': subPremier?.toIso8601String(),
      'dubPremier': dubPremier?.toIso8601String(),
      'month': month,
      'year': year,
      'season': season?.toJson(),
      'episodeOverride': episodeOverride?.toJson(),
      'subEpisodeOverride': subEpisodeOverride?.toJson(),
      'dubEpisodeOverride': dubEpisodeOverride?.toJson(),
      'delayedTimetable': delayedTimetable,
      'delayedFrom': delayedFrom?.toIso8601String(),
      'delayedUntil': delayedUntil?.toIso8601String(),
      'subDelayedTimetable': subDelayedTimetable,
      'subDelayedFrom': subDelayedFrom?.toIso8601String(),
      'subDelayedUntil': subDelayedUntil?.toIso8601String(),
      'dubDelayedTimetable': dubDelayedTimetable,
      'dubDelayedFrom': dubDelayedFrom?.toIso8601String(),
      'dubDelayedUntil': dubDelayedUntil?.toIso8601String(),
      'delayedDesc': delayedDesc,
      'jpnTime': jpnTime?.toIso8601String(),
      'subTime': subTime?.toIso8601String(),
      'dubTime': dubTime?.toIso8601String(),
      'description': description,
      'genres': genres.map((x) => x.toJson()).toList(),
      'studios': studios.map((x) => x.toJson()).toList(),
      'sources': sources.map((x) => x.toJson()).toList(),
      'mediaTypes': mediaTypes.map((x) => x.toJson()).toList(),
      'episodes': episodes,
      'lengthMin': lengthMin,
      'status': status,
      'imageVersionRoute': imageVersionRoute,
      'stats': stats?.toJson(),
      'days': days?.toJson(),
      'names': names?.toJson(),
      'relations': relations?.toJson(),
      'websites': websites?.toJson(),
    };
  }
}

class Category {
  final String name;
  final String route;

  Category({
    required this.name,
    required this.route,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String? ?? '',
      route: json['route'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'route': route,
    };
  }
}

class Season {
  final String? name;
  final String? route;

  Season({
    this.name,
    this.route,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      name: json['name'] as String?,
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'route': route,
    };
  }
}

class EpisodeOverride {
  // Add properties based on your API documentation
  // This is a placeholder since the structure wasn't fully specified
  final String? text;
  final int? number;

  EpisodeOverride({
    this.text,
    this.number,
  });

  factory EpisodeOverride.fromJson(Map<String, dynamic> json) {
    return EpisodeOverride(
      text: json['text'] as String?,
      number: json['number'] != null ? (json['number'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}

class Stats {
  // Add properties based on your API documentation
  final double? score;
  final int? ranked;
  final int? popularity;

  Stats({
    this.score,
    this.ranked,
    this.popularity,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      ranked: json['ranked'] != null ? (json['ranked'] as num).toInt() : null,
      popularity: json['popularity'] != null
          ? (json['popularity'] as num).toInt()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'ranked': ranked,
      'popularity': popularity,
    };
  }
}

class Days {
  // Add properties based on your API documentation
  final String? jpn;
  final String? sub;
  final String? dub;

  Days({
    this.jpn,
    this.sub,
    this.dub,
  });

  factory Days.fromJson(Map<String, dynamic> json) {
    return Days(
      jpn: json['jpn'] as String?,
      sub: json['sub'] as String?,
      dub: json['dub'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jpn': jpn,
      'sub': sub,
      'dub': dub,
    };
  }
}

class Names {
  final String? romaji;
  final String? english;
  final String? native;
  final String? alternative;

  Names({
    this.romaji,
    this.english,
    this.native,
    this.alternative,
  });

  factory Names.fromJson(Map<String, dynamic> json) {
    return Names(
      romaji: json['romaji'] as String?,
      english: json['english'] as String?,
      native: json['native'] as String?,
      alternative: json['alternative'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'romaji': romaji,
      'english': english,
      'native': native,
      'alternative': alternative,
    };
  }
}

class Relations {
  final List<dynamic>? adaptations;
  final List<dynamic>? sequels;
  final List<dynamic>? prequels;
  final List<dynamic>? others;

  Relations({
    this.adaptations,
    this.sequels,
    this.prequels,
    this.others,
  });

  factory Relations.fromJson(Map<String, dynamic> json) {
    return Relations(
      adaptations: json['adaptations'] as List<dynamic>?,
      sequels: json['sequels'] as List<dynamic>?,
      prequels: json['prequels'] as List<dynamic>?,
      others: json['others'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adaptations': adaptations,
      'sequels': sequels,
      'prequels': prequels,
      'others': others,
    };
  }
}

class Websites {
  final String? official;
  final String? twitter;
  final String? youtube;
  final String? crunchyroll;
  final String? funimation;
  final String? netflix;

  Websites({
    this.official,
    this.twitter,
    this.youtube,
    this.crunchyroll,
    this.funimation,
    this.netflix,
  });

  factory Websites.fromJson(Map<String, dynamic> json) {
    return Websites(
      official: json['official'] as String?,
      twitter: json['twitter'] as String?,
      youtube: json['youtube'] as String?,
      crunchyroll: json['crunchyroll'] as String?,
      funimation: json['funimation'] as String?,
      netflix: json['netflix'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'official': official,
      'twitter': twitter,
      'youtube': youtube,
      'crunchyroll': crunchyroll,
      'funimation': funimation,
      'netflix': netflix,
    };
  }
}
