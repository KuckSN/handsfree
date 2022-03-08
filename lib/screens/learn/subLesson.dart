import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handsfree/provider/lessonCardProvider.dart';
import 'package:handsfree/provider/subLessonProvider.dart';
import 'package:handsfree/services/database.dart';
import 'package:handsfree/widgets/loadingWholeScreen.dart';
import 'package:handsfree/widgets/buildButton.dart';
import 'package:handsfree/widgets/buildText.dart';
import 'package:handsfree/widgets/columnList.dart';
import 'package:handsfree/widgets/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/newUser.dart';
import '../../provider/lessonProvider.dart';
import '../../widgets/navBar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:handsfree/models/lessonModel.dart';

List _lessonCompletionList = [];
List<LessonModel>? _userModel;
String _syllabus = 'Unknown';
dynamic _user;

class SubLevel extends StatelessWidget {
  const SubLevel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LessonModel lesson = context.read<LessonProvider>().getClickedLesson;
    _user = Provider.of<NewUser?>(context);
    if(lesson.lessonId == 1){
      _syllabus = "Syllabus 1";
    }else if(lesson.lessonId == 2){
      _syllabus = "Syllabus 2";
    }

    return StreamBuilder<List<LessonModel>?> (
      stream: DatabaseService(uid: _user!.uid).getSyllabus(_syllabus),
      builder: (context, snapshot) {
        if(snapshot.hasData){


          _userModel= snapshot.data;
          if(_userModel!.isNotEmpty) {
            Provider.of<SubLessonProvider>(context, listen: false)
              .setSubLessons(_userModel);
          }

          bool completionOfSyllabus = true;
          for(int i = 0; i<_userModel!.length; i++){
            completionOfSyllabus = completionOfSyllabus && _userModel![i].isCompleted;
          }
          if(completionOfSyllabus){
            DatabaseService(uid: _user.uid).updateIsCompletedSyllabus(_syllabus);
          }

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage('assets/image/purple_heading.png'),
                    fit: BoxFit.cover),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 40, bottom: 5, right: 40),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                alignment: Alignment.topCenter,
                                image:
                                AssetImage('assets/image/sublevel_container.png'),
                                scale: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 53),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  height: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      alignment: Alignment.topCenter,
                                      image: AssetImage(lesson.lessonImage),
                                      fit: BoxFit.cover,
                                      scale: 0.5,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(padding: EdgeInsets.only(top: 20)),
                                    buildText.learningHeading2Text(lesson.lessonName),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                    ),
                                    buildText.learningHeading3Text(lesson.lessonDesc),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 80),
                    ),
                    ShaderMask(
                      shaderCallback: (Rect rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.purple,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.purple
                          ],
                          stops: [
                            0.0,
                            0.05,
                            0.95,
                            1.0
                          ], // 10% purple, 80% transparent, 10% purple
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstOut,
                      child: Consumer<SubLessonProvider>(
                          builder: (context, providerSubLesson, child) {
                            var subLessons = providerSubLesson.subLessons;
                            return Container(
                              height: MediaQuery.of(context).size.height / 1.6,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width / 8),
                                itemCount: subLessons.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Provider.of<LessonCardProvider>(context, listen: false)
                                          .resetIndex();

                                      //I dont know why Provider.of<LessonCardProvider>(context, listen: false)
                                      //is null!!!!

                                      Provider.of<SubLessonProvider>(context, listen: false)
                                          .setClickLesson(subLessons[index]);
                                      Provider.of<SubLessonProvider>(context, listen: false)
                                          .setSyllabus(_syllabus);
                                      Navigator.pushReplacementNamed(context, "/mainLearningPage");
                                    },
                                    child: ColumnList(lesson: subLessons[index]),
                                  );
                                },
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            )
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}

class LessonRefresh{
  static void refresh(){
    bool completionOfSyllabus = true;
    for(int i = 0; i<_userModel!.length; i++){
      completionOfSyllabus = completionOfSyllabus && _userModel![i].isCompleted;
    }
    if(completionOfSyllabus){
      DatabaseService(uid: _user.uid).updateIsCompletedSyllabus(_syllabus);
    }
  }
}
