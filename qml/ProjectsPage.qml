import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.7

import "components"

ListPage {
    id: projectsPage
    title: qsTr("Projects")

    /* The DetailView components hold the detail project-page
       It gets populated by clicking on a ListView-item or after
       creation of a new project by pressing "+"
       Normally this component is initalized by the projectIndex,
       which is an input for the local project property
      */
    Component {
        id: detailView
        Page {
            id: page
            title: qsTr("Detail View")

            property int projectIndex
            property var project: database.projectModel.get(projectIndex)

            Column{
                id: col
                spacing: dp(5)
                topPadding: dp(15)
                padding: dp(5)
                anchors.fill: parent

                AppTextFieldLabel{
                    id: projectNameLabel
                    text: qsTr("Project Name:")
                    width: col.width - 2 * col.spacing
                }

                AppTextField{
                    id: projectNameTextField
                    text:  project ? project.name : ""
                    width: col.width - 2 * col.spacing
                    onTextChanged: saveTimer.restart()
                }

                AppTextFieldLabel{
                    id: projectDescriptionLabel
                    text: qsTr("Project Description:")
                    width: col.width - 2 * col.spacing
                }

                AppTextField{
                    id: projectDescriptionTextField
                    text:  project ? project.description: ""
                    width: col.width - 2 * col.spacing
                    onTextChanged: saveTimer.restart()
                }

                DeleteButton{
                    id: deleteButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        InputDialog.confirm(app,
                           qsTr("Really wanna delete project %1?".arg(project.name)),
                           function (ok) {
                               if (!ok) { return; }
                               database.projectDao.remove(page.projectIndex)
                               navigationStack.pop()
                           })
                    }
                }
            }


            /* Needed for 2-way-property binding
              see: http://imaginativethinking.ca/bi-directional-data-binding-qt-quick/
              */
            Binding{
                target: project
                property: "name"
                value: projectNameTextField.text
            }

            Binding{
                target: project
                property: "description"
                value: projectDescriptionTextField.text
            }

            /* For preventing updating the datebase on every keystroke, we
              always wait for 500ms. If there is a new change in this time, the
              timer gets restart, so in the end, there should be very few writes
              to our local database */
            Timer{
                id: saveTimer
                interval: 500
                running: false
                repeat: false
                onTriggered: database.projectDao.save(projectIndex)
            }
        }
    }

    /*
       Opens a inputTextSingleLine and asks for the the name.
       Switches to detailView after creation.
      */
    function createNewProject(){
        InputDialog.inputTextSingleLine(app,
                                        qsTr("Create new Project"),
                                        qsTr("Project Name"),
                                        function (ok, text) {
                                            if (!ok || text === "") {
                                                return
                                            }
                                            appListView.switchTo(database.projectDao.append({"name": text, "description": ""}))
                                        })
    }

    /* "+"-Button for adding new project to the model
      */
    rightBarItem: IconButtonBarItem {
        icon: IconType.plus
        onClicked: createNewProject()
    }

    /* ListView for project-entries
       Clicking an entry -> DetailView
    */
    AppListView {
        id: appListView
        model: database.projectModel
        delegate: SimpleRow {
            text: name
            detailText: description
            onSelected: appListView.switchTo(index)
        }

        function switchTo(index) {
            navigationStack.push(detailView, { projectIndex: index })
        }
    }
}
