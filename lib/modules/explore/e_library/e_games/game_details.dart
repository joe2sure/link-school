import 'package:flutter/material.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/common/buttons/custom_long_elevated_button.dart';
import 'package:linkschool/modules/common/text_styles.dart';
import 'package:linkschool/modules/model/explore/home/game_model.dart';
import 'package:linkschool/modules/providers/explore/game/game_provider.dart';
import 'package:provider/provider.dart';


class GameDetails extends StatefulWidget {
  const GameDetails({super.key, required this.game});
  final Game game;

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false).fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    final likes = gameProvider.games?.cardGames.games
       .map((game) => _buildYouMightLikeCard(
              game: game,
              startColor: AppColors.gamesColor5,
              endColor: AppColors.gamesColor6,
            ))
       .toList() ??[];

    final recommendedGames =
        gameProvider.games?.puzzleGames.games.map((game) => game).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.game.title,
          style: AppTextStyles.normal600(
              fontSize: 20, color: AppColors.detailsbutton),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 326,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.game.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.game.title,
                    style: AppTextStyles.normal600(
                        fontSize: 22, color: AppColors.gametitle),
                  ),
                  Text(
                    'May contain ads and In-app purchases',
                    style: AppTextStyles.normal500(
                        fontSize: 14, color: AppColors.gameText),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: reviewText(
                        image: 'assets/icons/gamesicon/stars.png',
                        reviews: widget.game.rating.toString(),
                        reviewDes: '1k reviews',
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Play now button
                  CustomLongElevatedButton(
                    text: 'Play now',
                    onPressed: () {},
                    backgroundColor: AppColors.bgXplore3,
                    textStyle: AppTextStyles.normal500(
                        fontSize: 16, color: AppColors.assessmentColor1),
                  ),
                  const SizedBox(height: 50),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About this game',
                          style: AppTextStyles.normal700(
                              fontSize: 16, color: AppColors.gametitle),
                        ),
                        Text(
                          widget.game.description,
                          style: AppTextStyles.normal400(
                              fontSize: 16, color: AppColors.gameText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recommended',
                          style: AppTextStyles.normal700(
                            fontSize: 16,
                            color: AppColors.gametitle,
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: gameProvider.games?.puzzleGames.games
                                  .map((game) => recommendedCard(game: game))
                                  .toList() ??
                              [],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Games you may like',
                              style: AppTextStyles.normal700(
                                fontSize: 16,
                                color: AppColors.gametitle,
                              )),
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: likes.length,
                              itemBuilder: (context, index) => likes[index],
                            ),
                          ),
                        ],
                      )
                    ],
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

// Widget for recommended card
class recommendedCard extends StatelessWidget {
  final Game game;
  const recommendedCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 150,
      width: 300,
      decoration: BoxDecoration(
          color: AppColors.gameCard, borderRadius: BorderRadius.circular(20)),
      child: Image(
        image: NetworkImage(
          game.gameUrl,
        ),
        height: 90,
        width: 90,
      ),
    );
  }
}

// Widget for review text
Widget reviewText({
  String? reviews,
  required String reviewDes,
  IconData? icons,
  required String image,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (reviews != null)
            Text(
              reviews,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          Image.asset(
            image,
            width: 24,
            height: 24,
          ),
          if (icons != null) Icon(icons),
        ],
      ),
      Text(
        reviewDes,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  );
}


Widget _buildYouMightLikeCard({
  required Game game,
  required Color startColor,
  required Color endColor,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          width: 90.0,
          height: 95.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [startColor, endColor],
              ),
              borderRadius: BorderRadius.circular(10.0)),
          child: Image.network(
            game.thumbnail,
            fit: BoxFit.contain,
            
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColors.gamesColor9,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: AppTextStyles.normal500(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      game.title,
                      style: AppTextStyles.normal500(
                        fontSize: 13.0,
                        color: AppColors.text5Light,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16.0),
                        Text(
                          game.rating,
                          style: AppTextStyles.normal500(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        const Icon(Icons.file_download_outlined, size: 16.0),
                        Text(
                          '${150}k',
                          style: AppTextStyles.normal500(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  height: 45.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.gamesColor7,
                        AppColors.gamesColor8,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.backgroundLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Play',
                          style: AppTextStyles.normal600(
                              fontSize: 14.0, color: AppColors.buttonColor1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}


// class GameDetails extends StatefulWidget {
//   const GameDetails({super.key, required Game game});

//   @override
//   State<GameDetails> createState() => _GameDetailsState();
// }

// class _GameDetailsState extends State<GameDetails> {
//   final likes = [
//     _buildYouMightLikeCard(
//       startColor: AppColors.gamesColor5,
//       endColor: AppColors.gamesColor6,
//       imagePath: 'assets/images/games_3.png',
//       gameName: 'Borderlands 2',
//       platform: 'Cross-platform',
//       rating: 3.5,
//       downloadCount: 10,
//     ),
//     _buildYouMightLikeCard(
//       startColor: AppColors.gamesColor3,
//       endColor: AppColors.gamesColor4,
//       imagePath: 'assets/images/games_2.png',
//       gameName: 'Borderlands 2',
//       platform: 'Cross-platform',
//       rating: 3.5,
//       downloadCount: 10,
//     ),
//     _buildYouMightLikeCard(
//       startColor: AppColors.gamesColor1,
//       endColor: AppColors.gamesColor2,
//       imagePath: 'assets/images/games_1.png',
//       gameName: 'Borderlands 2',
//       platform: 'Cross-platform',
//       rating: 3.5,
//       downloadCount: 10,
//     ),
//     _buildYouMightLikeCard(
//       startColor: AppColors.gamesColor5,
//       endColor: AppColors.gamesColor6,
//       imagePath: 'assets/images/games_3.png',
//       gameName: 'Borderlands 2',
//       platform: 'Cross-platform',
//       rating: 3.5,
//       downloadCount: 10,
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundLight,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: Image.asset(
//               'assets/icons/arrow_back.png',
//               color: AppColors.primaryLight,
//               width: 34.0,
//               height: 34.0,
//             ),
//           ),
//         ),
//         title: Center(
//             child: Text(
//           'Hakuna Matata',
//           style: AppTextStyles.normal600(
//               fontSize: 20, color: AppColors.primaryLight),
//         )),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 326,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image:
//                       AssetImage('assets/images/gameDes/gameDescription.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Hakuna Matata King Saga',
//                     style: AppTextStyles.normal600(
//                         fontSize: 20, color: AppColors.gametitle),
//                   ),
//                   const Text(
//                     'May contain ads and In-app purchases',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     height: 31,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         reviewText(
//                           image: 'assets/icons/gamesicon/stars.png',
//                           reviews: '4.5',
//                           reviewDes: '1k reviews',
//                         ),
//                         const SizedBox(height: 20),
//                         VerticalDivider(),
//                         reviewText(
//                           image: 'assets/icons/gamesicon/downloading.png',
//                           reviewDes: '156 MB',
//                         ),
//                         const SizedBox(height: 20),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 32.0,right: 32.0),
//                           child: Container(
//                             width: 1,
//                             height: 1,
//                             decoration: BoxDecoration(

//                             color: AppColors.attCheckColor1,
//                           ),
//                         ),),

                         
//                         reviewText(
//                           image: 'assets/icons/gamesicon/+12.png',
//                           reviewDes: 'downloads',
//                         ),
                        
//                        Padding(
//                           padding: const EdgeInsets.only(left: 32.0,right: 32.0),
//                           child: Container(
//                             width: 1,
//                             height: 1,
//                             decoration: BoxDecoration(
//                               color: AppColors.attCheckColor1,
//                             ),
//                           ),
//                         ),

                     
//                         reviewText(
//                           image: 'assets/icons/gamesicon/+12.png',
//                           reviewDes: 'Rated for 12+',
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   CustomLongElevatedButton(
//                     text: 'Play now',
//                     onPressed: () {},
//                     backgroundColor: AppColors.bgXplore3,
//                     borderRadius: 32.0,
//                     textStyle: AppTextStyles.normal600(
//                         fontSize: 16, color: AppColors.assessmentColor1),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'About this game',
//                           style: AppTextStyles.normal600(
//                               fontSize: 16, color: AppColors.gametitle),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Text(
//                             'Benedict Timothy Carlton Cumberbatch CBE (born 19 July 1976) is an English actor. A graduate of the Victoria.',

//                             style: AppTextStyles.normal500(
//                                 fontSize: 16, color: AppColors.gameText),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Recommended',
//                           style: AppTextStyles.normal600(
//                             fontSize: 16,
//                             color: AppColors.gametitle,
//                           )),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       SizedBox(
//                         height: 150,
//                         child: ListView(
//                           scrollDirection: Axis.horizontal,
//                           children: [
//                             recommendedCard(),
//                             recommendedCard(),
//                             recommendedCard(),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
                          
//                            Text('Games you may like',
//                           style: AppTextStyles.normal700(
//                             fontSize: 16,
//                             color: AppColors.gametitle,
//                           )),
//                           SizedBox(
//                             height: 300,
//                             child: ListView.builder(
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: likes.length,
//                               itemBuilder: (context, index) => likes[index],
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class recommendedCard extends StatelessWidget {
//   const recommendedCard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 10),
//       height: 150,
//       width: 294,
//       decoration: BoxDecoration(
//           color: AppColors.gameCard, borderRadius: BorderRadius.circular(20)),
//       child: Image(
//         image: AssetImage(
//           'assets/images/gameDes/call_off_duty.png',
//         ),
//         height: 90,
//         width: 90,
//       ),
//     );
//   }
// }

// Widget reviewText({
//   String? reviews,
//   required String reviewDes,
//   IconData? icons,
//   required String image,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Row(
//         children: [
//           if (reviews != null)
//             Text(reviews,
//                 style: AppTextStyles.normal500(
//                     fontSize: 12, color: AppColors.gametitle)),
//           Image.asset(image, width: 16, height: 16),
//         ],
//       ),
//       Text(reviewDes,
//           style: AppTextStyles.normal500(
//               fontSize: 12, color: AppColors.gametitle)),
//     ],
//   );
// }

// Widget _buildYouMightLikeCard({
//   required Color startColor,
//   required Color endColor,
//   required String imagePath,
//   required String gameName,
//   required String platform,
//   required double rating,
//   required int downloadCount,
// }) {
//   return Container(
//     width: double.infinity,
//     margin: const EdgeInsets.only(bottom: 10.0),
//     child: Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
//           width: 75,
//           height: 80,
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   startColor,
//                   endColor,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(10.0)),
//           child: Image.asset(
//             imagePath,
//             fit: BoxFit.contain,
//           ),
//         ),
//         const SizedBox(width: 10.0),
//         Expanded(
//           child: Container(
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   width: .5,
//                   color: AppColors.gamesColor9,
//                 ),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       gameName,
//                       style: AppTextStyles.normal500(
//                         fontSize: 18.0,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 2.0),
//                     Text(
//                       platform,
//                       style: AppTextStyles.normal500(
//                         fontSize: 14.0,
//                         color: AppColors.text5Light,
//                       ),
//                     ),
//                     const SizedBox(height: 2.0),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 16.0),
//                         Text(
//                           "$rating",
//                           style: AppTextStyles.normal500(
//                             fontSize: 14.0,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(width: 16.0),
//                         const Icon(Icons.file_download_outlined, size: 16.0),
//                         Text(
//                           '${downloadCount}k',
//                           style: AppTextStyles.normal500(
//                             fontSize: 14.0,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 Container(
//                   height: 31.0,
//                   width: 80,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         AppColors.gamesColor7,
//                         AppColors.gamesColor8,
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: OutlinedButton(
//                       onPressed: () {},
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: AppColors.backgroundLight,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(4.0),
//                         ),
//                       ),
//                       child: Text(
//                         'Play',
//                         style: AppTextStyles.normal600(
//                             fontSize: 14.0, color: AppColors.buttonColor1),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }


// Widget VerticalDivider() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     child: SizedBox(
//       width: 1, 
//       height: 1, 
//       child: DecoratedBox(
//         decoration: BoxDecoration(color: AppColors.attCheckColor1),
//       ),
//     ),
//   );
// }

