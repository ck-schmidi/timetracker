import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Controls 1.4 as QQC1

import "components"

import "helpers.js" as Helpers

ListPage{
    id: trackingsPage
    title: qsTr("Trackings")

    /* This view shows a calendar and a datepicker
       It is intialized with a date and a callback-function.
       The callback function is called whenever a date or time
       has been changed
    */
    Component{
        id: dateTimePickerView

        Page{
            id: page
            title: qsTr("Pick Date and Time")

            property var date
            property var callback

            function returnDate(){
                var date = calendar.selectedDate
                date.setHours(timePicker.currentHours)
                date.setMinutes(timePicker.currentMinutes)
                callback(date)
            }

            Flickable{
                anchors.fill: parent
                contentHeight: col.height
                interactive: contentHeight > height

                Column{
                    id: col
                    padding: dp(15)
                    spacing: padding
                    anchors.left: parent.left
                    anchors.right: parent.right


                    QQC1.Calendar{
                        id: calendar
                        width: col.width / 4 * 3
                        height: width
                        anchors.horizontalCenter: parent.horizontalCenter
                        onSelectedDateChanged: page.returnDate()
                    }

                    TimePicker{
                        id: timePicker
                        anchors.horizontalCenter: parent.horizontalCenter
                        onAnyValueChanged: page.returnDate()
                    }
                }
            }

            Component.onCompleted: {
                var date = page.date
                if(date.getTime() === 0){
                    date = new Date(Date.now())
                }

                calendar.selectedDate = date
                timePicker.currentHours = date.getHours()
                timePicker.currentMinutes = date.getMinutes()
            }
        }

    }

    /* This view shows the detail-page for a certain
      entry:
      - project
      - start
      - endtime

      by click of any of the datetime the dateTimePickerView get shown
    */

    Component{
        id: detailView
        Page{
            id: page
            title: qsTr("Detail View")

            property int trackIndex
            property var track: database.trackModel.get(trackIndex)

            Column{
                id: col
                spacing: dp(5)
                topPadding: dp(15)
                padding: dp(5)
                anchors.fill: parent

                AppTextFieldLabel{
                    id: projectComboBoxLabel
                    text: qsTr("Project:")
                    width: col.width - 2 * col.spacing
                }

                QQC2.ComboBox{
                    id: projectComboBox
                    textRole: "name"
                    model: database.projectModel
                    width: col.width - 2 * col.spacing
                    currentIndex: -1

                    onCurrentIndexChanged: {
                        if(currentIndex < 0) {return;}
                        page.track.projectRowId = database.projectModel.get(currentIndex).rowId
                        database.trackDao.save(page.trackIndex)
                    }
                }

                AppTextFieldLabel{
                    id: startTextLabel
                    text: qsTr("Start Time")
                    width: col.width - 2 * col.spacing
                }

                AppTextField{
                    id: startText
                    width: col.width - 2 * col.spacing
                    MouseArea{
                        anchors.fill: parent
                        onClicked: appListView.switchToDateTimePickerView(track.start, function(date){
                            page.track.start = date
                            database.trackDao.save(page.trackIndex)
                            page.updateDateTimeTexts()
                        });
                    }
                }

                AppTextFieldLabel{
                    id: endTextLabel
                    text: qsTr("End Time")
                    width: col.width - 2 * col.spacing
                }

                AppTextField{
                    id: endText
                    width: col.width - 2 * col.spacing
                    MouseArea{
                        anchors.fill: parent
                        onClicked: appListView.switchToDateTimePickerView(track.end, function(date){
                            page.track.end = date
                            database.trackDao.save(page.trackIndex)
                            page.updateDateTimeTexts()
                        });
                    }
                }

                DeleteButton{
                    id: deleteButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        InputDialog.confirm(app,
                           qsTr("Really wanna delete this timetracking?"),
                           function (ok) {
                               if (!ok) { return; }
                               database.trackDao.remove(page.trackIndex)
                               navigationStack.pop()
                           })
                    }
                }

            }

            function updateDateTimeTexts(){
                if(!page.track){ return; }
                startText.text = page.track ? Helpers.formatDate(page.track.start) : ""
                endText.text = page.track ? Helpers.formatDate(page.track.end): ""
            }

            Component.onCompleted: {
                if(!page.track){ return; }
                updateDateTimeTexts()
                var index = database.projectDao.getIndexByRowId(page.track.projectRowId)
                projectComboBox.currentIndex = index
            }

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
            text: {
                var project = database.projectDao.getProjectByRowId(model.projectRowId)
                if(!project){ return "";}
                return "Project: %1".arg(project.name)
            }
            detailText: "%1 - %2".arg(Helpers.formatDate(model.start)).arg(Helpers.formatDate((model.end)))
            onSelected: appListView.switchTo(index)
        }

        function switchTo(index) {
            navigationStack.push(detailView, {trackIndex: index })
        }

        function switchToDateTimePickerView(date, callback){
            navigationStack.push(dateTimePickerView, {date: date, callback: callback})
        }

    }
}
