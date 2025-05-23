package com.vn.elsanobooking.presentation.components

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil.compose.rememberAsyncImagePainter
import com.vn.elsanobooking.config.Constants
import com.vn.elsanobooking.data.models.Artist
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import coil.request.ImageRequest
import coil.size.Size

@Composable
fun NearbyMakeupArtistCard(
    artist: Artist,
    navController: NavController,
    userId: Int,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .clickable {
                navController.navigate("artist_detail/${artist.id}/$userId")
            },
        shape = RoundedCornerShape(8.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Placeholder for avatar
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(24.dp))
                    .background(Color.Gray)
            ){
                if (!artist.avatar.isNullOrBlank()) {
                    Image(
                        painter = rememberAsyncImagePainter(
                            model = ImageRequest.Builder(LocalContext.current)
                                .data("${Constants.BASE_URL}${artist.avatar}")
                                .size(Size.ORIGINAL)
                                .crossfade(true)
                                .build()
                        ),
                        contentDescription = "${artist.displayName ?: ""}'s avatar",
                        contentScale = ContentScale.Crop,
                        modifier = Modifier.fillMaxSize()
                    )
                }
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column {
                Text(
                    text = artist.displayName ?: "",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.Black
                )
                Text(
                    text = "Rating: ${artist.rating} (${artist.reviewsCount} reviews)",
                    fontSize = 14.sp,
                    color = Color.Gray
                )
                Text(
                    text = artist.address ?: "",
                    fontSize = 14.sp,
                    color = Color.Gray
                )
            }
        }
    }
}