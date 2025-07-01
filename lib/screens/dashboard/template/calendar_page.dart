import 'package:admin_dashboard_template/core/theme/app_colors.dart';
import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAdminPage extends StatefulWidget {
  const CalendarAdminPage({super.key});

  @override
  State<CalendarAdminPage> createState() => _CalendarAdminPageState();
}

class _CalendarAdminPageState extends State<CalendarAdminPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {}; // Example events

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Sample events
    _events = {
      DateTime.now().subtract(const Duration(days: 2)): [Event('Event A'), Event('Event B')],
      DateTime.now(): [Event('Event C')],
      DateTime.now().add(const Duration(days: 3)): [Event('Event D'), Event('Event E'), Event('Event F')],
    };
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomCard(
      key: const PageStorageKey('calendarPage'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Event Calendar', style: textTheme.headlineSmall),
          const SizedBox(height: 20),
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              formatButtonDecoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 20.0),
          Text("Events for ${_selectedDay != null ? DateFormat.yMMMMd().format(_selectedDay!) : 'selected day'}:", style: textTheme.titleMedium),
          const SizedBox(height: 8.0),
          Expanded(
            child: _selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty
                ? ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      final event = _getEventsForDay(_selectedDay!)[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary.withAlpha(10)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(event.title),
                          leading: Icon(Icons.event, color: AppColors.primary.withAlpha(10)),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No events for this day.')),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  Event(this.title);

  @override
  String toString() => title;
}