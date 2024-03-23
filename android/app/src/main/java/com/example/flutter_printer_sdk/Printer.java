package com.example.flutter_printer_sdk;

import static com.example.flutter_printer_sdk.MainActivity.TexttoImageEncode;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.media.Image;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.imin.printerlib.IminPrintUtils;
import com.pos.sdk.printer.POIPrinterManager;
import com.pos.sdk.printer.models.BitmapPrintLine;
import com.pos.sdk.printer.models.PrintLine;
import com.pos.sdk.printer.models.TextPrintLine;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class Printer {
    private static final String TAG = "Printer";

    public static void printerTest(Context context) {
    

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

}
