#include <flutter_linux/flutter_linux.h>

#include "include/vk_native_client/vk_native_client_plugin.h"

// This file exposes some plugin internals for unit testing. See
// https://github.com/flutter/flutter/issues/88724 for current limitations
// in the unit-testable API.

// Handles the getPlatformVersion method call.
FlMethodResponse *get_platform_version();

// Handles the getClipboardText method call.
FlMethodResponse *get_clipboard_text();

// Handles the setClipboardText method call.
FlMethodResponse *set_clipboard_text(FlMethodCall *method_call);

// Handles the canCopyFromClipboard method call.
FlMethodResponse *can_copy_from_clipboard();
