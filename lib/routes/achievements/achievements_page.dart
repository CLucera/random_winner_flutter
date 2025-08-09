import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_winner_flutter/services/achievements_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  int _racesRun = 0;
  double _pixelsTravelled = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final racesRun = await AchievementsService.instance.getRacesRun();
    final pixelsTravelled =
        await AchievementsService.instance.getPixelsTravelled();
    if (mounted) {
      setState(() {
        _racesRun = racesRun;
        _pixelsTravelled = pixelsTravelled;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text('Races',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                _AchievementTile(
                  title: 'First Race',
                  subtitle: 'Complete 1 race',
                  progress: _racesRun / 1,
                  icon: Icons.flag,
                ),
                _AchievementTile(
                  title: 'Seasoned Racer',
                  subtitle: 'Complete 10 races',
                  progress: _racesRun / 10,
                  icon: Icons.military_tech,
                ),
                _AchievementTile(
                  title: 'Marathon Runner',
                  subtitle: 'Complete 100 races',
                  progress: _racesRun / 100,
                  icon: Icons.workspace_premium,
                ),
                const SizedBox(height: 24),
                Text('Distance',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                _AchievementTile(
                  title: 'Pixel Trotter',
                  subtitle: 'Travel 10,000 pixels',
                  progress: _pixelsTravelled / 10000,
                  icon: Icons.directions_run,
                ),
                _AchievementTile(
                  title: 'Pixel Sprinter',
                  subtitle: 'Travel 100,000 pixels',
                  progress: _pixelsTravelled / 100000,
                  icon: Icons.sprint,
                ),
                _AchievementTile(
                  title: 'Pixel Champion',
                  subtitle: 'Travel 1,000,000 pixels',
                  progress: _pixelsTravelled / 1000000,
                  icon: Icons.speed,
                ),
              ],
            ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool completed = progress >= 1.0;
    final displayProgress = min(progress, 1.0);

    return Card(
      elevation: completed ? 0 : 2,
      color: completed
          ? Colors.green.withOpacity(0.2)
          : Theme.of(context).cardColor,
      child: ListTile(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: completed ? Colors.green : Colors.amber,
              size: 36,
            ),
            if (completed)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 18,
              ),
          ],
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            if (!completed)
              LinearProgressIndicator(
                value: displayProgress,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
          ],
        ),
        trailing: Text('${(displayProgress * 100).toStringAsFixed(0)}%'),
      ),
    );
  }
}
