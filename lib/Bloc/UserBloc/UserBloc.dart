import 'package:flutter_app/Model/User/User_Model.dart';
import 'package:flutter_app/Repository/Repository.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rxdart/rxdart.dart';


class UserBloc {
  Repository _userRepository = Repository();
  final BehaviorSubject<User> _userBehavior =
  BehaviorSubject<User>();
  final LocalStorage storage = new LocalStorage('user');
  getUser(int id) async {
    User user = await _userRepository.getUserByID(id);
    _userBehavior.sink.add(user);
  }

  getUserLogin(String token) async {
    User userLogin = await _userRepository.login(token);
    storage.setItem('user', userLogin.toJson());
     print(storage.getItem('user'));
  }

  dispose() async {
    _userBehavior.close();
  }

  BehaviorSubject<User> get userProfile => _userBehavior.stream;
}

final userBloc = UserBloc();
