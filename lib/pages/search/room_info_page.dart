// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/channels/users/doctor_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class RoomInfoPage extends StatefulWidget {
  String roomId;
  RoomInfoPage({super.key, required this.roomId});

  @override
  _RoomInfoPage createState() => _RoomInfoPage();
}

class _RoomInfoPage extends State<RoomInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final selectedRoom = widget.roomId;
    List totalRooms = AppProviderPage.of(context, listen: false).rooms;
    int roomIndex =
        totalRooms.indexWhere((e) => e['channel']['id'] == selectedRoom);
    final roomInfo = totalRooms[roomIndex];
    final doctors = roomInfo['members']
        .where((e) => e['user']['role'] == 'doctor')
        .toList();

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            title: const Text('ROOM担当医師',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: FutureBuilder(
                future: getDoctorsData(doctors),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            final doctor = snapshot.data![index];
                            final hosptials =
                                AppProviderPage.of(context).hospitals;
                            int hospitalIndex = hosptials.indexWhere(
                                (e) => e.id == doctor.extraData['hospitalId']);

                            return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 15),
                                width: width * 0.9,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DoctorPage(
                                                            doctorId:
                                                                doctor.id)));
                                          },
                                          child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.black12,
                                              backgroundImage: NetworkImage(doctor
                                                      .image ??
                                                  'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png'))),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${doctor.extraData['occupation'] ?? ''}/${doctor.extraData['specialtyName'] ?? ''} ${doctor.extraData['lastName'] ?? ''}${doctor.extraData['firstName'] ?? ''}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'M_PLUS',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (hospitalIndex >= 0)
                                                Text(
                                                  hosptials[hospitalIndex].name,
                                                  style: const TextStyle(
                                                    color: Color(0xFFB4BABF),
                                                    fontSize: 15,
                                                    fontFamily: 'M_PLUS',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              const SizedBox(height: 10),
                                              Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        const Color(0xFFF7EDFB),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '${doctor.extraData['trouble'] ?? '${doctor.extraData['specialtyName'] ?? ''} 全般'}',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Color(0xFFB44DD9),
                                                      fontSize: 15,
                                                      fontFamily: 'M_PLUS',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ))
                                            ]),
                                      )
                                    ]));
                          })));
                })),
          ),
        ));
  }

  Future<List<User>> getDoctorsData(doctors) async {
    final client = StreamChat.of(context).client;

    try {
      List<String> doctorIds = [];
      for (final doctor in doctors) {
        doctorIds.add(doctor['user_id']);
      }

      final res = await client.queryUsers(filter: Filter.in_('id', doctorIds));
      return res.users;
    } catch (e) {
      safePrint(e);
      return [];
    }
  }
}
