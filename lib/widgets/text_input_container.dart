import 'package:flutter/material.dart';

class TextInputContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final IconData? icon;
  final Widget? heading;
  final Widget? trailing;
  // ignore: use_key_in_widget_constructors
  const TextInputContainer({
      this.icon,
      this.heading,
      this.trailing,
      this.width,
      required this.child,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?? MediaQuery.of(context).size.width,
      height: 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading!,
          const SizedBox(height: 5),
          Container(
            color: const Color.fromARGB(255, 56, 56, 56),
            child: Row(
              children: [
                if (icon != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: const Color(0xffd7d7d7),
                    ),
                    height: 50,
                    width: 50,
                    child: Center(
                      child: Icon(
                        icon,
                        color: const Color.fromARGB(255, 140, 140, 140),
                      ),
                    ),
                  ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: child,),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
