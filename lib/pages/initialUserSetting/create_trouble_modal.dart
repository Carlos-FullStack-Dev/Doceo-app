import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';

class CreateTroubleModal extends StatefulWidget {
  const CreateTroubleModal({super.key});

  @override
  _CreateTroubleModalState createState() => _CreateTroubleModalState();
}

class _CreateTroubleModalState extends State<CreateTroubleModal> {
  String newTag = '';
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            title: const Center(
                child: Text("悩み・疾病タグを作る",
                    style: TextStyle(
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black))),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: TextButton(
                child: Text("作成",
                    style: TextStyle(
                        fontFamily: 'M_PLUS',
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: newTag.isNotEmpty
                            ? const Color(0xffB44DD9)
                            : const Color(0xffCBCBCB))),
                onPressed: () {
                  if (newTag.isNotEmpty && errorMessage == null) {
                    onAddTag();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Autocomplete<String>(
              onSelected: (option) {
                setState(() {
                  newTag = option;
                });
              },
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text;

                if (query.isEmpty) return [];

                List<Tag?> tags =
                    AppProviderPage.of(context, listen: false).tags;

                return tags
                    .where((tag) =>
                        tag!.name.toLowerCase().contains(query.toLowerCase()))
                    .map((tag) => tag!.name);
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) =>
                  TextField(
                onChanged: (value) {
                  setState(() {
                    newTag = value;
                    if (value.length > 15) {
                      errorMessage = "15字以内で作成してください";
                    } else {
                      errorMessage = null;
                    }
                  });
                },
                focusNode: focusNode,
                controller: textEditingController,
                decoration: InputDecoration(
                  errorText: errorMessage,
                  hintText: "悩みタグを記入してください。最大15文字",
                  border: const UnderlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onAddTag() async {
    final tags = AppProviderPage.of(context, listen: false).tags;

    if (tags.indexWhere((tag) => tag.name == newTag) > -1) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "このタグはすでに登録されています");
    }

    try {
      final newItem = Tag(name: newTag);
      final request = ModelMutations.create(newItem);

      final res = await Amplify.API.mutate(request: request).response;

      tags.add(res.data);
      AppProviderPage.of(context, listen: false).tags = tags;
      Navigator.of(context).pop(res.data);
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
