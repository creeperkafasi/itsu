import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itsu/api/anime.dart';
import 'package:itsu/api/api.dart';
import 'package:itsu/api/ttanime.dart';
import 'package:itsu/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeInfoDialog extends StatelessWidget {
  final TTAnime ttAnime;
  const AnimeInfoDialog(this.ttAnime, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Anime>(
      future: getAnimeDetails(ttAnime.route),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SimpleDialog(
            title: const Text('Error'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Failed to load anime details: ${snapshot.error}'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final anime = snapshot.data!;
        final theme = Theme.of(context);

        return SimpleDialog(
          surfaceTintColor: Colors.blue,
          title: Row(
            children: [
              if (anime.imageVersionRoute != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    '$animeScheduleImg${anime.imageVersionRoute}',
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ttAnime.title,
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (anime.status != null)
                        Chip(
                          label: Text(anime.status!),
                          backgroundColor: _getStatusColor(
                            anime.status!,
                            context,
                          ),
                        ),
                      if (anime.episodes != null)
                        Chip(
                          label: Text('${anime.episodes} eps'),
                          avatar: const Icon(Icons.list, size: 16),
                        ),
                      if (anime.lengthMin != null)
                        Chip(
                          label: Text('${anime.lengthMin} min'),
                          avatar: const Icon(Icons.timer, size: 16),
                        ),
                      if (anime.year != null)
                        Chip(
                          label: Text('${anime.year}'),
                          avatar: const Icon(Icons.calendar_today, size: 16),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  if (anime.description?.isNotEmpty ?? false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          anime.description!,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                  // Genres/Studios
                  if (anime.genres.isNotEmpty || anime.studios.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (anime.genres.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'Genres',
                            anime.genres,
                            Icons.category,
                            "$animeScheduleBase/genres",
                          ),

                        if (anime.studios.isNotEmpty)
                          _buildInfoSection(
                            context,
                            'Studios',
                            anime.studios,
                            Icons.business,
                            "$animeScheduleBase/studios",
                          ),
                      ],
                    ),

                  // Airing Info
                  if (anime.jpnTime != null) _buildAiringInfo(context, anime),

                  // Streaming Links
                  if (anime.websites != null)
                    _buildStreamingLinks(context, anime.websites!),

                  const Divider(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Periodic Event'),
                        onPressed: () => addAnimeToCalendar(anime),
                      ),
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Category> items,
    IconData icon,
    String urlPrefix,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: items
                .map(
                  (item) => ActionChip(
                    label: Text(item.name),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => launchUrl(
                      Uri.parse("$urlPrefix/${Uri.encodeComponent(item.route)}"),
                      mode: LaunchMode.platformDefault,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAiringInfo(BuildContext context, Anime anime) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Airing Information',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (anime.premier != null)
              _buildAiringRow(
                'Japanese Release',
                anime.premier!,
                anime.jpnTime,
              ),
            if (anime.subPremier != null)
              _buildAiringRow('Sub Release', anime.subPremier!, anime.subTime),
            if (anime.dubPremier != null)
              _buildAiringRow('Dub Release', anime.dubPremier!, anime.dubTime),
          ],
        ),
      ),
    );
  }

  Widget _buildAiringRow(String label, DateTime? date, DateTime? time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (date != null)
            Text(
              DateFormat('dd.MM.yyyy').format(date),
            ),
          if (time != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                DateFormat('HH:mm').format(time.toLocal()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStreamingLinks(BuildContext context, Websites websites) {
    final links = {
      if (websites.crunchyroll?.isNotEmpty ?? false)
        'Crunchyroll': websites.crunchyroll!,
      if (websites.youtube?.isNotEmpty ?? false) 'YouTube': websites.youtube!,
      if (websites.netflix?.isNotEmpty ?? false) 'Netflix': websites.netflix!,
      if (websites.funimation?.isNotEmpty ?? false)
        'Funimation': websites.funimation!,
      if (websites.official?.isNotEmpty ?? false)
        'Official Site': websites.official!,
    };

    if (links.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Streaming Links',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: links.entries.map((entry) {
            String url = entry.value;
            if (!url.startsWith("http")) {
              url = "https://${entry.value}";
            }
            final icon = _getPlatformIcon(entry.key);
            return ActionChip(
              avatar: icon != null ? Icon(icon, size: 18) : null,
              label: Text(entry.key),
              onPressed: () {
                launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData? _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'crunchyroll':
        return Icons.play_circle_filled;
      case 'youtube':
        return Icons.play_circle_filled;
      case 'netflix':
        return Icons.play_circle_filled;
      case 'funimation':
        return Icons.play_circle_filled;
      case 'official site':
        return Icons.language;
      default:
        return null;
    }
  }

  Color _getStatusColor(String status, BuildContext context) {
    final brightness = Theme.of(context).brightness;
    switch (brightness) {
      case Brightness.dark:
        switch (status.toLowerCase()) {
          case 'ongoing':
            return Colors.green.shade700;
          case 'finished':
            return Colors.blue.shade700;
          case 'delayed':
            return Colors.orange.shade700;
          default:
            return Colors.grey.shade800;
        }
      case Brightness.light:
        switch (status.toLowerCase()) {
          case 'ongoing':
            return Colors.green.shade100;
          case 'finished':
            return Colors.blue.shade100;
          case 'delayed':
            return Colors.orange.shade100;
          default:
            return Colors.grey.shade200;
        }
    }
  }
}
