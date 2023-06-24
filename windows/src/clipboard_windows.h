// MIT License
//
// Copyright (c) 2023 Code Vedas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
