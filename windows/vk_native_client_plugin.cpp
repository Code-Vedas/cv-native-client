#include "vk_native_client_plugin.h"
// This must be included before many other Windows headers.
#include <windows.h>
#include <stdlib.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

#include "src/clipboard_windows.h"
#include "src/platform_windows.h"

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
      result->Success(flutter::EncodableValue(PlatformWindows::getPlatformVersion()));
    }
    else if (method_call.method_name().compare("getClipboardText") == 0)
    {
      result->Success(flutter::EncodableMap(ClipboardWindows::getClipboardText()));
    }
    else if (method_call.method_name().compare("setClipboardText") == 0)
    {
      // Set clipboard text
      result->Success(flutter::EncodableValue(ClipboardWindows::setClipboardText(method_call)));
    }
    else if (method_call.method_name().compare("canCopyFromClipboard") == 0)
    {
      // check if clipboard has text
      result->Success(flutter::EncodableValue(ClipboardWindows::canCopyFromClipboard()));
    }
    else
    {
      result->NotImplemented();
    }
  }
}