import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FeedSelectDoctorModal extends StatefulWidget {
  final String doctorName;

  const FeedSelectDoctorModal({Key? key, required this.doctorName})
      : super(key: key);

  @override
  _FeedSelectDoctorModalState createState() => _FeedSelectDoctorModalState();
}

class _FeedSelectDoctorModalState extends State<FeedSelectDoctorModal> {
  String doctorName = '';
  String doctorIcon = '';
  String doctorId = '';
  String? errorMessage;
  late Iterable<User> _lastDoctors = [];
  late final _debouncedSearch;

  @override
  void initState() {
    super.initState();
    setState(() {
      _debouncedSearch =
          Debounce(_fetchDoctors, const Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            title: const Center(
                child: Text("担当医師",
                    style: TextStyle(
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: TextButton(
                child: Text("登録",
                    style: TextStyle(
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: doctorName.isNotEmpty
                            ? const Color(0xffB44DD9)
                            : const Color(0xffCBCBCB))),
                onPressed: () {
                  if (doctorName.isNotEmpty && errorMessage == null) {
                    Navigator.of(context).pop({
                      'icon': doctorIcon,
                      'name': doctorName,
                      'id': doctorId
                    });
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Autocomplete<User>(
              displayStringForOption: (option) {
                if (option.extraData['firstName'] != null &&
                    option.extraData['lastName'] != null) {
                  return '${option.extraData['lastName']} ${option.extraData['firstName']}';
                }
                return option.name;
              },
              initialValue: TextEditingValue(text: widget.doctorName),
              optionsBuilder: (textEditingValue) async {
                if (textEditingValue.text == '') return [];

                final doctors =
                    await _debouncedSearch.call([textEditingValue.text]);

                if (doctors == null) {
                  return _lastDoctors;
                }
                setState(() {
                  _lastDoctors = doctors;
                });
                return doctors;
              },
              onSelected: (option) {
                setState(() {
                  doctorIcon = option.image.toString();
                  doctorId = option.id;
                  doctorName = (option.extraData['firstName'] != null &&
                          option.extraData['lastName'] != null)
                      ? '${option.extraData['lastName']} ${option.extraData['firstName']}'
                      : option.name;
                });
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) =>
                  TextField(
                onChanged: (value) {
                  setState(() {
                    doctorName = value;
                    doctorIcon = '';
                    doctorId = '';
                  });
                },
                focusNode: focusNode,
                controller: textEditingController,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintStyle: const TextStyle(color: Color(0xffcbcbcb)),
                  hintText: "担当医師名を入力してください",
                  border: const UnderlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<User>> _fetchDoctors(String query) async {
    query = query.toLowerCase();
    try {
      final client = StreamChat.of(context).client;
      final res =
          await client.queryUsers(filter: Filter.equal('role', 'doctor'));
      return res.users.where((user) {
        return user.extraData['firstName']
                .toString()
                .toLowerCase()
                .contains(query) ||
            user.extraData['lastName'].toString().toLowerCase().contains(query);
      }).toList();
    } catch (e) {
      safePrint(e);
      return [];
    }
  }
}
