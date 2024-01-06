<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->

  <html>
  <head>
    <title>CPSC 304 Community Garden Database Project</title>
</head>

<body>
    <h1> CPSC 304 Community Garden Project Demo</h1> <!-- importance of header-->


    <h2>Results</h2>
    <?php
    handle();
    ?>
    <br />


    <h2>Reset</h2>
    <p>If you wish to reset the table press on the reset button. This will take you to the initial data of the table.</p>

    <form method="POST" action="gardendb.php">
        <!-- if you want another page to load after the button is clicked, you have to specify that page in the action parameter -->
        <input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
        <p><input type="submit" value="Reset" name="reset"></p>
    </form>

    <hr /> <!--break in the html page-->




    <h2>Insertion</h2>
    <p>Insert a new plot to garden (GID: GD0101-GD0105)</p>
    <form method="POST" action="gardendb.php"> <!--refresh page when submitted-->
        <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
        <div class = "side-by-side">

            Garden_ID (GID): <input type = "text" name = "insertgardenid"><br \><br \>
            Plot_Number:<input type = "text" name = "insertplotnumber"><br \><br \>
            Plot_size:<input type = "number" name = "insertplotsize"><br \><br \>
            Staus(yes/no):<input type = "text" name = "insertplotstatus"><br \><br \>

        </div>
        <input type="submit" value="insert" name="insertSubmit"></p>

    </form>
    <hr />



    <h2>Deletion</h2>
    <p> Remove plot from garden in database (add the format)</p>
    <form method="POST" action="gardendb.php"> <!--refresh page when submitted-->
        <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
        Plot_ID: <input type="text" name="deleteplotfromgarden"> <br /><br />
        <input type="submit" value="delete" name="deleteSubmit"></p>
    </form>
    <hr />



    <h2>Selection Query</h2>
    <p>Select plots (available and/or size) </p>
    <form method="GET" action="gardendb.php"> <!--refresh page when submitted-->
        <input type="hidden" id="selectionQueryRequest" name="selectionQueryRequest">
        Availability (yes/no): <input type="text" name="selectavailableplot"> <br /><br />
        Plot size: <input type="number" name="selectedplotsize"> <br /><br />
        <input type="submit" value = "fetch" name="selectionSubmit"></p>
    </form>
    <hr />


















    <h2>Update</h2>
    <p>Update information about a garden plot</p>
    <form method="POST" action="gardendb.php"> <!--refresh page when submitted-->
        <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">

        Garden ID to Update: <input type="text" name="gardenIDToUpdate" required>
        Plot Number to Update: <input type="text" name="plotNumberToUpdate" required>
        New Plot Size: <input type="number" name="newPlotSize" required>
        New Status: <input type="text" name="newStatus" required>

        <input type="submit" value="Update" name="updateSubmit">
    </form>
    <hr />




    



    <h2>Projection Query</h2>
    <p> Project data about all plots </p>
    <form method="POST" action="gardendb.php">
        <input type="hidden" id="projectionQueryRequest" name="projectionQueryRequest">
        
        <!-- Enter Garden ID: <input type="text" name="gardenIDToProject"> -->
        
        <input type="submit" value="Submit" name="projectionSubmit">
    </form>
    <hr />




    <h2>Join Applicant, Application, Position Tables</h2>
    <p>Select all applicants who will join a position in a given location.</p>
    <form method="GET" action="gardendb.php"> <!--refresh page when submitted-->
        <input type="hidden" id="joinQueryRequest" name="joinQueryRequest">
        Location: <input type="text" name="joinLocation"> <br /><br />
        <input type="submit" name="joinSubmit"></p>
    </form>
    <hr />




    <h2>Aggregation with Count</h2>
    <p>Find the number of gardeners for each garden</p>
    <form method="GET" action="gardendb.php"> <!--refresh page when submitted-->
        <input type="hidden" id="aggregationCountRequest" name="aggregationCountRequest">
        <input type="submit" name="aggregationCountSubmit"></p>
    </form>




    <h2>Nested Aggregation with Group By</h2>
    <p>Find the garden which has ......</p>
    <form method="GET" action="project.php"> <!--refresh page when submitted-->
        <input type="hidden" id="nestedAggregationRequest" name="nestedAggregationRequest">
        <input type="submit" name="nestedAggregationSubmit"></p>
    </form>




    <h2>Division</h2>
    <p>Find all the gardens who have gardener.</p>
    <form method="GET" action="project.php"> <!--refresh page when submitted-->
        <input type="hidden" id="divisionQueryRequest" name="divisionQueryRequest">
        <input type="submit" name="divisionSubmit"></p>
    </form>

    <?php


		//this tells the system that it's no longer just parsing html; it's now parsing PHP

        $success = True; //keep track of errors so it redirects the page only if there are no errors
        $db_conn = NULL; // edit the login credentials in connectToDB()
        $show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

        function debugAlertMessage($message) {
            global $show_debug_alert_messages;

            if ($show_debug_alert_messages) {
                echo "<script type='text/javascript'>alert('" . $message . "');</script>";
            }
        }

        function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
            //echo "<br>running ".$cmdstr."<br>";
            global $db_conn, $success;

            $statement = OCIParse($db_conn, $cmdstr);
            //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
                echo htmlentities($e['message']);
                $success = False;
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
                echo htmlentities($e['message']);
                $success = False;
            }

            return $statement;
        }






        function executeBoundSQL($cmdstr, $list) {
            /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		In this case you don't need to create the statement several times. Bound variables cause a statement to only be
		parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		See the sample code below for how this function is used */

     global $db_conn, $success;
     $statement = OCIParse($db_conn, $cmdstr);

     if (!$statement) {
        echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
        $e = OCI_Error($db_conn);
        echo htmlentities($e['message']);
        $success = False;
    }

    foreach ($list as $tuple) {
        foreach ($tuple as $bind => $val) {
                    //echo $val;
                    //echo "<br>".$bind."<br>";
            OCIBindByName($statement, $bind, $val);
                    unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
                }

                $r = OCIExecute($statement, OCI_DEFAULT);
                if (!$r) {
                    echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                    $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
                    echo htmlentities($e['message']);
                    echo "<br>";
                    $success = False;
                }
            }
        }









        function connectToDB() {
            global $db_conn;

            // Your username is ora_(CWL_ID) and the password is a(student number). For example,
			// ora_platypus is the username and a12345678 is the password.
            $db_conn = OCILogon("ora_esim01", "a11895182", "dbhost.students.cs.ubc.ca:1522/stu");

            if ($db_conn) {
                debugAlertMessage("Database is Connected");
                return true;
            } else {
                debugAlertMessage("Cannot connect to Database");
                $e = OCI_Error(); // For OCILogon errors pass no handle
                echo htmlentities($e['message']);
                return false;
            }
        }

        function disconnectFromDB() {
            global $db_conn;

            debugAlertMessage("Disconnect from Database");
            OCILogoff($db_conn);
        }

        // QUERY FUNCTIONS
        // 
        // 
        // 
        // 
        // 

        

        function printInsertRequestResult() {
            $result = executePlainSQL("
                SELECT * 
                FROM Plot
                ORDER BY GardenID asc, Status asc");
            // echo "<br><p style='font-size: 20px;'>Retrieved data from Plot table:</p><br>";
            echo "<table>";
            echo "
            <tr>

            <th> Garden_ID </th>
            <th> Plot_Number </th>
            <th> Plot_size </th>
            <th> Status </th>

            </tr>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
                "<td>" . $row[0] . "</td>" . 
                "<td>" . $row[1] . "</td>" . 
                "<td>" . $row[2] . "</td>" . 
                "<td>" . $row[3] . "</td>" . 
                "<td>" . $row[4] . "</td>" . 
                "<td>" . $row[5] . "</td>" . 
                "<td>" . $row[6] . "</td>" . 
                "<td>" . $row[7] . "</td>" . 
                "<td>" . $row[8] . "</td>" . 
                "<td>" . $row[9] . "</td>" . 
                "<tr>";
            }
            echo "</table>";
        }


        function handleInsertRequest() {
            global $db_conn;

            //Getting the values from user and insert data into the table
            $tuple = array (
                ":garden_id"   => $_POST['insertgardenid'],
                ":plot_number" => $_POST['insertplotnumber'],
                ":plot_size"   => $_POST['insertplotsize'],
                ":plot_status" => $_POST['insertplotstatus'],
            );


            $alltuples = array (
                $tuple
            );

            echo "<br><p style = 'font-size: 22px;'> Plot Garden data before insert:</p><br>";
            printInsertRequestResult();

            executeBoundSQL("
                INSERT INTO  Plot(
                    PlotNumber,
                    GardenID,
                    PlotSize,
                    Status
                    ) 
                VALUES (
                    :plot_number,
                    :garden_id,
                    :plot_size,
                    :plot_status)
                ", 
                $alltuples);

            echo "<br><p style = 'font-size: 22px;'> Plot Garden data after insert:</p></br>";
            printInsertRequestResult();

            OCICommit($db_conn);
        }



        function printDeleteRequestResult() {
            $result = executePlainSQL("SELECT * FROM plot");

            // echo "<br><p style = 'font-text: 22px;'> Retrieved data from Community Garden table:</p><br>";
            echo "<table>";
            echo "
            <tr>
            // <th> Garden_ID </th>
            // <th> Name </th>
            // <th> Address </th>
            // <th> Total _Plots </th>
            // <th> Occupied _Plots </th>
            // <th> Daily_Sun_Exposure </th>
            // <th> Monthly_Precipitation </th>
            <th> Garden_ID </th>
            <th> Plot_Number </th>
            <th> Plot_size </th>
            <th> Status </th>

            </tr>
            ";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
                "<td>" . $row[0] . "</td>" . 
                "<td>" . $row[1] . "</td>" . 
                "<td>" . $row[2] . "</td>" . 
                "<td>" . $row[3] . "</td>" . 
                // "<td>" . $row[4] . "</td>" . 
                // "<td>" . $row[5] . "</td>" . 
                // "<td>" . $row[6] . "</td>" . 
                "<tr>";
            }

            echo "</table>";
        }

        function handleDeleteRequest() {
            global $db_conn;

            $tuple = array (
                ":plot_number" => $_POST['deleteplotfromgarden'],
            );

            $alltuples = array (
                $tuple
            );

            echo "<br><p style = 'font-size: 22px;'> Garden Data before delete:</p></br>";
            printDeleteRequestResult();

            executeBoundSQL("
                DELETE 
                FROM plot p
                WHERE p.PlotNumber = :plot_number
                ", $alltuples);

            echo "<br><p style = 'font-size: 22px;'> Garden data after delete:</p></br>";
            printDeleteRequestResult();
            
            OCICommit($db_conn);
        }





        function handleSelectionRequest() {
            global $db_conn;

             $result = executePlainSQL("
                SELECT *
                FROM Plot
                WHERE Status = '" . $_GET['selectavailableplot'] . "'
                AND
                PlotSize >= '" . $_GET['selectedplotsize'] . "'
                ");



             echo "<br>The plot information for Garden and etrieved data from InformationSession table:<br>";
             echo "<table>";
             echo "
                 <tr>
                <th>Plot_Number ID</th>
                <th>Garden_ID</th>
                <th>Plot_Size</th>
                <th>Status</th>
                 </tr>
             ";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
                "<td>" . $row[0] . "</td>" . 
                "<td>" . $row[1] . "</td>" . 
                "<td>" . $row[2] . "</td>" . 
                "<td>" . $row[3] . "</td>" . 
                "<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
        }

        function printUpdateRequestResult() {
            $result = executePlainSQL("
                SELECT * 
                FROM Plot
                ORDER BY GardenID ASC, PlotNumber ASC");
            echo "<table>";
            echo "
                <tr>
                    <th>Garden_ID</th>
                    <th>Plot_Number</th>
                    <th>Plot_Size</th>
                    <th>Status</th>
                </tr>";
        
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
                    "<td>" . $row[0] . "</td>" . 
                    "<td>" . $row[1] . "</td>" . 
                    "<td>" . $row[2] . "</td>" . 
                    "<td>" . $row[3] . "</td>" . 
                "</tr>";
            }
            echo "</table>";
        }
        
        function handleUpdateRequest() {
            global $db_conn;
        
            // Get values from the form
            $tuple = array(
                ":garden_id" => $_POST['gardenIDToUpdate'],
                ":plot_number" => $_POST['plotNumberToUpdate'],
                ":newPlotSize" => $_POST['newPlotSize'],
                ":newStatus" => $_POST['newStatus'],
            );
        
            $alltuples = array (
                $tuple
            );

            echo "<br><p style='font-size: 22px;'>Plot Garden data before update:</p><br>";
            printUpdateRequestResult();

            // Update the Plot table
            executeBoundSQL("
                UPDATE Plot
                SET PlotSize = :newPlotSize,
                    Status = :newStatus
                WHERE GardenID = :garden_id
                AND PlotNumber = :plot_number",
                $alltuples
            );
        
                // Display the data after the update
        
                echo "<br><p style='font-size: 22px;'>Plot Garden data after update:</p></br>";
                printUpdateRequestResult();
        
                OCICommit($db_conn);
        } 



        function handleResetRequest() {
            global $db_conn;
            // Drop old table
            executePlainSQL("DROP TABLE demoTable");

            // Create new table
            echo "<br> creating new table <br>";
            executePlainSQL("CREATE TABLE demoTable (id int PRIMARY KEY, name char(30))");
            OCICommit($db_conn);
        }



        function handleProjectionRequest() {
            global $db_conn;

            echo "<br><p style='font-size: 22px;'>Projection of plot data:</p><br>";
            $result = executePlainSQL("
                SELECT * 
                FROM Plot"
            );
            echo "<table>";
            echo "
                <tr>
                    <th>Garden_ID</th>
                    <th>Plot_Number</th>
                    <th>Plot_Size</th>
                    <th>Status</th>
                </tr>";
        
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
                    "<td>" . $row[0] . "</td>" . 
                    "<td>" . $row[1] . "</td>" . 
                    "<td>" . $row[2] . "</td>" . 
                    "<td>" . $row[3] . "</td>" . 
                "</tr>";
            }
            echo "</table>";
        }

        // function handleProjectionRequest() {
        //     global $db_conn;

        //     $tuple = array(
        //         ":garden_id" => $_POST['gardenIDToProject'],
        //     );

        //     $alltuples = array (
        //         $tuple
        //     );

        //     echo "<br><p style='font-size: 22px;'>Projection of plot data:</p><br>";
        //     $result = executeBoundSQL("
        //         SELECT * 
        //         FROM Plot
        //         WHERE GardenID = :garden_id",
        //         $alltuples
        //     );
        //     echo "<table>";
        //     echo "
        //         <tr>
        //             <th>Garden_ID</th>
        //             <th>Plot_Number</th>
        //             <th>Plot_Size</th>
        //             <th>Status</th>
        //         </tr>";
        
        //     while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        //         echo "<tr>" . 
        //             "<td>" . $row[0] . "</td>" . 
        //             "<td>" . $row[1] . "</td>" . 
        //             "<td>" . $row[2] . "</td>" . 
        //             "<td>" . $row[3] . "</td>" . 
        //         "</tr>";
        //     }
        //     echo "</table>";
        // }





        function handleCountRequest() {
            global $db_conn;

            $result = executePlainSQL("SELECT Count(*) FROM demoTable");

            if (($row = oci_fetch_row($result)) != false) {
                echo "<br> The number of tuples in demoTable: " . $row[0] . "<br>";
            }
        }







        function write_to_console($data) {
            $console = $data;
            if (is_array($console))
                $console = implode(',', $console);
            
            echo "<script>console.log('Console: " . $console . "' );</script>";
        }





        // HANDLE ALL POST ROUTES
        // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handlePOSTRequest() {
            if (connectToDB()) {
                if (array_key_exists('deleteQueryRequest', $_POST)) {
                    handleDeleteRequest();
                } else if (array_key_exists('updateQueryRequest', $_POST)) {
                    handleUpdateRequest();
                } else if (array_key_exists('insertQueryRequest', $_POST)) {
                    handleInsertRequest();
                } else if (array_key_exists('projectionQueryRequest', $_POST)) {
                    handleProjectionRequest();    
                }

                disconnectFromDB();
            }
        }

        // HANDLE ALL GET ROUTES
        // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('selectionSubmit', $_GET)) {
                    handleSelectionRequest();
                } else if (array_key_exists('projectionSubmit', $_GET)) {
                    handleProjectionRequest();
                } else if (array_key_exists('joinSubmit', $_GET)) {
                    handleJoinRequest();
                } else if (array_key_exists('aggregationCountSubmit', $_GET)) {
                    handleAggregationCountRequest();
                } else if (array_key_exists('nestedAggregationSubmit', $_GET)) {
                    handleNestedAggregationRequest();
                } else if (array_key_exists('divisionSubmit', $_GET)) {
                    handleDivisionRequest();
                } 

                disconnectFromDB();
            }
        }

        function handle() {
            if (isset($_POST['deleteSubmit']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit']) || isset($_POST['projectionSubmit'])) {
                handlePOSTRequest();
            } else if (isset($_GET['selectionQueryRequest'])) {
                handleGETRequest();
            } else if (isset($_GET['projectionQueryRequest'])) {
                handleGETRequest();
            } else if (isset($_GET['joinQueryRequest'])) {
                handleGETRequest();
            } else if (isset($_GET['aggregationCountRequest'])) {
                handleGETRequest();
            } else if (isset($_GET['nestedAggregationRequest'])) {
                handleGETRequest();
            } else if (isset($_GET['divisionQueryRequest'])) {
                handleGETRequest();
            } 
        }
        ?>
    </body>
    </html>
