#pragma once
#include <string>
#include <windows.h>

// class Clipboard
class Clipboard
{
public:
  std::string *getClipboardData(int format);
  void setClipboardData(int format, std::string data);
  std::string htmlToWindowsFragment(std::string htmlString);
  std::string windowsFragmentToHtml(std::string fragment);
  void clearClipboard();
};
