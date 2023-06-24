#include "clipboard_linux.h"

char ClipboardLinux::kMimeTextPlain[] = "text/plain";
char ClipboardLinux::kMimeTextHtml[] = "text/html";

char ClipboardLinux::kPlainText[] = "plainText";
char ClipboardLinux::kHtmlText[] = "htmlText";
GdkAtom ClipboardLinux::kGdkAtomTextPlain = gdk_atom_intern_static_string("text/plain");
GdkAtom ClipboardLinux::kGdkAtomTextHtml = gdk_atom_intern_static_string(kMimeTextHtml);

guint ClipboardLinux::kUserInfoTextPlain = 1;
guint ClipboardLinux::kUserInfoTextHtml = 2;

FlValue *ClipboardLinux::getClipboardData()
{
    auto *clipboard = gtk_clipboard_get_default(gdk_display_get_default());
    FlValue *map = fl_value_new_map();

    auto *text = gtk_clipboard_wait_for_text(clipboard);
    if (text != nullptr)
    {
        fl_value_set_string_take(map, "plainText", fl_value_new_string(text));
        g_free(text);
    }

    auto *html = gtk_clipboard_wait_for_contents(clipboard, gdk_atom_intern("text/html", FALSE));
    if (html != nullptr)
    {
        auto htmlType = gtk_selection_data_get_data_type(html);
        auto *htmlTypeName = gdk_atom_name(htmlType);
        if (strcmp(htmlTypeName, "text/html") == 0)
        {
            gint length;
            auto *htmlText = gtk_selection_data_get_data_with_length(html, &length);
            if (htmlText != nullptr)
            {
                fl_value_set_string_take(map, "htmlText", fl_value_new_string_sized((gchar *)htmlText, length));
            }
        }
        g_free(htmlTypeName);
        gtk_selection_data_free(html);
    }
    return map;
}

bool ClipboardLinux::canCopyFromClipboard()
{
    auto *clipboard = gtk_clipboard_get_default(gdk_display_get_default());
    auto *text = gtk_clipboard_wait_for_text(clipboard);
    bool canCopy = false;
    if (text != nullptr)
    {
        g_free(text);
    }
    else
    {
        canCopy = canCopy || false;
    }
    auto *html = gtk_clipboard_wait_for_contents(clipboard, gdk_atom_intern("text/html", FALSE));
    if (html != nullptr)
    {
        auto htmlType = gtk_selection_data_get_data_type(html);
        auto *htmlTypeName = gdk_atom_name(htmlType);
        if (strcmp(htmlTypeName, "text/html") == 0)
        {
            canCopy = canCopy || true;
        }
        else
        {
            canCopy = canCopy || false;
        }
    }
    else
    {
        canCopy = canCopy || false;
    }
    return canCopy;
}

bool ClipboardLinux::setClipboardData(FlMethodCall *method_call)
{
    auto *clipboard = gtk_clipboard_get_default(gdk_display_get_default());
    gtk_clipboard_set_text(clipboard, "", 0);
    gtk_clipboard_clear(clipboard);

    auto *args = fl_method_call_get_args(method_call);

    auto *targetList = gtk_target_list_new(nullptr, 0);
    // init array of string, use malloc to avoid memory leak
    auto *data = reinterpret_cast<gchar **>(malloc(2 * sizeof(gchar *)));

    auto *textPlainValue = fl_value_lookup_string(args, kPlainText);
    if (textPlainValue != nullptr && fl_value_get_type(textPlainValue) == FL_VALUE_TYPE_STRING)
    {
        auto *textPlainCString = fl_value_get_string(textPlainValue);
        data[0] = g_strdup(textPlainCString);
        gtk_target_list_add_text_targets(targetList, kUserInfoTextPlain);
    }
    auto *textHtmlValue = fl_value_lookup_string(args, kHtmlText);
    if (textHtmlValue != nullptr && fl_value_get_type(textHtmlValue) == FL_VALUE_TYPE_STRING)
    {
        auto *textHtmlCString = fl_value_get_string(textHtmlValue);
        data[1] = g_strdup(textHtmlCString);
        gtk_target_list_add(targetList, kGdkAtomTextHtml, 0, kUserInfoTextHtml);
    }

    if (data[0] != nullptr && data[1] != nullptr)
    {
        gint numTargets;
        auto *targetTable = gtk_target_table_new_from_list(targetList, &numTargets);
        gtk_clipboard_set_with_data(
            clipboard,
            targetTable,
            numTargets,
            [](GtkClipboard *clipboard, GtkSelectionData *selectionData, guint info, gpointer user_data_or_owner)
            {
                auto *data = reinterpret_cast<gchar **>(user_data_or_owner);
                if (info == kUserInfoTextPlain && data[0] != nullptr)
                {
                    auto *textPlainCString = data[0];
                    gtk_selection_data_set_text(selectionData, textPlainCString, strlen(textPlainCString));
                }
                else if (info == kUserInfoTextHtml && data[1] != nullptr)
                {
                    auto *textHtmlCString = data[1];
                    gtk_selection_data_set(selectionData, kGdkAtomTextHtml, 8, (guchar *)textHtmlCString, strlen(textHtmlCString));
                }
            },
            [](GtkClipboard *clipboard, gpointer user_data_or_owner)
            {
                auto *data = reinterpret_cast<gchar **>(user_data_or_owner);
                delete data;
            },
            data);
        gtk_clipboard_set_can_store(clipboard, targetTable, numTargets);
        gtk_clipboard_store(clipboard);

        gtk_target_table_free(targetTable, numTargets);
    }
    else
    {
        delete data;
        return false;
    }
    gtk_target_list_unref(targetList);

    return true;
}
