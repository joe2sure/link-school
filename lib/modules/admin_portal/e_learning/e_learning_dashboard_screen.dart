import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/common/constants.dart';
import 'package:linkschool/modules/common/text_styles.dart';
import 'package:linkschool/modules/common/widgets/portal/result_dashboard/level_selection.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ELearningDashboardScreen extends StatefulWidget {
  final PreferredSizeWidget appBar;
  const ELearningDashboardScreen({super.key, required this.appBar});

  @override
  State<ELearningDashboardScreen> createState() =>
      _ELearningDashboardScreenState();
}

class _ELearningDashboardScreenState extends State<ELearningDashboardScreen> {
  int currentAssessmentIndex = 0;
  int currentActivityIndex = 0;
  late PageController activityController;
  Timer? activityTimer;

  final List<Map<String, String>> assessments = [
    {
      'date': '19TH FEBRUARY 2024',
      'title': 'First C.A',
      'subject': 'Mathematics',
      'classes': 'JSS1, JSS2, JSS3',
    },
    {
      'date': '22ND FEBRUARY 2024',
      'title': 'Second C.A',
      'subject': 'English Language',
      'classes': 'JSS1, JSS2',
    },
    {
      'date': '25TH FEBRUARY 2024',
      'title': 'Third C A',
      'subject': 'Basic Science',
      'classes': 'JSS3',
    },
  ];

  final List<Map<String, String>> activities = [
    {
      'name': 'Dennis Toochi',
      'activity': 'posted an assignment on',
      'subject': 'Homeostasis for JSS2',
      'timestamp': 'Yesterday at 9:42 AM',
      'avatar': 'assets/images/student/avatar3.svg',
    },
    {
      'name': 'Ifeanyi Toochi',
      'activity': 'posted an assignment on',
      'subject': 'Hygiene for JSS2',
      'timestamp': 'Yesterday at 9:42 AM',
      'avatar': 'assets/images/student/avatar3.svg',
    },
    {
      'name': 'Raphael Toochi',
      'activity': 'posted an assignment on',
      'subject': 'Exercises for JSS2',
      'timestamp': 'Yesterday at 9:42 AM',
      'avatar': 'assets/images/student/avatar3.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    activityController = PageController(viewportFraction: 0.90);
    activityTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (activityController.hasClients) {
        setState(() {
          currentActivityIndex = (currentActivityIndex + 1) % activities.length;
          activityController.animateToPage(
            currentActivityIndex,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeIn,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    activityController.dispose();
    activityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Container(
        decoration: Constants.customBoxDecoration(context),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildTopContainers(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              sliver: SliverToBoxAdapter(
                child: _buildRecentActivity(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24.0)),
            SliverToBoxAdapter(
              child: Constants.heading600(
                title: 'Select Level',
                titleSize: 18.0,
                titleColor: AppColors.resultColor1,
              ),
            ),
            const SliverToBoxAdapter(
              child: LevelSelection(
                isSecondScreen: true,
                subjects: [
                  'Civic Education',
                  'Mathematics',
                  'English',
                  'Physics',
                  'Chemistry'
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContainers() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          CarouselSlider(
            items: assessments.map((assessment) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.paymentTxtColor1,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${assessment['subject']} ${assessment['title']}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Add ellipsis for long text
                                maxLines: 1, // Limit to one line
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors.paymentTxtColor1,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/student/calender-icon.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    assessment['date']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Add ellipsis for long text
                                    maxLines: 1, // Limit to one line
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(
                                  color: AppColors.backgroundLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '08:00 AM',
                                style: TextStyle(
                                  color: AppColors.backgroundLight,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Column(
                            children: [
                              const Text(
                                'Classes',
                                style: TextStyle(
                                  color: AppColors.backgroundLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width:
                                    80, // Set a fixed width for the classes text
                                child: Text(
                                  assessment['classes']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.backgroundLight,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Add ellipsis for long text
                                  maxLines: 1, // Limit to one line
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          const Column(
                            children: [
                              Text(
                                'Duration',
                                style: TextStyle(
                                  color: AppColors.backgroundLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '2h 30m',
                                style: TextStyle(
                                  color: AppColors.backgroundLight,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 185,
              viewportFraction: 0.90,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayCurve: Curves.easeIn,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  currentAssessmentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              assessments.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      currentAssessmentIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent activity',
            style: AppTextStyles.normal600(
                fontSize: 18, color: AppColors.backgroundDark),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: activityController,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(activity['avatar']!),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: [
                                    TextSpan(text: '${activity['name']} '),
                                    TextSpan(
                                      text: '${activity['activity']} ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    TextSpan(
                                      text: '${activity['subject']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activity['timestamp']!,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}