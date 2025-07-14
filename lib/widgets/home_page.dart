import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:itsu/api/api.dart';
import 'package:itsu/api/ttanime.dart';
import 'package:itsu/calendar.dart';
import 'package:itsu/main.dart';
import 'package:itsu/widgets/anime_info_dialog.dart';
import 'package:week_of_year/week_of_year.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pageDay = DateTime.now().weekday;
  final _pageController = PageController(
    initialPage: DateTime.now().weekday - 1,
  );
  var currentWeekOfYear = DateTime.now().weekOfYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Anime Schedule"),
      ),
      body: FutureBuilder<List<TTAnime>?>(
        future: (() async {
          final first = await getWeeklySchedule(
            year: DateTime.now().year,
            week: DateTime.now().weekOfYear,
            tz: await FlutterTimezone.getLocalTimezone(),
            airType: "sub",
          );
          final second = await getWeeklySchedule(
            year: DateTime.now().year,
            week: DateTime.now().add(Duration(days: 7)).weekOfYear,
            tz: await FlutterTimezone.getLocalTimezone(),
            airType: "sub",
          );
          return first + second;
        })(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          }
          if (snapshot.hasData) {
            final schedule = snapshot.data!;
            Map<int, List<TTAnime>> days = {};

            for (var anime in schedule) {
              final day =
                  anime.episodeDate.millisecondsSinceEpoch ~/
                  millisecondsinaday;

              if (days[day] == null) {
                days[day] = [];
              }
              days[day]!.add(
                anime,
              );
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icon(Icons.arrow_left),
                    ),
                    Text(
                      "${dayNames[(pageDay - 1) % 7 + 1]} - "
                      "${DateFormat('dd.MM.yyyy').format(DateTime.now().add(Duration(days: pageDay - DateTime.now().weekday)))}",
                    ),
                    IconButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icon(Icons.arrow_right),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: DateTime.daysPerWeek * 2,
                    onPageChanged: (value) => setState(() {
                      pageDay = value + 1;
                    }),
                    itemBuilder: (context, dayindex) {
                      if (schedule.isEmpty) {
                        return Center(
                          child: Text("No anime today :("),
                        );
                      }

                      final int day =
                          schedule.first.episodeDate.millisecondsSinceEpoch ~/
                          millisecondsinaday;
                      final data = days[day + dayindex]!;

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final anime = data[index];
                          return ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AnimeInfoDialog(anime);
                                },
                              );
                            },
                            visualDensity: VisualDensity.comfortable,
                            leading: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dismissible(
                                    behavior: HitTestBehavior.deferToChild,
                                    direction: DismissDirection.vertical,
                                    onDismissed: (_) => Navigator.pop(context),
                                    key: Key(
                                      "$animeScheduleImg${anime.imageVersionRoute}",
                                    ),
                                    child: Dialog(
                                      child: Image.network(
                                        "$animeScheduleImg${anime.imageVersionRoute}",
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                SizedBox(width: 48),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                width: 48,
                                "$animeScheduleImg${anime.imageVersionRoute}",
                                errorBuilder: (context, error, stackTrace) =>
                                    SizedBox(width: 48),
                              ),
                            ),
                            title: Text(
                              anime.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      DateFormat(
                                        'HH:mm',
                                      ).format(anime.episodeDate.toLocal()),
                                    ),
                                    VerticalDivider(),
                                    Text(
                                      "(Episode ${anime.episodeNumber}${anime.episodes != null ? "/${anime.episodes}" : ""})",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing:
                                (anime.episodeDate.isAfter(DateTime.now()))
                                ? IconButton(
                                    onPressed: () => addTimeTableToCalendar(anime),
                                    icon: Icon(Icons.notification_add),
                                  )
                                : IconButton(
                                    onPressed: null,
                                    icon: Icon(Icons.check),
                                  ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Center(
            child: SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
        },
      ),
    );
  }
}
