import VPlay 2.0
import QtQuick 2.0

Item {
    id: database
    //holds the current database Connections
    property var db

    //qml-listmodel representing or datastructures
    property ListModel projectModel: ListModel{}
    property ListModel trackModel: ListModel{}

    function init(){
        //creates the connection to our LocalStorage-database
        db = LocalStorage.openDatabaseSync("TimeTrackingDB", "1.0", "Timetracking Database", 100000);

        /* we always execute the create table statements with the addon 'IF NOT EXISTS', so they just gets created
          on the first application startup */
        db.transaction( function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS PROJECT(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS TRACK(id INTEGER PRIMARY KEY AUTOINCREMENT, comment TEXT, projectid INTEGER, start DATETIME, end DATETIME)')
        });
    }

    //holds all the model-functionality for projectModel
    property var projectDao : QtObject{
        //populates projectModel from database
        function populate(){

        }

        //append new project to projectModel
        function append(project){

        }

        //remove project in projectModel by given index
        function remove(modelIndex){

        }

        //remove project in database by given index
        //(project is already in the model)
        function save(modelIndex){

        }
    }

    //holds all the model-functionality for trackModel
    property var trackDao: QtObject{
        //populates trackModel from database
        function populate(){

        }

        //append new track to trackModel
        function append(track){

        }

        //remove track in trackModel by given index
        function remove(modelIndex){

        }

        //remove track in database by given index
        //(track is already in the model)
        function save(modelIndex){

        }
    }

    Component.onCompleted: {
        database.init()
        database.projectDao.populate()
        database.trackDao.populate()
    }
}
