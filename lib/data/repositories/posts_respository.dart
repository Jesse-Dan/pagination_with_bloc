import '../models/post.dart';
import '../services/posts_service.dart';

class PostsRepository {
  final PostsService service;

  PostsRepository(this.service);

  Future<List<Post>> fetchPosts({ page , limit}) async {
    List<Post> posts = await service.fetchPosts(page, limit: limit);
    return posts;
  }
}
