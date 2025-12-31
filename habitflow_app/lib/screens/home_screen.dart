import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';
import '../models/habit_completion.dart';
import '../repositories/habit_completion_repository.dart';
import '../utils/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/achievements_provider.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'achievements_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final HabitCompletionRepository _completionRepo = HabitCompletionRepository();
  Map<String, CompletionStatus?> _todayCompletions = {};

  Color _mapColor(String? colorName) {
    if (colorName == null) {
      return AppColors.primary;
    }

    switch (colorName) {
      case 'Red':
        return Colors.red;
      case 'Orange':
        return Colors.orange;
      case 'Blue':
        return AppColors.turquoise;
      case 'Green':
        return Colors.green;
      case 'Yellow':
        return Colors.yellow;
      case 'Purple':
        return AppColors.navyBlue;
      case 'Grey':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  List<Habit> filteredHabits = [];

  Future<void> _loadTodayCompletions(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final snapshot = await FirebaseFirestore.instance
        .collection('habitCompletions')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    final Map<String, CompletionStatus?> completions = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final habitId = data['habitId'] as String;
      final status = CompletionStatus.fromString(data['status'] ?? 'missed');
      completions[habitId] = status;
    }

    setState(() {
      _todayCompletions = completions;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final habitProvider = context.read<HabitProvider>();
      final prefsProvider = context.read<PreferencesProvider>();

      if (authProvider.currentUser != null) {
        habitProvider.loadHabits(authProvider.currentUser!.uid);
        await _loadTodayCompletions(authProvider.currentUser!.uid);
        await prefsProvider.loadUserPreferences(authProvider.currentUser!.uid);
      }

      if (!mounted) return;

      _noteController.text = prefsProvider.dailyNote;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addHabit() async {
    final authProvider = context.read<AuthProvider>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );

    if (!mounted) return;

    if (result != null && result is Habit && authProvider.currentUser != null) {
      await context.read<HabitProvider>().addHabit(result, authProvider.currentUser!.uid);
    }
  }

  CompletionStatus _statusFromString(String status) {
    switch (status) {
      case 'completed':
        return CompletionStatus.completed;
      case 'partial':
        return CompletionStatus.partial;
      case 'missed':
        return CompletionStatus.missed;
      default:
        return CompletionStatus.missed;
    }
  }

  Future<void> _markHabitCompletion(
      String userId,
      String habitId,
      DateTime date,
      CompletionStatus status,
      ) async {
    try {
      await _completionRepo.markHabitCompletion(userId, habitId, date, status);
      await _loadTodayCompletions(userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Habit marked as ${status.value}!'),
            duration: const Duration(seconds: 2),
            backgroundColor: status == CompletionStatus.completed
                ? Colors.green
                : status == CompletionStatus.partial
                ? Colors.orange
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _resetHabitCompletion(
      String userId,
      String habitId,
      DateTime date,
      ) async {
    try {
      await _completionRepo.deleteHabitCompletion(userId, habitId, date);
      await _loadTodayCompletions(userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit reset!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.grey,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildQuickMarkDialog(Habit habit) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mark "${habit.name}"',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'How did you do today?',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatusButton('Completed ✅', 'completed', Colors.green),
            const SizedBox(height: 12),
            _buildStatusButton('Partially Done 🟡', 'partial', Colors.orange),
            const SizedBox(height: 12),
            _buildStatusButton('Missed ❌', 'missed', Colors.red),
            const SizedBox(height: 12),
            _buildStatusButton('Reset 🔄', 'reset', Colors.grey),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, String value, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context, value),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.12),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color, width: 2.5),
          ),
          elevation: 0,
        ),
        child: Text(
          label, 
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<Habit> _applySearch(String query, List<Habit> habits) {
    if (query.trim().isEmpty) {
      return habits;
    } else {
      final lower = query.toLowerCase().trim();
      return habits.where((h) => h.name.toLowerCase().contains(lower)).toList();
    }
  }

  Widget _buildHomeContent() {
    return Consumer2<HabitProvider, AuthProvider>(
      builder: (context, habitProvider, authProvider, _) {
        final habits = habitProvider.habits;
        final filteredHabits = _applySearch(_searchController.text, habits);

        if (habitProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (habitProvider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error loading habits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    habitProvider.error!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 55, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Habit flow',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.navyBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      'Welcome ${authProvider.currentUser?.email?.split('@')[0] ?? 'User'}, lets improve!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade400
                            : AppColors.textLight,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.navyBlue.withValues(alpha: 0.3)
                              : AppColors.turquoise.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.navyBlue.withValues(alpha: 0.5)
                                : AppColors.turquoise.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              size: 18,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.turquoise
                                  : AppColors.navyBlue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Note for today',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.turquoise
                                    : AppColors.navyBlue,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800.withValues(alpha: 0.6)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _noteController,
                          maxLines: 3,
                          onChanged: (val) {
                            context.read<PreferencesProvider>().saveDailyNote(val);
                          },
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                            height: 1.4,
                          ),
                          decoration: InputDecoration(
                            hintText: "What's on your mind today? Write a reminder, intention, or thought you'd like to return to...",
                            hintStyle: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search habits...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800.withValues(alpha: 0.6)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                ),
              ),
            ),
            Expanded(
              child: filteredHabits.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.spa_outlined,
                          size: 72,
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No habits yet',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Start building better habits today',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (authProvider.currentUser != null) {
                            await habitProvider.createExampleHabits(
                              authProvider.currentUser!.uid,
                            );
                            await _loadTodayCompletions(authProvider.currentUser!.uid);
                          }
                        },
                        icon: const Icon(Icons.auto_awesome, size: 22),
                        label: const Text(
                          'Add Example Habits',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredHabits.length,
                itemBuilder: (context, index) {
                  final habit = filteredHabits[index];
                  final completionStatus = _todayCompletions[habit.id];

                  IconData statusIcon;
                  Color statusColor;
                  
                  if (completionStatus == CompletionStatus.completed) {
                    statusIcon = Icons.check_circle;
                    statusColor = Colors.green;
                  } else if (completionStatus == CompletionStatus.partial) {
                    statusIcon = Icons.adjust;
                    statusColor = Colors.orange;
                  } else if (completionStatus == CompletionStatus.missed) {
                    statusIcon = Icons.cancel;
                    statusColor = Colors.red;
                  } else {
                    statusIcon = Icons.radio_button_unchecked;
                    statusColor = Colors.grey.shade400;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _mapColor(habit.color),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _mapColor(habit.color).withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onLongPress: () {
                          habitProvider.deleteHabit(habit.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final result = await showDialog<String>(
                                    context: context,
                                    builder: (context) => _buildQuickMarkDialog(habit),
                                  );

                                  if (result != null && mounted) {
                                    final userId = authProvider.currentUser?.uid;
                                    if (userId != null) {
                                      if (result == 'reset') {
                                        await _resetHabitCompletion(userId, habit.id, DateTime.now());
                                      } else {
                                        await _markHabitCompletion(
                                          userId,
                                          habit.id,
                                          DateTime.now(),
                                          _statusFromString(result),
                                        );
                                      }

                                      if (!mounted) return;
                                      final achievementsProvider = context.read<AchievementsProvider>();
                                      if (!mounted) return;
                                      await achievementsProvider.calculateAchievements(userId);
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    statusIcon,
                                    color: statusColor,
                                    size: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        habit.name,
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : AppColors.textDark,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          decoration: completionStatus == CompletionStatus.completed 
                                              ? TextDecoration.lineThrough 
                                              : null,
                                          decorationColor: Colors.grey,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                    ),
                                    if (habit.hasReminder && habit.reminderDays != null && habit.reminderDays!.any((day) => day)) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.turquoise.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          Icons.notifications_active,
                                          size: 16,
                                          color: AppColors.turquoise,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey.shade600,
                                  size: 24,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HabitDetailScreen(habit: habit),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const AchievementsScreen(showAppBar: false);
      case 2:
        return const CalendarScreen(showAppBar: false);
      case 3:
        return const SettingsScreen(showAppBar: false);
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: _addHabit,
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.primary
              : AppColors.primary,
          unselectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
              : AppColors.textLight,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            context.read<PreferencesProvider>().saveTab(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Achievements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}