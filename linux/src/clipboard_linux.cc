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
#include "clipboard_linux.h"

char ClipboardLinux::kMimeTextPlain[] = "text/plain";
char ClipboardLinux::kMimeTextHtml[] = "text/html";

char ClipboardLinux::kPlainText[] = "plainText";
char ClipboardLinux::kHtmlText[] = "htmlText";
GdkAtom ClipboardLinux::kGdkAtomTextPlain = gdk_atom_intern_static_string("text/plain");
GdkAtom ClipboardLinux::kGdkAtomTextHtml = gdk_atom_intern_static_string(kMimeTextHtml);

guint ClipboardLinux::kUserInfoTextPlain = 1;
guint ClipboardLinux::kUserInfoTextHtml = 2;

/// @brief Get clipboard data
/// @return FlValue* - map with keys "plainText" and "htmlText"
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

/// @brief Get clipboard data mime types
/// @return FlValue* - list with mime types "plainText" and "htmlText"
/// - "plainText" - text/plain mime type (If clipboard contains plain text)
/// - "htmlText" - text/html mime type (If clipboard contains html text)
FlValue *ClipboardLinux::getClipboardDataMimeTypes()
{
    auto *clipboard = gtk_clipboard_get_default(gdk_display_get_default());
    auto *text = gtk_clipboard_wait_for_text(clipboard);
    FlValue *mimeArray = fl_value_new_list();
    if (text != nullptr)
    {
        fl_value_append_take(mimeArray, fl_value_new_string(kPlainText));
        g_free(text);
    }
    auto *html = gtk_clipboard_wait_for_contents(clipboard, gdk_atom_intern("text/html", FALSE));
    if (html != nullptr)
    {
        auto htmlType = gtk_selection_data_get_data_type(html);
        auto *htmlTypeName = gdk_atom_name(htmlType);
        if (strcmp(htmlTypeName, "text/html") == 0)
        {
            fl_value_append_take(mimeArray, fl_value_new_string(kHtmlText));
        }
    }
    return mimeArray;
}

/// @brief Set clipboard data
/// @param method_call - method call
/// @return bool - true if success
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
