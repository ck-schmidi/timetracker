import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.7

ListPage {
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
                spacing: dp(5)
                topPadding: dp(15)
                padding: dp(5)

                AppText{
                    id: projectNameLabel
                    text: qsTr("Project Name:")
                    font.pixelSize: sp(10)
                    color: "grey"
                }

                AppTextField{
                    id: projectNameTextField
                    text:  project ? project.name : ""
                    onTextChanged: saveTimer.restart()
                }

                AppText{
                    id: projectDescriptionLabel
                    text: qsTr("Project Description:")
                    font.pixelSize: sp(10)
                    color: "grey"
                }

                AppTextField{
                    id: projectDescriptionTextField
                    text:  project ? project.description: ""
                    onTextChanged: saveTimer.restart()
                }

                AppButton{
                    id: deleteButton

                    text: qsTr("delete")
                    icon: IconType.remove
                    backgroundColor: "red"
                    backgroundColorPressed: "purple"

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
