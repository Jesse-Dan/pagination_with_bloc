import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_bloc/bloc/my_bloc_bloc.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  final scrollController = ScrollController();
  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        BlocProvider.of<MyBlocBloc>(context).add(LoadMoreEvent());
      }
    });
  }

  @override
  void initState() {
    setupScrollController(context);
    BlocProvider.of<MyBlocBloc>(context).add( MainEvent());
    super.initState();
  }

  final TextEditingController page = TextEditingController();
  final TextEditingController limit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: RefreshIndicator(
          onRefresh: (() async {
            // BlocProvider.of<MyBlocBloc>(context).add(RefreshEvent());
          }),
          child: _list()),

      /// Filter
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.filter),
        label: const Text('Filter'),
        
        onPressed: () async {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: TextField(controller: limit),
                    actions: [
                      FloatingActionButton.extended(
                        icon: const Icon(Icons.filter),
                        label: const Text('Filter'),
                        onPressed: () async {
                          BlocProvider.of<MyBlocBloc>(context)
                            ..list.clear()
                            ..filterModel.page = 1
                            ..filterModel.limit = int.parse(limit.text)
                            ..add( MainEvent());
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        },
      ),
    );
  }

  Widget _list() {
    return BlocBuilder<MyBlocBloc, MyBlocState>(
      builder: (context, state) {
        log(state.toString());
        if (state is MyBlocInitial) {
          return const Center(child: Text('Please  wait \n Loading...'));
        } else if (state is MyBlocLoaded) {
          return ListView.builder(
            controller: scrollController,
            itemCount:
                state.post.length + (!BlocProvider.of<MyBlocBloc>(context).initialLoadComplete3 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.post.length) {
                return ListTile(
                  leading: Text(state.post[index].id.toString()),
                  subtitle: Text(state.post[index].body),
                  title: Text(state.post[index].title),
                );
              } else if (index == state.post.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        } else if (state is MyBlocEmpty) {
          return ListView.builder(
            controller: scrollController,
            itemCount:
                state.post.length + (!BlocProvider.of<MyBlocBloc>(context).initialLoadComplete3 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.post.length) {
                return ListTile(
                  leading: Text(state.post[index].id.toString()),
                  subtitle: Text(state.post[index].body),
                  title: Text(state.post[index].title),
                );
              } else if (index == state.post.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('No More data')),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
