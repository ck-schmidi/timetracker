<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- timetracker.qdoc -->
  <title>Simple Timetracker Tutorial | Qt </title>
</head>
<body>
<li>Simple Timetracker Tutorial</li>
<div class="sidebar">
<div class="toc">
<h3><a name="toc">Contents</a></h3>
<ul>
<li class="level1"><a href="#goal">Goal</a></li>
<li class="level1"><a href="#let-s-get-started">Let's get started</a></li>
<li class="level1"><a href="#structure">Structure</a></li>
<li class="level1"><a href="#database">Database</a></li>
<li class="level1"><a href="#screen-projectspage">Screen ProjectsPage</a></li>
<li class="level1"><a href="#screen-trackingspage">Screen TrackingsPage</a></li>
</ul>
</div>
<div class="sidebar-content" id="sidebar-content"></div></div>
<h1 class="title">Simple Timetracker Tutorial</h1>
<span class="subtitle"></span>
<!-- $$$timetracker-description -->
<div class="descr"> <a name="details"></a>
<p>This tutorial will show you how to use V-Play-Apps and QtQuick for creating a simple timetracking application.</p>
<a name="goal"></a>
<h2 id="goal">Goal</h2>
<p>The goal of this tutorial is creating a data-based mobile app. We want to have the possibility to add and configure projects, where we can then add timetrackings. We want to persist this data in a local storage. For this purpose we will use <b>Qt Quick Local Storage</b>. <b>Qt Quick Local Storage</b> uses a local sqlite database for saving the data. The tutorial will also cover how navigation between different screens in V-Play-Apps works. We will also build some new controls, like a timepicker which is used for selecting a time.</p>
<a name="let-s-get-started"></a>
<h2 id="let-s-get-started">Let's get started</h2>
<p>For creating a new V-Play-App we go to <b>File -&gt; New File Or Project</b> and then select <b>Empty Application</b> in section <b>Project/V-Play Apps</b>. Select a appropriate project-name (I chose <b>timetracking</b>) and click <b>Next</b>. Choose the latest installed Qt-Version and click <b>Next</b>. In the next screen you have to enter the app display name and the app-identifier. I chose <b>Timetracker</b> and <b>at.codekitchen.timetracker</b>. Interface orientation can be let to <b>Auto</b>. Choose your prefered source code management tool in the next screen and click <b>Finish</b></p>
<a name="structure"></a>
<h2 id="structure">Structure</h2>
<p>We will provide the following top-level navigation-structure</p>
<ul>
<li>Projects</li>
<li>Tracking</li>
<li>Reports</li>
</ul>
<p>So we want to end up with something like this:</p>
<p class="centerAlign"><img src="images/navigation.png" alt="" /></p><p>Now, let's dive into some code. Open the file <code>qml/Main.qml</code></p>
<p>For top-level navigation we use the V-Play component <code>Navigation</code>. <code>Navigation</code> renders platform-specific, for example if you are on Android it renders a Drawer-based navigation. In iOS its a tab-based navigation.</p>
<p>So lets build up our top-level UI-Structure by removing whats currently inside <code>App</code> and add a <code>Navigation</code> component with 3x <code>NavigationItem</code> as its children for each Navigation Entry. <code>NavigationItem</code> can be parameterized with a title and an icon. For the icons we use the V-Play compontent IconType for getting nice FontAwesome icons.</p>
<pre class="cpp">import VPlayApps <span class="number">1.0</span>

App {
    Navigation {
        NavigationItem {
            title: qsTr(<span class="string">&quot;Trackings&quot;</span>)
            icon: IconType<span class="operator">.</span>list
        }

        NavigationItem {
            title: qsTr(<span class="string">&quot;Projects&quot;</span>)
            icon: IconType<span class="operator">.</span>trello
        }

        NavigationItem{
            title: qsTr(<span class="string">&quot;Reports&quot;</span>)
            icon: IconType<span class="operator">.</span>file
        }
    }
}</pre>
<p>If we <b>Build an Run</b> our project we should see the top-level-navigation of our application.</p>
<a name="database"></a>
<h2 id="database">Database</h2>
<p>Before we get into programming our different screens, we should talk about the datastructures we use in our program.</p>
<p>We have a simple data structure:</p>
<pre class="cpp">                                  <span class="operator">+</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">+</span>
<span class="operator">+</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">+</span>             <span class="operator">|</span> Track             <span class="operator">|</span>
<span class="operator">|</span> Project           <span class="operator">|</span>             <span class="operator">+</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">+</span>
<span class="operator">+</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">+</span>             <span class="operator">|</span><span class="preprocessor"># comment          |</span>
<span class="operator">|</span><span class="preprocessor"># name             |             |# from             |</span>
<span class="operator">|</span><span class="preprocessor"># description      &lt;-------------+# to               |</span>
<span class="operator">+</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">+</span>             <span class="operator">+</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">-</span><span class="operator">+</span></pre>
<p>We want to organize projects and we want to have timetrackings (track) which can be assigned to one of this projects. So lets create a new qml-file <code>qml/Database.qml</code> for encapsulating all our model/database logic.</p>
<p>In our <code>Database</code> component we need to create a database-connection to our <code>LocalStorage</code> (will be done in the <code>init</code> function). The result of the connection is saved in the local property db. We also hold two models: <code>projectModel</code> for managing projects and trackModel for managing our timetrackings.</p>
<p>For every model we also need some extra logic for handling the model &lt;-&gt; database logic</p>
<p>In this case we have to Daos (DataAccessObjects) which have following functions:</p>
<ul>
<li><code>populate</code>: <i>populates the model from database</i></li>
<li><code>append(item)</code>: <i>appends an new item to the model</i></li>
<li><code>remove(index)</code>: <i>(removes an item from the model by given index}</i></li>
<li><code>save(index)</code>: <i>(saves an item from the model by given index)</i></li>
</ul>
<p>For our <code>projectDao</code> we will implement also two helper functions for finding projects by their rowId</p>
<p>The base structure of this component should look like:</p>
<pre class="cpp">Item {
    id: database
    property var db

    property ListModel projectModel: ListModel{}
    property ListModel trackModel: ListModel{}

    function init(){}

    property var projectDao : <span class="type">QtObject</span>{
        function populate(){}
        function append(project){}
        function remove(modelIndex){}
        function save(modelIndex){}
        function getIndexByRowId(rowId){}
        function getProjectByRowId(rowId){}
    }

    property var trackDao: <span class="type">QtObject</span>{
        function populate(){}
        function append(track){}
        function remove(modelIndex){}
        function save(modelIndex){}
    }

    Component<span class="operator">.</span>onCompleted: {
        database<span class="operator">.</span>init()
        database<span class="operator">.</span>projectDao<span class="operator">.</span>populate()
        database<span class="operator">.</span>trackDao<span class="operator">.</span>populate()
    }
}</pre>
<p>Now we get into the individual functions. Let's start with the <code>init()</code>-function. In this function we need to do following things:</p>
<ul>
<li>set up database connection</li>
<li>create database-structure (only on first startup)</li>
</ul>
<p>For setting up our database connection we use the function <code>openDataBaseSync(â¦)</code> from the LocalStorage QML-component. After setting the connection up, we execute the create-statement for our database. You should use the 'IF NOT EXISTS'-clause on the create-statements, then the statement is only executed on the first startup of the application.</p>
<pre class="cpp">function init(){
    db <span class="operator">=</span> LocalStorage<span class="operator">.</span>openDatabaseSync(<span class="string">&quot;TimeTrackingDB&quot;</span><span class="operator">,</span> <span class="string">&quot;1.0&quot;</span><span class="operator">,</span> <span class="string">&quot;Timetracking Database&quot;</span><span class="operator">,</span> <span class="number">100000</span>);
    db<span class="operator">.</span>transaction( function(tx) {
        tx<span class="operator">.</span>executeSql(<span class="char">'CREATE TABLE IF NOT EXISTS PROJECT(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)'</span>)
        tx<span class="operator">.</span>executeSql(<span class="char">'CREATE TABLE IF NOT EXISTS TRACK(id INTEGER PRIMARY KEY AUTOINCREMENT, comment TEXT, projectid INTEGER, start DATETIME, end DATETIME)'</span>)
    });
}</pre>
<p>If we <b>Build and Run</b> our application after implementing the <code>init</code>-function and doesn't get any error, the connection succeeded and the database and its tables were created.</p>
<p>Now let's implement the playerDao and let's start with the <code>populate</code>-function:</p>
<ul>
<li>We first check, if we our db property has a value. if not -&gt; return false</li>
<li>If we have a valid database-connection we start a transaction</li>
<li>In this transaction we execute the statement 'SELECT * FROM PROJECT' which returns all entries in table PROJECT</li>
<li>In the next step we iterate the result-set of this statement and add the project to our projectModel</li>
</ul>
<p>As you can see, we also save us the <code>rowId</code> of the database-entry, so we can identify our project-item for updates and deletions. We use the javascript <code>parseInt</code> function for converting the id from the database to an int-value.</p>
<pre class="cpp">function populate(){
    <span class="keyword">if</span>(<span class="operator">!</span>db){ <span class="keyword">return</span> <span class="keyword">false</span>; }

    db<span class="operator">.</span>transaction(function(tx){
        var result <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'SELECT * FROM PROJECT'</span>)
        <span class="keyword">for</span>(var i <span class="operator">=</span> <span class="number">0</span>; i <span class="operator">&lt;</span> result<span class="operator">.</span>rows<span class="operator">.</span>length; i<span class="operator">+</span><span class="operator">+</span>){
            var item <span class="operator">=</span> result<span class="operator">.</span>rows<span class="operator">.</span>item(i)
            projectModel<span class="operator">.</span>append({<span class="string">&quot;rowId&quot;</span>: parseInt(item<span class="operator">.</span>id)<span class="operator">,</span> <span class="string">&quot;name&quot;</span>: item<span class="operator">.</span>name<span class="operator">,</span> <span class="string">&quot;description&quot;</span>: item<span class="operator">.</span>description})
        }
    });
    <span class="keyword">return</span> <span class="keyword">true</span>;
}</pre>
<p>In the next step we will take a look on the <code>append</code>-function:</p>
<ul>
<li>For continuity we reset our name and description properties to an empty string, if they are undefined</li>
<li>In the next step we execute an INSERT-statement with our project-properties name and description</li>
<li>After the execution of the statement we save the retured rowId from the database and add the item to our model</li>
</ul>
<pre class="cpp">function append(project){
    project<span class="operator">.</span>name <span class="operator">=</span> project<span class="operator">.</span>name <span class="operator">!</span><span class="operator">=</span><span class="operator">=</span> undefined <span class="operator">?</span> project<span class="operator">.</span>name : <span class="string">&quot;&quot;</span>
    project<span class="operator">.</span>description <span class="operator">=</span> project<span class="operator">.</span>description <span class="operator">!</span><span class="operator">=</span><span class="operator">=</span> undefined <span class="operator">?</span> project<span class="operator">.</span>description: <span class="string">&quot;&quot;</span>
    db<span class="operator">.</span>transaction( function(tx) {
        var res <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'INSERT INTO PROJECT (name, description) VALUES(?, ?)'</span><span class="operator">,</span> <span class="operator">[</span>project<span class="operator">.</span>name<span class="operator">,</span> project<span class="operator">.</span>description<span class="operator">]</span>)
        <span class="comment">//change rowId before inserting to model</span>
        project<span class="operator">.</span>rowId <span class="operator">=</span> parseInt(res<span class="operator">.</span>insertId)
    })
    projectModel<span class="operator">.</span>append(project)
    <span class="keyword">return</span> projectModel<span class="operator">.</span>count <span class="operator">-</span> <span class="number">1</span>
}</pre>
<p>Now lets implement the remove function:</p>
<ul>
<li>The remove-function takes the modelIndex as a parameter, so we take our project from the model with the given index</li>
<li>In the next step again open a database-transaction and execute the DELETE-statement</li>
<li>For checking the success of the delete-statement we check the rowsAffected property on our statement-result</li>
<li>If the deletion was successful, we remove the given project from our model and return true, otherwise we return false</li>
</ul>
<pre class="cpp">function remove(modelIndex){
    var project <span class="operator">=</span> projectModel<span class="operator">.</span>get(modelIndex)
    var success
    db<span class="operator">.</span>transaction( function(tx) {
        var res <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'DELETE FROM PROJECT WHERE id = ?'</span><span class="operator">,</span> <span class="operator">[</span>project<span class="operator">.</span>rowId<span class="operator">]</span>)
        success <span class="operator">=</span> res<span class="operator">.</span>rowsAffected <span class="operator">&gt;</span> <span class="number">0</span>
    })

    <span class="keyword">if</span>(<span class="operator">!</span>success) { <span class="keyword">return</span> <span class="keyword">false</span>; }
    projectModel<span class="operator">.</span>remove(modelIndex)
    <span class="keyword">return</span> <span class="keyword">true</span>
}</pre>
<p>In the next step of the <code>projectDao</code> implementation we implement the <code>save</code> function.</p>
<ul>
<li>similar to the remove-function we first get the project from the model with the given index</li>
<li>In the next step we open a new database-transaction and execute the UPDATE-statement</li>
<li>If res.rowsAffected &gt; 0, we return true, otherwise we return false</li>
</ul>
<pre class="cpp">function save(modelIndex){
    var project <span class="operator">=</span> projectModel<span class="operator">.</span>get(modelIndex)
    var success
    db<span class="operator">.</span>transaction(function(tx){
        var res <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'UPDATE PROJECT SET name = ?, description = ? WHERE id = ?'</span><span class="operator">,</span> <span class="operator">[</span>project<span class="operator">.</span>name<span class="operator">,</span> project<span class="operator">.</span>description<span class="operator">,</span> project<span class="operator">.</span>rowId<span class="operator">]</span>)
        success <span class="operator">=</span> res<span class="operator">.</span>rowsAffected <span class="operator">&gt;</span> <span class="number">0</span>
    });
    <span class="keyword">return</span> success
}</pre>
<p>In the next step of the <code>projectDao</code> we'll implement our two helper functions</p>
<ul>
<li>getIndexByRowId simply iterates all projects from the projectModel and return the index of the rowId matches</li>
<li>getProjectByRowId uses this function and just returns the project behind the found index</li>
</ul>
<pre class="cpp">function getIndexByRowId(rowId){
    <span class="keyword">for</span>(var i <span class="operator">=</span> <span class="number">0</span>; i <span class="operator">&lt;</span> projectModel<span class="operator">.</span>count; i<span class="operator">+</span><span class="operator">+</span>){
    var project <span class="operator">=</span> projectModel<span class="operator">.</span>get(i)
    <span class="keyword">if</span>(project<span class="operator">.</span>rowId <span class="operator">=</span><span class="operator">=</span><span class="operator">=</span> rowId)
        <span class="keyword">return</span> i
    }
    <span class="keyword">return</span> <span class="operator">-</span><span class="number">1</span>
}

function getProjectByRowId(rowId){
    var index <span class="operator">=</span> getIndexByRowId(rowId)
    <span class="keyword">if</span>(index <span class="operator">=</span><span class="operator">=</span><span class="operator">=</span> <span class="operator">-</span><span class="number">1</span>)
        <span class="keyword">return</span> undefined;
    <span class="keyword">return</span> projectModel<span class="operator">.</span>get(index)
}</pre>
<p>The DAO-Code for the trackDao is pretty similar to the projectModel. I'll outline the main differences, but I won't go into every function explicitly.</p>
<p>The main difference to the projectModel is, that we have to care about the relationship between the track and the project.</p>
<ul>
<li>{In the function populate() we also save the projectRowId as our foreign-key}</li>
<li>{Our append function sets the default values for start, end and project(selects the last created project)}</li>
</ul>
<pre class="cpp"><span class="comment">//holds all the model-functionality for trackModel</span>
property var trackDao: <span class="type">QtObject</span>{
    function populate(){
        <span class="keyword">if</span>(<span class="operator">!</span>db){ <span class="keyword">return</span> <span class="keyword">false</span>; }
        db<span class="operator">.</span>transaction(function(tx){
            var result <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'SELECT * FROM TRACK'</span>)
            <span class="keyword">for</span>(var i <span class="operator">=</span> <span class="number">0</span>; i <span class="operator">&lt;</span> result<span class="operator">.</span>rows<span class="operator">.</span>length; i<span class="operator">+</span><span class="operator">+</span>){
                var item <span class="operator">=</span> result<span class="operator">.</span>rows<span class="operator">.</span>item(i)
                trackModel<span class="operator">.</span>append({<span class="string">&quot;rowId&quot;</span>: parseInt(item<span class="operator">.</span>id)<span class="operator">,</span>
                                   <span class="string">&quot;comment&quot;</span>: item<span class="operator">.</span>comment<span class="operator">,</span>
                                   <span class="string">&quot;projectRowId&quot;</span>: item<span class="operator">.</span>projectid<span class="operator">,</span>
                                   <span class="string">&quot;start&quot;</span>: item<span class="operator">.</span>start<span class="operator">,</span>
                                   <span class="string">&quot;end&quot;</span>: item<span class="operator">.</span>end})
            }
        });
        <span class="keyword">return</span> <span class="keyword">true</span>;
    }

    function append(track){
        track<span class="operator">.</span>comment <span class="operator">=</span> track<span class="operator">.</span>comment <span class="operator">!</span><span class="operator">=</span><span class="operator">=</span> undefined <span class="operator">?</span> track<span class="operator">.</span>comment : <span class="string">&quot;&quot;</span>
        track<span class="operator">.</span>start <span class="operator">=</span> <span class="keyword">new</span> Date(Date<span class="operator">.</span>now())
        track<span class="operator">.</span>end <span class="operator">=</span> <span class="keyword">new</span> Date(Date<span class="operator">.</span>now())

        var lastProject <span class="operator">=</span> projectModel<span class="operator">.</span>get(projectModel<span class="operator">.</span>count <span class="operator">-</span> <span class="number">1</span>)
        <span class="keyword">if</span> (lastProject){
            track<span class="operator">.</span>projectRowId <span class="operator">=</span> lastProject<span class="operator">.</span>rowId
        }
        <span class="keyword">else</span>{
            track<span class="operator">.</span>projectRowId <span class="operator">=</span> <span class="operator">-</span><span class="number">1</span>
        }

        var res
        db<span class="operator">.</span>transaction( function(tx) {
            res <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'INSERT INTO TRACK(comment, projectid, start, end) VALUES(?, ?, ?, ?)'</span><span class="operator">,</span>
                                <span class="operator">[</span>track<span class="operator">.</span>comment<span class="operator">,</span> track<span class="operator">.</span>projectRowId<span class="operator">,</span> track<span class="operator">.</span>start<span class="operator">,</span> track<span class="operator">.</span>end<span class="operator">]</span>)
            track<span class="operator">.</span>rowId <span class="operator">=</span> parseInt(res<span class="operator">.</span>insertId)
        })
        trackModel<span class="operator">.</span>insert(<span class="number">0</span><span class="operator">,</span> track)
        <span class="keyword">return</span> <span class="number">0</span>
    }

    function remove(modelIndex){
        var track <span class="operator">=</span> trackModel<span class="operator">.</span>get(modelIndex)
        var success
        db<span class="operator">.</span>transaction( function(tx) {
            var res <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'DELETE FROM TRACK WHERE id = ?'</span><span class="operator">,</span> <span class="operator">[</span>track<span class="operator">.</span>rowId<span class="operator">]</span>)
            success <span class="operator">=</span> res<span class="operator">.</span>rowsAffected <span class="operator">&gt;</span> <span class="number">0</span>
        })
        <span class="keyword">if</span>(<span class="operator">!</span>success) { <span class="keyword">return</span> success; }
        trackModel<span class="operator">.</span>remove(modelIndex)
        <span class="keyword">return</span> success
    }

    function save(modelIndex){
        var track <span class="operator">=</span> trackModel<span class="operator">.</span>get(modelIndex)
        var success
        db<span class="operator">.</span>transaction(function(tx){
            var res <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'UPDATE TRACK SET comment = ?, start = ?, end = ?, projectid = ? WHERE id = ?'</span><span class="operator">,</span>
                                    <span class="operator">[</span>track<span class="operator">.</span>comment<span class="operator">,</span> track<span class="operator">.</span>start<span class="operator">,</span> track<span class="operator">.</span>end<span class="operator">,</span> track<span class="operator">.</span>projectRowId<span class="operator">]</span>)
            success <span class="operator">=</span> res<span class="operator">.</span>rowsAffected <span class="operator">&gt;</span> <span class="number">0</span>
        });
        <span class="keyword">return</span> success
    }
}</pre>
<a name="screen-projectspage"></a>
<h2 id="screen-projectspage">Screen ProjectsPage</h2>
<p>We want to have a screen, where we can Add, Modify and Delete projects. When we go to the screen it should look like:</p>
<p class="centerAlign"><img src="images/projects.png" alt="" /></p><p>Let's create an empty QML-Component <code>ProjectsPage.qml</code> for our visual implementation.</p>
<p>After creating the new qml-file lets use it in our <code>Main.qml</code> component within a <code>NavigationStack</code> (needed for our Detail-Page)</p>
<p class="centerAlign"><img src="images/projects_details.png" alt="" /></p><pre class="cpp"><span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>

NavigationItem {
    title: qsTr(<span class="string">&quot;Projects&quot;</span>)
    icon: IconType<span class="operator">.</span>trello

    NavigationStack{
        ProjectsPage{}
    }
}
<span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>Now lets dive into <code>ProjectsPage.qml</code></p>
<p>Our toplevel-component is a <code>ListPage</code> where we set the title to 'Projects'</p>
<pre class="cpp">ListPage {
    title: qsTr(<span class="string">&quot;Projects&quot;</span>)
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
}</pre>
<p>For adding new projects we add a &quot;+&quot; - Button to the rightBarItem</p>
<pre class="cpp">ListPage{
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    rightBarItem: IconButtonBarItem {
        icon: IconType<span class="operator">.</span>plus
    }
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>Now we need a <code>ListView</code> for showing our entries from the database.</p>
<p>Let's add a <code>AppListView</code>, which provides a nice device-independent <code>ListView</code></p>
<p><code>AppListView</code> takes our database.projectModel as a model and we use the <code>SimpleRow</code> delegate for displaying our data (text should be the (project)name, detailText the (project)description)</p>
<pre class="cpp">ListPage{
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    AppListView {
        id: appListView
        model: database<span class="operator">.</span>projectModel
        delegate: SimpleRow {
            text: name
            detailText: description
        }
    }
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>For using our database we need to instantiate it in global scope (<code>Main.qml</code>) In this step we also add the <code>id</code> app (we will need this later)</p>
<pre class="cpp">App {
    id: app

    Database{
        id: database
    }
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>After this step we are able to show project-entries from the model (database)</p>
<p>In the next step we want to provide functionality for adding new projects.</p>
<p>So, let's add a function which opens a Dialog with a TextField for entering the name of the new project.</p>
<p><code>InputDialog</code> is a V-Play Component which provides single and multiline InputDialogs. In this case we one need a singleline input so we use the function <code>inputTextSingleLine</code>. It takes the topel-level app, a title, a placeholder-text and a callback-function, where we can handle the users actions and inputs.</p>
<p>In the callback-function we check if &quot;Cancel&quot; was pressed (!ok) or the input-text is empty. If one of these conditions is true, we return and do nothing</p>
<p>Otherwise we call our <code>projectDao.append(..&#x2e;)</code> function.</p>
<pre class="cpp">function createNewProject(){
    InputDialog<span class="operator">.</span>inputTextSingleLine(app<span class="operator">,</span>
                                    qsTr(<span class="string">&quot;Create new Project&quot;</span>)<span class="operator">,</span>
                                    qsTr(<span class="string">&quot;Project Name&quot;</span>)<span class="operator">,</span>
                                    function (ok<span class="operator">,</span> text) {
                                        <span class="keyword">if</span> (<span class="operator">!</span>ok <span class="operator">|</span><span class="operator">|</span> text <span class="operator">=</span><span class="operator">=</span><span class="operator">=</span> <span class="string">&quot;&quot;</span>) {
                                            <span class="keyword">return</span>
                                        }
                                        database<span class="operator">.</span>projectDao<span class="operator">.</span>append({<span class="string">&quot;name&quot;</span>: text<span class="operator">,</span> <span class="string">&quot;description&quot;</span>: <span class="string">&quot;&quot;</span>)
                                    })
}</pre>
<p>Let's use this function on our rightBarItem in the onClicked event-handler:</p>
<pre class="cpp">rightBarItem: IconButtonBarItem {
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    onClicked: createNewProject()
}</pre>
<p>Now we are able to create new projects by clicking the &quot;+&quot;-Button and filling the LineEdit.</p>
<p>In the next step we implement a DetailScreen for our ListView.</p>
<p>For this purpose we create a new component inside our <code>ProjectsPage</code> The component holds a page with the title 'Detail View'</p>
<p>We add two properties <code>projectIndex</code> + <code>project</code>. <code>projectIndex</code> is used as parameter for the DetailView</p>
<pre class="cpp">ListPage {
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    Component {
    id: detailView
        Page {
            id: page
            title: qsTr(<span class="string">&quot;Detail View&quot;</span>)

            property <span class="type">int</span> projectIndex
            property var project: database<span class="operator">.</span>projectModel<span class="operator">.</span>get(projectIndex)
        }
    }
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>For using this component we have to extend our implementation of our <code>AppListView</code> We add a function <code>switchTo(index)</code> for pushing our detailView to our navigationStack and use it in our <code>SimpleRow</code>-delegate</p>
<pre class="cpp">AppListView {
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    delegate: SimpleRow {
        <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
        onSelected: appListView<span class="operator">.</span>switchTo(index)
    }
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    function switchTo(index) {
        navigationStack<span class="operator">.</span>push(detailView<span class="operator">,</span> { projectIndex: index })
    }
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>We can also change our <code>createNewProject</code> function to switch to the detail-screen after creating the new project</p>
<pre class="cpp">function createNewProject(){
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
                                        appListView<span class="operator">.</span>switchTo(database<span class="operator">.</span>projectDao<span class="operator">.</span>append({<span class="string">&quot;name&quot;</span>: text<span class="operator">,</span> <span class="string">&quot;description&quot;</span>: <span class="string">&quot;&quot;</span>}))
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
}</pre>
<p>Now lets extend our DetailView for editing the project:</p>
<p>In the first step we add a <code>Column</code> container for providing all our labels and textfields:</p>
<p>For our Labels we create a new component <code>AppTextFieldLabel.qml</code> in a new folder <code>components</code> for preventing code-replication:</p>
<pre class="cpp">AppText{
    font<span class="operator">.</span>pixelSize: sp(<span class="number">10</span>)
    color: <span class="string">&quot;grey&quot;</span>
}</pre>
<p>We use the VPlay-App components <code>AppText</code> and <code>AppTextField</code> for the labels and textfields:</p>
<pre class="cpp">Component {
    id: detailView
    Page {
        <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
        Column{
            spacing: dp(<span class="number">5</span>)
            topPadding: dp(<span class="number">15</span>)
            padding: dp(<span class="number">5</span>)

            AppTextFieldLabel{
                id: projectNameLabel
                text: qsTr(<span class="string">&quot;Project Name:&quot;</span>)
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
            }

            AppTextField{
                id: projectNameTextField
                text:  project <span class="operator">?</span> project<span class="operator">.</span>name : <span class="string">&quot;&quot;</span>
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
                onTextChanged: saveTimer<span class="operator">.</span>restart()
            }

            AppTextFieldLabel{
                id: projectDescriptionLabel
                text: qsTr(<span class="string">&quot;Project Description:&quot;</span>)
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
            }

            AppTextField{
                id: projectDescriptionTextField
                text:  project <span class="operator">?</span> project<span class="operator">.</span>description: <span class="string">&quot;&quot;</span>
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
                onTextChanged: saveTimer<span class="operator">.</span>restart()
            }
        }
        <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>After that change, our DetailView shows the correct informations from the database, but editing still doesn't work correctly</p>
<p>We have to add the Bindings for 2-way-property binding (see: <a href="http://imaginativethinking.ca/bi-directional-data-binding-qt-quick/">http://imaginativethinking.ca/bi-directional-data-binding-qt-quick/</a>) and we add a timer for saving our changes (not too often ;))</p>
<pre class="cpp">Binding{
    target: project
    property: <span class="string">&quot;name&quot;</span>
    value: projectNameTextField<span class="operator">.</span>text
}

Binding{
    target: project
    property: <span class="string">&quot;description&quot;</span>
    value: projectDescriptionTextField<span class="operator">.</span>text
}

Timer{
    id: saveTimer
    interval: <span class="number">500</span>
    running: <span class="keyword">false</span>
    repeat: <span class="keyword">false</span>
    onTriggered: database<span class="operator">.</span>projectDao<span class="operator">.</span>save(projectIndex)
}</pre>
<p>We need to call this functions when our texts in the textfields gets changed</p>
<pre class="cpp">AppTextField{
    id: projectNameTextField
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    onTextChanged: saveTimer<span class="operator">.</span>restart()
}

AppTextField{
    id: projectDescriptionTextField
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    onTextChanged: saveTimer<span class="operator">.</span>restart()
}</pre>
<p>Our last task for the Project-Detail-View is adding a delete button:</p>
<p>In this case we create a new component <code>DeleteButton.qml</code> which encapsulates our DeleteButton. We use the <code>AppButton</code> component from V-Play-Apps with a remove-icon and text &quot;delete&quot; and some appropriate colors.</p>
<pre class="cpp">AppButton{
    id: deleteButton
    text: qsTr(<span class="string">&quot;delete&quot;</span>)
    icon: IconType<span class="operator">.</span>remove
    backgroundColor: <span class="string">&quot;red&quot;</span>
    backgroundColorPressed: <span class="string">&quot;purple&quot;</span>
}</pre>
<p>Similar to the text creating we again use the <code>InputDialog</code> component for creating an Dialog. In this case we just want to confirm the deletion. If the user confirms the deletion, we use our model-functions to remove it</p>
<pre class="cpp">Column{
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    DeleteButton{
        id: deleteButton
        onClicked: {
            InputDialog<span class="operator">.</span>confirm(app<span class="operator">,</span>
               qsTr(<span class="string">&quot;Really wanna delete project %1?&quot;</span><span class="operator">.</span>arg(project<span class="operator">.</span>name))<span class="operator">,</span>
               function (ok) {
                   <span class="keyword">if</span> (<span class="operator">!</span>ok) { <span class="keyword">return</span>; }
                   database<span class="operator">.</span>projectDao<span class="operator">.</span>remove(page<span class="operator">.</span>projectIndex)
                   navigationStack<span class="operator">.</span>pop()
               })
        }
    }
}</pre>
<p>Now we are done with the ProjectView.</p>
<a name="screen-trackingspage"></a>
<h2 id="screen-trackingspage">Screen TrackingsPage</h2>
<p><code>TrackingsPage</code> is pretty similar to <code>ProjectsPage</code>. It contains a <code>ListView</code> with all trackings, an Add-Button and a DetailView.</p>
<p>It should look like:</p>
<p class="centerAlign"><img src="images/trackings.png" alt="" /></p><p>with a detail screen:</p>
<p class="centerAlign"><img src="images/trackings_detail.png" alt="" /></p><p>and a Date/Time-picker screen for changing date and time</p>
<p class="centerAlign"><img src="images/datetimepicker.png" alt="" /></p><p>Let's create a QML-component <code>TrackingsPage.qml</code></p>
<p>Again, I won't go too much into the details, because its very similar to the ProjectsPage. Instead of opening a Dialog when clicking the &quot;+&quot;-Button, we directly append a new track to the model and switch to the DetailView for editing.</p>
<pre class="cpp">ListPage{
    id: trackingsPage
    title: qsTr(<span class="string">&quot;Trackings&quot;</span>)

    Component{
        id: detailView
        Page{
            title: qsTr(<span class="string">&quot;Detail View&quot;</span>)
            property <span class="type">int</span> trackIndex
            property var track: database<span class="operator">.</span>trackModel<span class="operator">.</span>get(trackIndex)
        }
    }

    rightBarItem: IconButtonBarItem {
        icon: IconType<span class="operator">.</span>plus
        onClicked: {
            appListView<span class="operator">.</span>switchTo(database<span class="operator">.</span>trackDao<span class="operator">.</span>append({comment: <span class="string">&quot;&quot;</span>}))
        }
    }

    AppListView{
        id: appListView
        model: database<span class="operator">.</span>trackModel

        delegate: SimpleRow {
            text: <span class="string">&quot;Project: %1&quot;</span><span class="operator">.</span>arg(database<span class="operator">.</span>projectDao<span class="operator">.</span>getProjectByRowId(model<span class="operator">.</span>projectRowId))
            detailText: <span class="string">&quot;%1 (%2)&quot;</span><span class="operator">.</span>arg(Helpers<span class="operator">.</span>formatDate(model<span class="operator">.</span>start))<span class="operator">.</span>arg(model<span class="operator">.</span>comment)
            onSelected: appListView<span class="operator">.</span>switchTo(index)
        }

        function switchTo(index) {
            navigationStack<span class="operator">.</span>push(detailView<span class="operator">,</span> {trackingIndex: index })
        }
    }
}</pre>
<p>In our <code>SimpleRow</code> delegate we use a helper-function formatDate(..&#x2e;) which we put in a new file <code>helpers.js</code> This function does the formatting of your date.</p>
<pre class="cpp"><span class="operator">.</span>pragma library

function formatDate(dt)
{
    dt <span class="operator">=</span> <span class="keyword">new</span> Date(dt);

    var formattedDate <span class="operator">=</span> <span class="char">'%1.%2.%3 %4:%5'</span>
    <span class="operator">.</span>arg(padLeft(dt<span class="operator">.</span>getDate()<span class="operator">,</span> <span class="char">'0'</span><span class="operator">,</span> <span class="number">2</span>))
    <span class="operator">.</span>arg(padLeft(dt<span class="operator">.</span>getMonth() <span class="operator">+</span> <span class="number">1</span><span class="operator">,</span> <span class="char">'0'</span><span class="operator">,</span> <span class="number">2</span>))
    <span class="operator">.</span>arg(dt<span class="operator">.</span>getFullYear())
    <span class="operator">.</span>arg(padLeft(dt<span class="operator">.</span>getHours()<span class="operator">,</span> <span class="char">'0'</span><span class="operator">,</span> <span class="number">2</span>))
    <span class="operator">.</span>arg(padLeft(dt<span class="operator">.</span>getMinutes()<span class="operator">,</span> <span class="char">'0'</span><span class="operator">,</span> <span class="number">2</span>))

    <span class="keyword">return</span> formattedDate
}

function padLeft(str<span class="operator">,</span> ch<span class="operator">,</span> width)
{
    var s <span class="operator">=</span> String(str);

    <span class="keyword">while</span> (s<span class="operator">.</span>length <span class="operator">&lt;</span> width)
    s <span class="operator">=</span> ch <span class="operator">+</span> s;

    <span class="keyword">return</span> s;
}</pre>
<p>Now we can use the <code>TrackingsPage</code> in <code>Main.qml</code></p>
<pre class="cpp">Navigation {
    NavigationItem {
        <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
        NavigationStack{
            TrackingsPage{}
        }
    }</pre>
<p>In the next step we will create some components, which we will later on need for our TrackingsPage. We will start with the TimePicker.</p>
<p>Let's create a new file <code>TimePicker.qml</code> in the folder components.</p>
<p>The implementation of <code>TimePicker.qml</code> is pretty straight-forward</p>
<ul>
<li>As top-level component we choose Item</li>
<li>Lets add a property visibleItem for configuring how many items should be shown in the tumbler-list</li>
<li>Create a Text-Component for our Tumbler-delegate which cares about the styling of the single text-line</li>
<li>Add a row with 2 Tumblers (one for hours, one four minutes) + identify them by setting an id</li>
<li>Lets add the property aliases currentHours and currentMinutes to our Tumblers curent index</li>
<li>For simpler usage we provide a new signal anyValueChanged which is fired by onCurrentHoursChanged and onCurrentMinutesChanged</li>
</ul>
<pre class="cpp">import VPlay <span class="number">2.0</span>
import <span class="type">QtQuick</span> <span class="number">2.7</span>
import <span class="type">QtQuick</span><span class="operator">.</span>Controls <span class="number">2.0</span>

Item{
    height: dp(<span class="number">100</span>)
    width: row<span class="operator">.</span>width

    property <span class="type">int</span> visibleItems: <span class="number">3</span>
    property alias currentHours: hourTumbler<span class="operator">.</span>currentIndex
    property alias currentMinutes: minutesTumbler<span class="operator">.</span>currentIndex

    signal anyValueChanged

    onCurrentHoursChanged: anyValueChanged()
    onCurrentMinutesChanged: anyValueChanged()

    Component{
        id: tumblerDelegate
        Text{
            text: {
                <span class="keyword">if</span>(modelData <span class="operator">&lt;</span> <span class="number">10</span>)
                    <span class="keyword">return</span> <span class="string">&quot;0&quot;</span> <span class="operator">+</span> modelData
                <span class="keyword">return</span> modelData
            }
            horizontalAlignment: Text<span class="operator">.</span>AlignHCenter
            verticalAlignment: Text<span class="operator">.</span>AlignVCenter
            font<span class="operator">.</span>pixelSize: dp(<span class="number">20</span>)
            opacity: <span class="number">1.0</span> <span class="operator">-</span> Math<span class="operator">.</span>abs(Tumbler<span class="operator">.</span>displacement) <span class="operator">/</span> (visibleItems <span class="operator">/</span> <span class="number">2</span>)
        }
    }

    Row{
        id: row
        Tumbler {
            id: hourTumbler
            width: dp(<span class="number">50</span>)
            model: <span class="number">24</span>
            delegate: tumblerDelegate
        }
        Tumbler {
            id: minutesTumbler
            width: dp(<span class="number">50</span>)
            model: <span class="number">60</span>
            delegate: tumblerDelegate
        }
    }
}</pre>
<p>Another component we will probably need at some more points will be a <code>AppTextFieldLabel</code> which is used for labeling controls on the screens.</p>
<p>We just set <code>font.pixelSize</code> and <code>color</code> to some appropriate values.</p>
<pre class="cpp">import VPlayApps <span class="number">1.0</span>
import <span class="type">QtQuick</span> <span class="number">2.0</span>

AppText{
    font<span class="operator">.</span>pixelSize: sp(<span class="number">10</span>)
    color: <span class="string">&quot;grey&quot;</span>
}</pre>
<p>Now let' complete our <code>TrackingPage</code>. First of all, we will add a new Component inside our <code>ListPage</code></p>
<ul>
<li>We use a page with gets parameterized with 2 values: date and callback</li>
<li>date is the date/time we want to show and edit</li>
<li>callback is the function which is called which callback(date), when the date/time gets changed by the user</li>
<li>For this purpose we have the function returnDate which creates the date and calls the callback-function</li>
<li>We have a column with a QtQuick1 Calender and our own Component TimePicker inside a Flickable for a better overflow-behaviour</li>
<li>In the function Component.onCompleted we initilize our Component after dynamic loading</li>
</ul>
<pre class="cpp"><span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>

Component{
    id: dateTimePickerView

    Page{
        id: page
        title: qsTr(<span class="string">&quot;Pick Date and Time&quot;</span>)

        property var date
        property var callback

        function returnDate(){
            var date <span class="operator">=</span> calendar<span class="operator">.</span>selectedDate
            date<span class="operator">.</span>setHours(timePicker<span class="operator">.</span>currentHours)
            date<span class="operator">.</span>setMinutes(timePicker<span class="operator">.</span>currentMinutes)
            callback(date)
        }

        Flickable{
            anchors<span class="operator">.</span>fill: parent
            contentHeight: col<span class="operator">.</span>height
            interactive: contentHeight <span class="operator">&gt;</span> col<span class="operator">.</span>heightd

            Column{
                id: col
                padding: dp(<span class="number">15</span>)
                spacing: padding
                anchors<span class="operator">.</span>left: parent<span class="operator">.</span>left
                anchors<span class="operator">.</span>right: parent<span class="operator">.</span>right


                QQC1<span class="operator">.</span>Calendar{
                    id: calendar
                    width: col<span class="operator">.</span>width <span class="operator">/</span> <span class="number">4</span> <span class="operator">*</span> <span class="number">3</span>
                    height: width
                    anchors<span class="operator">.</span>horizontalCenter: parent<span class="operator">.</span>horizontalCenter
                    onSelectedDateChanged: page<span class="operator">.</span>returnDate()
                }

                TimePicker{
                    id: timePicker
                    anchors<span class="operator">.</span>horizontalCenter: parent<span class="operator">.</span>horizontalCenter
                    onAnyValueChanged: page<span class="operator">.</span>returnDate()
                }
            }
        }

        Component<span class="operator">.</span>onCompleted: {
            var date <span class="operator">=</span> page<span class="operator">.</span>date
            <span class="keyword">if</span>(date<span class="operator">.</span>getTime() <span class="operator">=</span><span class="operator">=</span><span class="operator">=</span> <span class="number">0</span>){
                date <span class="operator">=</span> <span class="keyword">new</span> Date(Date<span class="operator">.</span>now())
            }

            calendar<span class="operator">.</span>selectedDate <span class="operator">=</span> date
            timePicker<span class="operator">.</span>currentHours <span class="operator">=</span> date<span class="operator">.</span>getHours()
            timePicker<span class="operator">.</span>currentMinutes <span class="operator">=</span> date<span class="operator">.</span>getMinutes()
        }
    }
}
<span class="operator">.</span><span class="operator">.</span><span class="operator">.</span></pre>
<p>Now we have a working screen for choosing date and time, so lets change our DetailView and use the new component.</p>
<p>Now lets add some new code to our detailView:</p>
<ul>
<li>We also need a Column for aranging our Labels, Combobox,..&#x2e;</li>
<li>Lets add the TextLabels, ComboBox, TextFields, DeleteButton to our Column</li>
<li>Delete-Button-behaviour is pretty similar to the ProjectsPage</li>
<li>Similar to dateTimePickerView we also uses a more imperative logic in this case</li>
<li>We have a function updateDateTimeTexts() which updates our textfields with the set dates</li>
<li>In Component.onCompleted we initialize our screen (update start/end-text + update combobox-value)</li>
<li>For ComboBox we use the onCurrentIndexChanged eventHandler for updating our model after change</li>
<li>We put some MouseAreas over the AppTextFields to prevent changing the text directly, instead we switch to the DateTimePickerView</li>
</ul>
<pre class="cpp">Component{
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    Page{
        <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
        Column{
            id: col
            spacing: dp(<span class="number">5</span>)
            topPadding: dp(<span class="number">15</span>)
            padding: dp(<span class="number">5</span>)
            anchors<span class="operator">.</span>fill: parent

            AppTextFieldLabel{
                id: projectComboBoxLabel
                text: qsTr(<span class="string">&quot;Project:&quot;</span>)
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
            }

            QQC2<span class="operator">.</span>ComboBox{
                id: projectComboBox
                textRole: <span class="string">&quot;name&quot;</span>
                model: database<span class="operator">.</span>projectModel
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
                currentIndex: <span class="operator">-</span><span class="number">1</span>

                onCurrentIndexChanged: {
                    <span class="keyword">if</span>(currentIndex <span class="operator">&lt;</span> <span class="number">0</span>) {<span class="keyword">return</span>;}
                    page<span class="operator">.</span>track<span class="operator">.</span>projectRowId <span class="operator">=</span> database<span class="operator">.</span>projectModel<span class="operator">.</span>get(currentIndex)<span class="operator">.</span>rowId
                    database<span class="operator">.</span>trackDao<span class="operator">.</span>save(page<span class="operator">.</span>trackIndex)
                }
            }

            AppTextFieldLabel{
                id: startTextLabel
                text: qsTr(<span class="string">&quot;Start Time&quot;</span>)
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
            }

            AppTextField{
                id: startText
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
                MouseArea{
                    anchors<span class="operator">.</span>fill: parent
                    onClicked: appListView<span class="operator">.</span>switchToDateTimePickerView(track<span class="operator">.</span>start<span class="operator">,</span> function(date){
                        page<span class="operator">.</span>track<span class="operator">.</span>start <span class="operator">=</span> date
                        database<span class="operator">.</span>trackDao<span class="operator">.</span>save(page<span class="operator">.</span>trackIndex)
                        page<span class="operator">.</span>updateDateTimeTexts()
                    });
                }
            }

            AppTextFieldLabel{
                id: endTextLabel
                text: qsTr(<span class="string">&quot;End Time&quot;</span>)
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
            }

            AppTextField{
                id: endText
                width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
                MouseArea{
                    anchors<span class="operator">.</span>fill: parent
                    onClicked: appListView<span class="operator">.</span>switchToDateTimePickerView(track<span class="operator">.</span>end<span class="operator">,</span> function(date){
                        page<span class="operator">.</span>track<span class="operator">.</span>end <span class="operator">=</span> date
                        database<span class="operator">.</span>trackDao<span class="operator">.</span>save(page<span class="operator">.</span>trackIndex)
                        page<span class="operator">.</span>updateDateTimeTexts()
                    });
                }
            }

            DeleteButton{
                id: deleteButton
                anchors<span class="operator">.</span>horizontalCenter: parent<span class="operator">.</span>horizontalCenter
                onClicked: {
                    InputDialog<span class="operator">.</span>confirm(app<span class="operator">,</span>
                       qsTr(<span class="string">&quot;Really wanna delete this timetracking?&quot;</span>)<span class="operator">,</span>
                       function (ok) {
                           <span class="keyword">if</span> (<span class="operator">!</span>ok) { <span class="keyword">return</span>; }
                           database<span class="operator">.</span>trackDao<span class="operator">.</span>remove(page<span class="operator">.</span>trackIndex)
                           navigationStack<span class="operator">.</span>pop()
                       })
                }
            }

        }

        function updateDateTimeTexts(){
            <span class="keyword">if</span>(<span class="operator">!</span>page<span class="operator">.</span>track){ <span class="keyword">return</span>; }
            startText<span class="operator">.</span>text <span class="operator">=</span> page<span class="operator">.</span>track <span class="operator">?</span> Helpers<span class="operator">.</span>formatDate(page<span class="operator">.</span>track<span class="operator">.</span>start) : <span class="string">&quot;&quot;</span>
            endText<span class="operator">.</span>text <span class="operator">=</span> page<span class="operator">.</span>track <span class="operator">?</span> Helpers<span class="operator">.</span>formatDate(page<span class="operator">.</span>track<span class="operator">.</span>end): <span class="string">&quot;&quot;</span>
        }

        Component<span class="operator">.</span>onCompleted: {
            <span class="keyword">if</span>(<span class="operator">!</span>page<span class="operator">.</span>track){ <span class="keyword">return</span>; }
            updateDateTimeTexts()
            var index <span class="operator">=</span> database<span class="operator">.</span>projectDao<span class="operator">.</span>getIndexByRowId(page<span class="operator">.</span>track<span class="operator">.</span>projectRowId)
            projectComboBox<span class="operator">.</span>currentIndex <span class="operator">=</span> index
        }
    }
}</pre>
<p>For switching to our new component DateTimePickerView we need some more functionality in our ListPage. Similar to switchTo(..&#x2e;) we now provide a function <code>switchToDateTimePickerView</code> for switching to our DateTimePickerView. We also do some changes on our text Property of <code>SimpleRow</code> We just return the project.name, if we can find a related project</p>
<pre class="cpp">AppListView{
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    delegate: SimpleRow {
        text: {
            var project <span class="operator">=</span> database<span class="operator">.</span>projectDao<span class="operator">.</span>getProjectByRowId(model<span class="operator">.</span>projectRowId)
            <span class="keyword">if</span>(<span class="operator">!</span>project){ <span class="keyword">return</span> <span class="string">&quot;&quot;</span>;}
            <span class="keyword">return</span> <span class="string">&quot;Project: %1&quot;</span><span class="operator">.</span>arg(project<span class="operator">.</span>name)
        }
        <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    }

    function switchToDateTimePickerView(date<span class="operator">,</span> callback){
        navigationStack<span class="operator">.</span>push(dateTimePickerView<span class="operator">,</span> {date: date<span class="operator">,</span> callback: callback})
    }
}</pre>
<p>In the last part of our tutorial we'll build a simple Report-View which sums up our worked hours per week.</p>
<p>It should look like:</p>
<p class="centerAlign"><img src="images/report.png" alt="" /></p><p>where we can select a project, the result page should look like:</p>
<p class="centerAlign"><img src="images/report_detail.png" alt="" /></p><p>Let's create a new QML-File <code>ReportsPage.qml</code> and integrate it in <code>Main.qml</code> (the same way as <code>ProjectsPage.qml</code> and <code>TrackingsPage.qml</code>}</p>
<p>Let's add some content:</p>
<p>Again we use <code>ListPage</code> as our toplevel-component.</p>
<ul>
<li>Add new Component reportResult which contains a simple Page with two paramaters (string projectName, var reportModel</li>
<li>Add a Column for our Report-Form</li>
<li>Add a QtQuickControls2 ComboBox and an AppButton for selecting a project and start the reporting</li>
</ul>
<pre class="cpp">ListPage {
    id: reportPage
    title: qsTr(<span class="string">&quot;Create report&quot;</span>)

    Component {
        id: reportResult
        Page {
            id: page
            title: qsTr(<span class="string">&quot;Result&quot;</span>)

            property string projectName
            property var reportModel
        }
    }

    Column{
        id: col
        anchors<span class="operator">.</span>fill: parent
        padding: dp(<span class="number">5</span>)
        spacing: dp(<span class="number">5</span>)

        QQC2<span class="operator">.</span>ComboBox{
            id: projectComboBox
            textRole: <span class="string">&quot;name&quot;</span>
            model: database<span class="operator">.</span>projectModel
            width: col<span class="operator">.</span>width <span class="operator">-</span> <span class="number">2</span> <span class="operator">*</span> col<span class="operator">.</span>spacing
        }

        AppButton{
            text: qsTr(<span class="string">&quot;show report&quot;</span>)
        }
    }
}</pre>
<p>For our reporting we need some functionality for extracting our report.</p>
<p>Let's go to <code>Database.qml</code> and add a function <code>getReport(..&#x2e;)</code>. In our function we again open an new database-transaction and execute a sql-statement which takes the sum over the difference of end and start and groups ther results per week.</p>
<p>After executing the statement we iterate the result and bring the result in a form, that is nice to use for iterating in QML.</p>
<pre class="cpp">Item {
    id: database
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
    function getReport(projectRowId){
        var result
        db<span class="operator">.</span>transaction(function(tx){
            result <span class="operator">=</span> tx<span class="operator">.</span>executeSql(<span class="char">'SELECT strftime(&quot;%W&quot;, START) AS week, ROUND(SUM(((julianday(END) - julianday(START))*24)), 2) as result FROM TRACK WHERE projectid = ? GROUP BY WEEK'</span><span class="operator">,</span>
                   <span class="operator">[</span>projectRowId<span class="operator">]</span>)
        });
        var report <span class="operator">=</span> <span class="operator">[</span><span class="operator">]</span>
        <span class="keyword">for</span>(var i <span class="operator">=</span> <span class="number">0</span>; i <span class="operator">&lt;</span> result<span class="operator">.</span>rows<span class="operator">.</span>length; i<span class="operator">+</span><span class="operator">+</span>){
            var item <span class="operator">=</span> result<span class="operator">.</span>rows<span class="operator">.</span>item(i)
            report <span class="operator">=</span> report<span class="operator">.</span>concat(item)
        }
        <span class="keyword">return</span> report
    }
    <span class="operator">.</span><span class="operator">.</span><span class="operator">.</span>
}</pre>
<p>Now we have the functionality for creating report for a certain project. Lets integrate it to our views.</p>
<p>So lets modify our <code>Component</code> &quot;pageResult&quot;</p>
<ul>
<li>We start by adding a Column to our <code>Page</code></li>
<li>In this column we add a row with a Label and an AppText (text is set to our component-parameter projectName</li>
<li>For showing the results of our report we place another Column in our Column</li>
<li>In a repeater we iterate over our reportModel</li>
<li>Inside our Repeater we again add a Row for placing the label for the calendar-week and the computed result from our function we wrote before</li>
</ul>
<pre class="cpp">Component {
    id: reportResult
    Page {
        id: page
        title: qsTr(<span class="string">&quot;Result&quot;</span>)

        property string projectName
        property var reportModel

        Column{
            id: col
            anchors<span class="operator">.</span>fill: parent
            padding: dp(<span class="number">10</span>)
            spacing: dp(<span class="number">10</span>)

            Row{
                spacing: dp(<span class="number">5</span>)
                AppTextFieldLabel{
                    id: projectNameTextLabel
                    text: qsTr(<span class="string">&quot;Project Name:&quot;</span>)
                }

                AppText{
                    id: projectNameText
                    text: projectName
                    anchors<span class="operator">.</span>baseline: projectNameTextLabel<span class="operator">.</span>baseline
                }
            }

            Column{
                spacing: dp(<span class="number">7</span>)
                Repeater{
                    model: reportModel <span class="operator">?</span> reportModel : <span class="number">0</span>
                    Row{
                        spacing: dp(<span class="number">5</span>)
                        AppTextFieldLabel{
                            id: calendarWeekText
                            text: <span class="string">&quot;KW&quot;</span><span class="operator">+</span> modelData<span class="operator">.</span>week <span class="operator">+</span> <span class="string">&quot;:&quot;</span>
                        }

                        AppText{
                            id: weekTotalText
                            text: modelData<span class="operator">.</span>result <span class="operator">+</span> <span class="string">&quot;h&quot;</span>
                            anchors<span class="operator">.</span>baseline: calendarWeekText<span class="operator">.</span>baseline
                        }
                    }
                }
            }
        }
    }
}</pre>
</div>
<!-- @@@timetracker -->
</body>
</html>
