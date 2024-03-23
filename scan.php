<?php
if(isset($_FILES['image'])){
$file_name = $_FILES['image']['name'];
$file_tmp =$_FILES['image']['tmp_name'];
move_uploaded_file($file_tmp,"images/".$file_name);
echo "<h3>Image Upload Success</h3>";
echo '<img src="images/'.$file_name.'" style="width:100%">';

shell_exec('"C:\\Program Files (x86)\\Tesseract-OCR\\tesseract" "C:\\xampp\\htdocs\\images\\'.$file_name.'" out');

echo "<br><h3>OCR after reading</h3><br><pre>";

$myfile = fopen("out.txt", "r") or die("Unable to open file!");
echo fread($myfile,filesize("out.txt"));
fclose($myfile);
echo "</pre>";
}
?>

private void Generate_QRCode()
        {
            //ServicePointManager.Expect100Continue = true;
            //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            var client = new RestClient("https://wire.easebuzz.in/api/v1/insta-collect/order/create/");
            client.Timeout = -1;

            Root101 request1 = new Root101();
            request1.key = "109ABDE555";
            request1.unique_request_number = "SMT" + frmVisitorDetails.Online_Id.ToString();
            //request1.amount = 1.0;
            //request1.per_transaction_amount = 1.0;

            decimal Paid_Amount = Convert.ToDecimal(txtMuseumTotalAmount.Text.Trim());
            decimal Add_Amount = .0m;
            //string Transaction_Amount = txtMuseumTotalAmount.Text.Trim() + ".0";

            request1.amount = Decimal.Add(Paid_Amount, Add_Amount);
            request1.per_transaction_amount = Decimal.Add(Paid_Amount, Add_Amount);

            request1.customer_name = frmVisitorDetails.Visitor_Name;
            request1.customer_phone = frmVisitorDetails.Mobile_No;
            request1.notify_customer_on_create = true;
            request1.notification_cycle_type = "daily";

            //request1.allowed_collection_modes = "[" + "bank_account" + "," + "upi" + "]";

            //string[] bank_details = new string[2] { "bank_account", "upi" };
            //var allowed_modes = new List<string>();
            //allowed_modes.AddRange(bank_details);

            request1.allowed_collection_modes = new string[2] { "bank_account", "upi" };

            //List<allowed_collection_modes> list = new List<allowed_collection_modes>
            //{
            //   new allowed_collection_modes() { bank_account = "bank_account", upi= "upi"},
            //};
            //string jsonOperation = JsonConvert.SerializeObject(list);
            //request1.allowed_collection_modes = list;


            //*request1.expiry_date = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");*/
            //request1.expiry_date = DateTime.Now.ToString("yyyy-MM-dd 23:00:00");

            DateTime Current_Time = DateTime.Now;
            DateTime Expiry_Time = Current_Time.AddMinutes(3);
            request1.expiry_date = Expiry_Time.ToString("yyyy-MM-dd HH:mm:ss");

            request1.udf1 = "";
            request1.udf2 = "";
            request1.udf3 = "";
            request1.udf4 = "";
            request1.udf5 = "";
            request1.customer_email = txtEmailId.Text;

            //request1.message = "Gujarat Smritivan Online Ticket Booking for " + txtMuseumTotalPerson.Text.ToString() + " Person and Amount Rs: " + txtMuseumTotalAmount.Text.Trim() + "";
            //request1.expiry_date = DateTime.Now.ToString("yyyy/MM/dd hh:mm:ss");

            string Authorization = request1.key + "|" + request1.unique_request_number + "|" + request1.amount + "|" + request1.per_transaction_amount + "|" + request1.udf1 + "|" + request1.udf2 + "|" + request1.udf3 + "|" + request1.udf4 + "|" + request1.udf5 + "|" + "AFBB97C664";
            SHA512Payment(Authorization);

            //List<Operation> list = new List<Operation>
            //{
            //   new Operation() { type = "sms", template= "Default sms template"},
            //   new Operation() { type = "email", template= "Default email template"},
            //   new Operation() { type = "whatsapp", template= "Default whatsapp template"},
            //};

            //string jsonOperation = JsonConvert.SerializeObject(list);
            //request1.operation = list;

            string hash = Hash_Value.ToLower();


            var request = new RestRequest(Method.POST);
            request.AddHeader("Authorization", ""+ hash +"");
            request.AddHeader("WIRE-API-KEY", "109ABDE555");
            request.AddHeader("Content-Type", "application/json");
            request.AddJsonBody(request1);
            //string key = "109ABDE555";
            //string unique_request_number = frmVisitorDetails.Online_Id.ToString();
            //string amount = txtMuseumTotalAmount.Text.Trim() + ".0";
            //string per_transaction_amount = txtMuseumTotalAmount.Text.Trim() + ".0";
            //string customer_name = frmVisitorDetails.Visitor_Name;
            //string customer_phone = frmVisitorDetails.Mobile_No;
            //string notify_customer_on_create = "true";
            //string notification_cycle_type = "daily";
            //string allowed_collection_modes = "[" + "bank_account" + "," + "upi" + "]";
            //string expiry_date = DateTime.Now.ToString("dd-MM-yyyy");
            //string customer_email = txtEmailId.Text;
            

            var body = JsonConvert.SerializeObject(request1);

            request.AddParameter("application/json", body, RestSharp.ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);
            Console.WriteLine(response.Content);
            Root102 jsonDe = JsonConvert.DeserializeObject<Root102>(response.Content);
            //var jsonObject = JsonSerializer.Deserialize<JsonObject>(jsonString);
            //Then you can use jsonObject["Data"]["Objects"][0]["FirstName"] to get the data.
            
            string stat = jsonDe.success;

            ID = jsonDe.data.transaction_order.id;
            //string ID = jsonDe.data.transaction_order.id;

            QRData = jsonDe.data.transaction_order.virtual_account.upi_qrcode_url;
            //string QRData = jsonDe.data.transaction_order.virtual_account.upi_qrcode_url;

            frmOnlineQRCode gd = new frmOnlineQRCode();
            gd.Show();
           
            this.Visible = false;

            //string trid=TR.id;

            //string QRCodeUrl=vqr.upi_qrcode_url;

            //Root13 latbody = new Root13();
            //Msg m = new Msg();
            //status = jsonDe.msg.status;
            //mode = jsonDe.msg.mode;
            //easePay = jsonDe.msg.easepayid;
            //bankreff = jsonDe.msg.bank_ref_num;
            //Amount = Convert.ToDouble(jsonDe.msg.amount);

        }