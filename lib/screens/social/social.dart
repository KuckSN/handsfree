import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handsfree/models/chatModel.dart';
import 'package:handsfree/models/userProfile.dart';
import 'package:handsfree/screens/social/onlineFriendList.dart';
import 'package:handsfree/services/database.dart';
import 'package:handsfree/widgets/breaker.dart';
import 'package:handsfree/widgets/buildButton.dart';
import 'package:handsfree/models/friendModel.dart';
import 'package:handsfree/widgets/overlay.dart';
import 'package:handsfree/widgets/navBar.dart';
import 'package:handsfree/widgets/smallCard.dart';
import 'package:handsfree/services/userPreference.dart';
import 'package:provider/provider.dart';
import 'package:handsfree/widgets/buildText.dart';

import '../../provider/communityProvider.dart';
import '../../provider/newsFeedProvider.dart';
import 'package:handsfree/widgets/navBar.dart';

double friendSize = 70;
double coumminitySize = 150;

class Social extends StatefulWidget {
  const Social({Key? key}) : super(key: key);

  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  var overlayState = const Overlays();
  @override
  Widget build(BuildContext context) {
    final isVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    // prevent screen rotation and force portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => NewsFeedProvider()),
      ],
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 160, 20, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildText.heading2Text("Online Friends"),
                              GestureDetector(
                                onTap: () async {
                                  //search all users
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.center,
                                      image: AssetImage(
                                          'assets/image/search_icon.png'),
                                      scale: 3,
                                    ),
                                  ),
                                  child: Container(),
                                ),
                              ),
                            ],
                          ),
                          Breaker(i: 5),
                          ShaderMask(
                            shaderCallback: (Rect rect) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.purple,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.purple
                                ],
                                stops: [
                                  0.0,
                                  0.03,
                                  0.97,
                                  1.0
                                ], // 10% purple, 80% transparent, 10% purple
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstOut,
                            child: const OnlineFriendList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                        child: buildNewsFeed()),
                  ],
                ),
              ],
            ),
            buildHeading(),
          ],
        ),
        floatingActionButton:
            isVisible ? const SizedBox() : NavBar.Buttons(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        bottomNavigationBar: NavBar.bar(context, 3),
      ),
    );
  }

  Widget buildHeading() {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
              maxHeight: 172, minWidth: MediaQuery.of(context).size.width),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/orange_heading4.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 60),
            alignment: Alignment.topCenter,
            child: buildText.bigTitle("Social"))
      ],
    );
  }

  Widget buildNewsFeed() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText.heading2Text("News Feed"),
          GestureDetector(
            onTap: () async {
              //check index and go the the respective place
            },
            child: Container(
              width: 40,
              height: 25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage('assets/image/search_icon.png'),
                  scale: 3,
                ),
              ),
              child: Container(),
            ),
          ),
        ],
      ),
      ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.purple,
              Colors.transparent,
              Colors.transparent,
              Colors.purple
            ],
            stops: [
              0.0,
              0.02,
              0.98,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Container(
          child: Consumer<NewsFeedProvider>(builder: (context, news, child) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: coumminitySize + 100,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return SmallCard(
                        id: news.cardDetails[index].id,
                        communitySize: coumminitySize,
                        communityImage: news.cardDetails[index].newsFeedImages,
                        communityTitle: news.cardDetails[index].newsFeedTitle,
                        communityDesc: news.cardDetails[index].newsFeedDesc);
                  }),
            );
          }),
        ),
      ),
    ]);
  }
}