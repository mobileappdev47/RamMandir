<?php 

$data_source="103.14.99.95";
$user=array("Database"=>"Sunmoon_Enterprises", "Uid"=>"sa_lio", "pwd"=>"Preet@13579");
$conn=sqlsrv_connect($data_source, $user);
$response=array("status"=> "0");



if(!empty($_REQUEST['User_Name']) && !empty($_REQUEST['Password']) && !empty($_REQUEST['Imei_No']) && !empty($_REQUEST['Role']))
{
	
	$username=$_REQUEST['User_Name'];
	$password=$_REQUEST['Password'];
	$imei_no = $_REQUEST['Imei_No'];
	$role = $_REQUEST['Role'];
	
    if($conn)
    {
		$query = "select Full_Name,User_Name,Password,smtp,Role,User_ID,Company,ControlerNo,Out_ControllerNo,Location_Id from user_master where User_Name='".$username."' and Password ='".$password."' and smtp= '".$imei_no."' and Role='".$role."'";
		$result =sqlsrv_query($conn, $query);
		$row =sqlsrv_fetch_array($result);
		$username = $row['Full_Name'];
		$userID = $row['App_UID'];
		$customerID = $row['User_ID'];
		$companyId = $row['Company'];
		$controllerNumber = $row['ControlerNo'];
		$outcontroller = $row['Out_ControllerNo'];
		$locationId = $row['Location_Id'];
		if($row)
		{
			$status = "successfully login";
			$code = 1;
			echo json_encode(array("response"=>$status,"username"=>$username,"userid"=>$userID,"Role"=>$role, "customerid"=>$customerID, "companyid"=> $companyId ,"controllerNumber" => $controllerNumber,"outcontrollerNumber" => $outcontroller,"Location_Id" => $locationId));
		}
		else
		{
			$status = "login failed & Please try again"; 
			$code = 0;
			echo json_encode(array("response"=>$status,"code"=>$code));
		}
	}
	else
	{
	    echo "Database connection error";
    }
}

else
{
	
     echo "Please set correct variables";
}


sqlsrv_close($conn);

?>