class PageResult<T> {
  final bool? hasMore;
  final List<T> itemList;

  PageResult(this.itemList, {this.hasMore});
}
