// MIT License
//
// Copyright (c) 2023 Code Vedas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
#include "cv_native_client_plugin.h"
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

namespace cv_native_client
{
  void CvNativeClientPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "cv_native_client",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<CvNativeClientPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result)
        {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  CvNativeClientPlugin::CvNativeClientPlugin() {}

  CvNativeClientPlugin::~CvNativeClientPlugin() {}

  void CvNativeClientPlugin::HandleMethodCall(
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