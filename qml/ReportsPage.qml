import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0 as QQC2

import "components"

ListPage {
    id: reportPage
    title: qsTr("Create report")

    /* Shows the report-result,
      gets paramaterized by projectName and reportModel */
    Component {
        id: reportResult
        Page {
            id: page
            title: qsTr("Result")

            property string projectName
            property var reportModel

            Column{
                id: col
                anchors.fill: parent
                padding: dp(10)
                spacing: dp(10)

                Row{
                    spacing: dp(5)
                    AppTextFieldLabel{
                        id: projectNameTextLabel
                        text: qsTr("Project Name:")
                    }

                    AppText{
                        id: projectNameText
                        text: projectName
                        anchors.baseline: projectNameTextLabel.baseline
                    }
                }

                Column{
                    spacing: dp(7)
                    Repeater{
                        model: reportModel ? reportModel : 0
                        Row{
                            spacing: dp(5)
                            AppTextFieldLabel{
                                id: calendarWeekText
                                text: "KW"+ modelData.week + ":"
                            }

                            AppText{
                                id: weekTotalText
                                text: modelData.result + "h"
                                anchors.baseline: calendarWeekText.baseline
                            }
                        }
                    }
                }
            }
        }
    }

    Column{
        id: col
        anchors.fill: parent
        padding: dp(5)
        spacing: dp(5)

        QQC2.ComboBox{
            id: projectComboBox
            textRole: "name"
            model: database.projectModel
            width: col.width - 2 * col.spacing
        }

        /* button for starting the reporting */
        AppButton{
            text: qsTr("show report")
            onClicked: {
                var project = database.projectModel.get(projectComboBox.currentIndex)
                if(!project) {return;}

                navigationStack.push(reportResult,
                                     {
                                       projectName: database.projectModel.get(projectComboBox.currentIndex).name,
                                       reportModel: database.getReport(project.rowId)
                                     })
            }
        }
    }

}
