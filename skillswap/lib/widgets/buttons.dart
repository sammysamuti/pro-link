import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  final String text;
  final Color btnclr;
  final Color textclr;
  final double width;
  final double height;
  final void Function() click;
  final double fontsize;
  ButtonOne(this.text, this.textclr, this.btnclr, this.width, this.height,
      this.fontsize, this.click,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: click,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set border radius
          ),
        ),
        minimumSize: MaterialStateProperty.all(
            Size(width, height)), // Set width and height
        backgroundColor:
            MaterialStateProperty.all<Color>(btnclr), // Set color to red
      ),
      child: Text(
        text,
        style: TextStyle(color: textclr, fontSize: fontsize),
      ),
    );
  }
}

class ButtonTwo extends StatelessWidget {
  final String text;
  final Color btnclr;
  final Color textclr;
  final void Function() click;
  final double width;
  final double height;
  final double fontsize;
  ButtonTwo(this.text, this.textclr, this.btnclr, this.width, this.height,
      this.fontsize, this.click,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: click,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double?>(4),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set border radius
          ),
        ),
        minimumSize: MaterialStateProperty.all(
            Size(width, height)), // Set width and height
        backgroundColor:
            MaterialStateProperty.all<Color>(btnclr), // Set color to red
      ),
      child: Text(
        text,
        style: TextStyle(color: textclr, fontSize: fontsize),
      ),
    );
  }
}

class Upload extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color btnclr;
  final Color textclr;
  final void Function() click;
  final double width;
  final double height;
  final double fontsize;
  Upload(this.icon,this.text, this.textclr, this.btnclr, this.width, this.height,
      this.fontsize, this.click,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: click,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double?>(4),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set border radius
            ),
          ),
          minimumSize: MaterialStateProperty.all(
              Size(width, height)), // Set width and height
          backgroundColor:
              MaterialStateProperty.all<Color>(btnclr), // Set color to red
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color:  Color(0XFF2E307A),),
            Text(
              text,
              style: TextStyle(color: textclr, fontSize: fontsize),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonTwoLoading extends StatelessWidget {
  final String text;
  final Color btnclr;
  final Color textclr;
  final void Function() click;
  final double width;
  final double height;
  final double fontsize;
  bool isLoading;
  ButtonTwoLoading(this.text, this.textclr, this.btnclr, this.width,
      this.height, this.fontsize, this.click, this.isLoading,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: click,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double?>(4),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set border radius
          ),
        ),
        minimumSize: MaterialStateProperty.all(
            Size(width, height)), // Set width and height
        backgroundColor:
            MaterialStateProperty.all<Color>(btnclr), // Set color to red
      ),
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ) // Show loading indicator
          : Text(
              text,
              style: TextStyle(color: textclr, fontSize: fontsize),
            ),
    );
  }
}

class ButtonThree extends StatelessWidget {
  final String text;
  final Color btnclr;
  final Color textclr;
  final double width;
  final double height;
  final void Function() click;
  ButtonThree(
      this.text, this.textclr, this.btnclr, this.width, this.height, this.click,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: click,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set border radius
          ),
        ),
        minimumSize: MaterialStateProperty.all(
            Size(width, height)), // Set width and height
        backgroundColor:
            MaterialStateProperty.all<Color>(btnclr), // Set color to red
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: textclr,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_outlined,
            size: 30,
          )
        ],
      ),
    );
  }
}

class FormText extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final double fontSize;

  const FormText(
      {required this.text, required this.alignment, this.fontSize = 15.0});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final double width;
  final double height;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  CustomTextFormField({
    required this.width,
    required this.height,
    this.labelText = '',
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height + 20,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: Color.fromARGB(255, 237, 241, 245),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 237, 241, 245)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 237, 241, 245)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 237, 241, 245)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: suffixIcon != null ? suffixIcon : null,
        ),
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomTextFormFieldTwo extends StatelessWidget {
  final double width;
  final double height;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final int? maxLine;
  final int? minLine;
  CustomTextFormFieldTwo(
      {required this.width,
      required this.height,
      this.labelText = '',
      required this.hintText,
      required this.controller,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.suffixIcon,
      this.onChanged,
      this.maxLine,
      this.minLine});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: 400,
      child: TextFormField(
        controller: controller,
        // minLines: minLine,
        maxLines: maxLine,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: Color.fromARGB(255, 237, 241, 245),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 237, 241, 245)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 237, 241, 245)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color.fromARGB(255, 237, 241, 245)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: suffixIcon != null ? suffixIcon : null,
        ),
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      ),
    );
  }
}




class Filter extends StatelessWidget {
  final String text;
  final Color btnclr;
  final Color textclr;
  final double width;
  final double height;
  final void Function() click;
  final double fontsize;
  Filter(this.text, this.textclr, this.btnclr, this.width, this.height,
      this.fontsize, this.click,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: click,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set border radius
          ),
        ),
        minimumSize: MaterialStateProperty.all(
            Size(width, height)), // Set width and height
        backgroundColor:
            MaterialStateProperty.all<Color>(btnclr), // Set color to red
      ),
      child: Text(
        text,
        style: TextStyle(color: textclr, fontSize: fontsize),
      ),
    );
  }
}