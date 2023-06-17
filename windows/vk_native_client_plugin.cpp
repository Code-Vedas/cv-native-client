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

namespace vk_native_client
{

  // static
  void VkNativeClientPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "vk_native_client",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<VkNativeClientPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result)
        {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  VkNativeClientPlugin::VkNativeClientPlugin() {}

  VkNativeClientPlugin::~VkNativeClientPlugin() {}

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
      // Retrieve text from the clipboard
      std::string clipboard_text;

      if (OpenClipboard(nullptr))
      {
        HANDLE clipboard_data = nullptr;

        // Check if HTML data is available
        clipboard_data = GetClipboardData(CF_HTML);
        if (clipboard_data != nullptr)
        {
          const char *html_text = static_cast<const char *>(GlobalLock(clipboard_data));
          if (html_text != nullptr)
          {
            clipboard_text = std::string(html_text);
            GlobalUnlock(clipboard_data);
          }
        }

        // If HTML data is not available, check for plain text data
        if (clipboard_text.empty())
        {
          clipboard_data = GetClipboardData(CF_TEXT);
          if (clipboard_data != nullptr)
          {
            const char *text = static_cast<const char *>(GlobalLock(clipboard_data));
            if (text != nullptr)
            {
              clipboard_text = std::string(text);
              GlobalUnlock(clipboard_data);
            }
          }
        }

        CloseClipboard();
      }

      if (!clipboard_text.empty())
      {
        result->Success(flutter::EncodableValue(clipboard_text));
      }
      else
      {
        result->Error("FAILED", "Failed to retrieve clipboard text");
      }
    }
    else if (method_call.method_name().compare("setClipboardText") == 0)
    {
      // Set text in the clipboard
      std::optional<flutter::EncodableValue> text_value = method_call.arguments();
      if (text_value && text_value->IsString())
      {
        std::string text = flutter::EncodableValue::ToString(text_value.value());
        if (OpenClipboard(nullptr))
        {
          HGLOBAL clipboard_data = GlobalAlloc(GMEM_MOVEABLE, text.size() + 1);
          if (clipboard_data != nullptr)
          {
            char *clipboard_text = static_cast<char *>(GlobalLock(clipboard_data));
            if (clipboard_text != nullptr)
            {
              strcpy_s(clipboard_text, text.size() + 1, text.c_str());
              GlobalUnlock(clipboard_data);
              if (SetClipboardData(CF_TEXT, clipboard_data) != nullptr)
              {
                CloseClipboard();
                result->Success();
                return;
              }
            }
            GlobalFree(clipboard_data);
          }
          CloseClipboard();
        }
      }
      result->Error("INVALID_ARGUMENT", "Invalid text argument");
    }
    else
    {
      result->NotImplemented();
    }
  }

} // namespace vk_native_client
