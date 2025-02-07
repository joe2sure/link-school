import 'package:flutter/material.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/common/text_styles.dart';
import 'package:linkschool/modules/common/constants.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class E_lib_vids extends StatelessWidget {
  const E_lib_vids({super.key});

  final String par_1 =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Null leo enim, pretium vitae nisl sit amet, bibendum euismod velit. Fusce placerat sagittis mi, id aliquet felis vehicula ac. Suspendisse mi massa, suscipit in ex id, condimentum. ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: Constants.customBoxDecoration(context),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 270,
                width: double.infinity,
                child: ClipRRect(
                  child: Image(
                      image: AssetImage(
                          'assets/images/video_images/e-vids-image.png')),
                  // SvgPicture.asset('assets/images/video_images/e-vids-image.png'),
                ),
              ),
              Column(
                children: [
                  LinearProgressIndicator(
                    value: 0.5,
                    color: AppColors.admissionclosed,
                    backgroundColor: AppColors.assessmentColor1,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: RichText(
                      // textAlign: TextAlign.left,
                      text: TextSpan(
                        text: 'Figma master class for biginner',
                        style: AppTextStyles.normal600(
                          fontSize: 20,
                          color: AppColors.assessmentColor2,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time, size: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: RichText(
                        text: TextSpan(
                            text: '6h 30Mins . Lessons',
                            style: AppTextStyles.normal400(
                                fontSize: 12,
                                color: AppColors.assessmentColor2)),
                      ),
                    )
                  ],
                ),
              ),

              // SizedBox(
              //   height: 10,
              // ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  height: 90,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: par_1,
                      style: AppTextStyles.normal400(
                          fontSize: 14, color: AppColors.assessmentColor2),
                    ),
                  )),

              // Tabar

              Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TabBar(
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              labelColor: AppColors.text2Light,
                              indicatorColor: AppColors.text3Light,
                              unselectedLabelColor: AppColors.assessmentColor2,
                              dividerColor: Colors.transparent,
                              tabs: [
                                Tab(text: 'Lessons'),
                                Tab(
                                  text: 'Related',
                                )
                              ],
                            ),
                            Expanded(
                                child: TabBarView(children: [
                              ListView(
                                children: [
                                  videoSection(),
                                  SizedBox(height: 10),
                                  videoSection(),
                                  SizedBox(height: 10),
                                  videoSection(),
                                  SizedBox(height: 10),
                                  videoSection(),
                                  SizedBox(height: 10),
                                ],
                              ),
                              ListView(
                                // scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                      height: 100,
                                      width: 350,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: RichText(
                                          text: TextSpan(
                                              text: par_1,
                                              style: AppTextStyles.normal400(
                                                fontSize: 14,
                                                color:
                                                    AppColors.assessmentColor2,
                                              ))))
                                ],
                              )
                            ])),
                          ])))
            ])));
  }
}

class videoSection extends StatelessWidget {
  const videoSection({
    super.key,
  });

  final String par_1 =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. id aliquet felis vehicula ac. Suspendisse mi massa, suscipit in ex id, condimentum. ";

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage(
                  'assets/images/video_images/e-vids-thumb.png',
                ),
                height: 82,
                width: 88,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: 'Bless the Lord oh my Soul',
                            style: AppTextStyles.normal500(
                                fontSize: 14, color: AppColors.backgroundDark)),
                      ),
                      SizedBox(width: 45),
                      GestureDetector(
                        onTap: () => (print("Play Clicked")),
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 24,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: '2014 . 2h 30m',
                      style: AppTextStyles.normal400(
                          fontSize: 12, color: AppColors.assessmentColor2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 200,
                    child: RichText(
                        textAlign: TextAlign.left,
                        maxLines: 8,
                        text: TextSpan(
                            text: par_1,
                            style: AppTextStyles.normal500(
                                fontSize: 12,
                                color: AppColors.assessmentColor2))),
                  ),
                )
              ],
            ),
          ],
        ),
      )
    ]);
  }
}
