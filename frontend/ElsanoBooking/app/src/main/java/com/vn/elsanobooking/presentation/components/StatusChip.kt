package com.vn.elsanobooking.presentation.components

import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.vn.elsanobooking.ui.theme.*

@Composable
fun StatusChip(status: String) {
    val (backgroundColor, textColor) = when (status) {
        "Pending" -> Pair(OrangeStatus.copy(alpha = 0.2f), OrangeStatus)
        "Confirmed" -> Pair(BluePrimary.copy(alpha = 0.2f), BluePrimary)
        "Completed" -> Pair(GreenStatus.copy(alpha = 0.2f), GreenStatus)
        "Cancelled" -> Pair(RedStatus.copy(alpha = 0.2f), RedStatus)
        else -> Pair(Color.Gray.copy(alpha = 0.2f), Color.Gray)
    }

    Surface(
        shape = RoundedCornerShape(16.dp),
        color = backgroundColor
    ) {
        Text(
            text = when (status) {
                "Pending" -> "Đang chờ xác nhận"
                "Confirmed" -> "Đã xác nhận"
                "Completed" -> "Đã hoàn thành"
                "Cancelled" -> "Đã hủy"
                else -> status
            },
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 4.dp),
            color = textColor,
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium,
            fontFamily = poppinsFontFamily
        )
    }
} 