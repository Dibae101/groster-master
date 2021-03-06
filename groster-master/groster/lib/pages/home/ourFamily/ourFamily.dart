import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/home/ourFamily/famMembers.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/func.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurFamily extends StatelessWidget {
  final UserRepository _userRepository = UserRepository.instance();
  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context);
    _userRepository.refreshUser();
    final User user = userRepository.getUser;

    return Scaffold(
      backgroundColor: UniversalVariables.backgroundCol,
      // appBar: CustomAppBar(
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.clear,
      //       color: Colors.black,
      //     ),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   centerTitle: true,
      //   title: Text("Family Profile",style: TextStyle(color: Colors.black),),
      // ),
      body: user.familyId == null
          ? Container(
              child: QuietBox(
                  title: "Set up your Family Profile",
                  subtitle:
                      "After this you can add the family list & group chat with your family",
                  buttonText: "SET UP NOW",
                  navRoute: "/setUpFamily"),
            )
          : Container(
              margin: EdgeInsets.only(top: 5),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed("/familyGroupChat");
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: Stack(
                                overflow: Overflow.clip,
                                alignment: Alignment.topRight,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(top: 4, right: 4),
                                        child: CachedImage(
                                          BLANK_IMAGE,
                                          isRound: true,
                                          radius: 45.0,
                                        ),
                                      )),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(bottom: 4, left: 4),
                                        child: CachedImage(
                                          userRepository.getUser.profilePhoto,
                                          isRound: true,
                                          radius: 45.0,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Family Group",
                          // style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FamilyMembers(),
                  Divider(
                    height: 10,
                    color: UniversalVariables.secondCol,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                          leading: Text(
                            "Id : ",
                            style: TextStyle(
                              // color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                user.familyId,
                                // style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.content_copy,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    final data =
                                        ClipboardData(text: user.familyId);
                                    Clipboard.setData(data);
                                    Fluttertoast.showToast(
                                      msg: "Id copied to clipboard",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          UniversalVariables.mainCol,
                                    );
                                  }),
                            ],
                          ),
                          contentPadding: EdgeInsets.only(left: 70.0),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.edit,
                            // color: UniversalVariables.iconCol,
                          ),
                          title: Text(
                            "Edit",
                            // style: TextStyle(color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.only(left: 70.0),
                          onTap: () {
                            Navigator.of(context).pushNamed("/setUpFamily");
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.share,
                            // color: UniversalVariables.iconCol,
                          ),
                          title: Text(
                            "Share",
                            // style: TextStyle(color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.only(left: 70.0),
                          onTap: () {
                            Func.share(
                              context,
                              "Setup Family with \nFamily Name : ${user.familyName} \n Family Id : ${user.familyId}",
                              "Join Family",
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.remove_circle_outline,
                          ),
                          title: Text(
                            "Leave Group",
                          ),
                          contentPadding: EdgeInsets.only(left: 70.0),
                          onTap: () async {
                            User upUser = User(
                              uid: user.uid,
                              email: user.email,
                              name: user.name,
                              profilePhoto: user.profilePhoto,
                              username: user.username,
                              familyName: null,
                              familyId: null,
                            );
                            if (!await _userRepository.leaveFamily(upUser)) {
                              Func.showToast("Error While Leaving Group");
                            } else {
                              Func.showToast("Leaved Group Successfully");
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
