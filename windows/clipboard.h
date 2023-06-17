#pragma once
#include <string>
#include <windows.h>

class Clipboard
{
public:
  UINT CF_HTML = RegisterClipboardFormat(TEXT("HTML Format"));
  std::string *getClipboardData(int format);
  void setClipboardData(int format, std::string data);
};
