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

namespace vk_native_client
{
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
    if (method_call.method_name().compare("getClipboardData") == 0)
    {
      // Get clipboard text and html
      result->Success(flutter::EncodableMap(ClipboardWindows::getClipboardData()));
    }
    else if (method_call.method_name().compare("setClipboardData") == 0)
    {
      // Set clipboard text and html
      result->Success(flutter::EncodableValue(ClipboardWindows::setClipboardData(method_call)));
    }
    else if (method_call.method_name().compare("getClipboardDataMimeTypes") == 0)
    {
      // Get clipboard data mime types
      result->Success(flutter::EncodableValue(ClipboardWindows::getClipboardDataMimeTypes()));
    }
    else
    {
      result->NotImplemented();
    }
  }
}