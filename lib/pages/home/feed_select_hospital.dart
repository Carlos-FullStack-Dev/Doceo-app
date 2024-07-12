import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';

class FeedSelectHospitalModal extends StatefulWidget {
  final String hospital;

  const FeedSelectHospitalModal({Key? key, required this.hospital})
      : super(key: key);

  @override
  _FeedSelectHospitalModalState createState() =>
      _FeedSelectHospitalModalState();
}

class _FeedSelectHospitalModalState extends State<FeedSelectHospitalModal> {
  String hospital = '';
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    List<Hospital?> hosptials = AppProviderPage.of(context).hospitals ?? [];

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            title: const Center(
                child: Text("訪問先",
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
                        color: hospital.isNotEmpty
                            ? const Color(0xffB44DD9)
                            : const Color(0xffCBCBCB))),
                onPressed: () {
                  if (hospital.isNotEmpty && errorMessage == null) {
                    Navigator.of(context).pop(hospital);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Autocomplete<String>(
              initialValue: TextEditingValue(text: widget.hospital),
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text == '') return [];

                return hosptials.where((item) {
                  return item!.name!
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                }).map((item) => item!.name!);
              },
              onSelected: (option) {
                setState(() {
                  hospital = option;
                });
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) =>
                  TextField(
                onChanged: (value) {
                  setState(() {
                    hospital = value;
                  });
                },
                focusNode: focusNode,
                controller: textEditingController,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintStyle: const TextStyle(color: Color(0xffcbcbcb)),
                  hintText: "病院名を記入してください",
                  border: const UnderlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
