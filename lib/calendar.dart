import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:itsu/api/anime.dart';
import 'package:itsu/api/ttanime.dart';
import 'package:url_launcher/url_launcher.dart';

void addTimeTableToCalendar(TTAnime anime) async {
  String title = "${anime.title} - Episode ${anime.episodeNumber}";
  String description =
      """\
Episode ${anime.episodeNumber}${anime.episodes != null ? "/${anime.episodes}" : ""}
""";

  if (Platform.isAndroid) {
    final intent = createCalendarIntent(
      title: title,
      description: description,
      beginTime: anime.episodeDate,
      endTime: anime.episodeDate.add(Duration(minutes: anime.lengthMin)),
    );
    intent.launch();
  } else {
    launchUrl(
      createGoogleCalendarLink(
        title: title,
        description: description,
        beginTime: anime.episodeDate,
        endTime: anime.episodeDate.add(Duration(minutes: anime.lengthMin)),
      ),
    );
  }
}

void addAnimeToCalendar(Anime anime) async {
  DateTime airTime = anime.subTime ?? DateTime(0);
  DateTime? beginTime = anime.premier?.copyWith(
    hour: airTime.hour,
    minute: airTime.minute,
    second: airTime.second,
  );
  if (Platform.isAndroid) {
    final intent = createCalendarIntent(
      title: anime.title,
      description: anime.description,
      beginTime: beginTime,
      endTime: beginTime?.add(Duration(minutes: anime.lengthMin ?? 0)),
      reccurrenceRule: RRule(
        frequency: "WEEKLY",
        interval: 1,
        count: anime.episodes,
      ),
    );
    intent.launch();
  } else {
    launchUrl(
      createGoogleCalendarLink(
        title: anime.title,
        description: anime.description,
        beginTime: beginTime,
        endTime: beginTime?.add(Duration(minutes: anime.lengthMin ?? 0)),
        reccurrenceRule: RRule(
          frequency: "WEEKLY",
          interval: 1,
          count: anime.episodes,
        ),
      ),
    );
  }
}

class RRule {
  /// "SECONDLY" / "MINUTELY" / "HOURLY" / "DAILY"
  ///            / "WEEKLY" / "MONTHLY" / "YEARLY"
  final String frequency;
  final int interval;
  final int? count;
  final DateTime? until;

  RRule({
    required this.frequency,
    required this.interval,
    this.count,
    this.until,
  });

  String toContract() {
    final parts = [
      "FREQ=$frequency",
      "INTERVAL=$interval",
      if (count != null) "COUNT=${count!}",
      if (until != null)
        "UNTIL=${until!.toUtc().toIso8601String().replaceAll(RegExp(r"[:-]"), "")}",
    ];
    return parts.join(";");
  }
}

AndroidIntent createCalendarIntent({
  String? title,
  String? description,
  DateTime? beginTime,
  DateTime? endTime,
  String? location,
  RRule? reccurrenceRule,
}) {
  final intent = AndroidIntent(
    action: 'android.intent.action.INSERT',
    data: 'content://com.android.calendar/event',
    type: "vnd.android.cursor.dir/event",
    arguments: {
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (beginTime != null) "beginTime": beginTime.millisecondsSinceEpoch,
      if (endTime != null) "endTime": endTime.millisecondsSinceEpoch,
      if (location != null) "eventLocation": location,
      if (reccurrenceRule != null) "rrule": reccurrenceRule.toContract(),
    },
  );

  return intent;
}

Uri createGoogleCalendarLink({
  String? title,
  String? description,
  String? location,
  DateTime? beginTime,
  DateTime? endTime,
  RRule? reccurrenceRule,
}) {
  return Uri.parse("https://calendar.google.com/u/0/r/eventedit").replace(
    queryParameters: {
      "text": title ?? "",
      "details": description ?? "",
      "location": location ?? "",
      "dates":
          "${beginTime?.toUtc().toIso8601String().replaceAll(RegExp(r"[:-]"), "")}/"
          "${endTime?.toUtc().toIso8601String().replaceAll(RegExp(r"[:-]"), "")}",
      if (reccurrenceRule != null)
        "recur": "RRULE:${reccurrenceRule.toContract()}",
    },
  );
}
