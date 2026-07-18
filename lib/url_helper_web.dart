import 'dart:html' as html;

String? getWebUrlKey() {
  try {
    final search = html.window.location.search;
    if (search != null && search.contains('key=')) {
      final uri = Uri.parse('http://dummy$search');
      return uri.queryParameters['key'];
    }
    final hash = html.window.location.hash;
    if (hash != null && hash.contains('key=')) {
      final uri = Uri.parse('http://dummy${hash.startsWith('#') ? hash.substring(1) : hash}');
      return uri.queryParameters['key'];
    }
  } catch (e) {
    print('Error getting web URL: $e');
  }
  return null;
}
