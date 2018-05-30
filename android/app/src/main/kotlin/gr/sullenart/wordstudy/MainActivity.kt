package gr.sullenart.wordstudy

import android.os.Bundle
import android.content.Context
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import com.dropbox.core.android.Auth

class MainActivity(): FlutterActivity() {

  private val CHANNEL = "gr.sullenart.wordstudy/dropbox"

  private val DROPBOX_PREF_FILE = "wordstudy_dropbox"
  private val ACCESS_TOKEN_KEY = "access-token"
  private val USER_ID_KEY = "user-id"

  private var pendingResult: Result? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "startDropBoxAuth") {
        val prefs = getSharedPreferences(DROPBOX_PREF_FILE, Context.MODE_PRIVATE)
        val accessToken = prefs.getString(ACCESS_TOKEN_KEY, null)
        if (accessToken != null) {
          result.success(accessToken)
        } else {
          pendingResult = result
          Auth.startOAuth2Authentication(this@MainActivity, getString(R.string.app_key))
        }
      }
      else if (call.method == "signOutDropBoxAuth") {
          result.success("OK")
      }
    }
  }

  override fun onResume() {
    super.onResume()

    val prefs = getSharedPreferences(DROPBOX_PREF_FILE, Context.MODE_PRIVATE)
    var accessToken = prefs.getString(ACCESS_TOKEN_KEY, null)
    if (accessToken == null) {
      accessToken = Auth.getOAuth2Token()
      if (accessToken != null) {
        prefs.edit().putString(ACCESS_TOKEN_KEY, accessToken).apply()
      }
    }

    if (pendingResult != null) {
      if (accessToken != null) {
        pendingResult?.success(accessToken)
      } else {
        pendingResult?.error("UNAVAILABLE", "No access token available", null)
      }
      pendingResult = null
    }

    val uid = Auth.getUid()
    val storedUid = prefs.getString(USER_ID_KEY, null)
    if (uid != null && uid != storedUid) {
      prefs.edit().putString(USER_ID_KEY, uid).apply()
    }
  }
}
