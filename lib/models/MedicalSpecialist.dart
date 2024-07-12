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


/** This is an auto generated class representing the MedicalSpecialist type in your schema. */
class MedicalSpecialist extends amplify_core.Model {
  static const classType = const _MedicalSpecialistModelType();
  final String id;
  final String? _medicalSpecialist;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MedicalSpecialistModelIdentifier get modelIdentifier {
      return MedicalSpecialistModelIdentifier(
        id: id
      );
  }
  
  String get medicalSpecialist {
    try {
      return _medicalSpecialist!;
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
  
  const MedicalSpecialist._internal({required this.id, required medicalSpecialist, createdAt, updatedAt}): _medicalSpecialist = medicalSpecialist, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MedicalSpecialist({String? id, required String medicalSpecialist}) {
    return MedicalSpecialist._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      medicalSpecialist: medicalSpecialist);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MedicalSpecialist &&
      id == other.id &&
      _medicalSpecialist == other._medicalSpecialist;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MedicalSpecialist {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("medicalSpecialist=" + "$_medicalSpecialist" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MedicalSpecialist copyWith({String? medicalSpecialist}) {
    return MedicalSpecialist._internal(
      id: id,
      medicalSpecialist: medicalSpecialist ?? this.medicalSpecialist);
  }
  
  MedicalSpecialist copyWithModelFieldValues({
    ModelFieldValue<String>? medicalSpecialist
  }) {
    return MedicalSpecialist._internal(
      id: id,
      medicalSpecialist: medicalSpecialist == null ? this.medicalSpecialist : medicalSpecialist.value
    );
  }
  
  MedicalSpecialist.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _medicalSpecialist = json['medicalSpecialist'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'medicalSpecialist': _medicalSpecialist, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'medicalSpecialist': _medicalSpecialist,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MedicalSpecialistModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MedicalSpecialistModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final MEDICALSPECIALIST = amplify_core.QueryField(fieldName: "medicalSpecialist");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MedicalSpecialist";
    modelSchemaDefinition.pluralName = "MedicalSpecialists";
    
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
      key: MedicalSpecialist.MEDICALSPECIALIST,
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

class _MedicalSpecialistModelType extends amplify_core.ModelType<MedicalSpecialist> {
  const _MedicalSpecialistModelType();
  
  @override
  MedicalSpecialist fromJson(Map<String, dynamic> jsonData) {
    return MedicalSpecialist.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'MedicalSpecialist';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MedicalSpecialist] in your schema.
 */
class MedicalSpecialistModelIdentifier implements amplify_core.ModelIdentifier<MedicalSpecialist> {
  final String id;

  /** Create an instance of MedicalSpecialistModelIdentifier using [id] the primary key. */
  const MedicalSpecialistModelIdentifier({
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
  String toString() => 'MedicalSpecialistModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MedicalSpecialistModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}