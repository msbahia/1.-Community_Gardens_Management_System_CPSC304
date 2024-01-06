<!-- Test Oracle file for UBC CPSC304
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  Modified by Jason Hall (23-09-20)
  This file shows the very basics of how to execute PHP commands on Oracle.
  Specifically, it will drop a table, create a table, insert values update
  values, and then query for values
  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up All OCI commands are
  commands to the Oracle libraries. To get the file to work, you must place it
  somewhere where your Apache server can run it, and you must rename it to have
  a ".php" extension. You must also change the username and password on the
  oci_connect below to be your ORACLE username and password
-->

<?php
// The preceding tag tells the web server to parse the following text as PHP
// rather than HTML (the default)

// The following 3 lines allow PHP errors to be displayed along with the page
// content. Delete or comment out this block when it's no longer needed.
// ini_set('display_errors', 1);
// ini_set('display_startup_errors', 1);
// error_reporting(E_ALL);

// Set some parameters

// Database access configuration
$config["dbuser"] = "ora_msbahia";			// change "cwl" to your own CWL
$config["dbpassword"] = "a85436434";		// change to 'a' + your student number
$config["dbserver"] = "dbhost.students.cs.ubc.ca:1522/stu";
$db_conn = NULL;	// login credentials are used in connectToDB()

$success = true;	// keep track of errors so page redirects only if there are no errors

$show_debug_alert_messages = False; // show which methods are being triggered (see debugAlertMessage())

// The next tag tells the web server to stop parsing the text as PHP. Use the
// pair of tags wherever the content switches to PHP
?>

<html>

<head>
	<title>CPSC 304 Community Garden Database Project</title>
	<link rel="stylesheet" type="text/css" href="styles304.css">
</head>


<div class="tab">
  <button class="tablinks" onclick="openTab(event, 'overview')">Overview</button>
  <button class="tablinks" onclick="openTab(event, 'communityGardens')">Community Gardens</button>
  <button class="tablinks" onclick="openTab(event, 'organizations')">Organizations</button>
  <button class="tablinks" onclick="openTab(event, 'plots')">Plots</button>
  <button class="tablinks" onclick="openTab(event, 'projection')">Project Customized Data</button>
  <button class="tablinks" onclick="openTab(event, 'findAPlot')">Find a Plot</button>
  <button class="tablinks" onclick="openTab(event, 'findAPlant')">Find a Plant</button>
  <button class="tablinks" onclick="openTab(event, 'communityLeaders')">Community Leaders</button>
  <button class="tablinks" onclick="openTab(event, 'deliveryInfo')">Delivery Information</button>
</div>

<body>
<h1>The Community Garden Database Project</h1>
<h2> Developed for CPSC 304</h2>

	<div id="overview" class="tabcontent">

		<h2>Display Table Data</h2>
		<!-- <p>Enter one of the following categories to view the associated data:</p> -->
		<p>Select a table to view the associated data:</p>
		<form method="GET" action="garden.php">
		<input type="hidden" id="displayTuplesRequest" name="displayTuplesRequest">
		<select name="tableName">
			<?php
				dropDownAllTables();
			?>
		</select>
		<p><input type="submit" name="displayTuples"></p>
		</form>

		<hr />
		<h2>Reset All Community Garden Data</h2>
		<p>Clear all the changes you have made to the database.</p>
		<p>WARNING! Pressing this button will permanently delete any changes you have made.</p>

		<form method="POST" action="garden.php">
			<!-- "action" specifies the file or page that will receive the form data for processing. As with this example, it can be this same file. -->
			<input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
			<p><input type="submit" value="Reset" name="reset"></p>
		</form>
	</div>

	<div id="communityGardens" class="tabcontent">
		<h2>Create a New Community Garden</h2>
		<p>Please provide the following details to create your <b>Community Garden</b></p>
		<form method="POST" action="garden.php"> <!--refresh page when submitted-->
			<input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
			Garden ID: <input type = "number" name = "insertGardenId"><br /><br />
			Name: <input type = "text" name = "insertName"><br /><br />
			Address: <input type = "test" name = "insertAddress"><br /><br />
			Total Plots: <input type = "number" name = "insertTotalPlots"><br /><br />
			Available Plots: <input type = "number" name = "insertAvailablePlots"><br /><br />
			Daily Sun Exposure (hr): <input type = "number" name = "insertDailySun"><br /><br />
			Monthly Precipitation (mm): <input type = "number" name = "insertMonthlyPrecip"><br /><br />
			Organization ID: <input type = "number" name = "insertOrganizationId"><br /><br />
			<input type="submit" value="Insert" name="insertSubmit"></p>
		</form>

		<hr />

		<h2>Delete a Garden</h2>
		<p>Provide the garden ID to permanently delete a <b>Community Garden</b></p>
		<form method="POST" action="garden.php"> <!--refresh page when submitted-->
			<input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
			Garden ID: <input type = "number" name = "deleteGardenId"><br \><br \>
			<input type="submit" value="Delete" name="deleteSubmit"></p>
		</form>
	</div>

	<div id="organizations" class="tabcontent">
		<h2>Update Organization</h2>
		<p>Enter the following information to update an <b>Organization</b></p>

		<form method="POST" action="garden.php">
			<input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
			Organization ID: <input type="number" name="updateId"> 
			<br /><br />
			<label for="updateNameCb">Name:</label>
			<input type="checkbox" id="updateNameCb" name="updateNameCb">
			<input type="text" name="updateName"> 
			<br /><br />
			<label for="updateAddressCb">Address:</label>
			<input type="checkbox" id="updateAddressCb" name="updateAddressCb">
			<input type="text" name="updateAddress"> 
			<br /><br />
			<label for="updateBudgetCb">Budget:</label>
			<input type="checkbox" id="updateBudgetCb" name="updateBudgetCb">
			<input type="number" name="updateBudget"> 
			<br /><br />
			<label for="updatePhoneCb">Phone Number:</label>
			<input type="checkbox" id="updatePhoneCb" name="updatePhoneCb">			
			<input type="text" name="updatePhone"> 
			<br /><br />
			<input type="submit" value="Update" name="updateSubmit"></p>
		</form>
	</div>

	<div id="plots" class="tabcontent">
		<h2>Filter and View Plots </h2>
		<p>Find and view information about plots. Use check boxes to select desired attributes and enter filter criteria.</p>


		<form method="POST" action="garden.php">
			<input type="hidden" id="selectionQueryRequest" name="selectionQueryRequest">
			
			<label for="selectGardenIdCb">Garden ID:</label>
			<input type="checkbox" id="selectGardenIdCb" name="selectGardenIdCb">
			<label for="selectGardenIdOp">Operator:</label>
			<select id="selectGardenIdOp" name="selectGardenIdOp">
				<option value="=">Equal To</option>
				<option value="!=">Not Equal To</option>
				<option value=">">Greater Than</option>
				<option value=">=">Greater Than or Equal To</option>
				<option value="<">Less Than</option>
				<option value="<=">Less Than or Equal To</option>
			</select>
			<label for="selectGardenIdVal">Value:</label>
			<input type="number" name="selectGardenIdVal">
			<label for="selectGardenIdOption">AND/OR:</label>
			<select id="selectGardenIdOption" name="selectGardenIdOption">
				<option value=""></option>
				<option value="AND">AND</option>
				<option value="OR">OR</option>
			</select>
			<br /><br />

			<label for="selectPlotNumberCb">Plot Number:</label>
			<input type="checkbox" id="selectPlotNumberCb" name="selectPlotNumberCb">
			<label for="selectPlotNumberOp">Operator:</label>
			<select id="selectPlotNumberOp" name="selectPlotNumberOp">
				<option value="=">Equal To</option>
				<option value="!=">Not Equal To</option>
				<option value=">">Greater Than</option>
				<option value=">=">Greater Than or Equal To</option>
				<option value="<">Less Than</option>
				<option value="<=">Less Than or Equal To</option>
			</select>
			<label for="selectPlotNumberVal">Value:</label>
			<input type="number" name="selectPlotNumberVal">
			<label for="selectPlotNumberOption">AND/OR:</label>
			<select id="selectPlotNumberOption" name="selectPlotNumberOption">
				<option value=""></option>
				<option value="AND">AND</option>
				<option value="OR">OR</option>
			</select>
			<br /><br />

			<label for="selectPlotSizeCb">Plot Size:</label>
			<input type="checkbox" id="selectPlotSizeCb" name="selectPlotSizeCb">
			<label for="selectPlotSizeOp">Operator:</label>
			<select id="selectPlotSizeOp" name="selectPlotSizeOp">
				<option value="=">Equal To</option>
				<option value="!=">Not Equal To</option>
				<option value=">">Greater Than</option>
				<option value=">=">Greater Than or Equal To</option>
				<option value="<">Less Than</option>
				<option value="<=">Less Than or Equal To</option>
			</select>
			<label for="selectPlotSizeVal">Value:</label>
			<input type="number" name="selectPlotSizeVal">
			<label for="selectPlotSizeOption">AND/OR:</label>
			<select id="selectPlotSizeOption" name="selectPlotSizeOption">
				<option value=""></option>
				<option value="AND">AND</option>
				<option value="OR">OR</option>
			</select>
			<br /><br />

			<label for="selectPlotStatusCb">Status:</label>
			<input type="checkbox" id="selectPlotStatusCb" name="selectPlotStatusCb">
			<select id="selectPlotStatusOp" name="selectPlotStatusOp">
				<option value="=">Equal To</option>
				<option value="!=">Not Equal To</option>
			</select>
			<select id="selectPlotStatusVal" name="selectPlotStatusVal">
				<option value="available">Available</option>
				<option value="occupied">Occupied</option>
				<option value="under development">Under Development</option>
				<option value="closed for renovation">Closed for Renovation</option>
				<option value="">NULL</option>
			</select>
			<br /><br />
			
			<input type="submit" value="Select" name="selectionSubmit"></p>
		</form>
	</div>


	<div id="projection" class="tabcontent">
		<h2>Select and View Custom Data</h2>
		<form method="POST" action="garden.php"> <!--refresh page when submitted-->
			<input type="hidden" id="projectionQueryRequest" name="projectionQueryRequest">
			<label for="tableSelection">Select table:</label>
			<select id="tableSelection" name="projectionTableName">
				<?php
					dropDownAllTablesAndAttributes();
				?>
			</select>

			<br /><br />
			<p> From the options listed in the dropdown menu, please list the attributes you would like to view: </p>
			<label for="projectionAtt1">Attribute 1:</label>
			<input type="text" name="projectionAtt1">
			<label for="projectionAtt2">Attribute 2:</label>
			<input type="text" name="projectionAtt2">
			<label for="projectionAtt3">Attribute 3:</label>
			<input type="text" name="projectionAtt3">
			<label for="projectionAtt4">Attribute 4:</label>
			<input type="text" name="projectionAtt4">
			<br /><br />
			<label for="projectionAtt5">Attribute 5:</label>
			<input type="text" name="projectionAtt5">
			<label for="projectionAtt6">Attribute 6:</label>
			<input type="text" name="projectionAtt6">
			<label for="projectionAtt7">Attribute 7:</label>
			<input type="text" name="projectionAtt7">
			<label for="projectionAtt8">Attribute 8:</label>
			<input type="text" name="projectionAtt8">
			<br /><br />
			<input type="submit" value="Project" name="projectionSubmit"></p>
		</form>
  	</div>

	<div id="findAPlant" class="tabcontent">
		<h2>Find a Plant</h2>
		<p>Find the names, addresses and plot numbers of community gardens that contain a specified plant species.</p>
		<form method="POST" action="garden.php"> <!--refresh page when submitted-->
			<input type="hidden" id="joinQueryRequest" name="joinQueryRequest">
			Plant Species: <input type="text" name="joinPlantSpecies"> <br />
			<input type="submit" value="Join" name="joinSubmit"></p>
		</form>
  	</div>

	<div id="findAPlot" class="tabcontent">
		<h2>Find Available Plots</h2>
		<p>Find the names and addresses of community gardens with at least two available large plots (plot size > 10).</p>
			<form method = "POST" action garden.php>
			<input type = "hidden" id = "aggregateByHavingQueryRequest" name = "aggregateByHavingQueryRequest">
			<input type = "submit" value="Aggregate with Having" name="aggregateByHavingSubmit"></p>
		</form>

		<h2>Summarize Plot Status</h2>
		<p>Find the total plot space by status across all commuity gardens.</p>
		<form method="POST" action="garden.php"> <!--refresh page when submitted-->
			<input type="hidden" id="aggregationGroupByQueryRequest" name="aggregationGroupByQueryRequest">
			<input type="submit" value="Aggregate with Group By" name="aggregationGroupBySubmit"></p>
		</form>

	</div>

	<div id="communityLeaders" class="tabcontent">
		<h2>Display Contact Information of Community Leaders</h2>
		<p>Find the names, addresses and phone numbers of gardeners that have attended all events.</p>
			<form method="POST" action="garden.php"> <!--refresh page when submitted-->
			<input type="hidden" id="divisionQueryRequest" name="divisionQueryRequest">
			<input type="submit" value="Divide" name="divisionSubmit"></p>
		</form>
	</div>

	<div id="deliveryInfo" class="tabcontent">
		<h2> Find Organizations with High-Cost Deliveries</h2>
		<p>Find organizations which have placed orders with a total higher than the average cost of all other orders.</p>
		<form method = "POST" action garden.php>
			<input type = "hidden" id = "nestedAggregationWithGroupByRequest" name = "nestedAggregationWithGroupByRequest">
			<input type = "submit" value="Nested Aggregate with Group By" name="nestedAggregationWithGroupBySubmit"></p>
		</form>
	</div>

	<script>
		function openTab(evt, tabName) {
			// Hide all tabcontent elements
			var tabcontent = document.getElementsByClassName("tabcontent");
			for (var i = 0; i < tabcontent.length; i++) {
				tabcontent[i].style.display = "none";
			}

			// Remove the 'active' class from all tablinks
			var tablinks = document.getElementsByClassName("tablinks");
			for (var i = 0; i < tablinks.length; i++) {
				tablinks[i].className = tablinks[i].className.replace(" active", "");
			}

			// Display the current tab content
			document.getElementById(tabName).style.display = "block";

			// Clear the results container
			var resultContainer = document.getElementById("resultContainer");
			var newResultContainer = document.createElement("div");
			newResultContainer.id = "resultContainer";
			resultContainer.parentNode.replaceChild(newResultContainer, resultContainer);

			// Add the 'active' class to the button that opened the tab
			evt.currentTarget.className += " active";
		}
	</script>

	<?php
	// The following code will be parsed as PHP

	function dropDownAllTables() {
		if(connectToDB()) {
			$sql = "SELECT table_name FROM user_tables";
			$result = executePlainSQL($sql);
			while ($row = oci_fetch_assoc($result)) {
                echo '<option value="' . $row['TABLE_NAME'] . '">' . $row['TABLE_NAME'] . '</option>';
            }
			
			disconnectFromDB();
		}
	}

	function dropDownAllTablesAndAttributes() {
		if(connectToDB()) {
			$sql = "SELECT table_name, column_name FROM user_tab_columns";
			$result = executePlainSQL($sql);
		
			$tables = [];
		
			while ($row = oci_fetch_assoc($result)) {
				$tableName = $row['TABLE_NAME'];
				$attributeName = $row['COLUMN_NAME'];
		
				if (!isset($tables[$tableName])) {
					$tables[$tableName] = [];
				}
		
				$tables[$tableName][] = $attributeName;
			}
		
			foreach ($tables as $tableName => $attributes) {
				echo '<option value="' . $tableName . '"><b>' . $tableName . '<b></option>';
		
				foreach ($attributes as $attribute) {
					echo '<option disabled style="padding-left: 10px;">' . $attribute . '</option>';				
				}
		
			}
			
			disconnectFromDB();
		}
	}

	function debugAlertMessage($message)
	{
		global $show_debug_alert_messages;

		if ($show_debug_alert_messages) {
			echo "<script type='text/javascript'>alert('" . $message . "');</script>";
		}
	}

	function executePlainSQL($cmdstr)
	{ //takes a plain (no bound variables) SQL command and executes it
		//echo "<br>running ".$cmdstr."<br>";
		global $db_conn, $success;

		$statement = oci_parse($db_conn, $cmdstr);
		//There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

		if (!$statement) {
			// echo "<br>Cannot/ parse the following command: " . $cmdstr . "<br>";
			// $e = OCI_Error($db_conn); // For oci_parse errors pass the connection handle
			// echo htmlentities($e['message']);
			// throw new Expection("Cannot parse the following command: " . $cmdstr);
			$success = False;
		}

		$r = oci_execute($statement, OCI_DEFAULT);
		if (!$r) {
			// echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
			// $e = oci_error($statement); // For oci_execute errors pass the statementhandle
			// echo htmlentities($e['message']);
			// throw new Exception("Cannot execute the following command: " . $cmdstr);
			$success = False;
		}

		return $statement;
	}

	function executeBoundSQL($cmdstr, $list)
	{
		/* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		In this case you don't need to create the statement several times. Bound variables cause a statement to only be
		parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		See the sample code below for how this function is used */

		global $db_conn, $success;
		$statement = oci_parse($db_conn, $cmdstr);

		if (!$statement) {
			// echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
			// $e = OCI_Error($db_conn);
			// echo htmlentities($e['message']);
			// throw new Exception("Cannot parse the following command: " . $cmdstr);
			$success = False;
		}

		foreach ($list as $tuple) {
			foreach ($tuple as $bind => $val) {
				//echo $val;
				//echo "<br>".$bind."<br>";
				oci_bind_by_name($statement, $bind, $val);
				unset($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
			}

			$r = oci_execute($statement, OCI_DEFAULT);
			if (!$r) {
				echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
				$e = OCI_Error($statement); // For oci_execute errors, pass the statementhandle
				// echo htmlentities($e['message']);
				// throw new Exception("Cannot execute the following command: " . $cmdstr);
				// echo "<br>";
				$success = False;
			}
		}

		return $statement;
	}


	function printResult($result, $str)
	{
		//prints results
		echo "<div id='resultContainer'>";
		echo "<br>Retrieved data from " . $str . ":<br>";
		echo "<br>";
		echo "<table>";
	
		// Fetch the column names from the result set
		$columns = [];
		$numberOfColumns = oci_num_fields($result);
	
		for ($i = 1; $i <= $numberOfColumns; $i++) {
			$column = oci_field_name($result, $i);
			$columns[] = $column;
		}
	
		// Print the table header with column names
		echo "<tr>";
		foreach ($columns as $column) {
			echo "<th>$column</th>";
		}
		echo "</tr>";
	
		// Loop through each row in the result set
		while ($row = OCI_Fetch_Array($result, OCI_ASSOC)) {
			// Print each row in an HTML table
			echo "<tr>";
			foreach ($columns as $column) {
				if (array_key_exists($column, $row)) {
					echo "<td>" . $row[$column] . "</td>";
				} else {
					echo "<td>" . "" . "</td>";
				}
				
			}
			echo "</tr>";
		}
		echo "</div>";
	}	

	function connectToDB()
	{
		global $db_conn;
		global $config;

		// Your username is ora_(CWL_ID) and the password is a(student number). For example,
		// ora_platypus is the username and a12345678 is the password.
		// $db_conn = oci_connect("ora_cwl", "a12345678", "dbhost.students.cs.ubc.ca:1522/stu");
		$db_conn = oci_connect($config["dbuser"], $config["dbpassword"], $config["dbserver"]);

		if ($db_conn) {
			debugAlertMessage("Database is Connected");
			return true;
		} else {
			debugAlertMessage("Cannot connect to Database");
			$e = OCI_Error(); // For oci_connect errors pass no handle
			echo htmlentities($e['message']);
			return false;
		}
	}

	function disconnectFromDB()
	{
		global $db_conn;

		debugAlertMessage("Disconnect from Database");
		oci_close($db_conn);
	}

	function handleUpdateRequest()
	{
		global $db_conn;

		echo "<div id='resultContainer'>";
		try {
			$i = 0;
			$sqlArray = [];
			$bindVarsArray = [];
			$updateId = $_POST['updateId'];
			if ($updateId === "") {
				throw new Exception("Organization Id cannot be NULL.");
			}
			// check that OrganizationID exists
			$result = executeBoundSQL("SELECT count(*) FROM Organization WHERE OrganizationId = :updateId", array(array(":updateId" => $updateId)));
			$row = oci_fetch_row($result);
			if($row[0] == 0){
				throw new Exception("Organization Id does not exist.");
			}

			if (isset($_POST['updateNameCb'])) {
				$updateName = $_POST['updateName'];
				if ($updateName === "") {
					$updateName = NULL;
				}
				
				$sql = "UPDATE Organization SET Name = :updateName WHERE OrganizationId = :updateId";
				$sqlArray[$i] = $sql;
				$bindVarsArray[$i] = array (
					":updateId"        => $updateId,
					":updateName"      => $updateName
				);
				$i++;

				// executeBoundSQL($sql, $alltuples);
				
			}

			if (isset($_POST['updateAddressCb'])) {
				$updateAddress = $_POST['updateAddress'];
				if ($updateAddress === "") {
					$updateAddress = NULL;
				}

				$sql = "UPDATE Organization SET Address = :updateAddress WHERE OrganizationId = :updateId";
				$sqlArray[$i] = $sql;

				$bindVarsArray[$i] = array (
					":updateId"        => $updateId,
					":updateAddress"   => $updateAddress
				);
				$i++;

					// executeBoundSQL($sql, $alltuples);		
			}

			if (isset($_POST['updateBudgetCb'])) {
				$updateBudget = $_POST['updateBudget'];
				if ($updateBudget === "") {
					$updateBudget = NULL;
				}

				$sql = "UPDATE Organization SET Budget = :updateBudget WHERE OrganizationId = :updateId";
				$sqlArray[$i] = $sql;

				$bindVarsArray[$i] = array (
					":updateId"        => $updateId,
					":updateBudget"    => $updateBudget
				);
				$i++;
				// executeBoundSQL($sql, $alltuples);	
			}

			if (isset($_POST['updatePhoneCb'])) {
				$updatePhone = $_POST['updatePhone'];
				if ($updatePhone === "") {
					$updatePhone = NULL;
				}

				// check for duplicate Phone Number
				if ($updatePhone != NULL) {
					$result = executeBoundSQL("SELECT count(*) FROM Organization WHERE PhoneNumber = :updatePhone", array(array(":updatePhone" => $updatePhone)));
					$row = oci_fetch_row($result);
					if($row[0] != 0) {
						$result = executeBoundSQL("SELECT OrganizationId FROM Organization WHERE PhoneNumber = :updatePhone", array(array(":updatePhone" => $updatePhone)));
						$row = oci_fetch_row($result);
						if($row[0] != $updateId) {
							throw new Exception("Phone Number already exists.");
						}
					}
				}

				$sql = "UPDATE Organization SET PhoneNumber = :updatePhone WHERE OrganizationId = :updateId";
				$sqlArray[$i] = $sql;

				$bindVarsArray[$i] = array (
					":updateId"        => $updateId,
					":updatePhone"     => $updatePhone
				);
				$i++;

				// executeBoundSQL($sql, $alltuples);	
			}

			for($j = 0; $j < $i; $j++) {
				executeBoundSQL($sqlArray[$j], array($bindVarsArray[$j]));
			}

			echo "Update successful.";
			echo "</div>";
			oci_commit($db_conn);

		} catch(Exception $e) {
			echo "Error: ". $e->getMessage() . "<br/>";
			echo "Update failed.";
		} 
	
	}

	function handleResetRequest()
	{
		global $db_conn;
		// // Drop old table
		// executePlainSQL("DROP TABLE demoTable");

		// Read SQL script file
		$sqlScript = file_get_contents(__DIR__ . '/gardenSQLinit.sql');

		// Split the script into individual statements
		$statements = explode(';', $sqlScript);

		echo "<div id='resultContainer'>";
		// Execute each statement
		foreach ($statements as $statement) {
			// Skip empty statements
			if (trim($statement) == '') {
				continue;
			}

			$parsed = oci_parse($db_conn, $statement);

			if ($parsed !== false) {
				$executed = oci_execute($parsed);

				if (!$executed) {
					$e = oci_error($parsed);
					echo "Error executing script: " . htmlentities($e['message']);
				}

				// Free the statement handle
				oci_free_statement($parsed);
			} else {
				$e = oci_error($db_conn);
				echo "Error parsing script: " . htmlentities($e['message']);
			}
		};
		echo "Reset successul.";
		echo "</div>"; 
		oci_commit($db_conn);
	}

	function handleInsertRequest() {
		global $db_conn;

		echo "<div id='resultContainer'>";
		try{	
			$bindVars = array();
			if ($_POST['insertGardenId'] === "") {
				throw new Exception("Garden Id cannot be NULL.");
			} else {
				$bindVars[":gardenId"] = $_POST['insertGardenId'];
			}
			if ($_POST['insertName'] === "") {
				$bindVars[":name"] = NULL;
			} else {
				$bindVars[":name"] = $_POST['insertName'];
			}
			if ($_POST['insertAddress'] === "") {
				throw new Exception("Address cannot be NULL.");
			} else {
				$bindVars[":address"] = $_POST['insertAddress'];
			}
			if ($_POST['insertTotalPlots'] === "") {
				throw new Exception("Total Plots cannot be NULL.");
			} else {
				$bindVars[":totalPlots"] = $_POST['insertTotalPlots'];
			}
			if ($_POST['insertAvailablePlots'] === "") {
				throw new Exception("Available Plots cannot be NULL.");
			} else {
				$bindVars[":availablePlots"] = $_POST['insertAvailablePlots'];
			}
			if ($_POST['insertDailySun'] === "") {
				$bindVars[":dailySun"] = NULL;
			} else {
				$bindVars[":dailySun"] = $_POST['insertDailySun'];
			}
			if ($_POST['insertMonthlyPrecip'] === "") {
				$bindVars[":monthlyPrecip"] = NULL;
			} else {
				$bindVars[":monthlyPrecip"] = $_POST['insertMonthlyPrecip'];
			}
			if ($_POST['insertOrganizationId'] === "") {
				throw new Exception("Organization Id cannot be NULL.");
			} else {
				$bindVars[":orgId"] = $_POST['insertOrganizationId'];
			}
			
			// check for duplicate GardenID 
			$result = executeBoundSQL("SELECT count(*) FROM CommunityGarden WHERE GardenId = :gardenId", array(array(":gardenId" => $_POST['insertGardenId'])));
			$row = oci_fetch_row($result);
			if($row[0] != 0){
				throw new Exception("Cannot insert duplicate Garden Id.");
			}

			// check for duplicate Address 
			$result = executeBoundSQL("SELECT count(*) FROM CommunityGarden WHERE Address = :address", array(array(":address" => $_POST['insertAddress'])));
			$row = oci_fetch_row($result);
			if($row[0] != 0){
				throw new Exception("Cannot insert duplicate Address.");
			}
		
			// If foreign key OrganizationId does not exist, insert it
			$result = executeBoundSQL("SELECT Count(*) FROM Organization WHERE OrganizationId = :orgId", array(array(":orgId" => $_POST['insertOrganizationId'])));
			$row = oci_fetch_row($result);
			if ($row[0] == 0) {
			// Insert OrganizationId into Organization
				executeBoundSQL("INSERT INTO Organization(OrganizationId, Name, Address, Budget, PhoneNumber) 
					VALUES(:orgId, NULL, NULL, NULL, NULL)", array(array(":orgId" => $_POST['insertOrganizationId'])));
			}

		// Insert data into table CommunityGarden
			executeBoundSQL("
				INSERT INTO CommunityGarden(
					GardenId,
					Name,
					Address,
					TotalPlots,
					AvailablePlots,
					DailySunExposure,
					MonthlyPrecipitation,
					OrganizationId
					) 
				VALUES(
					:gardenId,
					:name,
					:address,
					:totalPlots,
					:availablePlots,
					:dailySun,
					:monthlyPrecip,
					:orgId
				)", 
				array($bindVars));

			echo "Insert successful.";

			oci_commit($db_conn);

		} catch(Exception $e) {
			echo "Error: ". $e->getMessage() . "<br/>";
			echo "Insert failed.";
		}
		echo "</div>";
	}

	function handleDeleteRequest() {
		global $db_conn;

		echo "<div id='resultContainer'>";
		try {
			$bindVars = array();
			if ($_POST['deleteGardenId'] === "") {
				throw new Exception("Garden Id cannot be NULL.");
			} else {
				$bindVars[":gardenId"] = $_POST['deleteGardenId'];
			}

			// check that Garden Id exists
			$result = executeBoundSQL("SELECT count(*) FROM CommunityGarden WHERE GardenId = :gardenId", array($bindVars));
			$row = oci_fetch_row($result);
			if($row[0] == 0){
				throw new Exception("Garden Id does not exist.");
			}

			executeBoundSQL("
				DELETE 
				FROM CommunityGarden
				WHERE GardenId = :gardenId
				", array($bindVars));
			
			echo "Delete successful.";
			echo "</div>";

			oci_commit($db_conn);
		} catch(Exception $e) {
			echo "Error: ". $e->getMessage() . "<br/>";
			echo "Delete failed.";
		}
		echo "</div>";
	}

	function handleSelectionRequest() {
		global $success;
		$whereString = "";
		try {
			if (!isset($_POST['selectGardenIdCb']) && !isset($_POST['selectPlotNumberCb']) && !isset($_POST['selectPlotSizeCb'])
			 	&& !isset($_POST['selectPlotStatusCb'])) {
					throw new Exception("No attributes selected.");
			}

			if (isset($_POST['selectGardenIdCb'])) {
				$attribute = "GardenID";
				$operator = $_POST['selectGardenIdOp'];
				$value = $_POST['selectGardenIdVal'];
				if ($value === "") {
					throw new Exception("Garden Id cannot be NULL.");
				}
				$option = $_POST['selectGardenIdOption'];
				
				$whereString = concatenateWhereString($whereString, $attribute, $operator, $value, $option);
			}
			if (isset($_POST['selectPlotNumberCb'])) {
				$attribute = "PlotNumber";
				$operator = $_POST['selectPlotNumberOp'];
				$value = $_POST['selectPlotNumberVal'];
				if ($value === "") {
					throw new Exception("Plot Number cannot be NULL.");
				}
				$option = $_POST['selectPlotNumberOption'];
				
				$whereString = concatenateWhereString($whereString, $attribute, $operator, $value, $option);
			}
			if (isset($_POST['selectPlotSizeCb'])) {
				$attribute = "PlotSize";
				$operator = $_POST['selectPlotSizeOp'];
				$value = $_POST['selectPlotSizeVal'];
				$option = $_POST['selectPlotSizeOption'];
				
				$whereString = concatenateWhereString($whereString, $attribute, $operator, $value, $option);
				
			}
			if (isset($_POST['selectPlotStatusCb'])) {
				$attribute = "Status";
				$operator = $_POST['selectPlotStatusOp'];
				$value = "'" . $_POST['selectPlotStatusVal'] . "'";
				$option = "";
	
				$whereString = concatenateWhereString($whereString, $attribute, $operator, $value, $option);
			}
			
			if ($whereString != "") {
				$result = executePlainSQL("SELECT * FROM Plot WHERE " . $whereString);
				if (!$success) {
					throw new Exception("Invalid query syntax. Check AND/OR options.");
				}
				$str = "<b>Plot Selection Query</b>";
				printResult($result, $str);
			}
		} catch(Exception $e) {
			echo "Error: ", $e->getMessage();
		}
	}

	function concatenateWhereString($whereString, $attribute, $operator, $value, $option) {
		if ($value === "" && $operator === "=") {
			$whereString = $whereString . $attribute . " IS NULL " . $option . " ";
		} else if ($value === "" && $operator === "!=") {
			$whereString = $whereString . $attribute . " IS NOT NULL " . $option . " ";
		} else if ($value === "") {
			throw new Exception("Selected operator is not compatible with NULL value.");
		} else {
			 $whereString = $whereString . $attribute . " " . $operator . " " . $value . " " . $option . " ";
		}
		return $whereString;
	}

	function handleProjectionRequest() {
		global $success;
		try {
			$selectString = "";
			$att = array();
			$tableName = $_POST['projectionTableName'];
			for ($i = 0; $i < 8; $i++) {
				if (!empty($_POST['projectionAtt' . ($i+1)])) {
					$att[$i] = $_POST['projectionAtt' . ($i+1)];
					if (!isValidObjectName($att[$i])) {
						throw new Exception("Attribute " . $att[$i] . " is invalid.");
					}
					$sql = "SELECT " . $att[$i] . " FROM " . $tableName;	
					executePlainSQL($sql);
					if (!$success) {
						throw new Exception("Attribute " . $att[$i] . " does not exist.");
					}

					if ($i === 0) {
						$selectString .= $att[$i];
					} else {
						$selectString .= "," . $att[$i]; 
					}
				} else {
					break;
				}
			}

			$sql = "SELECT " . $selectString . "  FROM " . $tableName;

			$result = executePlainSQL($sql);	

			$str = "<b>Projection Query</b>";
			printResult($result, $str);
		} catch(Exception $e) {
			echo "Error: ", $e->getMessage();
		}
	}

	function handleJoinRequest() {

		try {
			$bindVars = array();
			$plantSpecies = $_POST['joinPlantSpecies'];
			if ($plantSpecies === "") {
				throw new Exception("Plant species cannot be NULL.");
			}
			$bindVars[":plantSpecies"] = $plantSpecies;


			$sql = "SELECT g.Name, g.Address, p.PlotNumber
			FROM CommunityGarden g, Plot p, GrowsIn gi, Plant pl
			WHERE g.GardenId = p.GardenId AND p.GardenId = gi.GardenId AND p.PlotNumber = gi.PlotNumber 
			AND gi.PlantID = pl.PlantID AND pl.Species = :plantSpecies";

			$result = executeBoundSQL($sql, array($bindVars));	

			$str = "<b>Join Query</b>";
			printResult($result, $str);
		} catch(Exception $e) {
			echo "Error: ", $e->getMessage();
		}
	}

	function handleAggregationGroupByRequest() {
		$sql = "SELECT Status, SUM(PlotSize) as TotalPlotSpace
		FROM Plot
		GROUP BY Status";
		
		$result = executePlainSQL($sql);

		$str = "<b>Aggregation with Group By Query</b>";
		printResult($result, $str);
	}

	function handleAggregateByHavingRequest() {
		$sql = "CREATE View Aggregated(GardenId, LargePlotsAvailable) AS
		SELECT p.GardenId, COUNT(P.PlotNumber) as NumberOfPlots
		FROM Plot p
		WHERE p.Status = 'available' AND p.PlotSize > 10
		GROUP BY p.GardenId
		HAVING count(*) > 1
		ORDER BY p.GardenId asc";

		executePlainSQL($sql);

		$sql = "SELECT g.Name, g.Address, a.LargePlotsAvailable
		FROM CommunityGarden g, Aggregated a
		WHERE g.GardenId = a.GardenId";

		$result = executePlainSQL($sql);

		$str = "<b>Aggregation with Having Query</b>";
		printResult($result, $str);

		$sql = "DROP View Aggregated";
		executePlainSQL($sql);
	}

	function handleNestedAggregationWithGroupByRequest(){

		$sql = "CREATE VIEW nestAgg(OrgID, NumOfOrders) AS
					SELECT d1.OrganizationID, count(d2.TotalCost)
					FROM DeliveryRequest1 d1, DeliveryRequest2 d2
					WHERE   d1.quantity = d2.quantity AND
					d1.AvgCostPerUnit = d2.AvgCostPerUnit AND
					d2.totalCost >  (SELECT AVG(d2.TotalCost)
									FROM DeliveryRequest2 d2)
					GROUP BY d1.OrganizationID";

		executePlainSQL($sql);

		$sql1 = "SELECT o.name, na.NumOfOrders
					FROM nestAgg na, Organization o
					WHERE na.OrgID = o.OrganizationID ";

		$result = executePlainSQL($sql1);

		$str = "<b>Nested Aggregation with Group By</b>";
		printResult($result, $str);

		$sql2 = "DROP VIEW nestAgg";
		executePlainSQL($sql2);
	}


	function handleDivisionRequest() {
		$sql = "CREATE View Div(GardenerID) AS
		SELECT g.GardenerId
		FROM Gardener1 g
		WHERE NOT EXISTS
		((SELECT a1.EventId
			FROM Attends a1)
		MINUS
		(SELECT a2.EventId
			FROM Attends a2
			WHERE g.GardenerId = a2.GardenerId))";

		executePlainSQL($sql);

		$sql = "SELECT g2.Name, g2.Address, g2.PhoneNumber
		FROM Gardener1 g1, Gardener2 g2, Div d
		WHERE d.GardenerId = g1.GardenerId AND g1.Name = g2.Name AND g1.Address = g2.Address";

		$result = executePlainSQL($sql);

		$str = "<b>Division Query</b>";
		printResult($result, $str);

		$sql = "DROP View Div";
		executePlainSQL($sql);

	}

	function handleCountRequest()
	{
		global $db_conn;

		$result = executePlainSQL("SELECT Count(*) FROM demoTable");

		if (($row = oci_fetch_row($result)) != false) {
			echo "<br> The number of tuples in demoTable: " . $row[0] . "<br>";
		}
	}

	function handleDisplayRequest()
	{
		global $db_conn;
		$table_name = $_GET['tableName'];

		try{

			if (!isValidObjectName($table_name)){
				throw new Exception("Input string contains invalid characters; please enter only valid string");
			} 

			$result = executePlainSQL("SELECT * FROM " . $table_name);
			$column = oci_field_name($result, 1);
			$result = executePlainSQL("SELECT * FROM " . $table_name . " ORDER BY " . $column . " ASC");

			$str = "table <b>" . $table_name . "</b>";
			printResult($result, $str);

		} catch(Exception $e) {
			echo "Error: ", $e->getMessage();
		}
	}

	function isValidObjectName($str) {
		// Use a regular expression to check if the string contains only alphanumeric characters and underscores
		return preg_match('/^[a-zA-Z0-9_]+$/', $str) === 1;
	}

	// HANDLE ALL POST ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
	function handlePOSTRequest()
	{
		if (connectToDB()) {
			if (array_key_exists('resetTablesRequest', $_POST)) {
				handleResetRequest();
			} else if (array_key_exists('updateQueryRequest', $_POST)) {
				handleUpdateRequest();
			} else if (array_key_exists('insertQueryRequest', $_POST)) {
				handleInsertRequest();
			} else if (array_key_exists('deleteQueryRequest', $_POST)) {
				handleDeleteRequest();
			} else if ((array_key_exists('selectionQueryRequest', $_POST))) {
				handleSelectionRequest();
			} else if ((array_key_exists('projectionQueryRequest', $_POST))) {
				handleProjectionRequest();
			} else if ((array_key_exists('joinQueryRequest', $_POST))) {
				handleJoinRequest();
			} else if ((array_key_exists('aggregationGroupByQueryRequest', $_POST))) {
				handleAggregationGroupByRequest(); 
			} else if ((array_key_exists('aggregateByHavingQueryRequest', $_POST))) {
				handleAggregateByHavingRequest();
			} else if ((array_key_exists('divisionQueryRequest', $_POST))) {
				handleDivisionRequest(); 	
			} else if ((array_key_exists('nestedAggregationWithGroupByRequest', $_POST))) {
				handleNestedAggregationWithGroupByRequest();
			}

			disconnectFromDB();
		}
	}

	// HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
	function handleGETRequest()
	{
		if (connectToDB()) {
			if (array_key_exists('countTuples', $_GET)) {
				handleCountRequest();
			} elseif (array_key_exists('displayTuples', $_GET)) {
				handleDisplayRequest();
			}

			disconnectFromDB();
		}
	}

	if (isset($_POST['reset']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit']) || isset($_POST['deleteSubmit']) 
		|| isset($_POST['selectionSubmit']) || isset($_POST['projectionSubmit']) || isset($_POST['joinSubmit']) 
		|| isset($_POST['aggregationGroupBySubmit']) || isset($_POST['aggregateByHavingSubmit']) || isset($_POST['nestedAggregationWithGroupBySubmit']) || isset($_POST['divisionSubmit'])) {
		handlePOSTRequest();
} else if (isset($_GET['countTupleRequest']) || isset($_GET['displayTuplesRequest'])) {
	handleGETRequest();
} 

	// End PHP parsing and send the rest of the HTML content
?>
</body>

</html>