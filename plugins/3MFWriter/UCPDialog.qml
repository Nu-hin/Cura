// Copyright (c) 2024 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

import UM 1.5 as UM
import Cura 1.1 as Cura

UM.Dialog
{
    id: exportDialog
    title: catalog.i18nc("@title:window", "Export Universal Cura Project")

    margin: UM.Theme.getSize("default_margin").width
    minimumWidth: UM.Theme.getSize("modal_window_minimum").width
    minimumHeight: UM.Theme.getSize("modal_window_minimum").height

    backgroundColor: UM.Theme.getColor("detail_background")
    property bool dontShowAgain: false

    function storeDontShowAgain()
    {
        UM.Preferences.setValue("cura/dialog_on_ucp_project_save", !dontShowAgainCheckbox.checked)
        UM.Preferences.setValue("cura/asked_dialog_on_ucp_project_save", false)
    }

    onVisibleChanged:
    {
        if(visible && UM.Preferences.getValue("cura/asked_dialog_on_ucp_project_save"))
        {
            dontShowAgain = !UM.Preferences.getValue("cura/dialog_on_ucp_project_save")
        }
    }

    headerComponent: Rectangle
    {
        height: childrenRect.height + 2 * UM.Theme.getSize("default_margin").height
        color: UM.Theme.getColor("main_background")

        ColumnLayout
        {
            id: headerColumn

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: UM.Theme.getSize("default_margin").height
            anchors.leftMargin: UM.Theme.getSize("default_margin").width
            anchors.rightMargin: anchors.leftMargin

            UM.Label
            {
                id: titleLabel
                text: catalog.i18nc("@action:title", "Summary - Universal Cura Project")
                font: UM.Theme.getFont("large")
            }

            UM.Label
            {
                id: descriptionLabel
                text: catalog.i18nc("@action:description", "When exporting a Universal Cura Project, all the models present on the build plate will be included with their current position, orientation and scale. You can also select which per-extruder or per-model settings should be included to ensure a proper printing of the batch, even on different printers.")
                font: UM.Theme.getFont("default")
                wrapMode: Text.Wrap
                Layout.maximumWidth: headerColumn.width
            }
        }
    }

    Rectangle
    {
        anchors.fill: parent
        color: UM.Theme.getColor("main_background")

        UM.I18nCatalog { id: catalog; name: "cura" }

        ListView
        {
            id: settingsExportList
            anchors.fill: parent
            anchors.margins: UM.Theme.getSize("default_margin").width
            spacing: UM.Theme.getSize("thick_margin").height
            model: settingsExportModel.settingsGroups
            clip: true

            ScrollBar.vertical: UM.ScrollBar { id: verticalScrollBar }

            delegate: SettingsSelectionGroup { Layout.margins: 0 }
        }
    }
    leftButtons:
    [
        UM.CheckBox
        {
            id: dontShowAgainCheckbox
            text: catalog.i18nc("@action:label", "Don't show project summary on save again")
            checked: dontShowAgain
        }
    ]
    rightButtons:
    [
        Cura.TertiaryButton
        {
            text: catalog.i18nc("@action:button", "Cancel")
            onClicked: reject()
        },
        Cura.PrimaryButton
        {
            text: catalog.i18nc("@action:button", "Save project")
            onClicked: accept()
        }
    ]

    buttonSpacing: UM.Theme.getSize("wide_margin").width

    onClosing:
    {
        storeDontShowAgain()
        manager.notifyClosed()
    }
    onRejected: storeDontShowAgain()
    onAccepted: storeDontShowAgain()
}
