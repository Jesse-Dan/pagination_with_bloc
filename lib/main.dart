import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_bloc/bloc/my_bloc_bloc.dart';

import 'data/repositories/posts_respository.dart';
import 'data/services/posts_service.dart';
import 'presentation/posts_screen.dart';

void main() {
  runApp(PaginationApp(
    repository: PostsRepository(PostsService()),
  ));
}

class PaginationApp extends StatelessWidget {
  final PostsRepository repository;

  const PaginationApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MyBlocBloc(PostsRepository(PostsService()),
          )),
        ],
        child: const PostsView(),
      ),
    );
  }
}
