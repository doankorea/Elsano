@file:OptIn(ExperimentalMaterial3Api::class)

package com.vn.elsanobooking.presentation.screen

import android.content.Intent
import android.net.Uri
import android.util.Log
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Error
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.preference.PreferenceManager
import com.vn.elsanobooking.R
import com.vn.elsanobooking.config.Constants
import com.vn.elsanobooking.data.api.RetrofitInstance
import com.vn.elsanobooking.data.api.VnpayDirectClient
import com.vn.elsanobooking.data.models.AppointmentResponse
import com.vn.elsanobooking.data.models.ReviewCreateRequest
import com.vn.elsanobooking.data.models.ReviewResponse
import com.vn.elsanobooking.data.models.VnpayPaymentRequest
import com.vn.elsanobooking.presentation.components.StatusChip
import com.vn.elsanobooking.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import retrofit2.HttpException
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.experimental.ExperimentalTypeInference

enum class AppointmentFilter {
    UPCOMING, COMPLETED, CANCELLED, ALL
}

@OptIn(ExperimentalMaterial3Api::class, ExperimentalTypeInference::class)
@Composable
fun ScheduleScreen(
    modifier: Modifier = Modifier,
    onNavigateToChat: (Int) -> Unit = {}
) {
    val context = LocalContext.current
    val preferences = PreferenceManager.getDefaultSharedPreferences(context)
    val userId = preferences.getInt("userId", -1)

    val coroutineScope = rememberCoroutineScope()
    
    // Sử dụng rememberSaveable để lưu trữ dữ liệu qua các lần recomposition
    var appointments by rememberSaveable { mutableStateOf<List<AppointmentResponse>>(emptyList()) }
    var isLoading by rememberSaveable { mutableStateOf(false) }
    var error by rememberSaveable { mutableStateOf<String?>(null) }
    var selectedFilter by rememberSaveable { mutableStateOf(AppointmentFilter.UPCOMING) }
    var selectedAppointment by remember { mutableStateOf<AppointmentResponse?>(null) }
    var showAppointmentDetail by rememberSaveable { mutableStateOf(false) }
    var showPaymentResultDialog by remember { mutableStateOf(false) }
    var paymentResultSuccess by remember { mutableStateOf(false) }
    var paymentResultMessage by remember { mutableStateOf("") }
    
    // Sử dụng LaunchedEffect với key1 = userId để chỉ load dữ liệu khi userId thay đổi
    LaunchedEffect(userId) {
        if (userId != -1 && appointments.isEmpty()) {
            try {
                isLoading = true
                val response = RetrofitInstance.bookingApi.getUserAppointments(userId)
                if (response.success) {
                    appointments = response.data ?: emptyList()
                } else {
                    error = response.message
                }
            } catch (e: Exception) {
                error = e.message
                Log.e("ScheduleScreen", "Error loading appointments: ${e.message}", e)
            } finally {
                isLoading = false
            }
        }
    }

    // Định nghĩa lại hàm refreshAppointments như một composable state
    val refreshAppointments: () -> Unit = remember {
        {
            coroutineScope.launch {
                try {
                    isLoading = true
                    val response = RetrofitInstance.bookingApi.getUserAppointments(userId)
                    if (response.success) {
                        appointments = response.data ?: emptyList()
                        error = null
                    } else {
                        error = response.message
                    }
                } catch (e: Exception) {
                    error = e.message
                    Log.e("ScheduleScreen", "Error refreshing appointments: ${e.message}", e)
                } finally {
                    isLoading = false
                }
            }
        }
    }

    // Format dates
    val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())

    // Sort and filter appointments
    val filteredAppointments = remember(appointments, selectedFilter) {
        when (selectedFilter) {
            AppointmentFilter.UPCOMING -> appointments.filter {
                it.status == "Pending" || it.status == "Confirmed"
            }.sortedBy {
                try {
                    dateFormat.parse(it.appointmentDate)?.time ?: Long.MAX_VALUE
                } catch (e: Exception) {
                    Log.e("ScheduleScreen", "Error parsing date: ${e.message}", e)
                    Long.MAX_VALUE
                }
            }
            AppointmentFilter.COMPLETED -> appointments.filter {
                it.status == "Completed"
            }.sortedByDescending {
                try {
                    dateFormat.parse(it.appointmentDate)?.time ?: 0
                } catch (e: Exception) {
                    Log.e("ScheduleScreen", "Error parsing date: ${e.message}", e)
                    0
                }
            }
            AppointmentFilter.CANCELLED -> appointments.filter {
                it.status == "Cancelled"
            }.sortedByDescending {
                try {
                    dateFormat.parse(it.appointmentDate)?.time ?: 0
                } catch (e: Exception) {
                    Log.e("ScheduleScreen", "Error parsing date: ${e.message}", e)
                    0
                }
            }
            AppointmentFilter.ALL -> appointments.sortedByDescending {
                try {
                    dateFormat.parse(it.appointmentDate)?.time ?: 0
                } catch (e: Exception) {
                    Log.e("ScheduleScreen", "Error parsing date: ${e.message}", e)
                    0
                }
            }
        }
    }

    if (showAppointmentDetail && selectedAppointment != null) {
        AppointmentDetailSheet(
            appointment = selectedAppointment!!,
            onDismiss = {
                showAppointmentDetail = false
                refreshAppointments()
            },
            onNavigateToChat = onNavigateToChat,
            onPaymentComplete = { success, message ->
                showPaymentResultDialog = true
                paymentResultSuccess = success
                paymentResultMessage = message
                refreshAppointments()
            },
            refreshAppointments = refreshAppointments
        )
    }

    // Dialog hiển thị kết quả thanh toán
    if (showPaymentResultDialog) {
        AlertDialog(
            onDismissRequest = {
                showPaymentResultDialog = false
                if (paymentResultSuccess) {
                    showAppointmentDetail = false
                }
            },
            title = {
                Text(
                    text = if (paymentResultSuccess) "Thanh toán thành công" else "Thông báo",
                    fontWeight = FontWeight.Bold,
                    fontFamily = poppinsFontFamily
                )
            },
            text = {
                Column {
                    Text(
                        text = paymentResultMessage,
                        fontFamily = poppinsFontFamily
                    )
                    if (paymentResultSuccess) {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Lịch hẹn của bạn đã được xác nhận.",
                            fontWeight = FontWeight.Medium,
                            color = GreenStatus,
                            fontFamily = poppinsFontFamily
                        )
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        showPaymentResultDialog = false
                        if (paymentResultSuccess) {
                            showAppointmentDetail = false
                        }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (paymentResultSuccess) GreenStatus else BluePrimary
                    )
                ) {
                    Text("OK", fontFamily = poppinsFontFamily)
                }
            }
        )
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        "Lịch hẹn của tôi",
                        fontFamily = poppinsFontFamily,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            )
        }
    ) { paddingValues ->
        Box(
            modifier = modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(bottom = 16.dp)
            ) {
                // Filter tabs
                item {
                    LazyRow(
                        modifier = Modifier.padding(horizontal = 16.dp),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        items(AppointmentFilter.values()) { filter ->
                            CategorySchedule(
                                title = when (filter) {
                                    AppointmentFilter.UPCOMING -> "Sắp tới"
                                    AppointmentFilter.COMPLETED -> "Đã hoàn thành"
                                    AppointmentFilter.CANCELLED -> "Đã hủy"
                                    AppointmentFilter.ALL -> "Tất cả"
                                },
                                isSelected = filter == selectedFilter,
                                onClick = { selectedFilter = filter }
                            )
                        }
                    }
                }

                // Loading state
                if (isLoading) {
                    item {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(32.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            CircularProgressIndicator()
                        }
                    }
                }
                // Error state
                else if (error != null) {
                    item {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(32.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = error ?: "Đã xảy ra lỗi",
                                color = Color.Red,
                                textAlign = TextAlign.Center
                            )
                        }
                    }
                }
                // Empty state
                else if (filteredAppointments.isEmpty()) {
                    item {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(32.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = when (selectedFilter) {
                                    AppointmentFilter.UPCOMING -> "Bạn không có lịch hẹn sắp tới"
                                    AppointmentFilter.COMPLETED -> "Bạn chưa có lịch hẹn nào hoàn thành"
                                    AppointmentFilter.CANCELLED -> "Bạn chưa có lịch hẹn nào bị hủy"
                                    AppointmentFilter.ALL -> "Bạn chưa có lịch hẹn nào"
                                },
                                textAlign = TextAlign.Center,
                                color = Color.Gray
                            )
                        }
                    }
                }
                // Appointment list
                else {
                    items(filteredAppointments) { appointment ->
                        AppointmentCard(
                            appointment = appointment,
                            onClick = {
                                selectedAppointment = appointment
                                showAppointmentDetail = true
                            },
                            modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun CategorySchedule(
    title: String,
    isSelected: Boolean = false,
    onClick: () -> Unit
) {
    Surface(
        modifier = Modifier
            .wrapContentWidth()
            .padding(top = 20.dp)
            .clickable(onClick = onClick),
        color = if (isSelected) Color(0xFF63B4FF).copy(alpha = 0.1f) else Color.Transparent,
        shape = RoundedCornerShape(100.dp)
    ) {
        Text(
            modifier = Modifier.padding(vertical = 16.dp, horizontal = 16.dp),
            text = title,
            fontFamily = poppinsFontFamily,
            color = if (isSelected) BluePrimary else Color.Gray,
            fontWeight = FontWeight.Medium,
            fontSize = 16.sp
        )
    }
}

@Composable
fun AppointmentCard(
    appointment: AppointmentResponse,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
    val displayFormat = SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.getDefault())
    val currencyFormat = NumberFormat.getCurrencyInstance(Locale("vi", "VN"))

    val appointmentDate = try {
        displayFormat.format(dateFormat.parse(appointment.appointmentDate)!!)
    } catch (e: Exception) {
        Log.e("ScheduleScreen", "Error parsing date: ${e.message}", e)
        appointment.appointmentDate
    }

    Card(
        modifier = modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = appointment.artistName,
                    fontWeight = FontWeight.Bold,
                    fontSize = 18.sp,
                    fontFamily = poppinsFontFamily
                )
                StatusChip(status = appointment.status)
            }

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = appointment.service.serviceName,
                fontWeight = FontWeight.Normal,
                fontSize = 16.sp,
                color = Color.DarkGray,
                fontFamily = poppinsFontFamily
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "Thời gian: $appointmentDate (${appointment.service.duration} phút)",
                fontSize = 14.sp,
                color = Color.Gray,
                fontFamily = poppinsFontFamily
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = "Địa điểm: ${appointment.location.address}",
                fontSize = 14.sp,
                color = Color.Gray,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                fontFamily = poppinsFontFamily
            )

            Spacer(modifier = Modifier.height(8.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Giá: ${currencyFormat.format(appointment.service.price)}",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.Black,
                    fontFamily = poppinsFontFamily
                )

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    appointment.payment?.let { payment ->
                        when (payment.paymentStatus) {
                            "Pending" -> {
                                Text(
                                    "Chưa thanh toán",
                                    color = OrangeStatus,
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Medium,
                                    fontFamily = poppinsFontFamily
                                )
                            }
                            "Completed" -> {
                                Text(
                                    "Đã thanh toán",
                                    color = GreenStatus,
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Medium,
                                    fontFamily = poppinsFontFamily
                                )
                            }
                            "Failed" -> {
                                Text(
                                    "Thanh toán thất bại",
                                    color = RedStatus,
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Medium,
                                    fontFamily = poppinsFontFamily
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppointmentDetailSheet(
    appointment: AppointmentResponse,
    onDismiss: () -> Unit,
    onNavigateToChat: (Int) -> Unit,
    onPaymentComplete: (Boolean, String) -> Unit,
    refreshAppointments: () -> Unit
) {
    val context = LocalContext.current
    val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
    val displayFormat = SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.getDefault())
    val currencyFormat = NumberFormat.getCurrencyInstance(Locale("vi", "VN"))
    val coroutineScope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }
    var isLoading by remember { mutableStateOf(false) }
    var showCancelDialog by remember { mutableStateOf(false) }
    var showResultDialog by remember { mutableStateOf(false) }
    var showRatingDialog by remember { mutableStateOf(false) }
    var showReviewResultDialog by remember { mutableStateOf(false) }
    var reviewResultMessage by remember { mutableStateOf("") }
    var reviewResultSuccess by remember { mutableStateOf(false) }
    var resultMessage by remember { mutableStateOf("") }
    var resultSuccess by remember { mutableStateOf(false) }
    var paymentUrlToOpen by remember { mutableStateOf<String?>(null) }
    var isPaymentProcessing by remember { mutableStateOf(false) }
    var lastProcessedAppointmentId by remember { mutableStateOf<Int?>(null) }

    // Launcher for opening URLs
    val urlLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult()
    ) {
        // Handle the result if needed
        isPaymentProcessing = false
        paymentUrlToOpen = null
    }

    // Effect to handle opening payment URL
    LaunchedEffect(paymentUrlToOpen) {
        paymentUrlToOpen?.let { url ->
            try {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                urlLauncher.launch(intent)
            } catch (e: Exception) {
                Log.e("PaymentDebug", "Error opening payment URL: ${e.message}", e)
                onPaymentComplete(false, "Không thể mở trang thanh toán. Vui lòng thử lại sau.")
                paymentUrlToOpen = null
                isPaymentProcessing = false
            }
        }
    }

    // Format dates
    val appointmentDate = try {
        displayFormat.format(dateFormat.parse(appointment.appointmentDate)!!)
    } catch (e: Exception) {
        appointment.appointmentDate
    }

    val endTime = try {
        val date = dateFormat.parse(appointment.appointmentDate)!!
        val calendar = Calendar.getInstance()
        calendar.time = date
        calendar.add(Calendar.MINUTE, appointment.service.duration)
        displayFormat.format(calendar.time)
    } catch (e: Exception) {
        "Không xác định"
    }

    // Determine if appointment can be cancelled
    val canCancel = appointment.status == "Pending" || appointment.status == "Confirmed"

    ModalBottomSheet(
        onDismissRequest = onDismiss,
        shape = RoundedCornerShape(topStart = 16.dp, topEnd = 16.dp)
    ) {
        LazyColumn(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp)
                .padding(bottom = 32.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // Header
            item {
                Text(
                    text = "Chi tiết lịch hẹn",
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold,
                    fontFamily = poppinsFontFamily,
                    modifier = Modifier.padding(top = 16.dp)
                )
            }

            // Status Section
            item {
                Spacer(modifier = Modifier.height(16.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        text = "Trạng thái",
                        fontSize = 14.sp,
                        color = Color.Gray,
                        fontFamily = poppinsFontFamily
                    )
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        StatusChip(status = appointment.status)

                        if (appointment.payment?.paymentStatus == "Pending") {
                            Spacer(modifier = Modifier.width(8.dp))
                            Icon(
                                painter = painterResource(id = R.drawable.ic_payment),
                                contentDescription = "Payment Required",
                                tint = OrangeStatus,
                                modifier = Modifier.size(16.dp)
                            )
                            Text(
                                "Chưa thanh toán",
                                color = OrangeStatus,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium,
                                modifier = Modifier.padding(start = 4.dp)
                            )
                        }
                    }
                }
            }

            // Appointment Details
            item {
                Divider(modifier = Modifier.padding(vertical = 12.dp))
                DetailRow(label = "Nghệ sĩ", value = appointment.artistName)
                DetailRow(label = "Dịch vụ", value = appointment.service.serviceName)
                DetailRow(label = "Thời gian bắt đầu", value = appointmentDate)
                DetailRow(label = "Thời gian kết thúc", value = endTime)
                DetailRow(label = "Thời lượng", value = "${appointment.service.duration} phút")
                DetailRow(label = "Địa điểm", value = appointment.location.address)
                DetailRow(label = "Giá dịch vụ", value = currencyFormat.format(appointment.service.price))
            }

            // Action Buttons (Direction and Chat)
            item {
                Spacer(modifier = Modifier.height(8.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    // Nút chỉ đường
                    OutlinedButton(
                        onClick = {
                            try {
                                // Thử sử dụng tọa độ nếu có
                                if (appointment.location.latitude != 0.0 && appointment.location.longitude != 0.0) {
                                    val uri = Uri.parse("google.navigation:q=${appointment.location.latitude},${appointment.location.longitude}")
                                    val mapIntent = Intent(Intent.ACTION_VIEW, uri)
                                    mapIntent.setPackage("com.google.android.apps.maps")

                                    // Kiểm tra xem có ứng dụng Maps không
                                    if (mapIntent.resolveActivity(context.packageManager) != null) {
                                        context.startActivity(mapIntent)
                                    } else {
                                        // Fallback dùng browser
                                        val browserUri = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=${appointment.location.latitude},${appointment.location.longitude}")
                                        val browserIntent = Intent(Intent.ACTION_VIEW, browserUri)
                                        context.startActivity(browserIntent)
                                    }
                                } else {
                                    // Nếu không có tọa độ, dùng địa chỉ text
                                    val uri = Uri.parse("geo:0,0?q=" + Uri.encode(appointment.location.address ?: ""))
                                    val mapIntent = Intent(Intent.ACTION_VIEW, uri)
                                    mapIntent.setPackage("com.google.android.apps.maps")

                                    if (mapIntent.resolveActivity(context.packageManager) != null) {
                                        context.startActivity(mapIntent)
                                    } else {
                                        val browserUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=" + Uri.encode(appointment.location.address ?: ""))
                                        val browserIntent = Intent(Intent.ACTION_VIEW, browserUri)
                                        context.startActivity(browserIntent)
                                    }
                                }
                            } catch (e: Exception) {
                                Toast.makeText(context, "Không thể mở bản đồ: ${e.message}", Toast.LENGTH_SHORT).show()
                            }
                        },
                        modifier = Modifier.weight(1f),
                        border = BorderStroke(1.dp, BluePrimary),
                        colors = ButtonDefaults.outlinedButtonColors(contentColor = BluePrimary)
                    ) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_directions),
                            contentDescription = "Directions",
                            tint = BluePrimary,
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Chỉ đường", fontFamily = poppinsFontFamily)
                    }

                    // Nút nhắn tin với artist
                    OutlinedButton(
                        onClick = {
                            // Điều hướng đến trang chat với artist
                            onNavigateToChat(appointment.artistId)
                        },
                        modifier = Modifier.weight(1f),
                        border = BorderStroke(1.dp, Color(0xFF4CAF50)),
                        colors = ButtonDefaults.outlinedButtonColors(contentColor = Color(0xFF4CAF50))
                    ) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_bottom_chat),
                            contentDescription = "Chat",
                            tint = Color(0xFF4CAF50),
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            "Nhắn tin với ${appointment.artistName.split(" ").lastOrNull() ?: "nhà cung cấp"}",
                            fontFamily = poppinsFontFamily,
                            fontSize = 13.sp,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis
                        )
                    }
                }
            }

            // Payment Information
            item {
                appointment.payment?.let { payment ->
                    Divider(modifier = Modifier.padding(vertical = 12.dp))
                    Text(
                        text = "Thông tin thanh toán",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        fontFamily = poppinsFontFamily
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    DetailRow(label = "Phương thức", value = payment.paymentMethod)
                    DetailRow(
                        label = "Trạng thái",
                        value = when (payment.paymentStatus) {
                            "Completed" -> "Đã thanh toán"
                            "Pending" -> "Chờ thanh toán"
                            "Cancelled" -> "Đã hủy"
                            "Failed" -> "Thanh toán thất bại"
                            else -> payment.paymentStatus
                        },
                        valueColor = when (payment.paymentStatus) {
                            "Completed" -> GreenStatus
                            "Pending" -> OrangeStatus
                            "Cancelled", "Failed" -> RedStatus
                            else -> Color.Black
                        }
                    )
                    DetailRow(label = "Số tiền", value = currencyFormat.format(payment.amount))
                }
            }

            // Cancel and Payment Buttons
            item {
                Spacer(modifier = Modifier.height(16.dp))
                if (appointment.status == "Pending" || appointment.status == "Confirmed") {
                    if (appointment.payment?.paymentStatus == "Pending") {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            // Nút hủy lịch
                            OutlinedButton(
                                onClick = { showCancelDialog = true },
                                modifier = Modifier.weight(1f),
                                colors = ButtonDefaults.outlinedButtonColors(contentColor = RedStatus),
                                border = BorderStroke(1.dp, RedStatus)
                            ) {
                                Text(
                                    "Hủy lịch hẹn",
                                    fontSize = 16.sp,
                                    fontWeight = FontWeight.Medium
                                )
                            }

                            // Nút thanh toán
                            Button(
                                onClick = {
                                    coroutineScope.launch {
                                        try {
                                            isLoading = true
                                            val paymentUrl = getPaymentUrl(
                                                appointmentId = appointment.appointmentId,
                                                amount = appointment.payment?.amount ?: 0.0
                                            )

                                            if (paymentUrl != null) {
                                                Log.d("PaymentDebug", "Opening payment URL: $paymentUrl")
                                                paymentUrlToOpen = paymentUrl
                                                isPaymentProcessing = true
                                                lastProcessedAppointmentId = appointment.appointmentId
                                            } else {
                                                onPaymentComplete(false, "Không lấy được link thanh toán. Vui lòng thử lại sau.")
                                            }
                                        } catch (e: Exception) {
                                            Log.e("PaymentDebug", "Lỗi khi xử lý thanh toán: ${e.message}", e)
                                            onPaymentComplete(false, "Lỗi khi xử lý thanh toán: ${e.message}")
                                        } finally {
                                            isLoading = false
                                        }
                                    }
                                },
                                modifier = Modifier
                                    .height(54.dp)
                                    .weight(1f),
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = Color(0xFF4CAF50),
                                    contentColor = Color.White
                                ),
                                shape = RoundedCornerShape(8.dp),
                                enabled = !isLoading,
                                elevation = ButtonDefaults.buttonElevation(
                                    defaultElevation = 4.dp,
                                    pressedElevation = 8.dp
                                )
                            ) {
                                if (isLoading) {
                                    CircularProgressIndicator(
                                        modifier = Modifier.size(24.dp),
                                        color = Color.White,
                                        strokeWidth = 2.dp
                                    )
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Text("Đang xử lý...", color = Color.White)
                                } else {
                                    Row(
                                        verticalAlignment = Alignment.CenterVertically,
                                        horizontalArrangement = Arrangement.Center,
                                        modifier = Modifier.fillMaxWidth()
                                    ) {
                                        Icon(
                                            painter = painterResource(id = R.drawable.ic_payment),
                                            contentDescription = "Payment Icon",
                                            tint = Color.White,
                                            modifier = Modifier.size(24.dp)
                                        )
                                        Spacer(modifier = Modifier.width(12.dp))
                                        Text(
                                            "Thanh toán",
                                            fontSize = 18.sp,
                                            fontWeight = FontWeight.Bold,
                                            color = Color.White
                                        )
                                    }
                                }
                            }
                        }
                    } else {
                        // Nếu không cần thanh toán, chỉ hiển thị nút hủy
                        OutlinedButton(
                            onClick = { showCancelDialog = true },
                            modifier = Modifier.fillMaxWidth(),
                            colors = ButtonDefaults.outlinedButtonColors(contentColor = RedStatus),
                            border = BorderStroke(1.dp, RedStatus)
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_arrow_back),
                                contentDescription = "Cancel",
                                tint = RedStatus,
                                modifier = Modifier.size(20.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                "Hủy lịch hẹn",
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }
                    }
                }
            }

            // Rating Button
            item {
                if (appointment.status == "Completed") {
                    Spacer(modifier = Modifier.height(16.dp))
                    Button(
                        onClick = { 
                            if (!appointment.isReviewed) {
                                showRatingDialog = true 
                            }
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(54.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = if (appointment.isReviewed) Color.Gray else Color(0xFF4CAF50),
                            contentColor = Color.White
                        ),
                        shape = RoundedCornerShape(8.dp),
                        enabled = !appointment.isReviewed
                    ) {
                        Icon(
                            imageVector = if (appointment.isReviewed) Icons.Filled.Check else Icons.Filled.Star,
                            contentDescription = if (appointment.isReviewed) "Reviewed" else "Rating",
                            tint = Color.White,
                            modifier = Modifier.size(24.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = if (appointment.isReviewed) "Đã đánh giá" else "Đánh giá nghệ sĩ",
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                    }
                }
            }

            // Bottom Spacing
            item {
                Spacer(modifier = Modifier.height(32.dp))
            }
        }
    }

    // Rating Dialog
    if (showRatingDialog) {
        RatingDialog(
            artistName = appointment.artistName,
            appointmentId = appointment.appointmentId,
            onDismiss = { showRatingDialog = false },
            onRatingSubmitted = { success, message ->
                showRatingDialog = false
                showReviewResultDialog = true
                reviewResultSuccess = success
                reviewResultMessage = message
            },
            refreshAppointments = refreshAppointments
        )
    }

    // Review Result Dialog
    if (showReviewResultDialog) {
        AlertDialog(
            onDismissRequest = {
                showReviewResultDialog = false
                if (reviewResultSuccess) {
                    onDismiss() // Close the appointment detail sheet if review was successful
                }
            },
            title = {
                Text(
                    text = if (reviewResultSuccess) "Đánh giá thành công" else "Thông báo",
                    fontWeight = FontWeight.Bold,
                    fontFamily = poppinsFontFamily
                )
            },
            text = {
                Column {
                    Text(
                        text = reviewResultMessage,
                        fontFamily = poppinsFontFamily
                    )
                    if (reviewResultSuccess) {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Cảm ơn bạn đã đánh giá dịch vụ của chúng tôi!",
                            fontWeight = FontWeight.Medium,
                            color = GreenStatus,
                            fontFamily = poppinsFontFamily
                        )
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        showReviewResultDialog = false
                        if (reviewResultSuccess) {
                            onDismiss() // Close the appointment detail sheet if review was successful
                        }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (reviewResultSuccess) GreenStatus else BluePrimary
                    )
                ) {
                    Text("OK", fontFamily = poppinsFontFamily)
                }
            }
        )
    }

    // Cancel Dialog
    if (showCancelDialog) {
        AlertDialog(
            onDismissRequest = { showCancelDialog = false },
            title = {
                Text(
                    text = "Xác nhận hủy lịch hẹn",
                    fontWeight = FontWeight.Bold,
                    fontFamily = poppinsFontFamily
                )
            },
            text = {
                Text(
                    text = "Bạn có chắc chắn muốn hủy lịch hẹn này không?",
                    fontFamily = poppinsFontFamily
                )
            },
            confirmButton = {
                Button(
                    onClick = {
                        coroutineScope.launch {
                            try {
                                isLoading = true
                                val response = RetrofitInstance.bookingApi.cancelAppointment(appointment.appointmentId)
                                if (response.success) {
                                    showCancelDialog = false
                                    onDismiss()
                                    refreshAppointments()
                                } else {
                                    val message = response.message ?: "Không thể hủy lịch hẹn"
                                    resultMessage = message
                                    resultSuccess = false
                                    showResultDialog = true
                                }
                            } catch (e: Exception) {
                                val errorMessage = when (e) {
                                    is HttpException -> {
                                        val errorBody = e.response()?.errorBody()?.string()
                                        Log.e("CancelAppointment", "HTTP error: ${e.code()}, Body: $errorBody")
                                        when (e.code()) {
                                            500 -> "Không thể hủy lịch hẹn lúc này. Vui lòng thử lại sau."
                                            else -> errorBody ?: "Lỗi khi hủy lịch hẹn: ${e.message()}"
                                        }
                                    }
                                    else -> {
                                        Log.e("CancelAppointment", "Error cancelling appointment", e)
                                        "Lỗi khi hủy lịch hẹn: ${e.message}"
                                    }
                                }
                                resultMessage = errorMessage
                                resultSuccess = false
                                showResultDialog = true
                            } finally {
                                isLoading = false
                            }
                        }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = RedStatus
                    )
                ) {
                    Text("Hủy lịch hẹn", fontFamily = poppinsFontFamily)
                }
            },
            dismissButton = {
                OutlinedButton(
                    onClick = { showCancelDialog = false }
                ) {
                    Text("Đóng", fontFamily = poppinsFontFamily)
                }
            }
        )
    }

    // Result Dialog
    if (showResultDialog) {
        AlertDialog(
            onDismissRequest = { showResultDialog = false },
            title = {
                Text(
                    text = if (resultSuccess) "Thành công" else "Thông báo",
                    fontWeight = FontWeight.Bold,
                    fontFamily = poppinsFontFamily
                )
            },
            text = {
                Text(
                    text = resultMessage,
                    fontFamily = poppinsFontFamily
                )
            },
            confirmButton = {
                Button(
                    onClick = { showResultDialog = false },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (resultSuccess) GreenStatus else BluePrimary
                    )
                ) {
                    Text("OK", fontFamily = poppinsFontFamily)
                }
            }
        )
    }

    // Hiển thị snackbar
    Box(modifier = Modifier.fillMaxSize()) {
        SnackbarHost(
            hostState = snackbarHostState,
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .padding(16.dp)
        )
    }
}

@Composable
fun DetailRow(
    label: String,
    value: String,
    valueColor: Color = Color.Black
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = label,
            fontSize = 14.sp,
            color = Color.Gray,
            fontFamily = poppinsFontFamily
        )
        Text(
            text = value,
            fontSize = 14.sp,
            color = valueColor,
            fontWeight = FontWeight.Medium,
            fontFamily = poppinsFontFamily
        )
    }
}

suspend fun getPaymentUrl(appointmentId: Int, amount: Double): String? {
    Log.d("PaymentDebug", "Getting payment URL for appointment $appointmentId with amount $amount")
    return try {
        val request = VnpayPaymentRequest(
            appointmentId = appointmentId,
            orderType = "other",
            amount = amount
        )
        Log.d("PaymentDebug", "Created payment request: $request")

        // Thử lấy payment URL bằng direct client trước
        var paymentUrl = VnpayDirectClient.getPaymentUrl(request)
        Log.d("PaymentDebug", "Direct client returned URL: $paymentUrl")

        // Nếu không thành công, thử dùng Retrofit API
        if (paymentUrl == null) {
            try {
                Log.d("PaymentDebug", "Trying Retrofit API...")
                val response = RetrofitInstance.vnpayApi.createVnpayUrl(request)
                val responseString = response.string()
                Log.d("PaymentDebug", "Retrofit API raw response: $responseString")

                paymentUrl = responseString

                // Validate URL format
                if (!responseString.startsWith("http")) {
                    Log.e("PaymentDebug", "Invalid URL format returned from Retrofit: $responseString")
                    // Thử trích xuất URL từ phản hồi bất thường
                    if (responseString.contains("http")) {
                        val urlRegex = "(https?://[^\\s\"'<>]+)".toRegex()
                        val match = urlRegex.find(responseString)
                        if (match != null) {
                            val extractedUrl = match.value
                            Log.d("PaymentDebug", "Extracted URL from response: $extractedUrl")
                            paymentUrl = extractedUrl
                        } else {
                            paymentUrl = null
                        }
                    } else {
                        paymentUrl = null
                    }
                }
            } catch (e: Exception) {
                Log.e("PaymentDebug", "Retrofit API error: ${e.message}", e)
                paymentUrl = null
            }
        }

        Log.d("PaymentDebug", "Final payment URL: $paymentUrl")
        paymentUrl
    } catch (e: Exception) {
        Log.e("PaymentDebug", "Error getting payment URL: ${e.message}", e)
        e.printStackTrace()
        null
    }
}
@Composable
fun RatingDialog(
    artistName: String,
    appointmentId: Int,
    onDismiss: () -> Unit,
    onRatingSubmitted: (Boolean, String) -> Unit,
    refreshAppointments: () -> Unit
) {
    var rating by remember { mutableStateOf(0) }
    var comment by remember { mutableStateOf("") }
    var isSubmitting by remember { mutableStateOf(false) }
    var resultMessage by remember { mutableStateOf("") }
    var resultSuccess by remember { mutableStateOf(false) }
    val coroutineScope = rememberCoroutineScope()

    Dialog(onDismissRequest = onDismiss) {
        Surface(
            shape = RoundedCornerShape(16.dp),
            color = MaterialTheme.colorScheme.surface,
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Header
                Text(
                    text = "Đánh giá dịch vụ",
                    style = MaterialTheme.typography.titleLarge.copy(
                        fontWeight = FontWeight.Bold,
                        fontFamily = poppinsFontFamily
                    ),
                    textAlign = TextAlign.Center
                )

                Text(
                    text = artistName,
                    style = MaterialTheme.typography.bodyMedium.copy(
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        fontFamily = poppinsFontFamily
                    ),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(top = 4.dp)
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Rating Stars
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.Center,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    repeat(5) { index ->
                        IconButton(
                            onClick = {
                                rating = index + 1
                                resultMessage = ""
                            },
                            modifier = Modifier.size(48.dp)
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Star,
                                contentDescription = "Sao ${index + 1}",
                                tint = if (index < rating) Color(0xFFFFC107) else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.3f),
                                modifier = Modifier.size(36.dp)
                            )
                        }
                    }
                }

                // Rating Label
                Text(
                    text = when (rating) {
                        0 -> "Chạm vào sao để đánh giá"
                        1 -> "Rất không hài lòng"
                        2 -> "Không hài lòng"
                        3 -> "Bình thường"
                        4 -> "Hài lòng"
                        else -> "Rất hài lòng"
                    },
                    style = MaterialTheme.typography.bodyMedium.copy(
                        color = if (rating > 0) Color(0xFFFFC107) else MaterialTheme.colorScheme.onSurfaceVariant,
                        fontFamily = poppinsFontFamily
                    ),
                    modifier = Modifier.padding(vertical = 8.dp)
                )

                // Result Message (Success or Error)
                if (resultMessage.isNotEmpty()) {
                    Surface(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 8.dp),
                        color = if (resultSuccess) GreenStatus.copy(alpha = 0.1f) else RedStatus.copy(alpha = 0.1f),
                        shape = RoundedCornerShape(8.dp)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = if (resultSuccess) Icons.Filled.Check else Icons.Filled.Error,
                                contentDescription = if (resultSuccess) "Success" else "Error",
                                tint = if (resultSuccess) GreenStatus else RedStatus,
                                modifier = Modifier.size(20.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                text = resultMessage,
                                style = MaterialTheme.typography.bodyMedium.copy(
                                    color = if (resultSuccess) GreenStatus else RedStatus,
                                    fontFamily = poppinsFontFamily
                                ),
                                modifier = Modifier.weight(1f)
                            )
                        }
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Comment TextField
                OutlinedTextField(
                    value = comment,
                    onValueChange = {
                        if (it.length <= 1000) {
                            comment = it
                            resultMessage = ""
                        }
                    },
                    label = { Text("Nhận xét của bạn (không bắt buộc)") },
                    placeholder = { Text("Chia sẻ trải nghiệm của bạn...") },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(120.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = TextFieldDefaults.outlinedTextFieldColors(
                        focusedBorderColor = MaterialTheme.colorScheme.primary,
                        unfocusedBorderColor = MaterialTheme.colorScheme.outline,
                        focusedLabelColor = MaterialTheme.colorScheme.primary,
                        errorBorderColor = RedStatus
                    ),
                    textStyle = MaterialTheme.typography.bodyMedium.copy(
                        fontFamily = poppinsFontFamily
                    ),
                    isError = comment.length > 1000
                )

                Text(
                    text = "${comment.length}/1000",
                    style = MaterialTheme.typography.bodySmall.copy(
                        color = if (comment.length > 1000) RedStatus else MaterialTheme.colorScheme.onSurfaceVariant,
                        fontFamily = poppinsFontFamily
                    ),
                    modifier = Modifier
                        .align(Alignment.End)
                        .padding(top = 4.dp)
                )

                Spacer(modifier = Modifier.height(24.dp))

                // Action Buttons
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    OutlinedButton(
                        onClick = onDismiss,
                        modifier = Modifier.weight(1f),
                        shape = RoundedCornerShape(8.dp),
                        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline),
                        colors = ButtonDefaults.outlinedButtonColors(
                            contentColor = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    ) {
                        Text(
                            text = "Hủy",
                            style = MaterialTheme.typography.labelLarge.copy(
                                fontFamily = poppinsFontFamily
                            )
                        )
                    }

                    Button(
                        onClick = {
                            if (rating == 0) {
                                resultMessage = "Vui lòng chọn số sao đánh giá"
                                resultSuccess = false
                                return@Button
                            }

                            if (comment.length > 1000) {
                                resultMessage = "Nội dung đánh giá không được vượt quá 1000 ký tự"
                                resultSuccess = false
                                return@Button
                            }

                            if (isSubmitting) return@Button

                            isSubmitting = true
                            coroutineScope.launch {
                                try {
                                    Log.d("RatingDialog", "Submitting review: appointmentId=$appointmentId, rating=$rating, comment=$comment")
                                    val response = RetrofitInstance.ratingApi.submitRating(
                                        ReviewCreateRequest(
                                            appointmentId = appointmentId,
                                            rating = rating,
                                            content = comment.trim()
                                        )
                                    )

                                    Log.d("RatingDialog", "API response: ${response.message}")
                                    resultMessage = response.message
                                    resultSuccess = response.message.isNotEmpty() && !response.message.contains("lỗi", ignoreCase = true)
                                    
                                    if (resultSuccess) {
                                        onRatingSubmitted(true, response.message)
                                        onDismiss()
                                        // Refresh appointments after successful rating
                                        refreshAppointments()
                                    } else {
                                        onRatingSubmitted(false, response.message)
                                    }
                                } catch (e: HttpException) {
                                    val errorBody = e.response()?.errorBody()?.string()
                                    Log.d("RatingDialog", "HTTP Exception: ${e.code()}, Error body: $errorBody")
                                    resultMessage = when (e.code()) {
                                        400 -> errorBody ?: "Đã có đánh giá cho lịch hẹn này"
                                        404 -> "Không tìm thấy lịch hẹn"
                                        else -> errorBody ?: "Lỗi: ${e.message()}"
                                    }
                                    resultSuccess = false
                                    onRatingSubmitted(false, resultMessage)
                                } catch (e: Exception) {
                                    Log.e("RatingDialog", "General Exception: ${e.message}", e)
                                    resultMessage = "Lỗi kết nối: Vui lòng thử lại sau"
                                    resultSuccess = false
                                    onRatingSubmitted(false, resultMessage)
                                } finally {
                                    isSubmitting = false
                                    Log.d("RatingDialog", "Submission process completed. isSubmitting set to false.")
                                }
                            }
                        },
                        modifier = Modifier.weight(1f),
                        enabled = !isSubmitting,
                        shape = RoundedCornerShape(8.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = MaterialTheme.colorScheme.primary,
                            contentColor = MaterialTheme.colorScheme.onPrimary
                        )
                    ) {
                        if (isSubmitting) {
                            CircularProgressIndicator(
                                modifier = Modifier.size(20.dp),
                                color = MaterialTheme.colorScheme.onPrimary,
                                strokeWidth = 2.dp
                            )
                        } else {
                            Text(
                                text = "Gửi đánh giá",
                                style = MaterialTheme.typography.labelLarge.copy(
                                    fontFamily = poppinsFontFamily
                                )
                            )
                        }
                    }
                }
            }
        }
    }
}