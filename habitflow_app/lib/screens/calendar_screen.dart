import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../repositories/habit_completion_repository.dart';
import '../models/habit_completion.dart';
import '../models/habit.dart';

class CalendarScreen extends StatefulWidget {
  final bool showAppBar;

  const CalendarScreen({super.key, this.showAppBar = true});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final HabitCompletionRepository _completionRepo = HabitCompletionRepository();
  DateTime _selectedMonth = DateTime.now();
  DateTime? _userSignupDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserSignupDate();
    });
  }

  Future<void> _getUserSignupDate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null) {
      setState(() {
        _userSignupDate = user.metadata.creationTime ?? DateTime.now();
      });
    }
  }

  bool _canGoToPreviousMonth() {
    if (_userSignupDate == null) return false;
    final previousMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    final signupMonth = DateTime(_userSignupDate!.year, _userSignupDate!.month);
    return !previousMonth.isBefore(signupMonth);
  }

  void _previousMonth() {
    if (_canGoToPreviousMonth()) {
      setState(() {
        _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
      });
    }
  }

  void _nextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    if (nextMonth.isBefore(DateTime(now.year, now.month + 1))) {
      setState(() {
        _selectedMonth = nextMonth;
      });
    }
  }

  String _getMonthName(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  Color _getStatusColor(CompletionStatus status) {
    switch (status) {
      case CompletionStatus.completed:
        return Colors.green;
      case CompletionStatus.partial:
        return Colors.yellow;
      case CompletionStatus.missed:
        return Colors.red;
    }
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      lastDay.day,
          (index) => DateTime(month.year, month.month, index + 1),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  void _showDayDetails(
      BuildContext context,
      DateTime date,
      List<HabitCompletion> completions,
      List<Habit> allHabits,
      ) {
    final completedCount = completions.where((c) => c.status == CompletionStatus.completed).length;
    final partialCount = completions.where((c) => c.status == CompletionStatus.partial).length;
    final missedCount = completions.where((c) => c.status == CompletionStatus.missed).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_getDayName(date)}, ${date.day} ${_getMonthName(date).split(' ')[0]}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Completed', completedCount, Colors.green),
                    _buildSummaryRow('Partial', partialCount, Colors.orange),
                    _buildSummaryRow('Missed', missedCount, Colors.red),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Habits',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...allHabits.map((habit) {
                final completion = completions.firstWhere(
                      (c) => c.habitId == habit.id,
                  orElse: () => HabitCompletion(
                    id: '',
                    habitId: habit.id,
                    userId: '',
                    date: date,
                    status: CompletionStatus.missed,
                    createdAt: DateTime.now(),
                  ),
                );

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    completion.status == CompletionStatus.completed
                        ? Icons.check_circle
                        : completion.status == CompletionStatus.partial
                        ? Icons.circle_outlined
                        : Icons.cancel,
                    color: _getStatusColor(completion.status),
                  ),
                  title: Text(habit.name),
                  subtitle: Text(
                    completion.status == CompletionStatus.completed
                        ? 'Completed'
                        : completion.status == CompletionStatus.partial
                        ? 'Partially Done'
                        : 'Missed',
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text('$label: $count'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);
    final userId = authProvider.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('Please login to view calendar'));
    }

    final content = StreamBuilder<List<HabitCompletion>>(
      stream: _completionRepo.getCompletionsForMonth(userId, _selectedMonth),
      builder: (context, completionSnapshot) {
        if (completionSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final completions = completionSnapshot.data ?? [];
        final daysInMonth = _getDaysInMonth(_selectedMonth);
        final userHabits = habitProvider.habits;

        // DEBUG: Print completions
        debugPrint('🔍 Total completions fetched: ${completions.length}');
        for (var c in completions) {
          debugPrint('📅 Completion: ${c.date} | Status: ${c.status.value} | HabitID: ${c.habitId}');
        }

        // Group completions by date
        final Map<String, List<HabitCompletion>> completionsByDate = {};
        for (var completion in completions) {
          final dateKey = '${completion.date.year}-${completion.date.month}-${completion.date.day}';
          debugPrint('🗓️ Date key: $dateKey for completion ${completion.id}');
          completionsByDate[dateKey] = completionsByDate[dateKey] ?? [];
          completionsByDate[dateKey]!.add(completion);
        }

        debugPrint('📊 Grouped completions by date: ${completionsByDate.keys.toList()}');

        return Column(
          children: [
            // Month header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: _canGoToPreviousMonth() ? Colors.black : Colors.grey,
                    ),
                    onPressed: _canGoToPreviousMonth() ? _previousMonth : null,
                  ),
                  Text(
                    _getMonthName(_selectedMonth),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: () {
                        final now = DateTime.now();
                        final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                        return nextMonth.isBefore(DateTime(now.year, now.month + 1))
                            ? Colors.black
                            : Colors.grey;
                      }(),
                    ),
                    onPressed: () {
                      final now = DateTime.now();
                      final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                      if (nextMonth.isBefore(DateTime(now.year, now.month + 1))) {
                        _nextMonth();
                      }
                    },
                  ),
                ],
              ),
            ),

            // Days list - ALL DAYS WILL RENDER HERE
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: daysInMonth.length,
                itemBuilder: (context, index) {
                  final date = daysInMonth[index];
                  final dateKey = '${date.year}-${date.month}-${date.day}';
                  final dayCompletions = completionsByDate[dateKey] ?? [];
                  final totalHabits = userHabits.length;
                  final completedCount = dayCompletions
                      .where((c) => c.status == CompletionStatus.completed)
                      .length;

                  return InkWell(
                    onTap: () => _showDayDetails(context, date, dayCompletions, userHabits),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _getDayName(date),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              children: dayCompletions.isEmpty
                                  ? [_buildDot(Colors.grey.shade300)]
                                  : dayCompletions
                                  .map((c) => _buildDot(_getStatusColor(c.status)))
                                  .toList(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$completedCount/$totalHabits',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Legend
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      _buildDot(Colors.green),
                      const SizedBox(width: 6),
                      const Text("Complete", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildDot(Colors.yellow),
                      const SizedBox(width: 6),
                      const Text("Partial", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildDot(Colors.red),
                      const SizedBox(width: 6),
                      const Text("Missed", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month, size: 20),
              SizedBox(width: 6),
              Text("Calendar"),
            ],
          ),
          centerTitle: true,
        ),
        body: content,
      );
    }

    return content;
  }
}