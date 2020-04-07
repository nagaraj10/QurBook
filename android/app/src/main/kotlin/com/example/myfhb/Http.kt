package com.example.myfhb

import com.loopj.android.http.AsyncHttpClient
import com.loopj.android.http.AsyncHttpResponseHandler
import java.net.URLEncoder

object Http {
    private const val BASE_URL = "https://translation.googleapis.com/language/translate/v2?"
    private const val KEY = "AIzaSyCc6bO7xRC9T_UvuiFqRIL65LhFXS67cXs"
    private val client = AsyncHttpClient()
    fun post(transText: String, sourceLang: String, destLang: String, responseHandler: AsyncHttpResponseHandler?) {
        client[getAbsoluteUrl(transText, sourceLang, destLang), responseHandler]
    }

    private fun makeKeyChunk(key: String): String {
        return "key=$KEY"
    }

    private fun makeTransChunk(transText: String): String {
        val encodedText = URLEncoder.encode(transText)
        return "&q=$encodedText"
    }

    private fun langSource(langSource: String): String {
        return "&source=$langSource"
    }

    private fun langDest(langDest: String): String {
        return "&target=$langDest"
    }

    private fun getAbsoluteUrl(transText: String, sourceLang: String, destLang: String): String {
        val apiUrl = BASE_URL + makeKeyChunk(KEY) + makeTransChunk(transText) + langSource(sourceLang) + langDest(destLang)
        println(apiUrl)
        return apiUrl
    }

    fun postToMaya(identity: String?, Utternance: String?, responseHandler: AsyncHttpResponseHandler?) {
        val Url = "https://ai.dev.vsolgmi.com/ai/api/lex/test?userId=" + URLEncoder.encode(identity) +
                "&text=" + URLEncoder.encode(Utternance)
        println("Url:$Url")
        client[Url, responseHandler]
    }
}