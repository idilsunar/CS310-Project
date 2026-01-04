import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../repositories/habit_completion_repository.dart';
import '../models/habit_completion.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';

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
  late PageController _pageController;
  int _currentPageIndex = 12 * 100;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserSignupDate();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    if (nextMonth.isBefore(DateTime(now.year, now.month + 1))) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  DateTime _getMonthForPage(int pageIndex) {
    final referenceDate = DateTime.now();
    final monthsOffset = pageIndex - _currentPageIndex;
    return DateTime(referenceDate.year, referenceDate.month + monthsOffset);
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      _selectedMonth = _getMonthForPage(pageIndex);
    });
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
        return Colors.orange;
      case CompletionStatus.missed:
        return Colors.red;
    }
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    
    final startWeekday = firstDay.weekday;
    final daysFromPreviousMonth = startWeekday - 1;
    
    final List<DateTime> days = [];
    
    for (int i = daysFromPreviousMonth; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }
    
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }
    
    final remainingDays = 42 - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(lastDay.add(Duration(days: i)));
    }
    
    return days;
  }

  void _showDayDetails(
      BuildContext context,
      DateTime date,
      List<HabitCompletion> completions,
      List<Habit> allHabits,
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final completedCount = completions.where((c) => c.status == CompletionStatus.completed).length;
    final partialCount = completions.where((c) => c.status == CompletionStatus.partial).length;
    final missedCount = completions.where((c) => c.status == CompletionStatus.missed).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        title: Text(
          '${_getDayName(date)}, ${date.day} ${_getMonthName(date).split(' ')[0]}',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                      : AppColors.lightTurquoise.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Completed', completedCount, Colors.green, theme),
                    _buildSummaryRow('Partial', partialCount, Colors.orange, theme),
                    _buildSummaryRow('Missed', missedCount, Colors.red, theme),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Habits',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
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
                  title: Text(
                    habit.name,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  subtitle: Text(
                    completion.status == CompletionStatus.completed
                        ? 'Completed'
                        : completion.status == CompletionStatus.partial
                        ? 'Partially Done'
                        : 'Missed',
                    style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
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

  Widget _buildSummaryRow(String label, int count, Color color, ThemeData theme) {
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
          Text(
            '$label: $count',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(
      DateTime month,
      Map<String, List<HabitCompletion>> completionsByDate,
      List<Habit> userHabits,
      ThemeData theme,
      bool isDark,
      ) {
    final daysInMonth = _getDaysInMonth(month);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => SizedBox(
              width: 40,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ))
                .toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: daysInMonth.length,
            itemBuilder: (context, index) {
              final date = daysInMonth[index];
              final isCurrentMonth = date.month == month.month;
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final dateKey = '${date.year}-${date.month}-${date.day}';
              final dayCompletions = completionsByDate[dateKey] ?? [];
              final totalHabits = userHabits.length;
              final completedCount = dayCompletions
                  .where((c) => c.status == CompletionStatus.completed)
                  .length;
              
              Color? cellColor;
              if (isCurrentMonth && dayCompletions.isNotEmpty) {
                final percentage = totalHabits > 0 ? completedCount / totalHabits : 0;
                if (percentage == 1.0) {
                  cellColor = Colors.green.withOpacity(0.3);
                } else if (percentage >= 0.5) {
                  cellColor = Colors.orange.withOpacity(0.3);
                } else if (percentage > 0) {
                  cellColor = Colors.yellow.withOpacity(0.3);
                } else {
                  cellColor = Colors.red.withOpacity(0.2);
                }
              }

              return InkWell(
                onTap: isCurrentMonth
                    ? () => _showDayDetails(context, date, dayCompletions, userHabits)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: cellColor,
                    border: isToday
                        ? Border.all(color: AppColors.turquoise, width: 2)
                        : Border.all(
                      color: isDark
                          ? theme.colorScheme.outline.withOpacity(0.2)
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: !isCurrentMonth
                              ? theme.colorScheme.onSurface.withOpacity(0.3)
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (isCurrentMonth && dayCompletions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '$completedCount/$totalHabits',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface.withOpacity(0.5)
                : Colors.grey.shade50,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? theme.colorScheme.outline.withOpacity(0.2)
                    : Colors.grey.shade200,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('All Done', Colors.green.withOpacity(0.3), theme),
              _buildLegendItem('Most Done', Colors.orange.withOpacity(0.3), theme),
              _buildLegendItem('Some Done', Colors.yellow.withOpacity(0.3), theme),
              _buildLegendItem('None Done', Colors.red.withOpacity(0.2), theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);
    final userId = authProvider.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('Please login to view calendar'));
    }

    final content = SafeArea(
      child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark 
                ? theme.colorScheme.surface.withOpacity(0.3)
                : AppColors.lightTurquoise.withOpacity(0.3),
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
                  color: _canGoToPreviousMonth() 
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.3),
                ),
                onPressed: _canGoToPreviousMonth() ? _previousMonth : null,
              ),
              Text(
                _getMonthName(_selectedMonth),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: () {
                    final now = DateTime.now();
                    final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                    return nextMonth.isBefore(DateTime(now.year, now.month + 1))
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(0.3);
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
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, pageIndex) {
              final monthForPage = _getMonthForPage(pageIndex);
              
              return StreamBuilder<List<HabitCompletion>>(
                stream: _completionRepo.getCompletionsForMonth(userId, monthForPage),
                builder: (context, completionSnapshot) {
                  if (completionSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final completions = completionSnapshot.data ?? [];
                  final userHabits = habitProvider.habits;

                  final Map<String, List<HabitCompletion>> completionsByDate = {};
                  for (var completion in completions) {
                    final dateKey = '${completion.date.year}-${completion.date.month}-${completion.date.day}';
                    completionsByDate[dateKey] = completionsByDate[dateKey] ?? [];
                    completionsByDate[dateKey]!.add(completion);
                  }

                    return _buildCalendarGrid(
                      monthForPage,
                      completionsByDate,
                      userHabits,
                      theme,
                      isDark,
                  );
                },
              );
            },
          ),
        ),
      ],
      ),
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
