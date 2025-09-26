import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants/app_constants.dart';
import '../../helpers/alarm_model.dart';
import '../../helpers/storage_helper.dart';
import '../../helpers/notification_helper.dart';

class AlarmScreen extends StatefulWidget {
  final Position currentPosition;
  final String? currentAddress;

  const AlarmScreen({
    Key? key,
    required this.currentPosition,
    this.currentAddress,
  }) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final StorageHelper _storageHelper = StorageHelper();
  List<Alarm> _alarms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadAlarms();
  }

  Future<void> _initializeAndLoadAlarms() async {
    await _storageHelper.initialize();
    await _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final alarms = await _storageHelper.getAllAlarms();
      setState(() {
        _alarms = alarms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading alarms: $e');
    }
  }

  Future<void> _addAlarm() async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    final alarmDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Alarm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Alarm Title',
                hintText: 'Enter alarm title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Text(
              'Alarm Time: ${_formatDateTime(alarmDateTime)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                Navigator.of(context).pop(titleController.text);
              }
            },
            child: const Text('Set Alarm'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _saveAlarm(
        title: result,
        alarmTime: alarmDateTime,
        description:
            descriptionController.text.isNotEmpty ? descriptionController.text : null,
      );
    }
  }

  Future<void> _saveAlarm({
    required String title,
    required DateTime alarmTime,
    String? description,
  }) async {
    try {
      final alarm = Alarm(
        title: title,
        alarmTime: alarmTime,
        description: description,
        latitude: widget.currentPosition.latitude,
        longitude: widget.currentPosition.longitude,
      );

      final id = await _storageHelper.insertAlarm(alarm);
      final savedAlarm = alarm.copyWith(id: id);

      await NotificationHelper.scheduleAlarmNotification(savedAlarm);

      await _loadAlarms();
      _showSuccessSnackBar('Alarm set successfully!');
    } catch (e) {
      _showErrorSnackBar('Error setting alarm: $e');
    }
  }

  Future<void> _toggleAlarm(Alarm alarm) async {
    try {
      await _storageHelper.toggleAlarm(alarm.id!, !alarm.isActive);

      if (alarm.isActive) {
        await NotificationHelper.cancelAlarmNotification(alarm.id!);
      } else {
        await NotificationHelper.scheduleAlarmNotification(
          alarm.copyWith(isActive: true),
        );
      }

      await _loadAlarms();
    } catch (e) {
      _showErrorSnackBar('Error updating alarm: $e');
    }
  }

  Future<void> _deleteAlarm(Alarm alarm) async {
    try {
      await _storageHelper.deleteAlarm(alarm.id!);
      await NotificationHelper.cancelAlarmNotification(alarm.id!);
      await _loadAlarms();
      _showSuccessSnackBar('Alarm deleted successfully!');
    } catch (e) {
      _showErrorSnackBar('Error deleting alarm: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(AppConstants.primaryColor),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// ✅ Custom formatter for 12-hour clock
  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $period';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatTime(dateTime)}   Fri ${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.backgroundColor),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Location info
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Selected Location",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Location subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.currentAddress ??
                            '${widget.currentPosition.latitude.toStringAsFixed(4)}, '
                            '${widget.currentPosition.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Alarms list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _alarms.isEmpty
                        ? const Center(
                            child: Text(
                              'No alarms set',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _alarms.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final alarm = _alarms[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatTime(alarm.alarmTime),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${_monthName(alarm.alarmTime.month)} ${alarm.alarmTime.day}, ${alarm.alarmTime.year}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: alarm.isActive,
                                      onChanged: (_) => _toggleAlarm(alarm),
                                      activeColor: Colors.deepPurpleAccent,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
