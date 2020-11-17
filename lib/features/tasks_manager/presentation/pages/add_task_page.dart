import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasks_app/core/constants.dart';
import 'package:tasks_app/core/util/logger.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final log = logger.log;
  TextEditingController _controller1;

  @override
  void initState() {
    _controller1 = TextEditingController(text: DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // prevent auto-rotate screen to landscape position
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'Add Task',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.grey[700],
        ),
      ),
      body: Container(
        // padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  child: Text(
                    "Title",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                // focusNode: _emailFocus,
                decoration: textInputDecoration.copyWith(hintText: ''),
                keyboardType: TextInputType.text,
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                maxLines: 5,
                minLines: 3,
                onChanged: (val) {
                  // setState(() => email = val);
                },
                // initialValue: email != null ? email : "",
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term){
                  // _fieldFocusChange(context, _emailFocus, _passwordFocus);
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: Colors.grey[600],
                thickness: 0.5,
                height: 0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 15),
                  child: Text(
                    "Priority",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomRadioButton(
                elevation: 0,
                enableButtonWrap: true,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  'High',
                  'Medium',
                  'Low',
                ],
                buttonValues: [
                  "HIGH",
                  "MEDIUM",
                  "LOW",
                ],
                buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)
                ),
                radioButtonValue: (value) {
                  log.d(value);
                },
                selectedColor: Theme.of(context).accentColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: Colors.grey[600],
                thickness: 0.5,
                height: 0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 15),
                  child: Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
              // focusNode: _emailFocus,
                decoration: textInputDecoration.copyWith(hintText: ''),
                keyboardType: TextInputType.text,
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                maxLines: 5,
                minLines: 3,
                onChanged: (val) {
                  // setState(() => email = val);
                },
                // initialValue: email != null ? email : "",
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term){
                  // _fieldFocusChange(context, _emailFocus, _passwordFocus);
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: Colors.grey[600],
                thickness: 0.5,
                height: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                controller: _controller1,
                //initialValue: _initialValue,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Time",
                onChanged: (val)
                {
                  log.d("time1: $val");
                  DateTime date = DateTime.parse(val);
                  log.d("time after: $date");
                },
                onSaved: (val)
                {
                  log.d("time2: $val");
                }
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Text(
                      "Create event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19
                      ),
                    ),
                    color: Colors.blueAccent,
                    onPressed: ()
                    {

                    },
                    minWidth: screenSize.width,
                    height: 50,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}