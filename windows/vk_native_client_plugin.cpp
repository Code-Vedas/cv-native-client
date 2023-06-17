#include "vk_native_client_plugin.h"
#include "clipboard.h"
// This must be included before many other Windows headers.
#include <windows.h>
#include <stdlib.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <sstream>
#include <variant>
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
      GetVersion(std::move(result));
    }
    else if (method_call.method_name().compare("getClipboardText") == 0)
    {
      GetHTMLClipboard(std::move(result));
    }
    else if (method_call.method_name().compare("setClipboardText") == 0)
    {
      // Set clipboard text
    }
    else
    {
      result->NotImplemented();
    }
  }

  void VkNativeClientPlugin::GetVersion(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
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

  void VkNativeClientPlugin::GetHTMLClipboard(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    Clipboard clipboard = Clipboard();
    std::string *html = clipboard.getClipboardData(clipboard.CF_HTML);
    if (html != nullptr)
    {
      result->Success(flutter::EncodableValue(*html));
      return;
    }

    std::string *text = clipboard.getClipboardData(CF_TEXT);
    if (text != nullptr)
    {
      result->Success(flutter::EncodableValue(*text));
      return;
    }

    std::string *unicode = clipboard.getClipboardData(CF_UNICODETEXT);
    if (unicode != nullptr)
    {
      result->Success(flutter::EncodableValue(*unicode));
      return;
    }

    result->Success(flutter::EncodableValue(nullptr));
  }

  void VkNativeClientPlugin::SetHTMLClipboard(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    // Set clipboard text
    Clipboard clipboard = Clipboard();
    // get clipboard data from method_call.arguments
    // argument is passed a String from flutter
    const auto *arguments = std::get_if<flutter::EncodableValue>(method_call.arguments());
    auto data = std::get_if<std::string>(arguments);
    if (data == nullptr)
    {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    clipboard.setClipboardData(clipboard.CF_HTML, *data);
    result->Success(flutter::EncodableValue(true));
  }
}