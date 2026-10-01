package com.brother.ptouch.sdk.printdemo.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.brother.ptouch.sdk.printdemo.R

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setTheme(R.style.AppTheme_NoActionbar_Main)
        setContentView(R.layout.activity_main)
    }
}
