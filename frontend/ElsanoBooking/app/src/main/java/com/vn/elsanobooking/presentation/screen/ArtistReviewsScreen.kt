package com.vn.elsanobooking.presentation.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.vn.elsanobooking.R
import com.vn.elsanobooking.data.models.ReviewData
import com.vn.elsanobooking.data.models.RatingCount
import com.vn.elsanobooking.ui.theme.poppinsFontFamily
import com.vn.elsanobooking.viewModel.ReviewViewModel
import java.text.SimpleDateFormat
import java.util.*
import coil.compose.AsyncImage
import com.vn.elsanobooking.config.Constants

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ArtistReviewsScreen(
    artistId: Int,
    onBackClick: () -> Unit
) {
    val viewModel: ReviewViewModel = viewModel()
    val reviews by viewModel.artistReviews.collectAsState()
    val reviewStats by viewModel.reviewStats.collectAsState()
    val isLoading = viewModel.isLoading
    val error = viewModel.error
    val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault())
    val displayFormat = SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.getDefault())

    // Fetch reviews
    LaunchedEffect(artistId) {
        viewModel.getArtistReviews(artistId)
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        "Đánh giá",
                        fontFamily = poppinsFontFamily,
                        fontWeight = FontWeight.SemiBold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_arrow_back),
                            contentDescription = "Back"
                        )
                    }
                }
            )
        }
    ) { padding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            when {
                isLoading -> {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center)
                    )
                }
                error != null -> {
                    Text(
                        text = error,
                        color = Color.Red,
                        modifier = Modifier
                            .align(Alignment.Center)
                            .padding(16.dp)
                    )
                }
                reviews.isEmpty() -> {
                    Text(
                        text = "Chưa có đánh giá nào",
                        modifier = Modifier
                            .align(Alignment.Center)
                            .padding(16.dp)
                    )
                }
                else -> {
                    LazyColumn(
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = PaddingValues(16.dp),
                        verticalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        // Rating Summary
                        item {
                            reviewStats?.let { stats ->
                                RatingSummaryCard(
                                    averageRating = stats.averageRating,
                                    totalReviews = stats.totalReviews,
                                    ratingDistribution = stats.ratingDistribution
                                )
                            }
                        }

                        // Reviews List
                        items(reviews) { review ->
                            ReviewCard(review, dateFormat, displayFormat)
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun RatingSummaryCard(
    averageRating: Double,
    totalReviews: Int,
    ratingDistribution: List<RatingCount>
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(bottom = 16.dp),
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = String.format("%.1f", averageRating),
                fontSize = 48.sp,
                fontWeight = FontWeight.Bold,
                fontFamily = poppinsFontFamily
            )

            Row(
                modifier = Modifier.padding(vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                repeat(5) { index ->
                    Icon(
                        imageVector = Icons.Filled.Star,
                        contentDescription = null,
                        tint = if (index < averageRating) Color(0xFFFFC107) else Color.Gray,
                        modifier = Modifier.size(24.dp)
                    )
                }
            }

            Text(
                text = "$totalReviews đánh giá",
                fontSize = 16.sp,
                color = Color.Gray,
                fontFamily = poppinsFontFamily
            )

            Spacer(modifier = Modifier.height(16.dp))

            
        }
    }
}

@Composable
fun RatingBar(rating: Int, count: Int, percentage: Float) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = "$rating",
            fontSize = 14.sp,
            modifier = Modifier.width(24.dp),
            fontFamily = poppinsFontFamily
        )

        Icon(
            imageVector = Icons.Filled.Star,
            contentDescription = null,
            tint = Color(0xFFFFC107),
            modifier = Modifier
                .size(16.dp)
                .padding(horizontal = 4.dp)
        )

        Box(
            modifier = Modifier
                .weight(1f)
                .height(8.dp)
                .clip(RoundedCornerShape(4.dp))
                .background(Color.LightGray)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxHeight()
                    .fillMaxWidth(percentage)
                    .clip(RoundedCornerShape(4.dp))
                    .background(Color(0xFFFFC107))
            )
        }

        Text(
            text = count.toString(),
            fontSize = 14.sp,
            modifier = Modifier
                .padding(start = 8.dp)
                .width(32.dp),
            fontFamily = poppinsFontFamily
        )
    }
}

@Composable
fun ReviewCard(
    review: ReviewData,
    dateFormat: SimpleDateFormat,
    displayFormat: SimpleDateFormat
) {
    val reviewDate = try {
        displayFormat.format(dateFormat.parse(review.createdAt)!!)
    } catch (e: Exception) {
        review.createdAt
    }

    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // User Avatar
                Box(
                    modifier = Modifier
                        .size(40.dp)
                        .clip(CircleShape)
                        .background(Color.Gray)
                ) {
                    if (!review.userAvatar.isNullOrBlank()) {
                        AsyncImage(
                            model = "${Constants.BASE_URL}${review.userAvatar}?t=${System.currentTimeMillis()}",
                            contentDescription = "${review.userName}'s avatar",
                            modifier = Modifier.fillMaxSize(),
                            contentScale = ContentScale.Crop
                        )
                    }
                }

                Spacer(modifier = Modifier.width(12.dp))

                // User Info and Rating
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = review.displayName ?: review.userName ?: "",
                        fontWeight = FontWeight.Medium,
                        fontSize = 16.sp,
                        fontFamily = poppinsFontFamily
                    )

                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        repeat(5) { index ->
                            Icon(
                                imageVector = Icons.Filled.Star,
                                contentDescription = null,
                                tint = if (index < review.rating) Color(0xFFFFC107) else Color.LightGray,
                                modifier = Modifier.size(16.dp)
                            )
                        }
                        
                        Text(
                            text = reviewDate,
                            fontSize = 12.sp,
                            color = Color.Gray,
                            modifier = Modifier.padding(start = 8.dp),
                            fontFamily = poppinsFontFamily
                        )
                    }
                }
            }

            if (!review.content.isNullOrBlank()) {
                Text(
                    text = review.content,
                    fontSize = 14.sp,
                    modifier = Modifier.padding(top = 12.dp),
                    fontFamily = poppinsFontFamily
                )
            }
        }
    }
} 