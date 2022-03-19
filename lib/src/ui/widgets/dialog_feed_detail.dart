import 'package:dartnyom/protonyom_models.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:ohmnyomer/generated/l10n.dart';
import 'package:ohmnyomer/src/ui/timestamp.dart';
import 'package:ohmnyomer/src/ui/widgets/builder_functions.dart';
import 'package:ohmnyomer/src/ui/widgets/constants.dart';
import 'package:ohmnyomer/src/ui/widgets/error_dialog.dart';

class DialogFeedDetail extends StatefulWidget {
  const DialogFeedDetail(this._amount, this._unit, this._feedTime, {Key? key}) : super(key: key);

  final DateTime _feedTime;
  final double _amount;
  final String _unit;

  @override
  State<StatefulWidget> createState() => _DialogFeedDetailState();
}

class _DialogFeedDetailState extends State<DialogFeedDetail> {
  late DateTime _feedTime;
  late double _amount;
  late String _unit;

  @override
  void initState() {
    _feedTime = widget._feedTime;
    _amount = widget._amount;
    _unit = widget._unit;
    if (_amount > 0.0) {
      _amountInputController.text = _amount.toString();
    }
    super.initState();
  }

  final TextEditingController _amountInputController = TextEditingController();

  Widget _buildFeedRow() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: buildSimpleTextField('0.0', TextInputType.number, _amountInputController),
              flex: 5,
            ),
            const SizedBox(width: 20.0),
            Expanded(child: infoText(_unit), flex: 1,),
      ],
    ));
  }

  Widget _buildFeedTimeRow() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              child: Container(
                height: 60.0,
                alignment: Alignment.center,
                child: infoText(_feedTime.formatDate()),
              ),
              onTap: () {
                Future<DateTime?> selectedDate = showDatePicker(
                  context: context,
                  initialDate: _feedTime,
                  firstDate: DateTime(_feedTime.year, _feedTime.month),
                  lastDate: DateTime(2099),
                );
                selectedDate.then((d) {
                  if (d!= null) {
                    setState(() {
                      _feedTime = DateTime(d.year, d.month, d.day,
                          _feedTime.hour, _feedTime.minute, _feedTime.second);
                    });
                  }
                });
              },
            ),
            InkWell(
              child: Container(
                height: 60.0,
                alignment: Alignment.center,
                child: infoText(_feedTime.formatTime()),
              ),
              onTap: () {
                Future<TimeOfDay?> selectedDate = showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: _feedTime.hour, minute: _feedTime.minute),
                );
                selectedDate.then((t) {
                  if (t!= null) {
                    setState(() {
                      _feedTime = DateTime(_feedTime.year, _feedTime.month, _feedTime.day,
                          t.hour, t.minute);
                    });
                  }
                });
              },
            ),
          ],
        );
  }

  Widget _buildCancelButton() {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.cancel_outlined, color: Colors.black54),
    );
  }

  Widget _buildSaveButton() {
    return IconButton(
        onPressed: () {
          double amount = 0.0;
          try {
            amount = double.parse(_amountInputController.text);
          } catch (e) {
            amount = 0.0;
          }
          if (amount <= 0.0) {
            ErrorDialog().showInputAssert(context,
              S.of(context).feed_zero_amount,
              S.of(context).more_food_please,
            );
          } else {
            Feed f = Feed()
              ..amount = double.parse(_amountInputController.text)
              ..unit = _unit
              ..timestamp = Int64(_feedTime.toSecondsSinceEpoch());
            Navigator.of(context).pop(f);
          }
        },
        icon: const Icon(Icons.send, color: Colors.black54),
    );
  }

  Widget _buildActionsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCancelButton(),
          const SizedBox(width: 20.0),
          _buildSaveButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
      title: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Image.asset('assets/feed/bowl-full.jpeg'),
        ),
      ),
      children: [
        const Divider(),
        _buildFeedRow(),
        const Divider(),
        _buildFeedTimeRow(),
        const Divider(),
        _buildActionsRow(),
      ],
      elevation: 10.0,
      contentPadding: const EdgeInsets.all(20.0),
    );
  }
}
