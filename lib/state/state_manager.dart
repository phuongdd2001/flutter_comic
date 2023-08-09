import 'package:flutter_comic_reader/model/comic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

final comicSelected = StateProvider((ref) => Comic());