part of 'my_bloc_bloc.dart';

abstract class MyBlocState extends Equatable {
  const MyBlocState();

  @override
  List<Object> get props => [];
}

class MyBlocInitial extends MyBlocState {}

class MyBlocLoading extends MyBlocState {
  }

class MyBlocLoaded extends MyBlocState {
  final List<Post> post;

  const MyBlocLoaded(this.post);

}
