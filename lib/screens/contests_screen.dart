import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

class ContestsScreen extends StatefulWidget {
  const ContestsScreen({super.key});

  @override
  State<ContestsScreen> createState() => _ContestsScreenState();
}

class _ContestsScreenState extends State<ContestsScreen> {
  final List<Contest> _activeContests = [
    Contest(
      id: 'contest_1',
      title: 'Sunset Landscape Challenge',
      description: 'Create the most beautiful sunset landscape',
      prize: 500,
      endsIn: const Duration(hours: 12, minutes: 30),
      participants: 234,
      theme: 'Nature',
    ),
    Contest(
      id: 'contest_2',
      title: 'Abstract Art Showdown',
      description: 'Express your creativity with abstract art',
      prize: 1000,
      endsIn: const Duration(days: 1, hours: 5),
      participants: 456,
      theme: 'Abstract',
    ),
    Contest(
      id: 'contest_3',
      title: 'Character Design Battle',
      description: 'Design the most unique character',
      prize: 750,
      endsIn: const Duration(hours: 8, minutes: 15),
      participants: 189,
      theme: 'Characters',
    ),
  ];

  Future<void> _joinContest(Contest contest) async {
    // Log analytics
    await AnalyticsService.logContestJoined(contest.id);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🎨 Join Contest'),
          content: Text(
              'Join "${contest.title}" for a chance to win ${contest.prize} Kashes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startContest(contest);
              },
              child: const Text('JOIN NOW'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _startContest(Contest contest) async {
    // Navigate to contest coloring screen
    // This would show the specific model for the contest
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined ${contest.title}! Good luck!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Judged Contests'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              // Show past wins
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                  SizedBox(height: 12),
                  Text(
                    'AI-Judged Competitions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Win Kashes by creating the best artwork!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Active Contests',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Contest Cards
            ..._activeContests.map((contest) => _buildContestCard(contest)),

            const SizedBox(height: 24),

            // Your Submissions
            Text(
              'Your Submissions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _buildSubmissionCard(
              title: 'Ocean Waves Contest',
              status: 'Pending Judgment',
              submittedAt: '2 hours ago',
              icon: Icons.hourglass_empty,
              color: Colors.orange,
            ),
            _buildSubmissionCard(
              title: 'Forest Friends Challenge',
              status: 'Won - 2nd Place',
              submittedAt: '1 day ago',
              icon: Icons.emoji_events,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContestCard(Contest contest) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(contest.theme),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${contest.participants}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              contest.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contest.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prize',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${contest.prize} Kashes',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Ends in',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      _formatDuration(contest.endsIn),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _joinContest(contest),
                child: const Text('JOIN CONTEST'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionCard({
    required String title,
    required String status,
    required String submittedAt,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text('Submitted $submittedAt'),
        trailing: Chip(
          label: Text(
            status,
            style: const TextStyle(fontSize: 11),
          ),
          backgroundColor: color.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

class Contest {
  final String id;
  final String title;
  final String description;
  final int prize;
  final Duration endsIn;
  final int participants;
  final String theme;

  Contest({
    required this.id,
    required this.title,
    required this.description,
    required this.prize,
    required this.endsIn,
    required this.participants,
    required this.theme,
  });
}
