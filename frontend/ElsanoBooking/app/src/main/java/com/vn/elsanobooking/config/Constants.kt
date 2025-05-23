package com.vn.elsanobooking.config

import android.content.Context
import androidx.preference.PreferenceManager

object Constants {
    // Change this to your actual server IP and port
    const val BASE_URL = "http://192.168.37.241:5207"
    const val CHAT_HUB_URL = "$BASE_URL/chatHub"
    
    // Auth token key for SharedPreferences
    const val AUTH_TOKEN_KEY = "auth_token"
    const val SERVER_URL_KEY = "server_url"
    
    // Method to get the auth token from SharedPreferences
    var AUTH_TOKEN: String = ""
        private set
    
    // Call this method from the application startup or login screen
    fun updateAuthToken(context: Context) {
        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
        AUTH_TOKEN = sharedPreferences.getString(AUTH_TOKEN_KEY, "") ?: ""
    }
    
    // Use this method to save the auth token during login
    fun saveAuthToken(context: Context, token: String) {
        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
        sharedPreferences.edit().putString(AUTH_TOKEN_KEY, token).apply()
        AUTH_TOKEN = token
    }

    // Get the server URL from SharedPreferences or use default
    fun getServerUrl(context: Context): String {
        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
        return sharedPreferences.getString(SERVER_URL_KEY, BASE_URL) ?: BASE_URL
    }

    // Save the server URL to SharedPreferences
    fun saveServerUrl(context: Context, url: String) {
        val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)
        sharedPreferences.edit().putString(SERVER_URL_KEY, url).apply()
    }
}