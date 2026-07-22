// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/widgets.dart';

/// Detects the base paragraph direction of a piece of user generated text.
///
/// Flutter resolves the paragraph direction from `Directionality.of(context)`,
/// which follows the *app* locale. That breaks messages which mix an RTL
/// script (Arabic, Persian, Hebrew, ...) with latin words: the Unicode
/// bidi algorithm then reorders the runs against the author's intent.
///
/// Following the Unicode Bidirectional Algorithm (UAX #9, rule P2/P3) we look
/// for the first *strong* character and derive the base direction from it.
/// Neutral characters (digits, punctuation, whitespace, emoji) are skipped,
/// and bidi isolates are skipped over as a whole so that an embedded latin
/// mention at the very beginning does not flip a Persian message to LTR.
extension TextDirectionDetection on String {
  /// Characters with a strong right-to-left bidi class.
  ///
  /// Covers Hebrew, Arabic, Syriac, Thaana, N'Ko, Samaritan, Mandaic,
  /// Arabic Extended-A/B, Arabic Presentation Forms A and B.
  static final RegExp _strongRtl = RegExp(
    r'[\u0590-\u05FF'
    r'\u0600-\u06FF'
    r'\u0700-\u074F'
    r'\u0750-\u077F'
    r'\u0780-\u07BF'
    r'\u07C0-\u07FF'
    r'\u0800-\u085F'
    r'\u0860-\u08FF'
    r'\u200F' // RIGHT-TO-LEFT MARK
    r'\uFB1D-\uFB4F'
    r'\uFB50-\uFDFF'
    r'\uFE70-\uFEFF]',
  );

  /// Characters with a strong left-to-right bidi class (latin, greek,
  /// cyrillic, and the CJK/kana blocks which are LTR as well).
  static final RegExp _strongLtr = RegExp(
    r'[A-Za-z'
    r'\u00C0-\u02B8'
    r'\u0370-\u058F'
    r'\u0900-\u1FFF'
    r'\u200E' // LEFT-TO-RIGHT MARK
    r'\u2C00-\uD7FF'
    r'\uF900-\uFB17]',
  );

  /// Opening bidi isolate/embedding controls.
  static const Set<int> _isolateStarts = {
    0x2066, // LRI
    0x2067, // RLI
    0x2068, // FSI
    0x202A, // LRE
    0x202B, // RLE
    0x202D, // LRO
    0x202E, // RLO
  };

  /// Closing bidi isolate/embedding controls.
  static const Set<int> _isolateEnds = {
    0x2069, // PDI
    0x202C, // PDF
  };

  /// The base [TextDirection] this string should be laid out with, or `null`
  /// when the string contains no strong character at all (pure emoji, digits,
  /// punctuation). Callers should fall back to the ambient directionality in
  /// that case.
  TextDirection? get detectedTextDirection {
    var isolateDepth = 0;

    for (final rune in runes) {
      if (_isolateStarts.contains(rune)) {
        isolateDepth++;
        continue;
      }
      if (_isolateEnds.contains(rune)) {
        if (isolateDepth > 0) isolateDepth--;
        continue;
      }
      // Characters inside an isolate must not influence the base direction.
      if (isolateDepth > 0) continue;

      final char = String.fromCharCode(rune);
      if (_strongRtl.hasMatch(char)) return TextDirection.rtl;
      if (_strongLtr.hasMatch(char)) return TextDirection.ltr;
    }
    return null;
  }

  /// Convenience helper which resolves to the ambient directionality of
  /// [context] when this string has no strong character.
  TextDirection textDirectionOf(BuildContext context) =>
      detectedTextDirection ?? Directionality.of(context);
}
