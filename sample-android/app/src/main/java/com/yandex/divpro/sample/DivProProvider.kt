package com.yandex.divpro.sample

import androidx.appcompat.app.AppCompatActivity
import androidx.preference.PreferenceManager
import com.yandex.divpro.DivPro
import com.yandex.divpro.DivProParams

object DivProProvider {

    private lateinit var divPro: DivPro

    fun init(activity: AppCompatActivity) {
        val prefs = PreferenceManager.getDefaultSharedPreferences(activity)
        val requestUrlKey = activity.getString(R.string.request_url_key)
        val requestUrl = prefs.getString(requestUrlKey, "")!!.let {
            it.ifEmpty { activity.getString(R.string.request_url_default) }
        }
        val appKey = prefs.getString(activity.getString(R.string.appkey_key), "") ?: ""
        val flags = prefs.getString(activity.getString(R.string.request_flags_key), null)
            ?.split(",")
            ?.map { it.trim() }
            ?.toTypedArray()
        val updateIntervalKey = activity.getString(R.string.request_interval_key)
        val updateInterval = prefs.getString(updateIntervalKey, null)?.toIntOrNull() ?: 0
        val requestImmediately =
            prefs.getBoolean(activity.getString(R.string.request_immediately_key), true)

        val params = DivProParams(
            url = requestUrl,
            appKey = appKey,
            flags = flags,
            appVersion = BuildConfig.APP_VERSION,
            updateIntervalSec = updateInterval,
            requestImmediatelyAfterInit = requestImmediately
        )
        divPro = DivPro(activity, params)
    }

    fun get() = divPro
}
