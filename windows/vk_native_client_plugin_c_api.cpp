#include "include/vk_native_client/vk_native_client_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "vk_native_client_plugin.h"

void VkNativeClientPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  vk_native_client::VkNativeClientPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
