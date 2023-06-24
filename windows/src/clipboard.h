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
