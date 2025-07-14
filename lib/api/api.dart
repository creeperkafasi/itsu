import "dart:convert";

import "package:http/http.dart" as http;
import "package:itsu/api/anime.dart";
import "package:itsu/api/ttanime.dart";

const animeScheduleBase = "https://animeschedule.net";
const animeScheduleImg =
    "https://img.animeschedule.net/production/assets/public/img/";
const animeScheduleApi = "https://animeschedule.net/api/v3";

const token = "Bearer K7JgAiSXuIGPgnrkGDZ3i743TrxGBW";

Future<List<TTAnime>> getWeeklySchedule({
  int? year,
  int? week,
  String? tz,
  String? airType,
}) async {
  var uri = Uri.parse(
    "$animeScheduleApi/timetables"
    "${airType != null ? "/$airType" : ""}",
  );
  uri = uri.replace(
    queryParameters: {
      "year": year?.toString(),
      "week": week?.toString(),
      "tz": tz,
    },
  );
  final res = await http
      .get(uri, headers: {"Authorization": token})
      .then(
        (value) => jsonDecode(value.body),
      );

  final list = TTAnime.parseList(res);

  return list;
}

Future<Anime> getAnimeDetails(String slug) async {
  final json = await http
      .get(Uri.parse("$animeScheduleApi/anime/$slug"))
      .then((res) => jsonDecode(res.body));
  return Anime.fromJson(json);
}
