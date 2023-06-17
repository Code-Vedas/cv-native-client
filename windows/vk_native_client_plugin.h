#ifndef FLUTTER_PLUGIN_VK_NATIVE_CLIENT_PLUGIN_H_
#define FLUTTER_PLUGIN_VK_NATIVE_CLIENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace vk_native_client
{

    class VkNativeClientPlugin : public flutter::Plugin
    {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        VkNativeClientPlugin();

        virtual ~VkNativeClientPlugin();

        // Disallow copy and assign.
        VkNativeClientPlugin(const VkNativeClientPlugin &) = delete;
        VkNativeClientPlugin &operator=(const VkNativeClientPlugin &) = delete;

        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
        void GetVersion(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
        void GetHTMLClipboard(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
        void SetHTMLClipboard(
            const flutter::MethodCall<flutter::EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

} // namespace vk_native_client

#endif // FLUTTER_PLUGIN_VK_NATIVE_CLIENT_PLUGIN_H_
