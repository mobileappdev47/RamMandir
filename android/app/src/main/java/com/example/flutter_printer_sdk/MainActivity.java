package com.example.flutter_printer_sdk;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
import com.imin.printerlib.IminPrintUtils;
import com.pos.sdk.printer.POIPrinterManager;
import com.pos.sdk.printer.models.BitmapPrintLine;
import com.pos.sdk.printer.models.PrintLine;
import com.pos.sdk.printer.models.TextPrintLine;
import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "Printer";
    private static final String CHANNEL = "com.imin.printerlib";
    private IminPrintUtils.PrintConnectType connectType = IminPrintUtils.PrintConnectType.SPI;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL);
        channel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("method")) {

                        RequestQueue queue = Volley.newRequestQueue(MainActivity.this);
                        String url = "https://accountsandtaxminers.com/parkingIndore_WebService.asmx/Get_SessionPassParkingTicket";
                        JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(
                                Request.Method.GET, url, null,
                                new Response.Listener<JSONArray>() {

                                    @Override
                                    public void onResponse(JSONArray response) {
                                        try {

                                            for (int i = 0; i < response
                                                    .length(); i++) {
                                                JSONObject jsonobject = response
                                                        .getJSONObject(0);
                                                final POIPrinterManager printerManager = new POIPrinterManager(
                                                        getApplicationContext());
                                                printerManager.open();
                                                int state = printerManager
                                                        .getPrinterState();
                                                Log.d(TAG, "printer state = "
                                                        + state);
                                                printerManager.setPrintFont(
                                                        "/system/fonts/Android-1.ttf");
                                                printerManager.setPrintGray(
                                                        2000);
                                                printerManager.setLineSpace(
                                                        5);
                                                String str1 = "INDORE PARKING";
                                                PrintLine p1 = new TextPrintLine(
                                                        str1,
                                                        PrintLine.CENTER,
                                                        30);
                                                printerManager.addPrintLine(
                                                        p1);
                                                String str2 = "Season Pass";
                                                PrintLine p2 = new TextPrintLine(
                                                        str2,
                                                        PrintLine.CENTER,
                                                        40);
                                                printerManager.addPrintLine(
                                                        p2);
                                                printerManager.setPrintFont(
                                                        "/system/fonts/DroidSansMono.ttf");
                                                Bitmap bitmap = TexttoImageEncode(
                                                        MainActivity.this,
                                                        jsonobject.getString(
                                                                "Ticket_No"));
                                                printerManager.addPrintLine(
                                                        new BitmapPrintLine(
                                                                bitmap,
                                                                PrintLine.CENTER));
                                                List<TextPrintLine> list5 = printList(
                                                        "Enter Date: ",
                                                        "",
                                                        jsonobject.getString(
                                                                "Enterdate"),
                                                        20,
                                                        true);
                                                printerManager.addPrintLine(
                                                        list5);
                                                List<TextPrintLine> list1 = printList(
                                                        "End Date: ",
                                                        "",
                                                        jsonobject.getString(
                                                                "validateDate"),
                                                        20,
                                                        true);
                                                printerManager.addPrintLine(
                                                        list1);
                                                List<TextPrintLine> list6 = printList(
                                                        "Plan Type: ",
                                                        "",
                                                        jsonobject.getString(
                                                                "planType"),
                                                        20,
                                                        true);
                                                printerManager.addPrintLine(
                                                        list6);
                                                List<TextPrintLine> list3 = printList(
                                                        "Ticket No: ",
                                                        "",
                                                        jsonobject.getString(
                                                                "Ticket_No"),
                                                        20,
                                                        true);
                                                printerManager.addPrintLine(
                                                        list3);
                                                List<TextPrintLine> list7 = printList(
                                                        "Amount: ",
                                                        "",
                                                        jsonobject.getString(
                                                                "amount"),
                                                        20,
                                                        true);
                                                printerManager.addPrintLine(
                                                        list7);
                                                List<TextPrintLine> list4 = printList(
                                                        "Vehical Number",
                                                        "",
                                                        jsonobject.getString(
                                                                "VehicleNo"),
                                                        20,
                                                        true);
                                                printerManager.addPrintLine(
                                                        list4);
                                                List<TextPrintLine> list2 = printList(
                                                        "Vehicle Type",
                                                        "",
                                                        jsonobject.getString(
                                                                "vehicleType"),
                                                        20,
                                                        true);
                                                printerManager.addPrintLine(
                                                        list2);

                                                String str6 = "Info@parkomate.com";
                                                PrintLine p6 = new TextPrintLine(
                                                        str6,
                                                        PrintLine.CENTER,
                                                        14);
                                                printerManager.addPrintLine(
                                                        p6);
                                                String str7 = "+91 84528 41212";
                                                PrintLine p7 = new TextPrintLine(
                                                        str7,
                                                        PrintLine.CENTER,
                                                        14);
                                                printerManager.addPrintLine(
                                                        p7);
                                                String str9 = "****** Thank You ******";
                                                PrintLine p9 = new TextPrintLine(
                                                        str9,
                                                        PrintLine.CENTER,
                                                        18);
                                                printerManager.addPrintLine(
                                                        p9);
                                                String str0 = "                    \n                  \n                 \n";
                                                PrintLine p0 = new TextPrintLine(
                                                        str0,
                                                        PrintLine.CENTER,
                                                        18);
                                                printerManager.addPrintLine(
                                                        p0);

                                                printerManager.setPrintGray(
                                                        2000);
                                                printerManager.setLineSpace(
                                                        10);

                                                POIPrinterManager.IPrinterListener listener = new POIPrinterManager.IPrinterListener() {
                                                    @Override
                                                    public void onStart() {
                                                    }

                                                    @Override
                                                    public void onFinish() {
                                                        printerManager.cleanCache();
                                                        printerManager.close();
                                                    }

                                                    @Override
                                                    public void onError(
                                                            int code,
                                                            String msg) {
                                                        Log.e("POIPrinterManager",
                                                                "code: " + code + "msg: "
                                                                        + msg);
                                                        printerManager.close();
                                                    }
                                                };
                                                if (state == 4) {
                                                    printerManager.close();
                                                    return;
                                                }
                                                printerManager.beginPrint(
                                                        listener);

                                            }

                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }, new Response.ErrorListener() {
                            @Override
                            public void onErrorResponse(VolleyError error) {
                                Log.e("error", "error" + error);
                            }
                        });
                        queue.add(jsonArrayRequest);
                    }

                    if (call.method.equals("outPrint")) {
                        printTicket(call);

                    } else if (call.method.equals("printText")) {
                        printTicketin(call);

                    }
                }

        );

        // MethodChannel channelpay = new
        // MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),
        // CHANNELPAY);
        // channelpay.setMethodCallHandler(
        // (call, result) -> {
        // channel_result = result;
        // if (call.method.equals("payWithEasebuzz")) {
        // if (start_payment) {
        // start_payment = false;
        // startPayment(call.arguments);
        // }
        // }
        //
        // });

    }

    public void printTicketin(MethodCall call) {

        String deviceId = call.argument("device_Id").toString();
        String companyId = call.argument("company_Id").toString();
        RequestQueue queue = Volley.newRequestQueue(MainActivity.this);
        String url = "https://accountsandtaxminers.com/ShreeRamAyodhyaParking_WebService.asmx/GetParkingDetailsNewDynamic?Company_Id="+companyId+
                "&DeviceId="+deviceId;
        JsonObjectRequest jsonArrayRequest = new JsonObjectRequest(
                Request.Method.GET, url, null,
                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        try {

                            JSONArray jsonArray = response
                                    .getJSONArray("body");
                            JSONObject jsonobject = jsonArray
                                    .getJSONObject(0);
                            final POIPrinterManager printerManager = new POIPrinterManager(
                                    getApplicationContext());
                            printerManager.open();
                            int state = printerManager
                                    .getPrinterState();
                            Log.d(TAG, "printer state = "
                                    + state);

                            printerManager.setPrintFont(
                                    "/system/fonts/Android-1.ttf");
                            printerManager.setPrintGray(2000);
                            printerManager.setLineSpace(5);
//                                    String str1 = "Ayodhya Ram Mandir";
                            String str1 =     jsonobject.getString(
                                    "Location_Name");
                            PrintLine p1 = new TextPrintLine(str1, PrintLine.CENTER,
                                    30);
                            printerManager.addPrintLine(p1);
                            String str2 = jsonobject.getString(
                                    "Middle") + "\n*************";
                            Bitmap bitmap = TexttoImageEncode(
                                    getApplicationContext(),
                                    jsonobject.getString(
                                            "Ticket_No"));
                            printerManager.addPrintLine(new BitmapPrintLine(bitmap,
                                    PrintLine.CENTER));
                            PrintLine p2 = new TextPrintLine(str2, PrintLine.CENTER,
                                    30);
                            printerManager.addPrintLine(p2);
                            printerManager.setPrintFont(
                                    "/system/fonts/DroidSansMono.ttf");
                            List<TextPrintLine> list1 = printList("Date: ",
                                    "",  jsonobject.getString(
                                            "Ticket_Date"),
                                    25, true);
                            printerManager.addPrintLine(list1);
                            List<TextPrintLine> list3 = printList("Ticket No: ",
                                    "",  jsonobject.getString(
                                            "Ticket_No"),
                                    25, true);
                            printerManager.addPrintLine(list3);
                            List<TextPrintLine> list4 = printList(
                                    "Vehical Number", "",
                                    jsonobject.getString(
                                            "Vehicle_No"), 24,
                                    true);
                            printerManager.addPrintLine(list4);
                            List<TextPrintLine> list2 = printList("Vehicle Type",
                                    "",
                                    jsonobject.getString(
                                            "Category_Name"),
                                    24, true);
                            printerManager.addPrintLine(list2);
                            /*
                             * String str3 =
                             * "\nLoss of ticket will be charged as per following";
                             * PrintLine p3 = new TextPrintLine(str3,
                             * PrintLine.CENTER, 18);
                             * printerManager.addPrintLine(p3);
                             * String str4 = "Bike-Rs.500\n";
                             * PrintLine p4 = new TextPrintLine(str4,
                             * PrintLine.CENTER, 18);
                             * printerManager.addPrintLine(p4);
                             */
                            /*
                             * String str5 =
                             * "if vehicle is left in parking lot over 24 hours vehicle will be locked/towed. Contact operator for fine charges\n"
                             * ;
                             * PrintLine p5 = new TextPrintLine(str5,
                             * PrintLine.CENTER, 18);
                             * printerManager.addPrintLine(p5);
                             */
                            String str6 =  jsonobject.getString(
                                    "Email");
                            PrintLine p6 = new TextPrintLine(str6, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p6);
                            String str7 = jsonobject.getString(
                                    "PhoneNo");
                            PrintLine p7 = new TextPrintLine(str7, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p7);

                            String str8 = jsonobject.getString(
                                    "Bottom1");
                            PrintLine p8 = new TextPrintLine(str8, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p8);

                            String str9 = jsonobject.getString(
                                    "Bottom2");
                            PrintLine p9 = new TextPrintLine(str9, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p9);

                            String str10 = jsonobject.getString(
                                    "Bottom3");
                            PrintLine p10 = new TextPrintLine(str10, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p10);

                            String str11 = jsonobject.getString(
                                    "Bottom4");
                            PrintLine p11 = new TextPrintLine(str11, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p11);

                            String str12 = jsonobject.getString(
                                    "Bottom5");
                            PrintLine p12 = new TextPrintLine(str12, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p12);

                            String str13 = jsonobject.getString(
                                    "Bottom6");
                            PrintLine p13 = new TextPrintLine(str13, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p13);

                            String str14 = jsonobject.getString(
                                    "Bottom7");
                            PrintLine p14 = new TextPrintLine(str14, PrintLine.CENTER,
                                    14);
                            printerManager.addPrintLine(p14);


                            String str15 = "\n\n\n";
                            PrintLine p15 = new TextPrintLine(str15, PrintLine.CENTER,
                                    18);
                            printerManager.addPrintLine(p15);
                            String str16 = "                    \n                  \n                 ";
                            PrintLine p16 = new TextPrintLine(str16, PrintLine.CENTER,
                                    18);
                            printerManager.addPrintLine(p16);

                            printerManager.setPrintGray(2000);
                            printerManager.setLineSpace(50);

                            POIPrinterManager.IPrinterListener listener = new POIPrinterManager.IPrinterListener() {
                                @Override
                                public void onStart() {
                                }

                                @Override
                                public void onFinish() {
                                    printerManager.cleanCache();
                                    printerManager.close();
                                }

                                @Override
                                public void onError(
                                        int code,
                                        String msg) {
                                    Log.e("POIPrinterManager",
                                            "code: " + code + "msg: "
                                                    + msg);
                                    printerManager.close();
                                }
                            };
                            if (state == 4) {
                                printerManager.close();
                                return;
                            }
                            printerManager.beginPrint(
                                    listener);



                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

                Log.e("error", "error" + error);
            }
        });
        queue.add(jsonArrayRequest);

    }




    public void printTicket(MethodCall call) {
        String typer = call.argument("type").toString().trim();
        if("vehicle".equals(typer) ) {

            String ticketNo = call.argument("ticketNo").toString();
            String companyId = call.argument("company_Id").toString();
            String locationId = call.argument("locationId").toString();
            String ticketDate = call.argument("Ticket_Date").toString();
            String outDate = call.argument("Out_date").toString();
            String parkingTime = call.argument("Parking_Time").toString();
            String ticketNoText = call.argument("Ticket_No").toString();
            String vehicleRate = call.argument("Vehicle_Rate").toString();
            String vehicleNo = call.argument("Vehicle_No").toString();
            RequestQueue queue = Volley.newRequestQueue(MainActivity.this);
            String url = "https://accountsandtaxminers.com/ShreeRamAyodhyaParking_WebService.asmx/GetCalculateParkingPriceNewVehicleNoDynamic?Ticket_No="
                    + ticketNo + "&Company_Id=" + companyId +
                    "&LocationName=" + locationId;
            System.out.println(url);
            JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(
                    Request.Method.GET, url, null,
                    new Response.Listener<JSONArray>() {

                        @Override
                        public void onResponse(JSONArray response) {
                            try {
                                System.out.println("Response-----" + response.toString());

//                                Map<String, Object> parcking = call.argument(
//                                        "data");
                                //JSONObject parcking = call.argument("data");
                                System.out.println("======" +response.toString());

//                                JSONArray jsonArray = response
//                                        .getJSONArray("body");
                                JSONObject jsonobject = response
                                        .getJSONObject(0);

                                final POIPrinterManager printerManager = new POIPrinterManager(
                                        getApplicationContext());
                                printerManager.open();
                                int state = printerManager
                                        .getPrinterState();
                                Log.d(TAG, "printer state = "
                                        + state);


                                printerManager.setPrintFont(
                                        "/system/fonts/Android-1.ttf");
                                printerManager.setPrintGray(
                                        2000);
                                printerManager.setLineSpace(
                                        5);

                                String str1 = jsonobject.getString(
                                        "LocationName");
                                PrintLine p1 = new TextPrintLine(
                                        str1,
                                        PrintLine.CENTER,
                                        30);
                                printerManager.addPrintLine(
                                        p1);
                                String str2 = "Out Ticket";
                                PrintLine p2 = new TextPrintLine(
                                        str2,
                                        PrintLine.CENTER,
                                        40);
                                printerManager.addPrintLine(
                                        p2);
                                printerManager.setPrintFont(
                                        "/system/fonts/DroidSansMono.ttf");
                                // Bitmap bitmap = TexttoImageEncode(
                                // MainActivity.this,
                                // jsonObject.getString(
                                // "Ticket_No"));
                                // printerManager.addPrintLine(
                                // new BitmapPrintLine(
                                // bitmap,
                                // PrintLine.CENTER));
                                List<TextPrintLine> list5 = printList(
                                        "Ticket Date: ",
                                        "",
                                        ticketDate.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list5);
                                List<TextPrintLine> list1 = printList(
                                        "Out Date: ",
                                        "",
                                       outDate.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list1);
                                List<TextPrintLine> list6 = printList(
                                        "Parking_Time: ",
                                        "",
                                        parkingTime.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list6);
                                List<TextPrintLine> list3 = printList(
                                        "Ticket No: ",
                                        "",
                                        ticketNoText.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list3);
                                List<TextPrintLine> list7 = printList(
                                        "Vehicle_Rate: ",
                                        "",
                                        vehicleRate.toString() + "₹",
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list7);
                                List<TextPrintLine> list4 = printList(
                                        "Vehical Number",
                                        "",
                                       vehicleNo.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list4);
                                // List<TextPrintLine> list2 = printList(
                                // "Ticket Number",
                                // "",
                                // call.argument(
                                // "Ticket_No"),
                                // 20,
                                // true);
                                // printerManager.addPrintLine(
                                // list2);
                                // String str3 = "\nLoss
                                // of ticket will be
                                // charged as per
                                // following";
                                // PrintLine p3 = new
                                // TextPrintLine(str3,
                                // PrintLine.CENTER,
                                // 18);
                                // printerManager.addPrintLine(p3);
                                // String str4 =
                                // "Car-Rs.1000
                                // Bike-Rs.500\n";
                                // PrintLine p4 = new
                                // TextPrintLine(str4,
                                // PrintLine.CENTER,
                                // 18);
                                // printerManager.addPrintLine(p4);

                                String str6 = jsonobject.getString(
                                        "Email");
                                PrintLine p6 = new TextPrintLine(
                                        str6,
                                        PrintLine.CENTER,
                                        15);
                                printerManager.addPrintLine(
                                        p6);
                                String str7 = jsonobject.getString(
                                        "PhoneNo");
                                PrintLine p7 = new TextPrintLine(
                                        str7,
                                        PrintLine.CENTER,
                                        15);
                                printerManager.addPrintLine(
                                        p7);
                                String str8 = "                    \n                  \n                 ";
                                PrintLine p8 = new TextPrintLine(str8, PrintLine.CENTER, 18);
                                printerManager.addPrintLine(p8);
                                String str5 = "****** Thank You ******\n"
                                        + "                      \n                      \n                      \n";
                                PrintLine p5 = new TextPrintLine(str5,
                                        PrintLine.CENTER,
                                        18);
                                printerManager.addPrintLine(p5);

                                printerManager.setPrintGray(2000);
                                printerManager.setLineSpace(
                                        10);


                                POIPrinterManager.IPrinterListener listener = new POIPrinterManager.IPrinterListener() {
                                    @Override
                                    public void onStart() {
                                    }

                                    @Override
                                    public void onFinish() {
                                        printerManager.cleanCache();
                                        printerManager.close();
                                    }

                                    @Override
                                    public void onError(
                                            int code,
                                            String msg) {
                                        Log.e("POIPrinterManager",
                                                "code: " + code + "msg: "
                                                        + msg);
                                        printerManager.close();
                                    }
                                };
                                if (state == 4) {
                                    printerManager.close();
                                    return;
                                }
                                printerManager.beginPrint(
                                        listener);

                                System.out.println("Response-----" + response.toString());
                            } catch (Exception e) {
                                Log.e("error -----", e.getMessage());
                                Log.e("error -----", e.toString());
                                e.printStackTrace();
                            }
                        }
                    }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {

                    System.out.println("error ----vehicle");
                    Log.e("error", "error" + error);
                    Log.e("error", "error" + url);
                }
            });
            queue.add(jsonArrayRequest);





        }

        else {

            String ticketNo = call.argument("ticketNo").toString();
            String companyId = call.argument("company_Id").toString();
            String locationId = call.argument("locationId").toString();
            String ticketDate = call.argument("Ticket_Date").toString();
            String outDate = call.argument("Out_date").toString();
            String parkingTime = call.argument("Parking_Time").toString();
            String ticketNoText = call.argument("Ticket_No").toString();
            String vehicleRate = call.argument("Vehicle_Rate").toString();
            String vehicleNo = call.argument("Vehicle_No").toString();
            RequestQueue queue = Volley.newRequestQueue(MainActivity.this);
            String url = "https://accountsandtaxminers.com/ShreeRamAyodhyaParking_WebService.asmx/GetCalculateParkingPriceNewDynamic?Ticket_No=" + ticketNo + "&Company_Id=" + companyId +
                    "&LocationName=" + locationId;
            JsonArrayRequest jsonArrayRequest = new JsonArrayRequest(
                    Request.Method.GET, url, null,
                    new Response.Listener<JSONArray>() {

                        @Override
                        public void onResponse(JSONArray response) {
                            try {
//                                JSONArray data = call.argument(
//                                        "data");
//                                JSONObject parcking = data.getJSONObject(0);

//                                JSONArray jsonArray = response
//                                        .getJSONArray("body");
                                JSONObject jsonobject = response
                                        .getJSONObject(0);
                                final POIPrinterManager printerManager = new POIPrinterManager(
                                        getApplicationContext());
                                printerManager.open();
                                int state = printerManager
                                        .getPrinterState();
                                Log.d(TAG, "printer state = "
                                        + state);


                                printerManager.setPrintFont(
                                        "/system/fonts/Android-1.ttf");
                                printerManager.setPrintGray(
                                        2000);
                                printerManager.setLineSpace(
                                        5);

                                String str1 = jsonobject.getString(
                                        "LocationName");
                                PrintLine p1 = new TextPrintLine(
                                        str1,
                                        PrintLine.CENTER,
                                        30);
                                printerManager.addPrintLine(
                                        p1);
                                String str2 = "Out Ticket";
                                PrintLine p2 = new TextPrintLine(
                                        str2,
                                        PrintLine.CENTER,
                                        40);
                                printerManager.addPrintLine(
                                        p2);
                                printerManager.setPrintFont(
                                        "/system/fonts/DroidSansMono.ttf");
                                // Bitmap bitmap = TexttoImageEncode(
                                // MainActivity.this,
                                // jsonObject.getString(
                                // "Ticket_No"));
                                // printerManager.addPrintLine(
                                // new BitmapPrintLine(
                                // bitmap,
                                // PrintLine.CENTER));
                                List<TextPrintLine> list5 = printList(
                                        "Ticket Date: ",
                                        "",
                                        ticketDate.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list5);
                                List<TextPrintLine> list1 = printList(
                                        "Out Date: ",
                                        "",
                                        outDate.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list1);
                                List<TextPrintLine> list6 = printList(
                                        "Parking_Time: ",
                                        "",
                                        parkingTime.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list6);
                                List<TextPrintLine> list3 = printList(
                                        "Ticket No: ",
                                        "",
                                       ticketNoText.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list3);
                                List<TextPrintLine> list7 = printList(
                                        "Vehicle_Rate: ",
                                        "",
                                        vehicleRate.toString() + "₹",
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list7);
                                List<TextPrintLine> list4 = printList(
                                        "Vehical Number",
                                        "",
                                       vehicleNo.toString(),
                                        20,
                                        true);
                                printerManager.addPrintLine(
                                        list4);
                                // List<TextPrintLine> list2 = printList(
                                // "Ticket Number",
                                // "",
                                // call.argument(
                                // "Ticket_No"),
                                // 20,
                                // true);
                                // printerManager.addPrintLine(
                                // list2);
                                // String str3 = "\nLoss
                                // of ticket will be
                                // charged as per
                                // following";
                                // PrintLine p3 = new
                                // TextPrintLine(str3,
                                // PrintLine.CENTER,
                                // 18);
                                // printerManager.addPrintLine(p3);
                                // String str4 =
                                // "Car-Rs.1000
                                // Bike-Rs.500\n";
                                // PrintLine p4 = new
                                // TextPrintLine(str4,
                                // PrintLine.CENTER,
                                // 18);
                                // printerManager.addPrintLine(p4);

                                String str6 = jsonobject.getString(
                                        "Email");
                                PrintLine p6 = new TextPrintLine(
                                        str6,
                                        PrintLine.CENTER,
                                        15);
                                printerManager.addPrintLine(
                                        p6);
                                String str7 = jsonobject.getString(
                                        "PhoneNo");
                                PrintLine p7 = new TextPrintLine(
                                        str7,
                                        PrintLine.CENTER,
                                        15);
                                printerManager.addPrintLine(
                                        p7);
                                String str8 = "                    \n                  \n                 ";
                                PrintLine p8 = new TextPrintLine(str8, PrintLine.CENTER, 18);
                                printerManager.addPrintLine(p8);
                                String str5 = "****** Thank You ******\n"
                                        + "                      \n                      \n                      \n";
                                PrintLine p5 = new TextPrintLine(str5,
                                        PrintLine.CENTER,
                                        18);
                                printerManager.addPrintLine(p5);

                                printerManager.setPrintGray(2000);
                                printerManager.setLineSpace(
                                        10);


                                POIPrinterManager.IPrinterListener listener = new POIPrinterManager.IPrinterListener() {
                                    @Override
                                    public void onStart() {
                                    }

                                    @Override
                                    public void onFinish() {
                                        printerManager.cleanCache();
                                        printerManager.close();
                                    }

                                    @Override
                                    public void onError(
                                            int code,
                                            String msg) {
                                        Log.e("POIPrinterManager",
                                                "code: " + code + "msg: "
                                                        + msg);
                                        printerManager.close();
                                    }
                                };
                                if (state == 4) {
                                    printerManager.close();
                                    return;
                                }
                                printerManager.beginPrint(
                                        listener);


                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {

                    Log.e("error", "error" + error);
                }
            });
            queue.add(jsonArrayRequest);
        }
    }

    // private void startPayment(Object arguments) {
    // try {
    // Gson gson = new Gson();
    // JSONObject parameters = new JSONObject(gson.toJson(arguments));
    // Intent intentProceed = new Intent(getActivity(), PWECouponsActivity.class);
    // intentProceed.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
    // Iterator<?> keys = parameters.keys();
    // while (keys.hasNext()) {
    // String value = "";
    // String key = (String) keys.next();
    // value = parameters.optString(key);
    // if (key.equals("amount")) {
    // Double amount = new Double(parameters.optString("amount"));
    // intentProceed.putExtra(key, amount);
    // } else {
    // intentProceed.putExtra(key, value);
    // }
    // }
    // startActivityForResult(intentProceed, PWEStaticDataModel.PWE_REQUEST_CODE);
    // } catch (Exception e) {
    // start_payment = true;
    // Map<String, Object> error_map = new HashMap<>();
    // Map<String, Object> error_desc_map = new HashMap<>();
    // String error_desc = "exception occured:" + e.getMessage();
    // error_desc_map.put("error", "Exception");
    // error_desc_map.put("error_msg", error_desc);
    // error_map.put("result", PWEStaticDataModel.TXN_FAILED_CODE);
    // error_map.put("payment_response", error_desc_map);
    // channel_result.success(error_map);
    // }
    // };

    // @Override
    // protected void onActivityResult(int requestCode, int resultCode, Intent data)
    // {
    // if (data != null) {
    // if (requestCode == PWEStaticDataModel.PWE_REQUEST_CODE) {
    // start_payment = true;
    // JSONObject response = new JSONObject();
    // Map<String, Object> error_map = new HashMap<>();
    // if (data != null) {
    // String result = data.getStringExtra("result");
    // String payment_response = data.getStringExtra("payment_response");
    // try {
    // JSONObject obj = new JSONObject(payment_response);
    // response.put("result", result);
    // response.put("payment_response", obj);
    // channel_result.success(JsonConverter.equals(response));
    // } catch (Exception e) {
    // Map<String, Object> error_desc_map = new HashMap<>();
    // error_desc_map.put("error", result);
    // error_desc_map.put("error_msg", payment_response);
    // error_map.put("result", result);
    // error_map.put("payment_response", error_desc_map);
    // channel_result.success(error_map);
    // }
    // } else {
    // Map<String, Object> error_desc_map = new HashMap<>();
    // String error_desc = "Empty payment response";
    // error_desc_map.put("error", "Empty error");
    // error_desc_map.put("error_msg", error_desc);
    // error_map.put("result", "payment_failed");
    // error_map.put("payment_response", error_desc_map);
    // channel_result.success(error_map);
    // }
    // } else {
    // super.onActivityResult(requestCode, resultCode, data);
    // }
    // }
    // }

    // private static List<TextPrintLine> printList(String leftStr, String
    // centerStr, String rightStr, int size, boolean bold){
    // TextPrintLine textPrintLine1 = new TextPrintLine(leftStr, PrintLine.LEFT,
    // size, bold);
    // TextPrintLine textPrintLine2 = new TextPrintLine(centerStr,PrintLine.CENTER,
    // size, bold);
    // TextPrintLine textPrintLine3 = new TextPrintLine(rightStr, PrintLine.RIGHT,
    // size, bold);
    // List<TextPrintLine> list = new ArrayList<>();
    // list.add(textPrintLine1);
    // list.add(textPrintLine2);
    // list.add(textPrintLine3);
    // return list;
    // }

    public static Bitmap TexttoImageEncode(Context context, String value) {
        BitMatrix bitMatrix;

        try {
            bitMatrix = new MultiFormatWriter().encode(value, BarcodeFormat.DATA_MATRIX.QR_CODE, 200, 200,
                    null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        int bitMatrixWidth = bitMatrix.getWidth();
        int bitMatrixHeight = bitMatrix.getHeight();
        int[] pixels = new int[bitMatrixWidth * bitMatrixHeight];
        for (int y = 0; y < bitMatrixHeight; y++) {
            for (int x = 0; x < bitMatrixWidth; x++) {
                pixels[y * bitMatrixWidth + x] = bitMatrix.get(x, y)
                        ? ContextCompat.getColor(context, android.R.color.black)
                        : ContextCompat.getColor(context, android.R.color.white);
            }
        }

        Bitmap bitmap = Bitmap.createBitmap(bitMatrixWidth, bitMatrixHeight, Bitmap.Config.ARGB_8888);
        bitmap.setPixels(pixels, 0, bitMatrixWidth, 0, 0, bitMatrixWidth, bitMatrixHeight);
        return bitmap;
    }

    private static List<TextPrintLine> printList(String leftStr, String centerStr, String rightStr, int size,
                                                 boolean bold) {
        TextPrintLine textPrintLine1 = new TextPrintLine(leftStr, PrintLine.LEFT, size, bold);
        TextPrintLine textPrintLine2 = new TextPrintLine(centerStr, PrintLine.CENTER, size, bold);
        TextPrintLine textPrintLine3 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);
        TextPrintLine textPrintLine4 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);
        TextPrintLine textPrintLine5 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);
        TextPrintLine textPrintLine6 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);
        TextPrintLine textPrintLine7 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);
        TextPrintLine textPrintLine8 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);
        TextPrintLine textPrintLine9 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);
        TextPrintLine textPrintLine0 = new TextPrintLine(rightStr, PrintLine.RIGHT, size, bold);

        List<TextPrintLine> list = new ArrayList<>();
        list.add(textPrintLine1);
        list.add(textPrintLine2);
        list.add(textPrintLine3);
        list.add(textPrintLine4);
        list.add(textPrintLine5);
        list.add(textPrintLine6);
        list.add(textPrintLine7);
        list.add(textPrintLine8);
        list.add(textPrintLine9);
        list.add(textPrintLine0);

        return list;
    }

};
