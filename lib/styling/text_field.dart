import 'package:flutter/material.dart';
import 'package:success_stations/styling/colors.dart';
class CustomTextFiled extends StatefulWidget {
  final String hintText;
  final hintStyle;
  final String errorText;
  final bool isObscure;
  final bool isIcon;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final ValueChanged onFieldSubmitted;
  final FormFieldSetter<String> onSaved;
  final ValueChanged onChanged;
  final bool autoFocus;
  final  validator;
  final contentPadding;
  final keyboardType;
  final maxLine;
  CustomTextFiled(
    {
      this.hintText ='',
      required this.errorText,
      required this.isObscure ,
      required this.textController,
      this.isIcon = true,
      this.padding = const EdgeInsets.only(left:0),
      this.hintColor = Colors.black,
      this.iconColor = Colors.black  ,
      required this.onFieldSubmitted,
      required this.onChanged,
      this.autoFocus = true,
      required this.validator,
      required this.onSaved,
      this.hintStyle,
      this.contentPadding,
      this.keyboardType,
      this.maxLine

    }
  );
  @override
  _CustomTextFiledState createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height:55,
          child: Padding(
            padding: widget.padding,
            child: TextFormField( 
              maxLines: widget.maxLine,
              keyboardType: widget.keyboardType, 
              style: TextStyle(
                color:AppColors.inputTextColor
              ),   
                focusNode: FocusNode(),      
                controller: widget.textController,
                onFieldSubmitted: widget.onFieldSubmitted,
                onChanged: widget.onChanged,
                validator: widget.validator,
                obscureText: widget.isObscure,
                onSaved: widget.onSaved,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: widget.contentPadding,
                  fillColor: AppColors.inputColor,
                  filled: true,
                  // border: InputBorder.none,
                  errorBorder: OutlineInputBorder(
                     borderSide: BorderSide(
                      color: Colors.red
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                     borderSide: BorderSide(
                      color: Colors.red
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade200
                    ),
                  ),
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle
                ),
              ),
            ),
          ),
      ],
    );
  }
}