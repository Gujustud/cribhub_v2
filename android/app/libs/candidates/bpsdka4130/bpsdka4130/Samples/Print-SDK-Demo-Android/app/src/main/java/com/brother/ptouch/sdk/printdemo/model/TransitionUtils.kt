package com.brother.ptouch.sdk.printdemo.model

import android.content.Context
import android.content.Intent
import android.widget.ProgressBar
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.lifecycle.LifecycleOwner
import androidx.navigation.NavDirections
import androidx.navigation.fragment.NavHostFragment.Companion.findNavController
import com.brother.ptouch.sdk.printdemo.R
import com.brother.ptouch.sdk.printdemo.ui.GetIntFragment
import com.brother.ptouch.sdk.printdemo.ui.GetIntListFragment
import com.brother.ptouch.sdk.printdemo.ui.components.ShowResultFragment
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object TransitionUtils {

    fun getIntArgument(fragment: Fragment, directions: NavDirections, titleStringId: Int, hintStringId: Int, decisionBlock:(Int)->Unit) {
        val navController = findNavController(fragment)
        val savedStateHandle = navController.currentBackStackEntry?.savedStateHandle ?: return
        val liveData = savedStateHandle.getLiveData<Int>(GetIntFragment.KeyInputValue)

        navController.navigate(directions.apply {
            arguments.putInt(GetIntFragment.KeyTitle, titleStringId)
            arguments.putInt(GetIntFragment.KeyHint, hintStringId)
        })

        val lifecycleOwner = navController.currentBackStackEntry as LifecycleOwner // 注意：ここでのcurrentBackStackEntryは遷移先
        liveData.observe(lifecycleOwner) {
            decisionBlock(it)
            savedStateHandle.remove<Int>(GetIntFragment.KeyInputValue)
        }
    }

    fun getIntListArgument(fragment: Fragment, directions: NavDirections, titleStringId: Int, decisionBlock:(ArrayList<Int>)->Unit) {
        val navController = findNavController(fragment)
        val savedStateHandle = navController.currentBackStackEntry?.savedStateHandle ?: return
        val liveData = savedStateHandle.getLiveData<ArrayList<Int>>(GetIntListFragment.KeyInputValue)

        navController.navigate(directions.apply {
            arguments.putInt(GetIntListFragment.KeyTitle, titleStringId)
        })

        val lifecycleOwner = navController.currentBackStackEntry as LifecycleOwner // 注意：ここでのcurrentBackStackEntryは遷移先
        liveData.observe(lifecycleOwner) {
            decisionBlock(it)
            savedStateHandle.remove<ArrayList<Int>>(GetIntListFragment.KeyInputValue)
        }
    }

    fun getFileArgument(launcher: ActivityResultLauncher<Intent>, isMultiple: Boolean, decisionBlock:(ArrayList<String>)->Unit) {
        fileDecisionBlock = decisionBlock
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, isMultiple)
        }
        launcher.launch(intent)
    }
    private var fileDecisionBlock:(ArrayList<String>)->Unit = {}
    fun fileLauncher(fragment: Fragment): ActivityResultLauncher<Intent> {
        return fragment.registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
            if (it.resultCode != AppCompatActivity.RESULT_OK) {
                return@registerForActivityResult
            }
            val context = fragment.context ?: return@registerForActivityResult
            val data = ArrayList<String>()
            it.data?.data?.let { uri ->
                val path = StorageUtils.getSelectFileUri(context, uri) ?: return@registerForActivityResult
                data.add(path)
            }

            val clipData = it.data?.clipData
            if (clipData != null) {
                for (i in 0 until clipData.itemCount) {
                    val path = StorageUtils.getSelectFileUri(context, clipData.getItemAt(i).uri) ?: return@registerForActivityResult
                    data.add(path)
                }
            }

            if (data.isEmpty()) {
                return@registerForActivityResult
            }

            fileDecisionBlock(data)
        }
    }

    suspend fun showResult(fragment: Fragment, directions: NavDirections, result: String) {
        withContext(Dispatchers.Main) {
            findNavController(fragment).navigate(directions.apply {
                arguments.putString(ShowResultFragment.KeyPrintResult, result);
            })
        }
    }

    fun showWaitingDialog(context: Context): AlertDialog {
        val progressView = ProgressBar(context)
        val waitingDialog = MaterialAlertDialogBuilder(context)
            .setMessage(context.getString(R.string.waiting))
            .setView(progressView)
            .setCancelable(false)
            .create()
        waitingDialog.show()
        return waitingDialog
    }
}
