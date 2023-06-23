package com.yandex.divpro.sample

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.preference.Preference
import androidx.preference.PreferenceFragmentCompat
import com.yandex.divpro.DivPro

class SettingsFragment : PreferenceFragmentCompat() {

    private lateinit var divPro: DivPro

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val screenTitle = requireContext().getString(R.string.sample_settings)
        divPro = DivProProvider.get()
        divPro.onEvent(screenTitle.lowercase())

        (requireActivity() as AppCompatActivity).supportActionBar?.apply {
            setDisplayHomeAsUpEnabled(true)
            title = screenTitle
        }
    }

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        setPreferencesFromResource(R.xml.preferences, rootKey)

        val buttonKey = requireContext().getString(R.string.request_button_key)
        findPreference<Preference>(buttonKey)?.onPreferenceClickListener =
            Preference.OnPreferenceClickListener {
                divPro.onRequestsAllowed()
                true
            }
    }
}
