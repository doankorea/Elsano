package com.vn.elsanobooking.ui.base

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

/**
 * Base Fragment class that all fragments should extend
 * Handles common functionality and lifecycle management
 */
abstract class BaseFragment : Fragment() {
    
    private var isViewCreated = false
    private var isViewVisible = false
    private var isDataInitialized = false

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        isViewCreated = true
        
        // Only initialize if not already done and view is visible
        if (!isDataInitialized && isViewVisible) {
            initializeData()
        }
    }

    override fun onResume() {
        super.onResume()
        isViewVisible = true
        
        // Initialize if view is created but data isn't initialized
        if (isViewCreated && !isDataInitialized) {
            initializeData()
        }
    }

    override fun onPause() {
        super.onPause()
        isViewVisible = false
    }

    override fun onDestroyView() {
        super.onDestroyView()
        isViewCreated = false
    }

    /**
     * Initialize the fragment's data
     * This will only be called once when the fragment becomes visible
     */
    protected open fun initializeData() {
        isDataInitialized = true
    }

    /**
     * Reset the initialization state
     * Call this when you want to reinitialize the fragment's data
     */
    protected fun resetInitialization() {
        isDataInitialized = false
        if (isViewCreated && isViewVisible) {
            initializeData()
        }
    }

    /**
     * Helper function to create ViewModel instances
     */
    protected inline fun <reified T : ViewModel> getViewModel(): T {
        return ViewModelProvider(this)[T::class.java]
    }

    /**
     * Helper function to create ViewModel instances scoped to the activity
     */
    protected inline fun <reified T : ViewModel> getActivityViewModel(): T {
        return ViewModelProvider(requireActivity())[T::class.java]
    }

    /**
     * Check if the fragment is currently visible to the user
     */
    protected fun isFragmentVisible(): Boolean {
        return isViewVisible
    }
} 