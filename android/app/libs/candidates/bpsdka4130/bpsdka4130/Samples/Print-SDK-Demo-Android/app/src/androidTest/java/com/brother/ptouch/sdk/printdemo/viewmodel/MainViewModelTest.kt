package com.brother.ptouch.sdk.printdemo.viewmodel

import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.MockitoAnnotations

@RunWith(AndroidJUnit4::class)
class MainViewModelTest {
    private var viewModel = MainViewModel()

    @Before
    fun setup() {
        MockitoAnnotations.openMocks(this)
    }

    /**
     * FIXME: for test
     */
    @Test
    fun test() {
        assert(1 == 1)
    }
}
