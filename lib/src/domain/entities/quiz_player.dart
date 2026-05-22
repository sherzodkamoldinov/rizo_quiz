import 'package:equatable/equatable.dart';

/// Identifies the player session inside the quiz package.
/// Host passes this when launching `QuizEntry`.
class QuizPlayer extends Equatable {
  const QuizPlayer({
    required this.userId,
    required this.displayName,
    required this.lang,
    this.avatarUrl,
  });

  final String userId;
  final String displayName;

  /// ISO language code: 'ru' | 'uz' | 'en'.
  final String lang;

  /// Optional profile photo URL. Null/empty → letter fallback in avatar circle.
  final String? avatarUrl;

  @override
  List<Object?> get props => [userId, displayName, lang, avatarUrl];
}
