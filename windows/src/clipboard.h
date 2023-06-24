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

/// class Clipboard
class Clipboard
{
public:
  /// @brief Get clipboard data
  /// @param format - Clipboard format
  /// @return String of clipboard data
  std::string *getClipboardData(int format);

  /// @brief Set clipboard data
  /// @param format - Clipboard format
  /// @param data - Clipboard data
  /// @return True if successful otherwise false
  void setClipboardData(int format, std::string data);

  /// @brief htmlToWindowsFragment
  /// @param htmlString - HTML string
  /// @return Windows fragment of HTML string
  std::string htmlToWindowsFragment(std::string htmlString);

  /// @brief windowsFragmentToHtml
  /// @param fragment - Windows fragment of HTML string
  /// @return HTML string
  std::string windowsFragmentToHtml(std::string fragment);
  void clearClipboard();
};
