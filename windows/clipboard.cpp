#include "Clipboard.h"
#include <iostream>
#include <vector>
std::string *Clipboard::getClipboardData(int format)
{
  std::string str;
  if (OpenClipboard(nullptr))
  {
    HANDLE hData = GetClipboardData(format);
    if (hData != nullptr)
    {
      LPCSTR pszText = static_cast<LPCSTR>(GlobalLock(hData));
      if (pszText != nullptr)
      {
        str.assign(pszText);
        GlobalUnlock(hData);
      }
    }
    CloseClipboard();
  }
  if (str.empty())
  {
    return nullptr;
  }
  return new std::string(str);
}

void Clipboard::setClipboardData(int format, std::string data)
{
  if (OpenClipboard(nullptr))
  {
    EmptyClipboard();
    HGLOBAL hClipboardData;
    hClipboardData = GlobalAlloc(GMEM_DDESHARE, data.size() + 1);
    char *pchData;
    pchData = (char *)GlobalLock(hClipboardData);
    strcpy(pchData, LPCSTR(data.c_str()));
    GlobalUnlock(hClipboardData);
    SetClipboardData(format, hClipboardData);
    CloseClipboard();
  }
}