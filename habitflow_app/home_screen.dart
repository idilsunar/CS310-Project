import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Color _mapColor(String? colorName) {
    if (colorName == null) {
      return AppColors.primary; // varsayılan renk
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

  // Tüm habitler
  List<Habit> habits = [];

  // Ekranda gösterilen (filtreli) habitler
  List<Habit> filteredHabits = [];

  @override
  void initState() {
    super.initState();
    filteredHabits = List.from(habits);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Add Habit ekranından yeni habit alma
  Future<void> _addHabit() async {
    final result = await Navigator.pushNamed(context, '/addHabit');

    if (result != null && result is Habit) {
      setState(() {
        habits.add(result);
      });
      _applySearch(_searchController.text); // mevcut search'e göre listeyi güncelle
    }
  }

  void _applySearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        // boşsa hepsini göster
        filteredHabits = List.from(habits);
      } else {
        final lower = query.toLowerCase().trim();
        filteredHabits = habits
            .where((h) => h.name.toLowerCase().contains(lower))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'AppBar-HabitFlow',
          style: AppTextStyles.title,
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          // LOGO
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 70,
            ),
          ),

          const SizedBox(height: 12),

          // SEARCH BAR (gerçek filtre)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _applySearch,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextStyles.subtitle,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // HABIT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filteredHabits.length,
              itemBuilder: (context, index) {
                final habit = filteredHabits[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: _mapColor(habit.color),
                      width: 2,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        habit.isDone
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: habit.isDone ? Colors.green : AppColors.textDark,
                      ),
                      onPressed: () {
                        setState(() {
                          habit.isDone = !habit.isDone;
                        });
                      },
                    ),

                    title: Text(
                      habit.name,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textDark,
                        fontSize: 18,
                      ),
                    ),

                    // önce info, sonra alarm
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/habitDetail',
                              arguments: habit,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/reminder',
                              arguments: habit,
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

          // NOTE FOR TODAY
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Note for today:',
                alignLabelWithHint: true,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/calendar');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}