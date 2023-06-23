package com.yandex.divpro.sample

import android.content.Context.MODE_PRIVATE
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.yandex.divpro.DivPro
import com.yandex.divpro.sample.databinding.FragmentMainBinding

private const val PREFS_NAME = "prefs"
private const val WEB_VIEW_URL_KEY = "web_view_url"

private const val DEFAULT_REQUEST_URL = "https://wikipedia.org"

class MainFragment : Fragment() {

    private lateinit var divPro: DivPro
    private lateinit var binding: FragmentMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        divPro = DivProProvider.get()
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        (requireActivity() as AppCompatActivity).supportActionBar?.apply {
            setDisplayHomeAsUpEnabled(false)
            title = requireContext().getString(R.string.app_name)
        }

        binding = FragmentMainBinding.inflate(inflater)

        binding.settingsButton.setOnClickListener {
            findNavController().navigate(R.id.action_to_settingsFragment)
        }

        val prefs = requireContext().getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        prefs.getString(WEB_VIEW_URL_KEY, "")?.ifEmpty { DEFAULT_REQUEST_URL }?.let {
            binding.omniboxInput.setText(it)
        }

        binding.omniboxButton.setOnClickListener {
            prefs.edit().putString(WEB_VIEW_URL_KEY, omniboxUrl).apply()
            binding.webView.loadUrl(omniboxUrl)
        }

        binding.webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?) =
                false

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                url?.let {
                    val trimmedUrl = if (it.endsWith("/")) it.substringBeforeLast("/") else it
                    divPro.onUrl(Uri.parse(trimmedUrl))
                }
            }
        }

        return binding.root
    }

    private val omniboxUrl get() = binding.omniboxInput.text.toString()
}
