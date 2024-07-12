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


/** This is an auto generated class representing the PointHistory type in your schema. */
class PointHistory extends amplify_core.Model {
  static const classType = const _PointHistoryModelType();
  final String id;
  final String? _type;
  final int? _point;
  final String? _userId;
  final String? _text;
  final String? _doctorId;
  final String? _messageId;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PointHistoryModelIdentifier get modelIdentifier {
      return PointHistoryModelIdentifier(
        id: id
      );
  }
  
  String get type {
    try {
      return _type!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get point {
    try {
      return _point!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
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
  
  String get text {
    try {
      return _text!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get doctorId {
    return _doctorId;
  }
  
  String? get messageId {
    return _messageId;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const PointHistory._internal({required this.id, required type, required point, required userId, required text, doctorId, messageId, createdAt, updatedAt}): _type = type, _point = point, _userId = userId, _text = text, _doctorId = doctorId, _messageId = messageId, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory PointHistory({String? id, required String type, required int point, required String userId, required String text, String? doctorId, String? messageId}) {
    return PointHistory._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      point: point,
      userId: userId,
      text: text,
      doctorId: doctorId,
      messageId: messageId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PointHistory &&
      id == other.id &&
      _type == other._type &&
      _point == other._point &&
      _userId == other._userId &&
      _text == other._text &&
      _doctorId == other._doctorId &&
      _messageId == other._messageId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PointHistory {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("point=" + (_point != null ? _point!.toString() : "null") + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("text=" + "$_text" + ", ");
    buffer.write("doctorId=" + "$_doctorId" + ", ");
    buffer.write("messageId=" + "$_messageId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PointHistory copyWith({String? type, int? point, String? userId, String? text, String? doctorId, String? messageId}) {
    return PointHistory._internal(
      id: id,
      type: type ?? this.type,
      point: point ?? this.point,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      doctorId: doctorId ?? this.doctorId,
      messageId: messageId ?? this.messageId);
  }
  
  PointHistory copyWithModelFieldValues({
    ModelFieldValue<String>? type,
    ModelFieldValue<int>? point,
    ModelFieldValue<String>? userId,
    ModelFieldValue<String>? text,
    ModelFieldValue<String?>? doctorId,
    ModelFieldValue<String?>? messageId
  }) {
    return PointHistory._internal(
      id: id,
      type: type == null ? this.type : type.value,
      point: point == null ? this.point : point.value,
      userId: userId == null ? this.userId : userId.value,
      text: text == null ? this.text : text.value,
      doctorId: doctorId == null ? this.doctorId : doctorId.value,
      messageId: messageId == null ? this.messageId : messageId.value
    );
  }
  
  PointHistory.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = json['type'],
      _point = (json['point'] as num?)?.toInt(),
      _userId = json['userId'],
      _text = json['text'],
      _doctorId = json['doctorId'],
      _messageId = json['messageId'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': _type, 'point': _point, 'userId': _userId, 'text': _text, 'doctorId': _doctorId, 'messageId': _messageId, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'point': _point,
    'userId': _userId,
    'text': _text,
    'doctorId': _doctorId,
    'messageId': _messageId,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<PointHistoryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PointHistoryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final POINT = amplify_core.QueryField(fieldName: "point");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final TEXT = amplify_core.QueryField(fieldName: "text");
  static final DOCTORID = amplify_core.QueryField(fieldName: "doctorId");
  static final MESSAGEID = amplify_core.QueryField(fieldName: "messageId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PointHistory";
    modelSchemaDefinition.pluralName = "PointHistories";
    
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
      key: PointHistory.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PointHistory.POINT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PointHistory.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PointHistory.TEXT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PointHistory.DOCTORID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: PointHistory.MESSAGEID,
      isRequired: false,
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

class _PointHistoryModelType extends amplify_core.ModelType<PointHistory> {
  const _PointHistoryModelType();
  
  @override
  PointHistory fromJson(Map<String, dynamic> jsonData) {
    return PointHistory.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'PointHistory';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [PointHistory] in your schema.
 */
class PointHistoryModelIdentifier implements amplify_core.ModelIdentifier<PointHistory> {
  final String id;

  /** Create an instance of PointHistoryModelIdentifier using [id] the primary key. */
  const PointHistoryModelIdentifier({
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
  String toString() => 'PointHistoryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PointHistoryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}