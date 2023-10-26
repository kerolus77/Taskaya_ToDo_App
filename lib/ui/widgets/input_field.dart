// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/ui/size_config.dart';
import 'package:to_do/ui/theme.dart';

class InputField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final bool maxLines;


  InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    this.maxLines=false,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
 bool test=false;
final FocusNode _focusNode = FocusNode();

@override
void initState() {
  super.initState();
 
  _focusNode.addListener(_onFocusChange);
}

void _onFocusChange() {
  if (!_focusNode.hasFocus) {
    
    _validation(widget.controller?.text, widget.title);
  }
}

@override
void dispose() {
  _focusNode.dispose(); 
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: titleStyle),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            width: SizeConfig.screenWidth,
             height:widget.maxLines?130: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all( color:!test?Colors.grey:Colors.red),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    autofocus: false,
                    maxLines: widget.maxLines?1000:2, // <-- SEE HERE
                    minLines: widget.maxLines?5:1,
                    readOnly: widget.widget != null ? true : false,
                    style: subtitleStyle,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    validator: test
                          ? (value) {
          if (isRequiredFieldValid(value)) {
          setState(() {
            test=false;
          });
          } else {
           _validation(value, widget.title);
          }
          return null;
        }
      :null,
        focusNode: _focusNode,
              onChanged: (value) { if (isRequiredFieldValid(value)) {
          setState(() {
            test=false;
          });
          } },
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: subtitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          // ignore: deprecated_member_use
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          // ignore: deprecated_member_use
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                      
                    ),
                  ),
                ),
                widget.widget ?? Container(),
              ],
            ),
          ),
          test?AnimatedContainer(
            margin: const EdgeInsets.only(left: 15,top: 5),
            duration: const Duration(seconds: 2),
            
            
            child: Text('${widget.title} is required!')):Container(),
        ],
      ),
      
    );
  }

bool isRequiredFieldValid(String? value) {
  return value != null && value.isNotEmpty;
}
String? _validation(String? value, String field) {
    if (field == 'Title' || field == 'Note') {
      if (value == null || value.isEmpty) {
        setState(() {
       test =true;
        });
      }
    }
    return null;
  }
}
