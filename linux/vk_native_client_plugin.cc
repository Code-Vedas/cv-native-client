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
#include "include/vk_native_client/vk_native_client_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include "src/clipboard_linux.h"

#include "vk_native_client_plugin_private.h"

#define VK_NATIVE_CLIENT_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), vk_native_client_plugin_get_type(), \
                              VkNativeClientPlugin))

using namespace std;

struct _VkNativeClientPlugin
{
  GObject parent_instance;
};

G_DEFINE_TYPE(VkNativeClientPlugin, vk_native_client_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void vk_native_client_plugin_handle_method_call(
    VkNativeClientPlugin *self,
    FlMethodCall *method_call)
{
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar *method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getClipboardData") == 0)
  {
    /// get clipboard data from gtk clipboard
    response = get_clipboard_data();
  }
  else if (strcmp(method, "getClipboardDataMimeTypes") == 0)
  {
    /// get clipboard data mime types from gtk clipboard
    response = get_clipboard_data_mime_types();
  }
  else if (strcmp(method, "setClipboardData") == 0)
  {
    /// set clipboard data to gtk clipboard
    response = set_clipboard_data(method_call);
  }
  else
  {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse *get_clipboard_data_mime_types()
{
  g_autoptr(FlValue) mimeArray = ClipboardLinux::getClipboardDataMimeTypes();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(mimeArray));
}

FlMethodResponse *set_clipboard_data(FlMethodCall *method_call)
{
  bool success = ClipboardLinux::setClipboardData(method_call);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(success)));
}

FlMethodResponse *get_clipboard_data()
{
  g_autoptr(FlValue) map = ClipboardLinux::getClipboardData();
  return FL_METHOD_RESPONSE(fl_method_success_response_new(map));
}

static void vk_native_client_plugin_dispose(GObject *object)
{
  G_OBJECT_CLASS(vk_native_client_plugin_parent_class)->dispose(object);
}

static void vk_native_client_plugin_class_init(VkNativeClientPluginClass *klass)
{
  G_OBJECT_CLASS(klass)->dispose = vk_native_client_plugin_dispose;
}

static void vk_native_client_plugin_init(VkNativeClientPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  VkNativeClientPlugin *plugin = VK_NATIVE_CLIENT_PLUGIN(user_data);
  vk_native_client_plugin_handle_method_call(plugin, method_call);
}

void vk_native_client_plugin_register_with_registrar(FlPluginRegistrar *registrar)
{
  VkNativeClientPlugin *plugin = VK_NATIVE_CLIENT_PLUGIN(
      g_object_new(vk_native_client_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "vk_native_client",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}