package com.yandex.divpro.sample

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity

class LauncherActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DivProProvider.init(this)
        setContentView(R.layout.activity_launcher)
        Handler(Looper.getMainLooper()).postDelayed(DivProProvider.get()::onStart, 300)
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressedDispatcher.onBackPressed()
        return true
    }
}
