import "dart:convert";

import "package:http/http.dart" as http;
import "package:itsu/animedetails.dart";

const animescheduleImg =
    "https://img.animeschedule.net/production/assets/public/img/";
const animescheduleApi = "https://animeschedule.net/api/v3";

const token = "Bearer K7JgAiSXuIGPgnrkGDZ3i743TrxGBW";

Future<List<AnimeDetails>> getWeeklySchedule({
  int? year,
  int? week,
  String? tz,
  String? airType,
}) async {
  var uri = Uri.parse(
    "$animescheduleApi/timetables"
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

  final list = await AnimeDetails.parseList(res);

  return list;
}
