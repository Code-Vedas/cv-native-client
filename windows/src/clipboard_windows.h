#pragma once
#include <string>
#include <windows.h>
#include <flutter/standard_method_codec.h>

/// class ClipboardWindows
class ClipboardWindows
{
public:
  /// @brief Get clipboard data
  static UINT CF_HTML;

  /// @brief Get clipboard data
  /// @return Map of clipboard data with mime type as key and data as value.
  ///   - plainText: String (if plain text is available)
  ///   - htmlText: String (if html text is available)
  static std::map<flutter::EncodableValue, flutter::EncodableValue> getClipboardData();

  /// @brief Get clipboard data mime types
  /// @return Vector of clipboard data mime types.
  ///   - plainText: String (if plain text is available)
  ///   - htmlText: String (if html text is available)
  static std::vector<flutter::EncodableValue> getClipboardDataMimeTypes();

  /// @brief Set clipboard data
  /// @param method_call - Method call
  /// @return True if successful otherwise false
  static bool setClipboardData(const flutter::MethodCall<flutter::EncodableValue> &method_call);
};
