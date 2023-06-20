#include "clipboard_windows.h"
#include "clipboard.h"
#include <iostream>
#include <vector>

UINT ClipboardWindows::CF_HTML = RegisterClipboardFormat(TEXT("HTML Format"));

std::map<flutter::EncodableValue, flutter::EncodableValue> ClipboardWindows::getClipboardText()
{
  std::map<flutter::EncodableValue, flutter::EncodableValue> map;
  Clipboard clipboard = Clipboard();
  std::string *text = clipboard.getClipboardData(CF_TEXT);
  if (text != nullptr)
  {
    map[flutter::EncodableValue("plainText")] = flutter::EncodableValue(*text);
  }
  else
  {
    std::string *unicode = clipboard.getClipboardData(CF_UNICODETEXT);
    if (unicode != nullptr)
    {
      map[flutter::EncodableValue("plainText")] = flutter::EncodableValue(*unicode);
    }
    else
    {
      map[flutter::EncodableValue("plainText")] = flutter::EncodableValue("");
    }
  }

  std::string *html = clipboard.getClipboardData(CF_HTML);
  if (html != nullptr)
  {
    map[flutter::EncodableValue("htmlText")] = flutter::EncodableValue(clipboard.windowsFragmentToHtml(*html));
  }
  else
  {
    map[flutter::EncodableValue("htmlText")] = flutter::EncodableValue("");
  }

  return map;
}
bool ClipboardWindows::canCopyFromClipboard()
{
  Clipboard clipboard = Clipboard();
  std::string *text = clipboard.getClipboardData(CF_TEXT);
  if (text != nullptr)
  {
    return true;
  }
  std::string *unicode = clipboard.getClipboardData(CF_UNICODETEXT);
  if (unicode != nullptr)
  {
    return true;
  }
  std::string *html = clipboard.getClipboardData(CF_HTML);
  if (html != nullptr)
  {
    return true;
  }
  return false;
}
bool ClipboardWindows::setClipboardText(const flutter::MethodCall<flutter::EncodableValue> &method_call)
{
  // Set clipboard text
  Clipboard clipboard = Clipboard();
  // get clipboard data from method_call.arguments
  // argument is passed a String from flutter
  const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (!arguments)
  {
    return false;
  }
  // get htmlText from arguments
  const auto htmlText = arguments->find(flutter::EncodableValue("htmlText"));
  // get plainText from arguments
  const auto plainText = arguments->find(flutter::EncodableValue("plainText"));

  if (htmlText == arguments->end() || plainText == arguments->end())
  {
    return false;
  }
  // clear clipboard
  clipboard.clearClipboard();
  // set clipboard data
  clipboard.setClipboardData(CF_TEXT, std::get<std::string>(plainText->second));
  clipboard.setClipboardData(CF_HTML, clipboard.htmlToWindowsFragment(std::get<std::string>(htmlText->second)));
  return true;
}