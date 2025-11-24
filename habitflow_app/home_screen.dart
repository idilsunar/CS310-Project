import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';
import 'reminder_setting_screen.dart';
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
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Yellow':
        return Colors.yellow;
      case 'Purple':
        return Colors.purple;
      case 'Grey':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  List<Habit> habits = [
    Habit(name: 'Morning Run', category: 'Sports and activities', frequency: '4 times per week', color: 'Blue', isDone: false),
    Habit(name: 'Read Book', category: 'Personal growth', frequency: 'Every day', color: 'Green', isDone: false),
    Habit(name: 'Meditation', category: 'Health', frequency: 'Every day', color: 'Purple', isDone: true),
    Habit(name: 'Study Time', category: 'Work', frequency: '3 times per week', color: 'Orange', isDone: false),
  ];

  List<Habit> filteredHabits = [];

  @override
  void initState() {
    super.initState();
    filteredHabits = List.from(habits);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addHabit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );

    if (result != null && result is Habit) {
      setState(() {
        habits.add(result);
      });
      _applySearch(_searchController.text);
    }
  }

  void _applySearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredHabits = List.from(habits);
      } else {
        final lower = query.toLowerCase().trim();
        filteredHabits = habits
            .where((h) => h.name.toLowerCase().contains(lower))
            .toList();
      }
    });
  }

  Widget _buildHomeContent() {
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
                Colors.white,
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
                  const Text(
                    'Habit Flow',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4EFF),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  'Welcome User, lets improve!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: TextField(
                  controller: _noteController,
                  maxLines: 3,
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
            onChanged: _applySearch,
            decoration: InputDecoration(
              hintText: 'Search habits...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
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
                        color: Colors.white,
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
                          onPressed: () {
                            setState(() {
                              habit.isDone = !habit.isDone;
                            });
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
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
                            IconButton(
                              icon: Icon(
                                Icons.notifications_none,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ReminderSettingScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onLongPress: () {
                          setState(() {
                            habits.remove(habit);
                          });
                          _applySearch(_searchController.text);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
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
