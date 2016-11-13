import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.7

import "helpers.js" as Helpers

ListPage{
    id: trackingsPage
    title: qsTr("Trackings")

    Component{
        id: detailView
        Page{
            title: qsTr("Detail View")
        }
    }

    rightBarItem: IconButtonBarItem {
        icon: IconType.plus
        onClicked: {
            appListView.switchTo(database.trackDao.append({comment: ""}))
        }
    }

    AppListView{
        id: appListView
        model: database.trackModel

        delegate: SimpleRow {
            text: "Project: %1".arg(database.projectDao.getProjectByRowId(model.projectRowId))
            detailText: "%1 (%2)".arg(Helpers.formatDate(model.start)).arg(model.comment)
            onSelected: appListView.switchTo(index)
        }

        function switchTo(index) {
            navigationStack.push(detailView, { projectIndex: index })
        }
    }
}
