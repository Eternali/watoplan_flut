package com.chipthinkstudios.watoplan

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.ContactsContract

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

import android.app.Activity.RESULT_OK;


const val channelName = "contact_picker"
const val pickerCode = 85500

class ContactPickerPlugin(private var activity: Activity)
  : MethodCallHandler, PluginRegistry.ActivityResultListener {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), channelName)
      val instance = ContactPickerPlugin(registrar.activity())
      registrar.addActivityResultListener(instance)
      channel.setMethodCallHandler(instance)
    }
  }

  private var pendingResult: Result? = null

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "selectContact") {
      pendingResult?.error("multiple_requests", "Cancelled by second request.", null)
      pendingResult = result

      val i = Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI)
      activity.startActivityForResult(i, pickerCode)
    } else {
      result.notImplemented()
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, resultIntent: Intent): Boolean {
    if (requestCode != pickerCode) return false;
    if (resultCode != RESULT_OK) {
      pendingResult?.success(null)
      pendingResult = null
      return true;
    }

    val contactUri: Uri = resultIntent.data
    val cursor: Cursor = activity.contentResolver.query(
      contactUri, null, null, null, null
    )
    cursor.moveToFirst()

    val phoneType = cursor.getInt(cursor.getColumnIndex(
      ContactsContract.CommonDataKinds.Phone.TYPE
    ))
    val phoneLabel = cursor.getString(cursor.getColumnIndex(
      ContactsContract.CommonDataKinds.Phone.LABEL
    ))
    val phoneNumber = cursor.getString(cursor.getColumnIndex(
      ContactsContract.CommonDataKinds.Phone.NUMBER
    ))
    val name = cursor.getString(cursor.getColumnIndex(
      ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
    ))
    val photo = cursor.getBlob(cursor.getColumnIndex(
      ContactsContract.CommonDataKinds.Photo.PHOTO
    ))

    cursor.close()

    pendingResult?.success(hashMapOf(
      "phoneNumber" to phoneNumber,
      "phoneLabel" to phoneLabel,
      "name" to name,
      "avatar" to photo
    ))
    pendingResult = null
    return true
  }

}


