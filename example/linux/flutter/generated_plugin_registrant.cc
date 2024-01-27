//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cv_native_client/cv_native_client_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) cv_native_client_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CvNativeClientPlugin");
  cv_native_client_plugin_register_with_registrar(cv_native_client_registrar);
}
