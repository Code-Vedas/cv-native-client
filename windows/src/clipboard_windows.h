#pragma once
#include <string>
#include <windows.h>
#include <flutter/standard_method_codec.h>

// class ClipboardWindows
class ClipboardWindows
{
public:
  static UINT CF_HTML;
  static std::map<flutter::EncodableValue, flutter::EncodableValue> getClipboardText();
  static bool canCopyFromClipboard();
  static bool setClipboardText(const flutter::MethodCall<flutter::EncodableValue> &method_call);
};
