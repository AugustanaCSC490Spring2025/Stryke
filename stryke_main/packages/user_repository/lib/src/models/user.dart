
import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String name;

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
});

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? name,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }


  MyUserEntity toEntity(){
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
    );
  }

  static MyUser fromEntity(MyUserEntity entity){
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
    );
  }

  @override
  String toString() {
    return 'MyUser(userId: $userId, email: $email, name: $name)';
  }



}