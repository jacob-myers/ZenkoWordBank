class Trie<T> {
  TrieNode<T> root = TrieNode([]);

  TrieNode<T>? _getNode(String path) {
    TrieNode<T>? node = root;
    int i = 0;
    while (node != null) {
      if (i >= path.length) {
        return node;
      }
      node = node.children[path.codeUnits[i]];
      i++;
    }
    return null;
  }

  void insert(String name, T data) {
    TrieNode<T> node = root;
    for (int i = 0; i < name.length; i++) {
      node = node.children.putIfAbsent(name.codeUnits[i], () => TrieNode([]));
    }
    node.data.add(data);
  }

  void remove(String name, T data) {
    _getNode(name)?.data.remove(data);
  }

  List<T> get(String name) {
    return _getNode(name)?.data ?? [];
  }

  List<T> search(String searchTerm) {
    List<T> list = [];
    var node = _getNode(searchTerm);
    if (node == null) {
      return list;
    }
    _getChildren(node, list);
    return list;
  }

  void _getChildren(TrieNode<T> node, List<T> list) {
    var data = node.data;
    list.addAll(data);
    for (TrieNode<T> child in node.children.values) {
      _getChildren(child, list);
    }
  }
}

class TrieNode<T> {
  List<T> data;
  Map<int, TrieNode<T>> children = {};

  TrieNode(this.data);
}
