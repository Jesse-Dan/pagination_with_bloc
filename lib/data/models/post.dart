class Post {
  final String title;
  final String body;
  final int id;
const Post({required this.title,required this.body,required this.id, });
  Post.fromJson(Map json) :
    title = json['title'],
    body = json['body'],
    id = json['id'];

}