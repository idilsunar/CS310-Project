import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final habitProvider = context.read<HabitProvider>();
      final prefsProvider = context.read<PreferencesProvider>();

      if (authProvider.currentUser != null) {
        habitProvider.loadHabits(authProvider.currentUser!.uid);
      }

      setState(() {
        _selectedIndex = prefsProvider.lastSelectedTab;
      });

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

  Widget _buildQuickMarkDialog(Habit habit) {
    return AlertDialog(
      title: Text('Mark "${habit.name}"'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How did you do today?'),
          const SizedBox(height: 16),
          _buildStatusButton('Completed ✅', 'completed', Colors.green),
          const SizedBox(height: 8),
          _buildStatusButton('Partially Done 🟡', 'partial', Colors.orange),
          const SizedBox(height: 8),
          _buildStatusButton('Missed ❌', 'missed', Colors.red),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String label, String value, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context, value),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color, width: 2),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading habits',
                  style: TextStyle(fontSize: 18, color: Colors.red.shade400),
                ),
                const SizedBox(height: 8),
                Text(
                  habitProvider.error!,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
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
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Habit flow',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navyBlue,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Welcome ${authProvider.currentUser?.email ?? 'User'}, lets improve!',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                          width: 1.5
                      ),
                    ),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      onChanged: (val) {
                        context.read<PreferencesProvider>().saveDailyNote(val);
                      },
                      decoration: InputDecoration(
                        labelText: 'Note for today:',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search habits...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            Expanded(
              child: filteredHabits.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.spa_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No habits yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to create your first habit',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (authProvider.currentUser != null) {
                          await habitProvider.createExampleHabits(
                            authProvider.currentUser!.uid,
                          );
                        }
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Add Example Habits'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredHabits.length,
                itemBuilder: (context, index) {
                  final habit = filteredHabits[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _mapColor(habit.color),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _mapColor(habit.color).withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      leading: IconButton(
                        icon: Icon(
                          habit.isDone
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: habit.isDone ? Colors.green : Colors.grey.shade400,
                          size: 32,
                        ),
                        onPressed: () async {
                          // Show completion dialog
                          final result = await showDialog<String>(
                            context: context,
                            builder: (context) => _buildQuickMarkDialog(habit),
                          );

                          if (result != null && mounted) {
                            // Mark habit in Firestore
                            final userId = authProvider.currentUser?.uid;
                            if (userId != null) {
                              await _markHabitCompletion(
                                userId,
                                habit.id,
                                DateTime.now(),
                                _statusFromString(result),
                              );

                              // Refresh achievements after marking
                              if (!mounted) return;
                              final achievementsProvider = context.read<AchievementsProvider>();
                              if (!mounted) return;
                              await achievementsProvider.calculateAchievements(userId);
                            }
                          }
                        },
                      ),
                      title: Text(
                        habit.name,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration: habit.isDone ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.grey,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.grey.shade600,
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
                      onLongPress: () {
                        habitProvider.deleteHabit(habit.id);
                      },
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
        elevation: 4,
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
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
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