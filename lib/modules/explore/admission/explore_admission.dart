import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/common/constants.dart';
import 'package:linkschool/modules/common/text_styles.dart';

class ExploreAdmission extends StatefulWidget {
  const ExploreAdmission({super.key, required this.height});

  final double height;

  @override
  State<ExploreAdmission> createState() => _ExploreAdmissionState();
}

class _ExploreAdmissionState extends State<ExploreAdmission> {
    final _schoolItems =[
      _SearchItems(
        title:'SOLIS',
         formSales: 'Form for sale at ₦10,000.00',
         admissionDistanc: '2km',
         admissionStatus:'closed', image: Image(image: AssetImage('assets/images/millionaire.png')), ),
      _SearchItems(
        title:'SOLIS',
         formSales: 'Form for sale at ₦10,000.00',
         admissionDistanc: '2km',
         admissionStatus:'closed', image: Image(image: AssetImage('assets/images/millionaire.png')), ),
      _SearchItems(
        title:'SOLIS',
         formSales: 'Form for sale at ₦10,000.00',
         admissionDistanc: '2km',
         admissionStatus:'closed', image: Image(image: AssetImage('assets/images/millionaire.png')), ),
      _SearchItems(
        title:'SOLIS',
         formSales: 'Form for sale at ₦10,000.00',
         admissionDistanc: '2km',
         admissionStatus:'closed', image: Image(image: AssetImage('assets/images/millionaire.png')), )
          
    ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constants.customBoxDecoration(context),
      child: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  // TabBar
                  Container(
                    child: TabBar(
                      labelStyle: AppTextStyles.normal2Light,
                      indicatorColor: AppColors.text2Light,
                      tabs: const [
                        Tab(text: 'Top'),
                        Tab(text: 'Near me'),
                        Tab(text: 'Recommended'),
                      ],
                    ),
                  ),
            
                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: Top
                        ListView(
                          children: [
                            _TextIconRow(
                              text: 'View All Top Schools',
                              icon: Icons.arrow_forward,
                            ),
                            CarouselSlider(
                              items: [
                                _TopSchoolsCard(
                                  schoolName: 'Daughters Of Divine Love',
                                  formPrice: '₦10,000.00',
                                  admissionStatus: 'Open',
                                ),
                                _TopSchoolsCard(
                                  schoolName: 'Another School',
                                  formPrice: '₦10,000.00',
                                  admissionStatus: 'Closed',
                                ),
                              ],
                              options: CarouselOptions(
                                height: 280.0,
                                viewportFraction: 1.2,
                                padEnds: true,
                                autoPlay: true,
                                enableInfiniteScroll: false,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),

                            Column(
                  children: [
                    _TextIconRow(text: 'Based on your recent serches', icon:Icons.arrow_forward),
                    SizedBox(height: 5,),
                    _BasedOnSearches(schoolName: 'Daughters Of Divine Love', formPrice: '₦10,000.00', admissionStatus: 'Closed'),
                     SizedBox(height: 5,),
                    _BasedOnSearches(schoolName: 'Daughters Of Divine Love', formPrice: '₦10,000.00', admissionStatus: 'Closed'),
                     SizedBox(height: 5,),
                    _BasedOnSearches(schoolName: 'Daughters Of Divine Love', formPrice: '₦10,000.00', admissionStatus: 'Closed'),
                     SizedBox(height: 5,),
                    _BasedOnSearches(schoolName: 'Daughters Of Divine Love', formPrice: '₦10,000.00', admissionStatus: 'Closed'),
                  ],
                )

                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount), 
                        itemBuilder: itemBuilder)
                          ],
                        ),
            
                        // Tab 2: Near me
                        ListView(
                          children: const [
                            Center(child: Text('Near Me Content')),
                          ],
                        ),
            
                        // Tab 3: Recommended
                        ListView(
                          children: const [
                            Center(child: Text('Recommended Content')),
                          ],
                        ),
                      ],
                    ),
                  ),
            
                 
                ],
              ),
            ),
          ),

           
        ],
      ),
    );
  }
}

// Reusable Widget: Title with Icon
Widget _TitleWithIcon({
  required String title,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Icon(icon),
      ],
    ),
  );
}

// Reusable Widget: School Image
Widget _SchoolImage() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: Image.asset(
      'assets/images/millionaire.png',
      fit: BoxFit.cover,
      height: 150,
    ),
  );
}

// Reusable Widget: School Logo Image
Widget _SchoolLogoImage() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: Image.asset(
      'assets/images/millionaire.png',
      fit: BoxFit.cover,
      height: 50,
      width: 50,
    ),
  );
}

// Reusable Widget: School Description
Widget _SchoolDescription({
  required String schoolName,
  required String formPrice,
  required String admissionStatus,
}) {
  return Padding(
    padding: const EdgeInsetsDirectional.all(10.0),
    child: Row(
      children: [
        _SchoolLogoImage(),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schoolName,
              style: AppTextStyles.titleDark.copyWith(color: Colors.black),
            ),
            Text(
              'Form for sale at $formPrice',
              style: const TextStyle(color: Colors.black),
            ),
            Row(
              children: [
                const Text(
                  'Admissions:',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 5),
                Text(
                  'open',
                  style: AppTextStyles.normal400(
                      fontSize: 16, color: AppColors.admissionopen),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

// Reusable Widget: Top Schools Card
Widget _TopSchoolsCard({
  required String schoolName,
  required String formPrice,
  required String admissionStatus,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        _SchoolImage(),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: _SchoolDescription(
            schoolName: schoolName,
            formPrice: formPrice,
            admissionStatus: admissionStatus,
          ),
        ),
      ],
    ),
  );
}
Widget _BasedOnSearches({
  required String schoolName,
  required String formPrice,
  required String admissionStatus,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        _SchoolImage(),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: _SchoolDescription(
            schoolName: schoolName,
            formPrice: formPrice,
            admissionStatus: admissionStatus,
          ),
        ),
      ],
    ),
  );
}




Widget _TextIconRow({
  required String text,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Icon(icon),
      ],
    ),
  );
}

Widget _SearchItems ({
  required image,
  required title,
  required formSales,
  required admissionDistanc,
  required admissionStatus
}){
  return Row(
    children: [
      Image(image: AssetImage(image)),
      Column(
        children: [
        Text(title),
        Text(formSales),
        Row(
          children: [
             Text(admissionDistanc),
             Text(admissionStatus)
          ],
        )
       
        ],
      )
    ],
  );
}
