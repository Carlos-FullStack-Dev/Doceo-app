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


/** This is an auto generated class representing the Channel type in your schema. */
class Channel {
  final String id;
  final String? _type;
  final String? _image;
  final String? _name;
  final String? _description;
  final int? _feedsCount;
  final int? _doctorFeedsCount;
  final List<String>? _questions;
  final List<String>? _tags;
  final String? _owner;
  final bool? _disabled;

  String? get type {
    return _type;
  }
  
  String? get image {
    return _image;
  }
  
  String? get name {
    return _name;
  }
  
  String? get description {
    return _description;
  }
  
  int? get feedsCount {
    return _feedsCount;
  }
  
  int? get doctorFeedsCount {
    return _doctorFeedsCount;
  }
  
  List<String>? get questions {
    return _questions;
  }
  
  List<String>? get tags {
    return _tags;
  }
  
  String? get owner {
    return _owner;
  }
  
  bool? get disabled {
    return _disabled;
  }
  
  const Channel._internal({required this.id, type, image, name, description, feedsCount, doctorFeedsCount, questions, tags, owner, disabled}): _type = type, _image = image, _name = name, _description = description, _feedsCount = feedsCount, _doctorFeedsCount = doctorFeedsCount, _questions = questions, _tags = tags, _owner = owner, _disabled = disabled;
  
  factory Channel({String? id, String? type, String? image, String? name, String? description, int? feedsCount, int? doctorFeedsCount, List<String>? questions, List<String>? tags, String? owner, bool? disabled}) {
    return Channel._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      image: image,
      name: name,
      description: description,
      feedsCount: feedsCount,
      doctorFeedsCount: doctorFeedsCount,
      questions: questions != null ? List<String>.unmodifiable(questions) : questions,
      tags: tags != null ? List<String>.unmodifiable(tags) : tags,
      owner: owner,
      disabled: disabled);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Channel &&
      id == other.id &&
      _type == other._type &&
      _image == other._image &&
      _name == other._name &&
      _description == other._description &&
      _feedsCount == other._feedsCount &&
      _doctorFeedsCount == other._doctorFeedsCount &&
      DeepCollectionEquality().equals(_questions, other._questions) &&
      DeepCollectionEquality().equals(_tags, other._tags) &&
      _owner == other._owner &&
      _disabled == other._disabled;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Channel {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("image=" + "$_image" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("feedsCount=" + (_feedsCount != null ? _feedsCount!.toString() : "null") + ", ");
    buffer.write("doctorFeedsCount=" + (_doctorFeedsCount != null ? _doctorFeedsCount!.toString() : "null") + ", ");
    buffer.write("questions=" + (_questions != null ? _questions!.toString() : "null") + ", ");
    buffer.write("tags=" + (_tags != null ? _tags!.toString() : "null") + ", ");
    buffer.write("owner=" + "$_owner" + ", ");
    buffer.write("disabled=" + (_disabled != null ? _disabled!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Channel copyWith({String? id, String? type, String? image, String? name, String? description, int? feedsCount, int? doctorFeedsCount, List<String>? questions, List<String>? tags, String? owner, bool? disabled}) {
    return Channel._internal(
      id: id ?? this.id,
      type: type ?? this.type,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      feedsCount: feedsCount ?? this.feedsCount,
      doctorFeedsCount: doctorFeedsCount ?? this.doctorFeedsCount,
      questions: questions ?? this.questions,
      tags: tags ?? this.tags,
      owner: owner ?? this.owner,
      disabled: disabled ?? this.disabled);
  }
  
  Channel copyWithModelFieldValues({
    ModelFieldValue<String>? id,
    ModelFieldValue<String?>? type,
    ModelFieldValue<String?>? image,
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? description,
    ModelFieldValue<int?>? feedsCount,
    ModelFieldValue<int?>? doctorFeedsCount,
    ModelFieldValue<List<String>?>? questions,
    ModelFieldValue<List<String>?>? tags,
    ModelFieldValue<String?>? owner,
    ModelFieldValue<bool?>? disabled
  }) {
    return Channel._internal(
      id: id == null ? this.id : id.value,
      type: type == null ? this.type : type.value,
      image: image == null ? this.image : image.value,
      name: name == null ? this.name : name.value,
      description: description == null ? this.description : description.value,
      feedsCount: feedsCount == null ? this.feedsCount : feedsCount.value,
      doctorFeedsCount: doctorFeedsCount == null ? this.doctorFeedsCount : doctorFeedsCount.value,
      questions: questions == null ? this.questions : questions.value,
      tags: tags == null ? this.tags : tags.value,
      owner: owner == null ? this.owner : owner.value,
      disabled: disabled == null ? this.disabled : disabled.value
    );
  }
  
  Channel.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = json['type'],
      _image = json['image'],
      _name = json['name'],
      _description = json['description'],
      _feedsCount = (json['feedsCount'] as num?)?.toInt(),
      _doctorFeedsCount = (json['doctorFeedsCount'] as num?)?.toInt(),
      _questions = json['questions']?.cast<String>(),
      _tags = json['tags']?.cast<String>(),
      _owner = json['owner'],
      _disabled = json['disabled'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': _type, 'image': _image, 'name': _name, 'description': _description, 'feedsCount': _feedsCount, 'doctorFeedsCount': _doctorFeedsCount, 'questions': _questions, 'tags': _tags, 'owner': _owner, 'disabled': _disabled
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'image': _image,
    'name': _name,
    'description': _description,
    'feedsCount': _feedsCount,
    'doctorFeedsCount': _doctorFeedsCount,
    'questions': _questions,
    'tags': _tags,
    'owner': _owner,
    'disabled': _disabled
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Channel";
    modelSchemaDefinition.pluralName = "Channels";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'id',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'type',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'image',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'name',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'description',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'feedsCount',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'doctorFeedsCount',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'questions',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'tags',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'owner',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'disabled',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
  });
}