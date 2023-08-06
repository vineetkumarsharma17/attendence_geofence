class UserDb {
  String name;
  String? id;
  String email;
  String? profilePic;

  UserDb({required this.name, required this.email, this.id, this.profilePic});

  UserDb.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        id = json['id'],
        profilePic = json['profilePic'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (id != null) {
      data['id'] = id;
    }
    data['email'] = this.email;
    data['profilePic'] = this.profilePic;
    return data;
  }
}
