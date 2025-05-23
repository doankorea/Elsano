package com.vn.elsanobooking.presentation.screen

import android.content.ContentValues.TAG
import android.net.Uri
import android.util.Log
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.navigation.NavGraph.Companion.findStartDestination
import coil.compose.AsyncImage
import com.vn.elsanobooking.viewModel.AuthViewModel
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Person
import androidx.compose.runtime.saveable.rememberSaveable
import com.vn.elsanobooking.config.Constants
import com.vn.elsanobooking.data.api.Suggestion
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileOutputStream

@Composable
fun ProfileScreen(navController: NavController, authViewModel: AuthViewModel) {
    var showEditDialog by remember { mutableStateOf(false) }
    var showAddLocationDialog by remember { mutableStateOf(false) }
    var avatarUri by remember { mutableStateOf<Uri?>(null) }
    val context = LocalContext.current

    // Launcher for picking an image
    val imagePickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        uri?.let {
            avatarUri = it
            val file = uri.toFile(context)
            file?.let {
                authViewModel.updateAvatar(it)
            } ?: Toast.makeText(context, "Không thể xử lý hình ảnh", Toast.LENGTH_SHORT).show()
        }
    }

    // Show toast for UI state
    LaunchedEffect(authViewModel.uiState) {
        when (val state = authViewModel.uiState) {
            is AuthViewModel.UiState.Success -> {
                Toast.makeText(context, state.message, Toast.LENGTH_SHORT).show()
            }
            is AuthViewModel.UiState.Error -> {
                Toast.makeText(context, state.message, Toast.LENGTH_LONG).show()
            }
            else -> {}
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Header
        Text(
            text = "Hồ Sơ",
            style = MaterialTheme.typography.headlineMedium.copy(
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary
            ),
            modifier = Modifier.padding(bottom = 16.dp)
        )

        if (authViewModel.isLoading) {
            CircularProgressIndicator(
                modifier = Modifier.padding(16.dp),
                color = MaterialTheme.colorScheme.primary
            )
        } else {
            // Avatar
            Card(
                modifier = Modifier
                    .size(100.dp)
                    .clip(CircleShape),
                shape = CircleShape,
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(MaterialTheme.colorScheme.surface)
                        .clickable { imagePickerLauncher.launch("image/*") },
                    contentAlignment = Alignment.Center
                ) {
                    authViewModel.avatar?.let { avatarUrl ->
                        AsyncImage(
                            model = "${Constants.BASE_URL}${avatarUrl}?t=${System.currentTimeMillis()}",
                            contentDescription = "Avatar",
                            modifier = Modifier.fillMaxSize()
                        )
                    } ?: Icon(
                        imageVector = Icons.Default.Person,
                        contentDescription = "Avatar Placeholder",
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(48.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // User information card
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                ) {
                    ProfileInfoItem("Tên đăng nhập", authViewModel.userName)
                    Divider(
                        modifier = Modifier.padding(vertical = 8.dp),
                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)
                    )
                    ProfileInfoItem("Tên hiển thị", authViewModel.displayName.ifEmpty { authViewModel.userName })
                    Divider(
                        modifier = Modifier.padding(vertical = 8.dp),
                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)
                    )
                    ProfileInfoItem("Email", authViewModel.email)
                    Divider(
                        modifier = Modifier.padding(vertical = 8.dp),
                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)
                    )
                    ProfileInfoItem(
                        "Số điện thoại",
                        authViewModel.phoneNumber.takeIf { it.isNotBlank() } ?: "Chưa cung cấp"
                    )
                    Divider(
                        modifier = Modifier.padding(vertical = 8.dp),
                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)
                    )
                    ProfileInfoItem(
                        "Địa chỉ",
                        authViewModel.location?.address ?: "Chưa cung cấp"
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Action Buttons
            Button(
                onClick = { showEditDialog = true },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    contentColor = MaterialTheme.colorScheme.onPrimary
                )
            ) {
                Text(
                    text = "Chỉnh sửa thông tin",
                    style = MaterialTheme.typography.labelLarge
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            OutlinedButton(
                onClick = { showAddLocationDialog = true },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
                shape = RoundedCornerShape(12.dp),
                border = BorderStroke(1.dp, MaterialTheme.colorScheme.primary)
            ) {
                Text(
                    text = "Thêm địa chỉ",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.primary
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            TextButton(
                onClick = {
                    authViewModel.logout()
                    navController.navigate("profile_screen") {
                        popUpTo(navController.graph.findStartDestination().id) { inclusive = true }
                    }
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp),
            ) {
                Text(
                    text = "Đăng xuất",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.error
                )
            }
        }
    }

    // Edit Profile Dialog
    if (showEditDialog) {
        EditProfileDialog(
            authViewModel = authViewModel,
            onDismiss = { showEditDialog = false }
        )
    }

    // Add Location Dialog
    if (showAddLocationDialog) {
        AddLocationDialog(
            authViewModel = authViewModel,
            onDismiss = { showAddLocationDialog = false }
        )
    }
}

@Composable
fun ProfileInfoItem(label: String, value: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 6.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = "$label:",
            style = MaterialTheme.typography.bodyMedium.copy(
                fontWeight = FontWeight.Medium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        )
        Text(
            text = value,
            style = MaterialTheme.typography.bodyMedium.copy(
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onSurface
            )
        )
    }
}

@Composable
fun EditProfileDialog(authViewModel: AuthViewModel, onDismiss: () -> Unit) {
    var userName by remember { mutableStateOf(authViewModel.userName) }
    var displayName by remember { mutableStateOf(authViewModel.displayName) }
    var email by remember { mutableStateOf(authViewModel.email) }
    var phoneNumber by remember { mutableStateOf(authViewModel.phoneNumber) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                text = "Chỉnh sửa thông tin",
                style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold)
            )
        },
        text = {
            Column {
                OutlinedTextField(
                    value = userName,
                    onValueChange = { userName = it },
                    label = { Text("Tên đăng nhập") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )
                Spacer(modifier = Modifier.height(12.dp))
                OutlinedTextField(
                    value = displayName,
                    onValueChange = { displayName = it },
                    label = { Text("Tên hiển thị") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )
                Spacer(modifier = Modifier.height(12.dp))
                OutlinedTextField(
                    value = email,
                    onValueChange = { email = it },
                    label = { Text("Email") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )
                Spacer(modifier = Modifier.height(12.dp))
                OutlinedTextField(
                    value = phoneNumber,
                    onValueChange = { phoneNumber = it },
                    label = { Text("Số điện thoại") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    authViewModel.updateUserInfo(
                        newUserName = userName,
                        newDisplayName = displayName,
                        newPhoneNumber = phoneNumber,
                        newEmail = email,
                        newAvatar = authViewModel.avatar,
                        newIsActive = authViewModel.isActive
                    )
                    onDismiss()
                },
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    contentColor = MaterialTheme.colorScheme.onPrimary
                )
            ) {
                Text("Lưu", style = MaterialTheme.typography.labelLarge)
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Hủy", style = MaterialTheme.typography.labelLarge)
            }
        },
        containerColor = MaterialTheme.colorScheme.surface,
        shape = RoundedCornerShape(16.dp)
    )
}

@Composable
fun AddLocationDialog(authViewModel: AuthViewModel, onDismiss: () -> Unit) {
    var address by rememberSaveable { mutableStateOf("") }
    var suggestions by remember { mutableStateOf<List<Suggestion>>(emptyList()) }
    var city by rememberSaveable { mutableStateOf("") }
    var district by rememberSaveable { mutableStateOf("") }
    var ward by rememberSaveable { mutableStateOf("") }
    var latitude by remember { mutableStateOf<Double?>(null) }
    var longitude by remember { mutableStateOf<Double?>(null) }
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    val debounceSearch = remember {
        debounce<String>(300) { query ->
            if (query.length >= 2) {
                authViewModel.searchAddress(query) { result ->
                    suggestions = result
                }
            } else {
                suggestions = emptyList()
            }
        }
    }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                text = "Thêm địa chỉ",
                style = MaterialTheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold)
            )
        },
        text = {
            Column {
                OutlinedTextField(
                    value = address,
                    onValueChange = {
                        address = it
                        debounceSearch(it)
                    },
                    label = { Text("Địa chỉ") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )

                if (suggestions.isNotEmpty()) {
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .heightIn(max = 200.dp),
                        shape = RoundedCornerShape(8.dp),
                        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
                    ) {
                        Column(
                            modifier = Modifier.verticalScroll(rememberScrollState())
                        ) {
                            suggestions.forEach { suggestion ->
                                Row(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .clickable {
                                            address = suggestion.description
                                            city = suggestion.compound?.province ?: ""
                                            district = suggestion.compound?.district ?: ""
                                            ward = suggestion.compound?.commune ?: ""
                                            authViewModel.getCoordinates(suggestion.place_id) { lat, lng ->
                                                latitude = lat
                                                longitude = lng
                                            }
                                            suggestions = emptyList()
                                        }
                                        .padding(12.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Text(
                                        text = "📍",
                                        modifier = Modifier.padding(end = 8.dp)
                                    )
                                    Text(
                                        text = suggestion.description,
                                        style = MaterialTheme.typography.bodyMedium
                                    )
                                }
                                if (suggestions.last() != suggestion) {
                                    Divider(
                                        color = MaterialTheme.colorScheme.outline.copy(alpha = 0.2f)
                                    )
                                }
                            }
                        }
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))
                OutlinedTextField(
                    value = city,
                    onValueChange = { city = it },
                    label = { Text("Tỉnh/Thành phố") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )
                Spacer(modifier = Modifier.height(12.dp))
                OutlinedTextField(
                    value = district,
                    onValueChange = { district = it },
                    label = { Text("Quận/Huyện") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )
                Spacer(modifier = Modifier.height(12.dp))
                OutlinedTextField(
                    value = ward,
                    onValueChange = { ward = it },
                    label = { Text("Phường/Xã") },
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(12.dp),
                    textStyle = MaterialTheme.typography.bodyMedium
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    if (latitude != null && longitude != null && address.isNotBlank()) {
                        authViewModel.addLocation(
                            latitude = latitude!!,
                            longitude = longitude!!,
                            address = address,
                            type = "" // Type removed from UI as per simplification
                        )
                        onDismiss()
                    } else {
                        Toast.makeText(context, "Vui lòng chọn địa chỉ hợp lệ", Toast.LENGTH_SHORT).show()
                    }
                },
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    contentColor = MaterialTheme.colorScheme.onPrimary
                )
            ) {
                Text("Thêm", style = MaterialTheme.typography.labelLarge)
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Hủy", style = MaterialTheme.typography.labelLarge)
            }
        },
        containerColor = MaterialTheme.colorScheme.surface,
        shape = RoundedCornerShape(16.dp)
    )
}

// Debounce function
fun <T> debounce(delayMs: Long, action: (T) -> Unit): (T) -> Unit {
    var lastJob: Job? = null
    return { param: T ->
        lastJob?.cancel()
        lastJob = CoroutineScope(Dispatchers.Main).launch {
            delay(delayMs)
            action(param)
        }
    }
}

fun Uri.toFile(context: android.content.Context): File? {
    return try {
        val inputStream = context.contentResolver.openInputStream(this)
        val file = File(context.cacheDir, "avatar_${System.currentTimeMillis()}.jpg")
        FileOutputStream(file).use { outputStream ->
            inputStream?.copyTo(outputStream) ?: throw IllegalStateException("Input stream is null")
        }
        file
    } catch (e: Exception) {
        Log.e(TAG, "Error converting Uri to File", e)
        null
    }
}