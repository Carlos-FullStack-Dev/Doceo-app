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


/** This is an auto generated class representing the User type in your schema. */
class User {
  final String? _name;
  final String? _role;
  final String? _image;
  final String? _firstName;
  final String? _lastName;

  String? get name {
    return _name;
  }
  
  String? get role {
    return _role;
  }
  
  String? get image {
    return _image;
  }
  
  String? get firstName {
    return _firstName;
  }
  
  String? get lastName {
    return _lastName;
  }
  
  const User._internal({name, role, image, firstName, lastName}): _name = name, _role = role, _image = image, _firstName = firstName, _lastName = lastName;
  
  factory User({String? name, String? role, String? image, String? firstName, String? lastName}) {
    return User._internal(
      name: name,
      role: role,
      image: image,
      firstName: firstName,
      lastName: lastName);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      _name == other._name &&
      _role == other._role &&
      _image == other._image &&
      _firstName == other._firstName &&
      _lastName == other._lastName;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("role=" + "$_role" + ", ");
    buffer.write("image=" + "$_image" + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? name, String? role, String? image, String? firstName, String? lastName}) {
    return User._internal(
      name: name ?? this.name,
      role: role ?? this.role,
      image: image ?? this.image,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? role,
    ModelFieldValue<String?>? image,
    ModelFieldValue<String?>? firstName,
    ModelFieldValue<String?>? lastName
  }) {
    return User._internal(
      name: name == null ? this.name : name.value,
      role: role == null ? this.role : role.value,
      image: image == null ? this.image : image.value,
      firstName: firstName == null ? this.firstName : firstName.value,
      lastName: lastName == null ? this.lastName : lastName.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : _name = json['name'],
      _role = json['role'],
      _image = json['image'],
      _firstName = json['firstName'],
      _lastName = json['lastName'];
  
  Map<String, dynamic> toJson() => {
    'name': _name, 'role': _role, 'image': _image, 'firstName': _firstName, 'lastName': _lastName
  };
  
  Map<String, Object?> toMap() => {
    'name': _name,
    'role': _role,
    'image': _image,
    'firstName': _firstName,
    'lastName': _lastName
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'name',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'role',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'image',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'firstName',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'lastName',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}