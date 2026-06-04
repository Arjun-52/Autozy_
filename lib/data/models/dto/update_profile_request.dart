class UpdateProfileRequest {
  final String? name;
  final String? email;

  UpdateProfileRequest({this.name, this.email});

  Map<String, dynamic> toJson() => {
        if (name != null && name!.trim().isNotEmpty) 'name': name!.trim(),
        if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
      };
}
