import 'package:flutter/material.dart';
import 'package:linkschool/modules/common/constants.dart';

class ExploreAdmission extends StatefulWidget {
  const ExploreAdmission({super.key, required double height});

  @override
  State<ExploreAdmission> createState() => _ExploreAdmissionState();
}

class _ExploreAdmissionState extends State<ExploreAdmission> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:Constants.customBoxDecoration(context),
    );
  }
}