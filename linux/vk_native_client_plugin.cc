#include "include/vk_native_client/vk_native_client_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <memory>
#include <string>
#include <cstring>

using namespace std;

#include "vk_native_client_plugin_private.h"

#define VK_NATIVE_CLIENT_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), vk_native_client_plugin_get_type(), \
                              VkNativeClientPlugin))

struct _VkNativeClientPlugin
{
  GObject parent_instance;
};

G_DEFINE_TYPE(VkNativeClientPlugin, vk_native_client_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void vk_native_client_plugin_handle_method_call(
    VkNativeClientPlugin *self,
    FlMethodCall *method_call,
    FlMethodResponse **response)
{
  const gchar *method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0)
  {
    *response = get_platform_version();
  }
  else if (strcmp(method, "getClipboardText") == 0)
  {
    *response = get_clipboard_text();
  }
  else if (strcmp(method, "setClipboardText") == 0)
  {
    FlValue *args = fl_method_call_get_args(method_call);
    *response = set_clipboard_text(args);
    fl_value_unref(args);
  }
  else
  {
    *response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
}

// Get the platform version
FlMethodResponse *get_platform_version()
{
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.release);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

// Get the clipboard text
FlMethodResponse *get_clipboard_text()
{
  // Get clipboard text from GTK
  GdkClipboard *clipboard = gdk_clipboard_get_default(GDK_DISPLAY(gdk_display_get_default()));
  FlValue *result = nullptr;

  if (gdk_clipboard_wait_is_text_available(clipboard))
  {
    gchar *text = nullptr;
    gdk_clipboard_read_text(clipboard, &text);
    if (text != nullptr)
    {
      result = FL_VALUE(fl_value_new_string(text));
      g_free(text);
    }
  }

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

// Set the clipboard text
FlMethodResponse *set_clipboard_text(FlValue *args)
{
  FlValue *text = fl_value_lookup_string(args, "text");
  if (text == nullptr)
  {
    return FL_METHOD_RESPONSE(fl_method_error_response_new("error", "text is required", nullptr));
  }

  GdkClipboard *clipboard = gdk_clipboard_get_default(GDK_DISPLAY(gdk_display_get_default()));
  gdk_clipboard_set_text(clipboard, fl_value_get_string(text), -1);

  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

// Dispose the plugin object
static void vk_native_client_plugin_dispose(GObject *object)
{
  G_OBJECT_CLASS(vk_native_client_plugin_parent_class)->dispose(object);
}

// Initialize the plugin class
static void vk_native_client_plugin_class_init(VkNativeClientPluginClass *klass)
{
  G_OBJECT_CLASS(klass)->dispose = vk_native_client_plugin_dispose;
}

// Initialize the plugin instance
static void vk_native_client_plugin_init(VkNativeClientPlugin *self) {}

// Callback function for method calls from Flutter
static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data)
{
  VkNativeClientPlugin *plugin = VK_NATIVE_CLIENT_PLUGIN(user_data);
  FlMethodResponse *response = nullptr;
  vk_native_client_plugin_handle_method_call(plugin, method_call, &response);
  fl_method_call_respond(method_call, response, nullptr);
  fl_method_response_unref(response);
}

// Register the plugin with the registrar
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
