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
            //if database is not initialized -> return false
            if(!db){
                return false;
            }
            //otherwise we execute the sql-statement, iterate all results and add them to projectModel
            db.transaction(function(tx){
                var result = tx.executeSql('SELECT * FROM PROJECT')
                for(var i = 0; i < result.rows.length; i++){
                    var item = result.rows.item(i)
                    projectModel.append({"rowId": parseInt(item.id), "name": item.name, "description": item.description})
                }
            });
            return true;
        }

        //append new project to projectModel
        function append(project){
            /*if any of the properties name or description is not defined
              we change the to empty strings before inserting them to the
              database */
            project.name = project.name !== undefined ? project.name : ""
            project.description = project.description !== undefined ? project.description: ""
            db.transaction( function(tx) {
                var res = tx.executeSql('INSERT INTO PROJECT (name, description) VALUES(?, ?)', [project.name, project.description])
                //change rowId before inserting to model
                project.rowId = parseInt(res.insertId)
            })
            projectModel.append(project)
            return projectModel.count - 1
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
