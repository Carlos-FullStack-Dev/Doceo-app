/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Questionnaire type in your schema. */
class Questionnaire extends amplify_core.Model {
  static const classType = const _QuestionnaireModelType();
  final String id;
  final String? _roomId;
  final String? _question;
  final List<UserQuestionnaire>? _users;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  QuestionnaireModelIdentifier get modelIdentifier {
      return QuestionnaireModelIdentifier(
        id: id
      );
  }
  
  String get roomId {
    try {
      return _roomId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get question {
    try {
      return _question!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<UserQuestionnaire>? get users {
    return _users;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Questionnaire._internal({required this.id, required roomId, required question, users, createdAt, updatedAt}): _roomId = roomId, _question = question, _users = users, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Questionnaire({String? id, required String roomId, required String question, List<UserQuestionnaire>? users}) {
    return Questionnaire._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      roomId: roomId,
      question: question,
      users: users != null ? List<UserQuestionnaire>.unmodifiable(users) : users);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Questionnaire &&
      id == other.id &&
      _roomId == other._roomId &&
      _question == other._question &&
      DeepCollectionEquality().equals(_users, other._users);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Questionnaire {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("roomId=" + "$_roomId" + ", ");
    buffer.write("question=" + "$_question" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Questionnaire copyWith({String? roomId, String? question, List<UserQuestionnaire>? users}) {
    return Questionnaire._internal(
      id: id,
      roomId: roomId ?? this.roomId,
      question: question ?? this.question,
      users: users ?? this.users);
  }
  
  Questionnaire copyWithModelFieldValues({
    ModelFieldValue<String>? roomId,
    ModelFieldValue<String>? question,
    ModelFieldValue<List<UserQuestionnaire>?>? users
  }) {
    return Questionnaire._internal(
      id: id,
      roomId: roomId == null ? this.roomId : roomId.value,
      question: question == null ? this.question : question.value,
      users: users == null ? this.users : users.value
    );
  }
  
  Questionnaire.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _roomId = json['roomId'],
      _question = json['question'],
      _users = json['users'] is List
        ? (json['users'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => UserQuestionnaire.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'roomId': _roomId, 'question': _question, 'users': _users?.map((UserQuestionnaire? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'roomId': _roomId,
    'question': _question,
    'users': _users,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<QuestionnaireModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<QuestionnaireModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ROOMID = amplify_core.QueryField(fieldName: "roomId");
  static final QUESTION = amplify_core.QueryField(fieldName: "question");
  static final USERS = amplify_core.QueryField(
    fieldName: "users",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserQuestionnaire'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Questionnaire";
    modelSchemaDefinition.pluralName = "Questionnaires";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        provider: amplify_core.AuthRuleProvider.IAM,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Questionnaire.ROOMID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Questionnaire.QUESTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Questionnaire.USERS,
      isRequired: false,
      ofModelName: 'UserQuestionnaire',
      associatedKey: UserQuestionnaire.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _QuestionnaireModelType extends amplify_core.ModelType<Questionnaire> {
  const _QuestionnaireModelType();
  
  @override
  Questionnaire fromJson(Map<String, dynamic> jsonData) {
    return Questionnaire.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Questionnaire';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Questionnaire] in your schema.
 */
class QuestionnaireModelIdentifier implements amplify_core.ModelIdentifier<Questionnaire> {
  final String id;

  /** Create an instance of QuestionnaireModelIdentifier using [id] the primary key. */
  const QuestionnaireModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'QuestionnaireModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is QuestionnaireModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}