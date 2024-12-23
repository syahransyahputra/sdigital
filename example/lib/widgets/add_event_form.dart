import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import 'custom_button.dart';
import 'date_time_selector.dart';

class AddOrEditEventForm extends StatefulWidget {
  final void Function(CalendarEventData)? onEventAdd;
  final CalendarEventData? event;

  const AddOrEditEventForm({
    super.key,
    this.onEventAdd,
    this.event,
  });

  @override
  _AddOrEditEventFormState createState() => _AddOrEditEventFormState();
}

class _AddOrEditEventFormState extends State<AddOrEditEventForm> {
  late DateTime _startDate = DateTime.now().withoutTime;
  late DateTime _endDate = DateTime.now().withoutTime;

  DateTime? _startTime;
  DateTime? _endTime;

  Color _color = Colors.blue;

  final _form = GlobalKey<FormState>();

  late final _descriptionController = TextEditingController();
  late final _titleController = TextEditingController();
  late final _titleNode = FocusNode();
  late final _descriptionNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _setDefaults();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();

    _descriptionController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: AppConstants.inputDecoration.copyWith(
              labelText: "Judul tugas",
            ),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            validator: (value) {
              final title = value?.trim();

              if (title == null || title == "") {
                return "Tolong masukan Judul tugas.";
              }

              return null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Tanggal mulai",
                  ),
                  initialDateTime: _startDate,
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime
                        .isAfter(_endDate.withoutTime)) {
                      _endDate = date.withoutTime;
                    }

                    _startDate = date.withoutTime;

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Tolong masukan tanggal mulai";
                    }

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _startDate = date ?? _startDate,
                  type: DateTimeSelectionType.date,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  initialDateTime: _endDate,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Tanggal Berakhir",
                  ),
                  onSelect: (date) {
                    if (date.withoutTime.withoutTime
                        .isBefore(_startDate.withoutTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Tanggal akhir terjadi sebelum tanggal mulai.'),
                      ));
                    } else {
                      _endDate = date.withoutTime;
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Tolong pilih tanggal berakhir.";
                    }

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _endDate = date ?? _endDate,
                  type: DateTimeSelectionType.date,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Waktu Mulai",
                  ),
                  initialDateTime: _startTime,
                  minimumDateTime: CalendarConstants.epochDate,
                  onSelect: (date) {
                    if (_endTime != null &&
                        date.getTotalMinutes > _endTime!.getTotalMinutes) {
                      _endTime = date.add(Duration(minutes: 1));
                    }
                    _startTime = date;

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onSave: (date) => _startTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Waktu Berakhir",
                  ),
                  initialDateTime: _endTime,
                  onSelect: (date) {
                    if (_startTime != null &&
                        date.getTotalMinutes < _startTime!.getTotalMinutes) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Waktu berakhir lebih awal dari waktu mulai.'),
                      ));
                    } else {
                      _endTime = date;
                    }

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onSave: (date) => _endTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _descriptionController,
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "") {
                return "Tolong masukan deskripsi tugas.";
              }

              return null;
            },
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Deskripsi Tugas",
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Text(
                "Warna Tugas: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _displayColorPicker,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Color.fromARGB(0xFF, 0x43, 0x38, 0x78),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: _createEvent,
            title: widget.event == null ? "Tambah Tugas" : "Update Tugas",
          ),
        ],
      ),
    );
  }

  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData(
      date: _startDate,
      endTime: _endTime,
      startTime: _startTime,
      endDate: _endDate,
      color: _color,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    widget.onEventAdd?.call(event);
    _resetForm();
  }

  void _setDefaults() {
    if (widget.event == null) return;

    final event = widget.event!;

    _startDate = event.date;
    _endDate = event.endDate;
    _startTime = event.startTime ?? _startTime;
    _endTime = event.endTime ?? _endTime;
    _titleController.text = event.title;
    _descriptionController.text = event.description ?? '';
  }

  void _resetForm() {
    _form.currentState?.reset();
    _startDate = DateTime.now().withoutTime;
    _endDate = DateTime.now().withoutTime;
    _startTime = null;
    _endTime = null;
    _color = Colors.blue;

    if (mounted) {
      setState(() {});
    }
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Select event color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _color = color;
                    });
                  }
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
