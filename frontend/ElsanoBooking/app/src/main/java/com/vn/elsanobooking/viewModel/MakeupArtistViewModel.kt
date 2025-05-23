package com.vn.elsanobooking.viewModel

import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vn.elsanobooking.data.api.RetrofitInstance
import com.vn.elsanobooking.data.models.Artist
import com.vn.elsanobooking.data.models.Service
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.HttpException
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*

class MakeupArtistViewModel : ViewModel() {
    var artists by mutableStateOf<List<Artist>>(emptyList())
    var filteredArtists by mutableStateOf<List<Artist>>(emptyList())
    var selectedArtist by mutableStateOf<Artist?>(null)
    var services by mutableStateOf<List<Service>>(emptyList())
    var allServices by mutableStateOf<List<com.vn.elsanobooking.data.models.ServiceApiModel>>(emptyList())
    var uiState by mutableStateOf<UiState>(UiState.Idle)
    var isLoading by mutableStateOf(false)
    var selectedServiceId by mutableStateOf<Int?>(null)

    private val api = RetrofitInstance.makeupArtistApi
    private val generalApi = RetrofitInstance.generalApi

    private val _unavailableSlots = MutableLiveData<List<Pair<Date, Date>>>()
    val unavailableSlots: LiveData<List<Pair<Date, Date>>> get() = _unavailableSlots

    fun searchArtists(latitude: Double, longitude: Double, radius: Double = 10.0) {
        viewModelScope.launch {
            isLoading = true
            uiState = UiState.Idle
            println("Searching artists: lat=$latitude, lon=$longitude")
            try {
                val response = api.searchArtists(latitude, longitude, radius)
                println("API Response received. Artists count: ${response.size}")
                
                // Fetch detailed information for each artist
                val detailedArtists = response.map { artist ->
                    try {
                        val artistDetails = api.getArtistById(artist.id)
                        println("Fetched details for artist ${artist.id}. Services found: ${artistDetails.services?.size ?: 0}")
                        artistDetails
                    } catch (e: Exception) {
                        println("Error fetching details for artist ${artist.id}: ${e.message}")
                        artist // Return the original artist if details cannot be fetched
                    }
                }
                
                artists = detailedArtists
                
                // When we get new artists, reset filtered artists
                updateFilteredArtists()
                
                println("Artists update completed:")
                artists.forEach { artist ->
                    println("Artist ${artist.id} - ${artist.fullName}:")
                    println("  Services count: ${artist.services?.size ?: 0}")
                    artist.services?.forEach { service ->
                        println("  - Service: ${service.serviceId} - ${service.serviceName} - ${service.price}đ")
                    }
                }
                
                uiState = if (artists.isNotEmpty()) {
                    UiState.Success("Tìm kiếm thành công")
                } else {
                    UiState.Error("Không tìm thấy thợ trang điểm gần đây")
                }
            } catch (e: HttpException) {
                println("HTTP Error: ${e.message()}")
                println("Error response: ${e.response()?.errorBody()?.string()}")
                uiState = UiState.Error("Lỗi HTTP: ${e.message()}")
            } catch (e: IOException) {
                println("Network Error: ${e.message}")
                println("Stack trace: ${e.stackTraceToString()}")
                uiState = UiState.Error("Lỗi mạng: ${e.message}")
            } catch (e: Exception) {
                println("Unexpected error: ${e.message}")
                println("Stack trace: ${e.stackTraceToString()}")
                uiState = UiState.Error("Lỗi không xác định: ${e.message}")
            } finally {
                isLoading = false
                println("Search completed: isLoading=$isLoading, uiState=$uiState")
            }
        }
    }

    fun filterArtistsByService(serviceId: Int?) {
        println("Filtering artists by service: $serviceId")
        selectedServiceId = serviceId
        
        // When changing service filter, update filtered artists
        updateFilteredArtists()
        
        println("Filtered artists count: ${filteredArtists.size}")
        
        // Additional debug
        if (selectedServiceId != null) {
            filteredArtists.forEach { artist ->
                println("Filtered artist: ${artist.fullName}")
                val matchingServices = artist.services?.filter { service ->
                    service.serviceId == selectedServiceId
                } ?: emptyList()
                
                println("  Matching services: ${matchingServices.size}")
                matchingServices.forEach { service ->
                    println("    Service: ${service.serviceName}")
                }
            }
        }
    }

    private fun updateFilteredArtists() {
        filteredArtists = if (selectedServiceId != null) {
            println("Filtering artists by serviceId: $selectedServiceId")
            
            // Get artists who offer this service
            val matchingArtists = artists.filter { artist ->
                // Check if any service matches the selected service type ID
                // Try multiple fields to see which one works
                val hasMatchingService = artist.services?.any { service ->
                    // Try serviceId field
                    val matchesServiceId = service.serviceId == selectedServiceId
                    
                    // Try serviceDetailId field as fallback
                    val matchesDetailId = service.serviceDetailId == selectedServiceId
                    
                    // Debug info
                    if (matchesServiceId || matchesDetailId) {
                        println("MATCH: Artist=${artist.fullName}, Service=${service.serviceName}, " +
                                "serviceId=${service.serviceId}, serviceDetailId=${service.serviceDetailId}")
                    }
                    
                    // Match if either field matches
                    matchesServiceId || matchesDetailId
                } ?: false
                
                hasMatchingService
            }
            
            println("Found ${matchingArtists.size} matching artists out of ${artists.size} total")
            matchingArtists
        } else {
            println("No service selected, showing all ${artists.size} artists")
            artists
        }
    }

    fun getArtistDetails(artistId: Int) {
        viewModelScope.launch {
            isLoading = true
            uiState = UiState.Idle
            try {
                val artist = api.getArtistById(artistId)
                selectedArtist = artist
                services = artist.services ?: emptyList()
                println("Artist details loaded: ${artist.fullName}")
                println("Rating: ${artist.rating}, Reviews: ${artist.reviewsCount}")
                println("Services: ${services.size}")
                uiState = UiState.Success("Tải thông tin thành công")
            } catch (e: HttpException) {
                val errorMessage = when (e.code()) {
                    404 -> "Không tìm thấy nghệ sĩ"
                    else -> "Lỗi: ${e.message()}"
                }
                uiState = UiState.Error(errorMessage)
            } catch (e: Exception) {
                uiState = UiState.Error("Lỗi khi tải thông tin: ${e.message}")
            } finally {
                isLoading = false
            }
        }
    }

    fun fetchAllServices() {
        viewModelScope.launch {
            isLoading = true
            try {
                val response = generalApi.getAllServices()
                allServices = response
            } catch (e: Exception) {
                // handle error, optionally update uiState
            } finally {
                isLoading = false
            }
        }
    }

    suspend fun fetchUnavailableSlots(artistId: Int, startDate: Date, endDate: Date) {
        withContext(Dispatchers.IO) {
            try {
                val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
                val response = RetrofitInstance.bookingApi.getUnavailableSlots(
                    artistId,
                    dateFormat.format(startDate),
                    dateFormat.format(endDate)
                )
                if (response.isSuccessful) {
                    val slots = response.body()?.data?.mapNotNull {
                        val start = try { dateFormat.parse(it.startTime) } catch (e: Exception) { null }
                        val end = try { dateFormat.parse(it.endTime) } catch (e: Exception) { null }
                        if (start != null && end != null) Pair(start, end) else null
                    } ?: emptyList()
                    _unavailableSlots.postValue(slots)
                } else {
                    Log.e("MakeupArtistViewModel", "Failed to fetch unavailable slots: ${response.message()}")
                }
            } catch (e: Exception) {
                Log.e("MakeupArtistViewModel", "Error fetching unavailable slots: ${e.message}", e)
            }
        }
    }

    sealed class UiState {
        object Idle : UiState()
        data class Success(val message: String) : UiState()
        data class Error(val message: String) : UiState()
    }
}