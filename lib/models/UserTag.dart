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


/** This is an auto generated class representing the UserTag type in your schema. */
class UserTag extends amplify_core.Model {
  static const classType = const _UserTagModelType();
  final String id;
  final String? _userId;
  final Tag? _tag;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserTagModelIdentifier get modelIdentifier {
      return UserTagModelIdentifier(
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
  
  Tag? get tag {
    return _tag;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserTag._internal({required this.id, required userId, tag, createdAt, updatedAt}): _userId = userId, _tag = tag, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserTag({String? id, required String userId, Tag? tag}) {
    return UserTag._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      tag: tag);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserTag &&
      id == other.id &&
      _userId == other._userId &&
      _tag == other._tag;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserTag {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("tag=" + (_tag != null ? _tag!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserTag copyWith({String? userId, Tag? tag}) {
    return UserTag._internal(
      id: id,
      userId: userId ?? this.userId,
      tag: tag ?? this.tag);
  }
  
  UserTag copyWithModelFieldValues({
    ModelFieldValue<String>? userId,
    ModelFieldValue<Tag?>? tag
  }) {
    return UserTag._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      tag: tag == null ? this.tag : tag.value
    );
  }
  
  UserTag.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _tag = json['tag']?['serializedData'] != null
        ? Tag.fromJson(new Map<String, dynamic>.from(json['tag']['serializedData']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'tag': _tag?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'tag': _tag,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserTagModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserTagModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final TAG = amplify_core.QueryField(
    fieldName: "tag",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Tag'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserTag";
    modelSchemaDefinition.pluralName = "UserTags";
    
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
      amplify_core.ModelIndex(fields: const ["tagId", "userId"], name: "byTag")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserTag.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: UserTag.TAG,
      isRequired: false,
      targetNames: ['tagId'],
      ofModelName: 'Tag'
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

class _UserTagModelType extends amplify_core.ModelType<UserTag> {
  const _UserTagModelType();
  
  @override
  UserTag fromJson(Map<String, dynamic> jsonData) {
    return UserTag.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserTag';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserTag] in your schema.
 */
class UserTagModelIdentifier implements amplify_core.ModelIdentifier<UserTag> {
  final String id;

  /** Create an instance of UserTagModelIdentifier using [id] the primary key. */
  const UserTagModelIdentifier({
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
  String toString() => 'UserTagModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserTagModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}