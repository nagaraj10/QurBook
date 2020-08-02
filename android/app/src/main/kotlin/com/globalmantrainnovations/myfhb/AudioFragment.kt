package com.globalmantrainnovations.myfhb

import android.os.Build
import android.os.Bundle
import android.os.SystemClock
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Chronometer
import android.widget.ImageView
import android.widget.TextView
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import java.util.*

class AudioFragment : Fragment(), View.OnClickListener {
    private var callName: TextView? = null
    private var callTimer: Chronometer? = null
    private var _video: ImageView? = null
    private var _mic: ImageView? = null
    private var _chat: ImageView? = null
    private var callEnd: ImageView? = null
    private fun initialiseView(v: View) {
        callEnd = v.findViewById(R.id.call_end)
        callName = v.findViewById(R.id.caller_name)
        callTimer = v.findViewById(R.id.call_timer)
        _video = v.findViewById(R.id.video)
        _mic = v.findViewById(R.id.audio)
        _chat = v.findViewById(R.id.chat)
        _video?.setOnClickListener(this)
        _mic?.setOnClickListener(this)
        _chat?.setOnClickListener(this)
        callEnd?.setOnClickListener(this)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        val v = inflater.inflate(R.layout.fragment_audio, container, false)
        initialiseView(v)
        return v
    }

    override fun onResume() {
        super.onResume()
        callTimer!!.base = SystemClock.elapsedRealtime() - CallOnUI.timerOffset
        callTimer!!.start()
    }

    override fun onStop() {
        super.onStop()
        callTimer!!.stop()
        CallOnUI.timerOffset = SystemClock.elapsedRealtime() - callTimer!!.base
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    fun showAlertDialogButtonClicked() {

        // setup the alert builder
        val builder = AlertDialog.Builder(Objects.requireNonNull(activity)!!)
        builder.setTitle(getString(R.string.alert))
        builder.setMessage(getString(R.string.msg_audio2video))
        builder.setCancelable(false)

        // add the buttons
        builder.setPositiveButton(getString(R.string.yes)) { dialogInterface, i -> //todo render audio screen.
            isVideoEnable = true
            Objects.requireNonNull(activity)!!.supportFragmentManager.beginTransaction().replace(R.id.main_content, VideoFragment()).commit()
        }
        builder.setNegativeButton(getString(R.string.no)) { dialogInterface, i ->
            isVideoEnable = false
            dialogInterface.dismiss()
        }

        // create and show the alert dialog
        val dialog = builder.create()
        dialog.show()
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    override fun onClick(view: View) {
        when (view.id) {
            R.id.audio -> isMute = if (!isMute) {
                _mic!!.setImageResource(R.drawable.ic_mic_off)
                true
            } else {
                _mic!!.setImageResource(R.drawable.ic_mic_on)
                false
            }
            R.id.video -> if (isVideoEnable) {
                isVideoEnable = false
                _video!!.setImageResource(R.drawable.ic_video_off)
            } else {
//                    isVideoEnable=true;
//                    _video.setImageResource(R.drawable.ic_video_off);
                showAlertDialogButtonClicked()
            }
            R.id.call_end ->             //todo end call headover to flutter
                activity!!.finish()
            R.id.chat -> {
            }
        }
    }

    companion object {
        private var isMute = false
        private var isVideoEnable = true
    }
}