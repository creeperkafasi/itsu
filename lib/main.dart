import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:itsu/animedetails.dart';
import 'package:itsu/api.dart';
import 'package:itsu/data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:week_of_year/week_of_year.dart';

const dayNames = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday",
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadUserData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark).copyWith(
        colorScheme: ColorScheme.dark(
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: "home",
      routes: {
        "home": (context) => HomePage(),
        // "login": LoginPage(),
      },
    );
  }
}

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
      body: FutureBuilder<List<AnimeDetails>?>(
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
          print(second.first.episodeDate);
          return [...first, ...second];
        })(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          }
          if (snapshot.hasData) {
            final schedule = snapshot.data!;
            Map<String, List<AnimeDetails>> days = {};

            for (var anime in schedule) {
              if (days[DateFormat('yyyy-MM-dd').format(anime.episodeDate)] ==
                  null) {
                days[DateFormat('yyyy-MM-dd').format(anime.episodeDate)] = [];
              }
              days[DateFormat('yyyy-MM-dd').format(anime.episodeDate)]!.add(
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
                      final day = DateFormat('yyyy-MM-dd').format(
                        schedule.first.episodeDate.add(
                          Duration(days: dayindex),
                        ),
                      );

                      final data = days[day]!;

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final anime = data[index];
                          return ListTile(
                            visualDensity: VisualDensity.comfortable,
                            leading: Image.network(
                              width: 48,
                              "$animescheduleImg${anime.imageVersionRoute}",
                              errorBuilder: (context, error, stackTrace) =>
                                  SizedBox(width: 48),
                            ),
                            title: Text(
                              anime.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('HH:mm').format(anime.episodeDate.toLocal()),
                                    ),
                                    VerticalDivider(),
                                    Text(
                                      "(Episode ${anime.episodeNumber}${anime.episodes != null ? "/${anime.episodes}" : ""})",
                                    ),
                                  ],
                                ),
                                if (anime.airingStatus.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "(${anime.airingStatus})",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            trailing:
                                (anime.episodeDate.isAfter(DateTime.now()))
                                ? IconButton(
                                    onPressed: () {
                                      launchUrl(
                                        Uri.parse(
                                          "https://calendar.google.com/calendar/u/0/r/eventedit",
                                        ).replace(
                                          queryParameters: {
                                            "dates":
                                                "${anime.episodeDate.toIso8601String().replaceAll(RegExp(r'[:\-]'), '')}/"
                                                "${anime.episodeDate.add(Duration(minutes: anime.lengthMin)).toIso8601String().replaceAll(RegExp(r'[:\-]'), '')}",
                                            "location": "",
                                            "text": anime.title,
                                            "details":
                                                "Episode ${anime.episodeNumber}${anime.episodes != null ? "/${anime.episodes}" : ""}",
                                          },
                                        ),
                                        mode: LaunchMode.externalNonBrowserApplication
                                      );
                                    },
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
