import VPlayApps 1.0

App {
    id: app

    Database{
        id: database
    }

    Navigation {
        NavigationItem {
            title: qsTr("Trackings")
            icon: IconType.list
            NavigationStack{
                TrackingsPage{}
            }
        }

        NavigationItem {
            title: qsTr("Projects")
            icon: IconType.trello

            NavigationStack{
                ProjectsPage{}
            }
        }

        NavigationItem{
            title: qsTr("Reports")
            icon: IconType.file
            NavigationStack{
                ReportsPage{}
            }
        }
    }
}
