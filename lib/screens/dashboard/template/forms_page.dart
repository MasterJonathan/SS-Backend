import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormsDemoPage extends StatefulWidget {
  const FormsDemoPage({super.key});

  @override
  State<FormsDemoPage> createState() => _FormsDemoPageState();
}

class _FormsDemoPageState extends State<FormsDemoPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _selectedOption;
  bool _isChecked = false;
  double _sliderValue = 50;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomCard(
      key: const PageStorageKey('formsPage'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Form Elements Showcase', style: textTheme.headlineSmall),
              const SizedBox(height: 24),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Enter your full name', prefixIcon: Icon(Icons.person_outline)),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your name';
                  return null;
                },
                onSaved: (value) => _name = value,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Email Address', hintText: 'your.email@example.com', prefixIcon: Icon(Icons.email_outlined)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter an email';
                  if (!value.contains('@')) return 'Please enter a valid email';
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select an Option', prefixIcon: Icon(Icons.arrow_drop_down_circle_outlined)),
                value: _selectedOption,
                items: ['Option 1', 'Option 2', 'Option 3']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedOption = value),
                validator: (value) => value == null ? 'Please select an option' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select Date',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'No date chosen'
                              : DateFormat.yMMMMd().format(_selectedDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                   Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select Time',
                           prefixIcon: Icon(Icons.access_time_outlined),
                        ),
                        child: Text(
                          _selectedTime == null
                              ? 'No time chosen'
                              : _selectedTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: const Text('Agree to terms and conditions'),
                value: _isChecked,
                onChanged: (bool? value) => setState(() => _isChecked = value!),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              Text('Select Value (Slider): ${_sliderValue.round()}', style: textTheme.bodyLarge),
              Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                divisions: 100,
                label: _sliderValue.round().toString(),
                onChanged: (double value) => setState(() => _sliderValue = value),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt_outlined),
                  label: const Text('Submit Form'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form submitted successfully!'), backgroundColor: Colors.green),
                      );
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please correct the errors in the form.'), backgroundColor: Colors.red),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}