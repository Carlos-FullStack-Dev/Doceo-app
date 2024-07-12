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


/** This is an auto generated class representing the UserQuestionnaire type in your schema. */
class UserQuestionnaire extends amplify_core.Model {
  static const classType = const _UserQuestionnaireModelType();
  final String id;
  final String? _userId;
  final String? _questionId;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserQuestionnaireModelIdentifier get modelIdentifier {
      return UserQuestionnaireModelIdentifier(
        id: id
      );
  }
  
  String get userId {
    try {
      return _userId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get questionId {
    try {
      return _questionId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserQuestionnaire._internal({required this.id, required userId, required questionId, createdAt, updatedAt}): _userId = userId, _questionId = questionId, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserQuestionnaire({String? id, required String userId, required String questionId}) {
    return UserQuestionnaire._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      questionId: questionId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserQuestionnaire &&
      id == other.id &&
      _userId == other._userId &&
      _questionId == other._questionId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserQuestionnaire {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("questionId=" + "$_questionId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserQuestionnaire copyWith({String? userId, String? questionId}) {
    return UserQuestionnaire._internal(
      id: id,
      userId: userId ?? this.userId,
      questionId: questionId ?? this.questionId);
  }
  
  UserQuestionnaire copyWithModelFieldValues({
    ModelFieldValue<String>? userId,
    ModelFieldValue<String>? questionId
  }) {
    return UserQuestionnaire._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      questionId: questionId == null ? this.questionId : questionId.value
    );
  }
  
  UserQuestionnaire.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _questionId = json['questionId'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'questionId': _questionId, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'questionId': _questionId,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserQuestionnaireModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserQuestionnaireModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final QUESTIONID = amplify_core.QueryField(fieldName: "questionId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserQuestionnaire";
    modelSchemaDefinition.pluralName = "UserQuestionnaires";
    
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id", "questionId", "userId"], name: "byQuestion")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserQuestionnaire.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserQuestionnaire.QUESTIONID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _UserQuestionnaireModelType extends amplify_core.ModelType<UserQuestionnaire> {
  const _UserQuestionnaireModelType();
  
  @override
  UserQuestionnaire fromJson(Map<String, dynamic> jsonData) {
    return UserQuestionnaire.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserQuestionnaire';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserQuestionnaire] in your schema.
 */
class UserQuestionnaireModelIdentifier implements amplify_core.ModelIdentifier<UserQuestionnaire> {
  final String id;

  /** Create an instance of UserQuestionnaireModelIdentifier using [id] the primary key. */
  const UserQuestionnaireModelIdentifier({
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
  String toString() => 'UserQuestionnaireModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserQuestionnaireModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}