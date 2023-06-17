#include "vk_native_client_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

// Additional headers for clipboard access
#include <ShlObj.h>
#include <winuser.h>

namespace vk_native_client
{

  // CF_HTML format constant
  static const UINT CF_HTML = RegisterClipboardFormat(TEXT("HTML Format"));

  // ...

  void VkNativeClientPlugin::HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    if (method_call.method_name().compare("getPlatformVersion") == 0)
    {
      std::ostringstream version_stream;
      version_stream << "Windows ";
      if (IsWindows10OrGreater())
      {
        version_stream << "10+";
      }
      else if (IsWindows8OrGreater())
      {
        version_stream << "8";
      }
      else if (IsWindows7OrGreater())
      {
        version_stream << "7";
      }
      result->Success(flutter::EncodableValue(version_stream.str()));
    }
    else if (method_call.method_name().compare("getClipboardText") == 0)
    {
      // Get clipboard text
      bool hasClipboardText = false;
      if (IsClipboardFormatAvailable(CF_HTML))
      {
        hasClipboardText = true;
      }
      else if (IsClipboardFormatAvailable(CF_UNICODETEXT))
      {
        hasClipboardText = true;
      }
      if (hasClipboardText)
      {
        if (OpenClipboard(nullptr))
        {
          HANDLE clipboardData = GetClipboardData(CF_UNICODETEXT);
          if (clipboardData != nullptr)
          {
            LPWSTR data = static_cast<LPWSTR>(GlobalLock(clipboardData));
            if (data != nullptr)
            {
              result->Success(flutter::EncodableValue(data));
              GlobalUnlock(clipboardData);
            }
            else
            {
              result->Success(flutter::EncodableValue());
            }
          }
          else
          {
            result->Success(flutter::EncodableValue());
          }
          CloseClipboard();
        }
        else
        {
          result->Success(flutter::EncodableValue());
        }
      }
      else
      {
        result->Success(flutter::EncodableValue());
      }
    }
    else if (method_call.method_name().compare("setClipboardText") == 0)
    {
      // Set clipboard text
      if (method_call.arguments().Contains("text"))
      {
        const auto &text_value = method_call.arguments().at("text");
        if (text_value.IsString())
        {
          const std::string &text = text_value.AsString();
          if (OpenClipboard(nullptr))
          {
            EmptyClipboard();
            // Allocate global memory for the clipboard data
            HGLOBAL clipboardData = GlobalAlloc(
                GMEM_MOVEABLE,
                (text.length() + 1) * sizeof(WCHAR));
            if (clipboardData != nullptr)
            {
              LPWSTR clipboardText =
                  static_cast<LPWSTR>(GlobalLock(clipboardData));
              if (clipboardText != nullptr)
              {
                // Copy the text to the allocated memory
                wcscpy_s(clipboardText, text.length() + 1,
                         text.c_str());
                GlobalUnlock(clipboardData);
                // Set the clipboard data
                SetClipboardData(CF_UNICODETEXT,
                                 clipboardData);
                CloseClipboard();
                result->Success(flutter::EncodableValue(true));
                return;
              }
              GlobalFree(clipboardData);
            }
            CloseClipboard();
          }
        }
        result->Error("InvalidArgument", "Invalid or missing 'text' argument");
      }
    }
    else
    {
      result->NotImplemented();
    }
  }

} // namespace vk_native_client
