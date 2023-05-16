part of 'my_bloc_bloc.dart';

class MyBlocEvent extends Equatable {
  const MyBlocEvent();

  @override
  List<Object> get props => [];
}

class MainEvent extends MyBlocEvent{
  @override
  List<Object> get props => [];
}

class LoadMoreEvent extends MyBlocEvent {
  final FilterModel? filterModel;

  const LoadMoreEvent({this.filterModel});

  @override
  List<Object> get props => [filterModel!];
}

class RefreshEvent extends MyBlocEvent {}
