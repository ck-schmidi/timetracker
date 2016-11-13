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
