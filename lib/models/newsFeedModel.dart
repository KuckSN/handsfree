class NewsFeedModel {
  final id;
  final newsFeedTitle;
  final newsFeedDesc;
  final newsFeedImages;
  final timestamp;
  final author;

  NewsFeedModel(
      this.id, this.newsFeedTitle, this.newsFeedDesc, this.newsFeedImages,
      this.timestamp, this.author);
}

class NewsFeedModel_1 {
  final author;
  final content;
  final media;
  final timestamp;
  final title;

  NewsFeedModel_1({this.author, this.content, this.media, this.timestamp, this.title});
}
