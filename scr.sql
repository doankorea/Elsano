USE [master]
GO
/****** Object:  Database [makeup]    Script Date: 5/21/2025 12:13:01 PM ******/
CREATE DATABASE [makeup]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'makeup', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\makeup.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'makeup_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\makeup_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [makeup] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [makeup].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [makeup] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [makeup] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [makeup] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [makeup] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [makeup] SET ARITHABORT OFF 
GO
ALTER DATABASE [makeup] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [makeup] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [makeup] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [makeup] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [makeup] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [makeup] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [makeup] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [makeup] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [makeup] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [makeup] SET  ENABLE_BROKER 
GO
ALTER DATABASE [makeup] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [makeup] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [makeup] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [makeup] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [makeup] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [makeup] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [makeup] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [makeup] SET RECOVERY FULL 
GO
ALTER DATABASE [makeup] SET  MULTI_USER 
GO
ALTER DATABASE [makeup] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [makeup] SET DB_CHAINING OFF 
GO
ALTER DATABASE [makeup] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [makeup] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [makeup] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [makeup] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'makeup', N'ON'
GO
ALTER DATABASE [makeup] SET QUERY_STORE = ON
GO
ALTER DATABASE [makeup] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [makeup]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Appointments]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointments](	[appointment_id] [int] IDENTITY(1,1) NOT NULL,	[user_id] [int] NOT NULL,	[artist_id] [int] NULL,	[service_detail_id] [int] NOT NULL,	[appointment_date] [datetime] NOT NULL,	[status] [nvarchar](20) NOT NULL,	[location_id] [int] NULL,	[created_at] [datetime] NULL,	[updated_at] [datetime] NULL,
 CONSTRAINT [PK__Appointm__A50828FCB06E2574] PRIMARY KEY CLUSTERED 
(
	[appointment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](	[location_id] [int] IDENTITY(1,1) NOT NULL,	[latitude] [decimal](10, 8) NOT NULL,	[longitude] [decimal](11, 8) NOT NULL,	[address] [nvarchar](255) NOT NULL,	[type] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK__Location__771831EA93E49A09] PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MakeupArtists]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MakeupArtists](	[artist_id] [int] IDENTITY(1,1) NOT NULL,	[user_id] [int] NOT NULL,	[full_name] [nvarchar](100) NOT NULL,	[bio] [ntext] NULL,	[experience] [int] NULL,	[specialty] [nvarchar](100) NULL,	[is_available_at_home] [tinyint] NULL,	[rating] [decimal](3, 2) NULL,	[reviews_count] [int] NULL,	[is_active] [tinyint] NULL,	[location_id] [int] NULL,
 CONSTRAINT [PK__MakeupAr__6CD04001B1BDC0D9] PRIMARY KEY CLUSTERED 
(
	[artist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Messages]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Messages](	[message_id] [int] IDENTITY(1,1) NOT NULL,	[sender_id] [int] NOT NULL,	[receiver_id] [int] NOT NULL,	[message_content] [ntext] NOT NULL,	[message_timestamp] [datetime] NULL,	[is_read] [tinyint] NULL,
 CONSTRAINT [PK__Messages__0BBF6EE68E5E6D76] PRIMARY KEY CLUSTERED 
(
	[message_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](	[payment_id] [int] IDENTITY(1,1) NOT NULL,	[appointment_id] [int] NOT NULL,	[payment_method] [nvarchar](20) NOT NULL,	[amount] [decimal](10, 2) NOT NULL,	[payment_status] [nvarchar](20) NOT NULL,	[created_at] [datetime] NULL,
 CONSTRAINT [PK__Payments__ED1FC9EA2641BB32] PRIMARY KEY CLUSTERED 
(
	[payment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](	[review_id] [int] IDENTITY(1,1) NOT NULL,	[appointment_id] [int] NOT NULL,	[user_id] [int] NOT NULL,	[artist_id] [int] NOT NULL,	[rating] [int] NOT NULL,	[content] [ntext] NULL,	[created_at] [datetime] NULL,
 CONSTRAINT [PK__Reviews__60883D909C72057A] PRIMARY KEY CLUSTERED 
(
	[review_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleClaims]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_RoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[NormalizedName] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceDetails]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceDetails](
	[service_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[service_id] [int] NOT NULL,
	[artist_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[duration] [int] NOT NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK__ServiceD__8327FB05EADDA462] PRIMARY KEY CLUSTERED 
(
	[service_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](	[service_id] [int] IDENTITY(1,1) NOT NULL,	[service_name] [nvarchar](100) NOT NULL,	[description] [ntext] NULL,	[is_active] [tinyint] NULL,	[created_at] [datetime] NULL,	[MakeupArtistArtistId] [int] NULL,
	[ImageUrl] [nvarchar](max) NULL,
 CONSTRAINT [PK__Services__3E0DB8AF0199314B] PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](	[Id] [int] IDENTITY(1,1) NOT NULL,	[avatar] [nvarchar](255) NULL,	[is_active] [tinyint] NULL,	[location_id] [int] NULL,	[created_at] [datetime] NULL,	[updated_at] [datetime] NULL,
	[UserName] [nvarchar](max) NULL,
	[NormalizedUserName] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[NormalizedEmail] [nvarchar](max) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[DisplayName] [nvarchar](max) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserClaims]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLogins]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_UserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserTokens]    Script Date: 5/21/2025 12:13:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserTokens](
	[UserId] [int] NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20250413021810_InitialCreate', N'8.0.14')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20250511081033_AddImageUrlToService', N'8.0.14')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20250520143203_AddDisplayNameToUser', N'8.0.14')
GO
SET IDENTITY_INSERT [dbo].[Appointments] ON 

INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (1, 19, 1, 1, CAST(N'2025-05-10T14:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T16:02:04.813' AS DateTime), CAST(N'2025-05-12T12:11:29.387' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (2, 19, 1, 1, CAST(N'2025-06-10T14:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T16:11:31.403' AS DateTime), CAST(N'2025-05-10T15:31:50.070' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (3, 19, 1, 1, CAST(N'2025-07-10T14:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T16:18:30.483' AS DateTime), CAST(N'2025-05-10T15:31:45.987' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (4, 19, 1, 1, CAST(N'2025-05-15T14:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T16:38:31.373' AS DateTime), CAST(N'2025-05-16T16:55:35.407' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (5, 19, 1, 1, CAST(N'2025-05-16T14:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T17:11:06.040' AS DateTime), CAST(N'2025-05-16T16:55:35.407' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (6, 19, 1, 1, CAST(N'2025-05-16T15:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T17:13:20.930' AS DateTime), CAST(N'2025-05-16T16:55:35.407' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (7, 19, 1, 1, CAST(N'2025-05-17T15:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T21:42:12.423' AS DateTime), CAST(N'2025-05-20T13:15:16.820' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (8, 19, 1, 1, CAST(N'2025-05-17T16:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T22:05:27.707' AS DateTime), CAST(N'2025-05-20T13:15:16.820' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (9, 19, 1, 1, CAST(N'2025-05-17T17:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-07T22:21:41.410' AS DateTime), CAST(N'2025-05-20T13:15:16.820' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (10, 19, 1, 1, CAST(N'2025-05-18T17:00:00.000' AS DateTime), N'Completed', 8, CAST(N'2025-05-07T22:29:39.670' AS DateTime), CAST(N'2025-05-20T15:09:53.623' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (11, 19, 1, 2, CAST(N'2025-05-08T19:47:00.000' AS DateTime), N'Cancelled', 5, CAST(N'2025-05-08T16:47:36.523' AS DateTime), CAST(N'2025-05-12T13:17:01.543' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (12, 19, 1, 2, CAST(N'2025-05-11T00:26:00.000' AS DateTime), N'Cancelled', 5, CAST(N'2025-05-09T00:27:06.780' AS DateTime), CAST(N'2025-05-12T13:17:01.543' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (13, 19, 1, 2, CAST(N'2025-05-19T17:00:00.000' AS DateTime), N'Completed', 8, CAST(N'2025-05-09T00:31:41.153' AS DateTime), CAST(N'2025-05-20T14:41:07.407' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (14, 6, 1, 2, CAST(N'2025-05-10T16:40:00.000' AS DateTime), N'Confirmed', 5, CAST(N'2025-05-09T20:40:29.713' AS DateTime), CAST(N'2025-05-09T20:42:28.070' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (15, 6, 1, 2, CAST(N'2025-05-22T20:43:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-09T20:43:33.167' AS DateTime), CAST(N'2025-05-20T15:08:56.697' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (16, 19, 1, 2, CAST(N'2025-05-28T20:58:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-09T20:59:03.853' AS DateTime), CAST(N'2025-05-20T14:00:27.017' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (17, 19, 1, 2, CAST(N'2025-05-12T21:06:00.000' AS DateTime), N'Confirmed', 5, CAST(N'2025-05-09T21:06:22.583' AS DateTime), CAST(N'2025-05-12T13:41:28.353' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (18, 19, 1, 2, CAST(N'2025-07-19T17:00:00.000' AS DateTime), N'Cancelled', 8, CAST(N'2025-05-09T21:11:09.697' AS DateTime), CAST(N'2025-05-10T15:31:38.910' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (19, 19, 1, 2, CAST(N'2025-05-23T21:11:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-09T21:11:41.230' AS DateTime), CAST(N'2025-05-20T14:41:50.163' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (20, 19, 1, 2, CAST(N'2025-05-25T21:20:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-09T21:20:26.263' AS DateTime), CAST(N'2025-05-20T14:29:48.297' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (21, 19, 1, 1, CAST(N'2025-05-29T23:00:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-09T23:00:26.883' AS DateTime), CAST(N'2025-05-12T18:04:28.300' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (22, 19, 1, 2, CAST(N'2025-05-18T23:04:00.000' AS DateTime), N'Cancelled', 5, CAST(N'2025-05-09T23:04:27.400' AS DateTime), CAST(N'2025-05-20T13:15:16.820' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (23, 19, 1, 2, CAST(N'2025-05-12T11:15:00.000' AS DateTime), N'Cancelled', 5, CAST(N'2025-05-12T11:04:50.553' AS DateTime), CAST(N'2025-05-12T13:17:01.543' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (24, 19, 1, 1, CAST(N'2025-05-12T13:00:00.000' AS DateTime), N'Cancelled', 5, CAST(N'2025-05-12T12:03:02.347' AS DateTime), CAST(N'2025-05-12T13:17:01.543' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (25, 19, 2, 3, CAST(N'2025-05-15T12:45:00.000' AS DateTime), N'Cancelled', 6, CAST(N'2025-05-13T12:45:18.223' AS DateTime), CAST(N'2025-05-16T16:55:35.407' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (26, 19, 1, 2, CAST(N'2025-05-25T15:17:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-20T15:17:24.243' AS DateTime), CAST(N'2025-05-20T15:18:29.007' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (27, 19, 1, 2, CAST(N'2025-05-24T17:36:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T17:36:35.490' AS DateTime), CAST(N'2025-05-20T17:36:35.490' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (28, 19, 1, 1, CAST(N'2025-05-26T17:40:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T17:40:51.397' AS DateTime), CAST(N'2025-05-20T17:40:51.397' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (29, 19, 1, 1, CAST(N'2025-06-04T17:50:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T17:50:12.173' AS DateTime), CAST(N'2025-05-20T17:50:12.173' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (30, 19, 1, 1, CAST(N'2025-05-26T06:56:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T17:57:02.440' AS DateTime), CAST(N'2025-05-20T17:57:02.440' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (31, 19, 1, 1, CAST(N'2025-05-30T18:09:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T18:10:04.330' AS DateTime), CAST(N'2025-05-20T18:10:04.330' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (32, 19, 1, 1, CAST(N'2025-05-28T18:14:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T18:14:32.307' AS DateTime), CAST(N'2025-05-20T18:14:32.307' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (33, 19, 1, 1, CAST(N'2025-06-21T18:16:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T18:17:04.187' AS DateTime), CAST(N'2025-05-20T18:17:04.187' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (34, 19, 1, 1, CAST(N'2025-06-29T18:22:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-20T18:22:27.737' AS DateTime), CAST(N'2025-05-20T19:04:57.923' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (35, 19, 1, 1, CAST(N'2025-06-02T18:24:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T18:25:00.710' AS DateTime), CAST(N'2025-05-20T18:25:00.710' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (36, 19, 1, 1, CAST(N'2025-06-13T18:28:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T18:28:22.947' AS DateTime), CAST(N'2025-05-20T18:28:22.947' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (37, 19, 1, 1, CAST(N'2025-06-15T18:33:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T18:33:55.727' AS DateTime), CAST(N'2025-05-20T18:33:55.727' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (38, 19, 1, 1, CAST(N'2025-06-08T18:36:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T18:36:53.277' AS DateTime), CAST(N'2025-05-20T18:36:53.277' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (39, 19, 1, 1, CAST(N'2025-06-16T18:44:00.000' AS DateTime), N'Completed', 5, CAST(N'2025-05-20T18:44:11.107' AS DateTime), CAST(N'2025-05-20T18:45:51.183' AS DateTime))
INSERT [dbo].[Appointments] ([appointment_id], [user_id], [artist_id], [service_detail_id], [appointment_date], [status], [location_id], [created_at], [updated_at]) VALUES (40, 19, 1, 1, CAST(N'2025-05-23T19:04:00.000' AS DateTime), N'Pending', 5, CAST(N'2025-05-20T19:04:38.887' AS DateTime), CAST(N'2025-05-20T19:04:38.887' AS DateTime))
SET IDENTITY_INSERT [dbo].[Appointments] OFF
GO
SET IDENTITY_INSERT [dbo].[Location] ON 

INSERT [dbo].[Location] ([location_id], [latitude], [longitude], [address], [type]) VALUES (5, CAST(21.03000000 AS Decimal(10, 8)), CAST(105.80000000 AS Decimal(11, 8)), N'165 C?u Gi?y, Phu?ng Quan Hoa, Qu?n C?u Gi?y, Thành ph? Hà N?i', N'artist')
INSERT [dbo].[Location] ([location_id], [latitude], [longitude], [address], [type]) VALUES (6, CAST(21.05657717 AS Decimal(10, 8)), CAST(106.17386700 AS Decimal(11, 8)), N'Huy?n Gia Bình, T?nh B?c Ninh', N'artist')
INSERT [dbo].[Location] ([location_id], [latitude], [longitude], [address], [type]) VALUES (7, CAST(21.05657717 AS Decimal(10, 8)), CAST(106.17386700 AS Decimal(11, 8)), N'Huy?n Gia Bình, T?nh B?c Ninh', N'')
INSERT [dbo].[Location] ([location_id], [latitude], [longitude], [address], [type]) VALUES (8, CAST(10.76262200 AS Decimal(10, 8)), CAST(106.66017200 AS Decimal(11, 8)), N'123 Main Street', N'')
SET IDENTITY_INSERT [dbo].[Location] OFF
GO
SET IDENTITY_INSERT [dbo].[MakeupArtists] ON 

INSERT [dbo].[MakeupArtists] ([artist_id], [user_id], [full_name], [bio], [experience], [specialty], [is_available_at_home], [rating], [reviews_count], [is_active], [location_id]) VALUES (1, 1, N'Tr?n Danh Ðoàn', NULL, NULL, NULL, 0, CAST(4.44 AS Decimal(3, 2)), 9, 1, 5)
INSERT [dbo].[MakeupArtists] ([artist_id], [user_id], [full_name], [bio], [experience], [specialty], [is_available_at_home], [rating], [reviews_count], [is_active], [location_id]) VALUES (2, 17, N'artist', NULL, NULL, NULL, 0, CAST(0.00 AS Decimal(3, 2)), 0, 1, 6)
SET IDENTITY_INSERT [dbo].[MakeupArtists] OFF
GO
SET IDENTITY_INSERT [dbo].[Messages] ON 

INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (1, 19, 1, N'Test tin nh?n t? Postman', CAST(N'2025-05-10T22:25:39.573' AS DateTime), 1)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (2, 19, 1, N'Test tin nh?n t? Postman 2', CAST(N'2025-05-10T22:27:08.090' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (3, 19, 1, N'Test tin nh?n t? Postman 3', CAST(N'2025-05-10T22:27:23.947' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (4, 19, 1, N'Test tin nh?n t? Postman 3', CAST(N'2025-05-10T22:31:38.110' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (5, 1, 19, N'ok', CAST(N'2025-05-10T22:37:35.950' AS DateTime), 1)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (6, 19, 1, N'ok', CAST(N'2025-05-10T23:07:39.033' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (7, 19, 1, N'ok', CAST(N'2025-05-10T23:07:44.973' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (8, 19, 1, N'ok', CAST(N'2025-05-10T23:07:52.323' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (9, 19, 1, N'ok', CAST(N'2025-05-10T23:11:45.613' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (10, 19, 1, N'ok', CAST(N'2025-05-10T23:11:58.930' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (11, 19, 1, N'a', CAST(N'2025-05-10T23:13:00.823' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (12, 19, 1, N'a', CAST(N'2025-05-10T23:13:09.663' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (13, 19, 1, N'ok', CAST(N'2025-05-10T23:13:11.887' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (14, 1, 19, N'll', CAST(N'2025-05-10T23:13:28.083' AS DateTime), 1)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (15, 19, 1, N'a', CAST(N'2025-05-10T23:14:42.563' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (16, 19, 1, N'a', CAST(N'2025-05-10T23:15:06.093' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (17, 19, 1, N'a', CAST(N'2025-05-10T23:28:07.007' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (18, 19, 1, N'a', CAST(N'2025-05-10T23:39:14.667' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (19, 19, 1, N'âljd', CAST(N'2025-05-11T00:36:45.190' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (20, 19, 1, N'a', CAST(N'2025-05-11T00:37:09.013' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (21, 19, 1, N'al', CAST(N'2025-05-11T00:54:08.773' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (22, 19, 1, N'hj', CAST(N'2025-05-11T00:57:33.617' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (23, 19, 1, N'ê', CAST(N'2025-05-11T01:04:50.787' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (24, 19, 1, N'wkn', CAST(N'2025-05-11T01:05:20.763' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (25, 19, 1, N'i', CAST(N'2025-05-11T01:07:44.193' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (26, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T01:10:18.937' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (27, 19, 1, N'rfu', CAST(N'2025-05-11T01:10:22.530' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (28, 19, 1, N'zsmsksk', CAST(N'2025-05-11T01:10:45.357' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (29, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T01:12:36.053' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (30, 19, 1, N'js', CAST(N'2025-05-11T01:12:40.027' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (31, 19, 1, N'il', CAST(N'2025-05-11T01:15:49.843' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (32, 19, 1, N'josn', CAST(N'2025-05-11T01:16:57.300' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (33, 19, 1, N'rh', CAST(N'2025-05-11T01:24:15.997' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (34, 19, 1, N'p', CAST(N'2025-05-11T01:35:33.820' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (35, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T01:50:46.030' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (36, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T01:50:56.543' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (37, 19, 1, N'eo', CAST(N'2025-05-11T01:52:27.333' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (38, 19, 1, N'wo', CAST(N'2025-05-11T01:52:37.527' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (39, 19, 1, N'll', CAST(N'2025-05-11T01:52:42.630' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (40, 19, 1, N'po', CAST(N'2025-05-11T01:56:44.757' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (41, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T01:56:48.123' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (42, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.577' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (43, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.407' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (44, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.427' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (45, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.417' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (46, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.420' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (47, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.410' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (48, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.420' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (49, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.413' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (50, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.580' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (51, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.580' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (52, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.407' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (53, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.580' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (54, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.580' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (55, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.577' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (56, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:19.930' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (57, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:20.420' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (58, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:20.457' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (59, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:20.513' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (60, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:20.670' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (61, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:20.710' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (62, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:21.133' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (63, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:21.200' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (64, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:21.260' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (65, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:21.823' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (66, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:23.307' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (67, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:23.437' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (68, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:24.870' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (69, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:25.133' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (70, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:26.407' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (71, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:35:26.930' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (72, 19, 1, N'ol', CAST(N'2025-05-11T08:35:51.303' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (73, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:41:08.837' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (74, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:41:12.117' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (75, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T08:41:18.840' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (76, 19, 1, N'we', CAST(N'2025-05-11T08:43:11.700' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (77, 19, 1, N'ol', CAST(N'2025-05-11T08:53:22.143' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (78, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:11:44.893' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (79, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:11:46.147' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (80, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:15:02.677' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (81, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:15:02.677' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (82, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:19:17.583' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (83, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:19:18.877' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (84, 19, 1, N'tl', CAST(N'2025-05-11T09:19:39.473' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (85, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:20:09.040' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (86, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:20:14.340' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (87, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:20:24.180' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (88, 19, 1, N'rf', CAST(N'2025-05-11T09:20:28.460' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (89, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:20:35.243' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (90, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:20:43.687' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (91, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:23:21.803' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (92, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:23:23.380' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (93, 19, 1, N'aaa', CAST(N'2025-05-11T09:23:26.957' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (94, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:28:00.427' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (95, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:28:01.990' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (96, 19, 1, N'ls', CAST(N'2025-05-11T09:28:04.747' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (97, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:28:09.613' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (98, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:35:10.080' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (99, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:35:11.627' AS DateTime), 0)
GO
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (100, 19, 1, N'yels', CAST(N'2025-05-11T09:35:14.800' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (101, 19, 1, N'iohshoshis', CAST(N'2025-05-11T09:35:16.913' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (102, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:48:59.473' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (103, 19, 1, N'Ki?m tra k?t n?i ChatHub', CAST(N'2025-05-11T09:49:03.343' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (104, 19, 1, N'phw', CAST(N'2025-05-11T09:55:27.307' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (105, 19, 1, N'wjdo', CAST(N'2025-05-11T09:55:31.220' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (106, 19, 1, N'hson', CAST(N'2025-05-11T09:55:52.903' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (107, 19, 1, N'lbhu', CAST(N'2025-05-11T09:56:40.540' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (108, 19, 1, N'iho', CAST(N'2025-05-11T09:56:42.813' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (109, 19, 1, N'pa', CAST(N'2025-05-11T09:59:23.897' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (110, 19, 1, N'duv', CAST(N'2025-05-11T09:59:25.753' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (111, 1, 19, N'áda', CAST(N'2025-05-11T09:59:50.693' AS DateTime), 1)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (112, 19, 1, N'sj', CAST(N'2025-05-11T12:25:43.617' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (113, 19, 1, N'sk', CAST(N'2025-05-11T12:43:00.650' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (114, 19, 1, N'aa', CAST(N'2025-05-11T12:46:51.070' AS DateTime), 0)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (115, 1, 19, N'ad', CAST(N'2025-05-12T16:48:55.047' AS DateTime), 1)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (116, 1, 19, N'alo', CAST(N'2025-05-12T16:51:53.883' AS DateTime), 1)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (117, 1, 19, N'ad', CAST(N'2025-05-12T18:42:36.897' AS DateTime), 1)
INSERT [dbo].[Messages] ([message_id], [sender_id], [receiver_id], [message_content], [message_timestamp], [is_read]) VALUES (118, 19, 1, N'hk', CAST(N'2025-05-13T12:45:58.813' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[Messages] OFF
GO
SET IDENTITY_INSERT [dbo].[Payments] ON 

INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (1, 1, N'Cash', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T16:02:04.870' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (2, 2, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T16:11:31.560' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (3, 3, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T16:18:30.690' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (4, 4, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Completed', CAST(N'2025-05-07T16:38:31.677' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (5, 5, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T17:11:06.337' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (6, 6, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T17:13:21.217' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (7, 7, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T21:42:12.737' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (8, 8, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T22:05:27.967' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (9, 9, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-07T22:21:41.740' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (10, 10, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Completed', CAST(N'2025-05-07T22:29:40.287' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (11, 11, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-08T16:47:36.717' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (12, 12, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-09T00:27:07.013' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (13, 13, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Completed', CAST(N'2025-05-09T00:31:41.163' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (14, 14, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Completed', CAST(N'2025-05-09T20:40:29.870' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (15, 15, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Pending', CAST(N'2025-05-09T20:43:33.180' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (16, 16, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Pending', CAST(N'2025-05-09T20:59:03.863' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (17, 17, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Completed', CAST(N'2025-05-09T21:06:22.750' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (18, 18, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-09T21:11:09.707' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (19, 19, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Pending', CAST(N'2025-05-09T21:11:41.233' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (20, 20, N'Online', CAST(500000.00 AS Decimal(10, 2)), N'Completed', CAST(N'2025-05-09T21:20:26.273' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (21, 21, N'Online', CAST(200000.00 AS Decimal(10, 2)), N'Completed', CAST(N'2025-05-09T23:00:27.110' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (22, 22, N'Cash', CAST(500000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-09T23:04:27.413' AS DateTime))
INSERT [dbo].[Payments] ([payment_id], [appointment_id], [payment_method], [amount], [payment_status], [created_at]) VALUES (23, 23, N'Cash', CAST(500000.00 AS Decimal(10, 2)), N'Cancelled', CAST(N'2025-05-12T11:04:50.720' AS DateTime))
SET IDENTITY_INSERT [dbo].[Payments] OFF
GO
SET IDENTITY_INSERT [dbo].[Reviews] ON 

INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (1, 21, 19, 1, 4, N'cung tam duoc aaaaaaaaaa', CAST(N'2025-05-13T06:39:56.273' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (6, 16, 19, 1, 4, N'ok', CAST(N'2025-05-20T07:01:03.950' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (7, 20, 19, 1, 5, N'ok', CAST(N'2025-05-20T07:32:37.743' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (8, 13, 19, 1, 5, N'abc', CAST(N'2025-05-20T07:44:15.177' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (9, 19, 19, 1, 3, N'aaa', CAST(N'2025-05-20T07:49:36.010' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (10, 10, 19, 1, 4, N'', CAST(N'2025-05-20T08:10:10.327' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (11, 26, 19, 1, 5, N'', CAST(N'2025-05-20T08:19:20.613' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (12, 39, 19, 1, 5, N'', CAST(N'2025-05-20T11:46:22.753' AS DateTime))
INSERT [dbo].[Reviews] ([review_id], [appointment_id], [user_id], [artist_id], [rating], [content], [created_at]) VALUES (13, 34, 19, 1, 5, N'ok', CAST(N'2025-05-20T12:05:12.780' AS DateTime))
SET IDENTITY_INSERT [dbo].[Reviews] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (1, N'Admin', N'ADMIN', NULL)
INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (2, N'Artist', N'ARTIST', NULL)
INSERT [dbo].[Roles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp]) VALUES (3, N'User', N'USER', NULL)
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[ServiceDetails] ON 

INSERT [dbo].[ServiceDetails] ([service_detail_id], [service_id], [artist_id], [user_id], [price], [duration], [created_at]) VALUES (1, 2, 1, 1, CAST(200000.00 AS Decimal(10, 2)), 30, CAST(N'2025-05-04T16:13:27.613' AS DateTime))
INSERT [dbo].[ServiceDetails] ([service_detail_id], [service_id], [artist_id], [user_id], [price], [duration], [created_at]) VALUES (2, 3, 1, 1, CAST(500000.00 AS Decimal(10, 2)), 60, CAST(N'2025-05-04T16:13:45.413' AS DateTime))
INSERT [dbo].[ServiceDetails] ([service_detail_id], [service_id], [artist_id], [user_id], [price], [duration], [created_at]) VALUES (3, 3, 2, 17, CAST(250000.00 AS Decimal(10, 2)), 30, CAST(N'2025-05-12T12:52:15.790' AS DateTime))
INSERT [dbo].[ServiceDetails] ([service_detail_id], [service_id], [artist_id], [user_id], [price], [duration], [created_at]) VALUES (4, 2, 2, 17, CAST(550000.00 AS Decimal(10, 2)), 60, CAST(N'2025-05-12T12:52:41.123' AS DateTime))
SET IDENTITY_INSERT [dbo].[ServiceDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Services] ON 

INSERT [dbo].[Services] ([service_id], [service_name], [description], [is_active], [created_at], [MakeupArtistArtistId], [ImageUrl]) VALUES (2, N'Makeup du tiec', N'Makeup co ban, nhe nhang', 1, CAST(N'2025-05-04T13:57:53.507' AS DateTime), NULL, N'/images/services/bb80d908-06e5-4787-8423-1ba5d2bcf987_eyelash.png')
INSERT [dbo].[Services] ([service_id], [service_name], [description], [is_active], [created_at], [MakeupArtistArtistId], [ImageUrl]) VALUES (3, N'Makeup co dau', N'Makeuip du tiec dam cuoi', 1, CAST(N'2025-05-04T13:58:14.127' AS DateTime), NULL, N'/images/services/819e9abd-1658-4426-8803-6e171a740b93_skincare.png')
SET IDENTITY_INSERT [dbo].[Services] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (1, N'/uploads/avatars/a85a9226-4705-4eab-aedf-00673c418a00.jpg', 1, NULL, CAST(N'2025-04-13T09:20:30.780' AS DateTime), CAST(N'2025-04-13T09:20:30.780' AS DateTime), N'doankorea', N'DOANKOREA', N'doankorea128@gmail.com', N'DOANKOREA128@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEINESzSOIuT6o3O394/V90pjjsw5aZ8wZZzJYidsvzpCKut26M30D9nhYRkuLT1HHQ==', N'6XAGKWINFXG2A5VQOH7BTKAUU77NWVSJ', N'090db5d6-6819-423f-ad78-fb604664757f', NULL, 0, 0, NULL, 1, 0, N'Trần Danh Đoàn')
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (2, NULL, 1, NULL, CAST(N'2025-04-13T17:58:48.550' AS DateTime), CAST(N'2025-04-13T17:58:48.550' AS DateTime), N'admin1', N'ADMIN1', N'test@example.com', N'TEST@EXAMPLE.COM', 0, N'AQAAAAIAAYagAAAAEJIhCrojBbJW2onIY9n9tALSt7l32hKON+BHS2Jy5BGv1fdeEGC6lgtx3EMzpuQAhg==', N'FWICZ7L3PR5KKVYBBH4VHP2BDUIEQXYP', N'dfd89919-570f-460b-8c36-472f6332b6db', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (3, NULL, 1, NULL, CAST(N'2025-04-20T00:34:05.647' AS DateTime), CAST(N'2025-04-20T00:34:05.647' AS DateTime), N'admin2', N'ADMIN2', N'user@gmail.com', N'USER@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEFMi6BJhxZStFMgejSL4WppGlZdD3+65K5lcqt3bEqYVakJmGFqf2lCN0gIDYFZE9g==', N'GZR2CHKOIBJJM7P74X6NE7UT3SOYKGOY', N'0f025cc6-bdae-4aed-aa8e-3733e956b73a', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (4, NULL, 1, NULL, CAST(N'2025-04-20T00:37:47.203' AS DateTime), CAST(N'2025-04-20T00:37:47.203' AS DateTime), N'user1', N'USER1', N'user@example.com', N'USER@EXAMPLE.COM', 0, N'AQAAAAIAAYagAAAAEAbv6iMee2UhrdgtVUaN+4d3vd7SbHv98A2rNUlEA1SoWW9jQ/uY9BBUT1NAbICTTQ==', N'GCDX36C2XWUDSKO7CR354A24VUH7M6X2', N'18e12260-f410-41f0-8354-8f33faf48ce6', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (5, NULL, 1, NULL, CAST(N'2025-04-20T00:38:43.870' AS DateTime), CAST(N'2025-04-20T00:38:43.870' AS DateTime), N'user2', N'USER2', N'user2@gmail.com', N'USER2@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEDM9MQfnitT5nqZyl6wmFj3T1NnFbi7IYr90aMLWCPpCRa0v0PvJs4X2UJUArQw4aA==', N'52YXAWNQXLGXRXYGM4ZHBAPXAMNJ3ODM', N'69043716-d18c-472c-a21e-a3b249f7e85c', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (6, NULL, 1, NULL, CAST(N'2025-04-20T00:46:37.110' AS DateTime), CAST(N'2025-04-20T00:46:37.110' AS DateTime), N'user3', N'USER3', N'user3@gmail.com', N'USER3@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEInX7ZPQes0XOm9BwN79HYeEg/IPq2hx2QEZ9LZFdsamzoZzo0tfyiY7vf6l1+gGyA==', N'ETIVCYIBWA3NLFBFFHNRH62R4NBKB2ZI', N'28331aea-52cf-439b-978d-4b3270a7031c', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (7, NULL, 1, NULL, CAST(N'2025-04-20T00:49:49.340' AS DateTime), CAST(N'2025-04-20T00:49:49.340' AS DateTime), N'user5', N'USER5', N'user@example.com', N'USER@EXAMPLE.COM', 0, N'AQAAAAIAAYagAAAAEMT78SjfweHp/gkUEJa/JosJeJSI5Px1VNfddiqoZdk7nIZnSDbeM4q3LO31piDe3Q==', N'LXIN4BAG6YY4GVL6JEIJUX2IG7E67YHA', N'cd256eb2-f037-4d72-9e26-d862216a3657', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (8, NULL, 1, NULL, CAST(N'2025-04-20T15:25:16.773' AS DateTime), CAST(N'2025-04-20T15:25:16.773' AS DateTime), N'user6', N'USER6', N'user@example.com', N'USER@EXAMPLE.COM', 0, N'AQAAAAIAAYagAAAAEHr4bsV3ELbe81x26aXWhC/B+adtZfFvVBCvqyr1Pv2iDTGKtMmklp6LmkH6ROKWVQ==', N'JEHOZD45RO5E7IILZX3FXWC2RGSJCTGA', N'2f7b1b67-9774-4480-909e-7ada34b4dc86', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (9, NULL, 1, NULL, CAST(N'2025-04-20T15:33:37.397' AS DateTime), CAST(N'2025-04-20T15:33:37.397' AS DateTime), N'userr', N'USERR', N'userr@gmail.com', N'USERR@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEO8+c6jDe7AfzAxXlm+Nb6JkWb2jG+jzTX1up9f6VZ/gAVBqhuU5N4XDVR4tgt2H7Q==', N'2LSKW4LA7Y5Z7QQ3O7CFS32X3DUC7RNV', N'f089ef41-4267-47a4-b95f-9797563f58eb', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (10, NULL, 1, NULL, CAST(N'2025-04-20T15:38:54.383' AS DateTime), CAST(N'2025-04-20T15:38:54.383' AS DateTime), N'userrr', N'USERRR', N'userr@gmail.com', N'USERR@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEOCOHtgri6ObmvcfbN4PcphxeMZS+1r8rGbzWaRU6rNKVFGUQfIbpfhBZsRiB/jLOQ==', N'IJRCKLPPYPCH4JLQQNJPMAJZQGVQJH4G', N'4cd10994-2dc4-48c7-8ed4-66f101e6a165', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (11, NULL, 1, NULL, CAST(N'2025-04-20T15:43:41.360' AS DateTime), CAST(N'2025-04-20T15:43:41.360' AS DateTime), N'aaaaa', N'AAAAA', N'aaaa@gmail.com', N'AAAA@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEHwsvgTC/8+cLlJmTlkechSufLPlhPiuuxukmonk/fR89CJEb7STW35KlMuC4YIrLA==', N'WXEBELOANUWKMN3XHGTJ4MDWXQOZQFNJ', N'75974db4-61a1-473e-8cf7-1d4e2aeeff69', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (12, NULL, 1, NULL, CAST(N'2025-04-20T15:47:30.570' AS DateTime), CAST(N'2025-04-20T15:47:30.570' AS DateTime), N'usser', N'USSER', N'usser@gmail.com', N'USSER@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEAIoyHUGamKDefJA0jgQ2XHxBthyTe2TQeoH1eDtsgzC5S1eGRY9IWcq3/8aMfY6pA==', N'ARQ7K36W3UB24LRKUOSUZECVF72VMK3Z', N'e7b35a36-3265-4323-a8db-4e99ff536705', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (13, NULL, 1, NULL, CAST(N'2025-04-20T15:54:57.620' AS DateTime), CAST(N'2025-04-20T15:54:57.620' AS DateTime), N'userrrrr', N'USERRRRR', N'usd@gmail.com', N'USD@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEBEIHTARz/yjSEaGXaU2lIxLQ/ZbjKwDYEEpgE77shdkM4c90tVLU1yKItK6Nq8C1w==', N'FJ47DO5YGHHWG54PGKNZ4234LY2CA3EV', N'f3a1c447-4ed7-4db2-ac40-4510f4be3810', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (14, NULL, 1, NULL, CAST(N'2025-04-20T15:56:13.267' AS DateTime), CAST(N'2025-04-20T15:56:13.267' AS DateTime), N'tyt', N'TYT', N'tyt@gmail.com', N'TYT@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEFasNWBdWHnx2kaFc5K+R5ky0PMfZYkKWAdTG7pncyuH9AHL4+O6wT7dIW/dRahqNw==', N'J5XLVW3ZHTIAXZT3W3L7C7OM22VIYN5Z', N'40990a89-129f-4bbe-8451-659989b34f53', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (15, NULL, 1, NULL, CAST(N'2025-04-24T20:36:01.773' AS DateTime), CAST(N'2025-04-24T20:36:01.773' AS DateTime), N'xdx', N'XDX', N'xdx@gmail.com', N'XDX@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAENNfuMWalLE/ptoYygjkuUQzoTEwCB4Wl7FA8i3mxovS8etX4mRRWh28tQYC8IuhlA==', N'V6NSH6TAF6LEHSN55CUVOR2BZZIN7MDN', N'c8e56c6d-79ca-4469-bf93-5d35b8c6447c', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (16, N'/Uploads/Avatars/b835fc5a-e987-40cd-acc4-26dc85e2236f.jpg', 1, NULL, CAST(N'2025-04-24T20:51:49.187' AS DateTime), CAST(N'2025-04-24T16:25:08.993' AS DateTime), N'xdxa', N'XDXA', N'xdxa@gmail.com', N'XDXA@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEAWzO2ItvmMtsNylAinIfj7R6IL+CFSnQqT/nE7362dbqWDrffRWyAOGuA2IxxzDXA==', N'TFSR5SOZE6G5C4H44O4L6NZXFOJEIRBU', N'5e7feab5-035f-4bd2-bd2f-3d2944144632', N'0940644187', 0, 0, NULL, 1, 0, N'Đoàn Trần')
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (17, N'/uploads/avatars/56f65cd0-3e9e-4024-bb22-3cbf6bf99f55.jpg', 1, NULL, CAST(N'2025-04-28T23:38:39.380' AS DateTime), CAST(N'2025-04-28T23:38:39.380' AS DateTime), N'artist', N'ARTIST', N'artist@gmail.com', N'ARTIST@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEOt9NfimD+z6wguUDmqmWp6JIZCd4k8yB3enRB0yAkc+4xIJWm2i7X8vlFgcu6YBLw==', N'LYKIRHXB4MMKZU6ZCB6RNFEL6GNTSUAA', N'f02da2f9-b54e-438b-94bc-cf947fe8f319', NULL, 0, 0, NULL, 1, 0, N'Đoàn Trầnn')
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (18, NULL, 1, NULL, CAST(N'2025-05-04T04:29:54.183' AS DateTime), CAST(N'2025-05-04T04:29:54.183' AS DateTime), N'admin', N'ADMIN', N'tddnhny@gmail.com', N'TDDNHNY@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEFMDQGExg8fvXWIOstlnMgnqhc6A8BQ87Beg/UfGkaCoEliCdP+9EWq7N0VpzHlLpA==', N'N57ZAZDFSSM2P3FPZFCBEYO35BYJFJRA', N'eb370ff5-eed6-450f-a485-5ab629f26401', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (19, N'/Uploads/Avatars/9807e894-ade3-42fd-b3ae-a6c7f6a3e05c.jpg', 1, 7, CAST(N'2025-05-06T15:16:50.403' AS DateTime), CAST(N'2025-05-21T04:45:33.313' AS DateTime), N'xaxa2', N'XAXA2', N'youngdoanzzz@gmail.com', N'YOUNGDOANZZZ@GMAIL.COM', 1, N'AQAAAAIAAYagAAAAEEBgEP3PcKLsU2CYqUylb2qEm+StQvW07QWD864hXs6E+XiHrNI88BPoBy5cuJccYA==', N'JD2FTLMLRSAQLVSEEJET3CKZZAZY7KHC', N'2295e901-b395-42f9-9708-7bc67d048fe5', NULL, 0, 0, NULL, 1, 0, N'Trần Đoàn')
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (20, NULL, 1, NULL, CAST(N'2025-05-12T22:20:27.970' AS DateTime), CAST(N'2025-05-12T22:20:27.970' AS DateTime), N'user', N'USER', N'youngdoanz@gmail.com', N'YOUNGDOANZ@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEINCj6h/1x0lvvGeMTBuF1BNt+d4eDLOChaW63kcfeHfkKTQ2eTbE6As4SyLEh+9uQ==', N'YQOYI4XVA64NEOZKIDTP4UDCRFACYCJ4', N'2d1d7be9-1767-48fa-946b-6e7342bfddb2', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (21, NULL, 1, NULL, CAST(N'2025-05-12T23:45:18.307' AS DateTime), CAST(N'2025-05-12T23:45:18.307' AS DateTime), N'user123', N'USER123', N'youngdoanzz@gmail.com', N'YOUNGDOANZZ@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEGQXsCH3dsV242/4/SRGcdNdUDkc8rpXzjPvL/AXSY30gFtbna4EXobCDA/xdHBDlw==', N'SCJKOM3AC7JXEPELVZBMHKOHTTKYBV36', N'bb06d41b-ab3a-4870-ad93-18d572760375', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (22, NULL, 1, NULL, CAST(N'2025-05-12T23:53:08.813' AS DateTime), CAST(N'2025-05-12T23:53:08.813' AS DateTime), N'user12345', N'USER12345', N'hcom25435@gmail.com', N'HCOM25435@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEDsuuuEtTaxXavzluucKf8szYJUcwZYtKOiGB8ruLKnXwQdlWLL8YGanMvzeMLgK+w==', N'KPM3VBCKVSZTTUTP46VN7MGCJAPSGDIQ', N'8818adb8-a20e-47bd-8188-d5a5250113c4', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (23, NULL, 1, NULL, CAST(N'2025-05-12T23:56:49.910' AS DateTime), CAST(N'2025-05-12T23:56:49.910' AS DateTime), N'testuser123', N'TESTUSER123', N'test123@example.com', N'TEST123@EXAMPLE.COM', 0, N'AQAAAAIAAYagAAAAEKuU9zGLFLvuUOJbkEQVhM763LUhn8Xu1CPtZ9hSeJ98f3AyWR0LgIGPggcSKO9vxg==', N'N3ZAZUWWQJN4PW6CF4ECISKSFFLP74EF', N'264c4efa-93b6-4b32-b959-bf3bf6201028', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (24, NULL, 1, NULL, CAST(N'2025-05-12T23:59:35.383' AS DateTime), CAST(N'2025-05-12T23:59:35.383' AS DateTime), N'userdoan', N'USERDOAN', N'hcom254@gmail.com', N'HCOM254@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEAyWNyoSOpyLY1vkdq3DUBQvfbeZ006sO3LArMIsbIiHNxH4/I8O9fRzdb/HkUuR9A==', N'B4GOMTKAYQGXYTBQ5WLILSURYHSJMZ3J', N'4cd1dba3-3b36-473c-ac11-f81c383885cc', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (25, NULL, 1, NULL, CAST(N'2025-05-13T00:02:45.740' AS DateTime), CAST(N'2025-05-13T00:02:45.740' AS DateTime), N'hcom', N'HCOM', N'hcom25413@gmail.com', N'HCOM25413@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEEh0rV3KnYHeIHe8gugd9qRRzWlQnhx1aCoR5cHhUYUbCx3d6g2t2tC486Ud3HVNZw==', N'YUIS6DFVQVFMI6UCL4YEMTTXRJVBFSRK', N'2e0ede18-0d04-4b33-bd3e-3645c92491cc', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (26, NULL, 1, NULL, CAST(N'2025-05-13T00:13:33.697' AS DateTime), CAST(N'2025-05-13T00:13:33.697' AS DateTime), N'hdkdb', N'HDKDB', N'djeoe@gmail.com', N'DJEOE@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEG8HAuzv18eCYCWm65Qrhy9w9h24n17UGP189U52NSYChYlYkdL813KZH6NS0BaAPw==', N'DDPFNRKPZE4UAP3BUJHUAL4X3PFLH4AN', N'e21ea5fc-6643-47be-b1d3-a419280ff791', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (27, NULL, 1, NULL, CAST(N'2025-05-13T00:22:25.700' AS DateTime), CAST(N'2025-05-13T00:22:25.700' AS DateTime), N'dkkdj', N'DKKDJ', N'dkkdj @gmail.com', N'DKKDJ @GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEB3fA7SbEKtlhHCk6grffEVRx0GepJSSkn8kn/IqProu9YnpkZKzh6/+I2S7MCO6SQ==', N'B2EUUDZBO52QGVMAJ4VIMM65WKK7CLIH', N'30712676-f442-48b8-b90c-8b932c76c686', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (28, NULL, 1, NULL, CAST(N'2025-05-13T00:24:16.710' AS DateTime), CAST(N'2025-05-13T00:24:16.710' AS DateTime), N'dkkdjg', N'DKKDJG', N'dkkd@gmail.com', N'DKKD@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEPesBVaLP0J2G9zxeubR6Jdg9XnX7uw8PBvTYjsAd4LH8drMuDHB5NgqyDAHeGkWug==', N'TKJTHEX2RXADREZHRYQUEKEN2IVNH6CY', N'79a768fc-d7c8-4ef9-85af-57d773317f5e', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (29, NULL, 1, NULL, CAST(N'2025-05-13T00:37:00.260' AS DateTime), CAST(N'2025-05-13T00:37:00.260' AS DateTime), N'oddkk', N'ODDKK', N'doodld@gmail.com', N'DOODLD@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEAJguFgf02vBTLlFs2qccQu3woL/+X91z49DXNkMtW3uEW3YN2VgQ3dCjQCF4WGFxQ==', N'ZDXUMBMIXHEJOPHJSHMYCYD7LRATHKLR', N'e364e20a-1562-4746-915a-46b379ed10ac', NULL, 0, 0, NULL, 1, 0, NULL)
INSERT [dbo].[User] ([Id], [avatar], [is_active], [location_id], [created_at], [updated_at], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [DisplayName]) VALUES (30, NULL, 1, NULL, CAST(N'2025-05-13T00:39:23.163' AS DateTime), CAST(N'2025-05-13T03:12:11.687' AS DateTime), N'djjd', N'DJJD', N'hdoe@gmail.com', N'HDOE@GMAIL.COM', 0, N'AQAAAAIAAYagAAAAEOhgYGy/uTAEklFN5BHVB8D3qZ8/yFuA/gUno2e3n71lAuXuc1IT+KuXc5d9h2h4Sg==', N'XCHFQJNAXSNMXOGPQV3KJDUKHBQEPZEY', N'd6d3c53c-e9b4-4d3c-b326-8babceedc5de', NULL, 0, 0, NULL, 1, 0, NULL)
SET IDENTITY_INSERT [dbo].[User] OFF
GO
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (1, 2)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (2, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (3, 1)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (4, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (5, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (6, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (7, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (8, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (9, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (10, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (11, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (12, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (13, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (14, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (15, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (16, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (17, 2)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (18, 1)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (19, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (20, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (21, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (22, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (23, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (24, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (25, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (26, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (27, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (28, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (29, 3)
INSERT [dbo].[UserRoles] ([UserId], [RoleId]) VALUES (30, 3)
GO
/****** Object:  Index [IX_Appointments_artist_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Appointments_artist_id] ON [dbo].[Appointments]
(
	[artist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Appointments_location_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Appointments_location_id] ON [dbo].[Appointments]
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Appointments_service_detail_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Appointments_service_detail_id] ON [dbo].[Appointments]
(
	[service_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Appointments_user_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Appointments_user_id] ON [dbo].[Appointments]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_MakeupArtists_location_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_MakeupArtists_location_id] ON [dbo].[MakeupArtists]
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__MakeupAr__B9BE370E2F4FDF56]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ__MakeupAr__B9BE370E2F4FDF56] ON [dbo].[MakeupArtists]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Messages_receiver_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Messages_receiver_id] ON [dbo].[Messages]
(
	[receiver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Messages_sender_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Messages_sender_id] ON [dbo].[Messages]
(
	[sender_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Payments_appointment_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Payments_appointment_id] ON [dbo].[Payments]
(
	[appointment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reviews_artist_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reviews_artist_id] ON [dbo].[Reviews]
(
	[artist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reviews_user_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reviews_user_id] ON [dbo].[Reviews]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Reviews__A50828FD37E48493]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UQ__Reviews__A50828FD37E48493] ON [dbo].[Reviews]
(
	[appointment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ServiceDetails_artist_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_ServiceDetails_artist_id] ON [dbo].[ServiceDetails]
(
	[artist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ServiceDetails_service_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_ServiceDetails_service_id] ON [dbo].[ServiceDetails]
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ServiceDetails_user_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_ServiceDetails_user_id] ON [dbo].[ServiceDetails]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Services_MakeupArtistArtistId]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_Services_MakeupArtistArtistId] ON [dbo].[Services]
(
	[MakeupArtistArtistId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_User_location_id]    Script Date: 5/21/2025 12:13:02 PM ******/
CREATE NONCLUSTERED INDEX [IX_User_location_id] ON [dbo].[User]
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Appointments] ADD  DEFAULT ('pending') FOR [status]
GO
ALTER TABLE [dbo].[Appointments] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Appointments] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[Location] ADD  DEFAULT ('artist') FOR [type]
GO
ALTER TABLE [dbo].[MakeupArtists] ADD  DEFAULT (CONVERT([tinyint],(0))) FOR [is_available_at_home]
GO
ALTER TABLE [dbo].[MakeupArtists] ADD  DEFAULT ((0.0)) FOR [rating]
GO
ALTER TABLE [dbo].[MakeupArtists] ADD  DEFAULT ((0)) FOR [reviews_count]
GO
ALTER TABLE [dbo].[MakeupArtists] ADD  DEFAULT (CONVERT([tinyint],(1))) FOR [is_active]
GO
ALTER TABLE [dbo].[Messages] ADD  DEFAULT (getdate()) FOR [message_timestamp]
GO
ALTER TABLE [dbo].[Messages] ADD  DEFAULT (CONVERT([tinyint],(0))) FOR [is_read]
GO
ALTER TABLE [dbo].[Payments] ADD  DEFAULT ('pending') FOR [payment_status]
GO
ALTER TABLE [dbo].[Payments] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Reviews] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[ServiceDetails] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT (CONVERT([tinyint],(1))) FOR [is_active]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (CONVERT([tinyint],(1))) FOR [is_active]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK__Appointme__artis__60A75C0F] FOREIGN KEY([artist_id])
REFERENCES [dbo].[MakeupArtists] ([artist_id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK__Appointme__artis__60A75C0F]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK__Appointme__locat__619B8048] FOREIGN KEY([location_id])
REFERENCES [dbo].[Location] ([location_id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK__Appointme__locat__619B8048]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK__Appointme__servi__628FA481] FOREIGN KEY([service_detail_id])
REFERENCES [dbo].[ServiceDetails] ([service_detail_id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK__Appointme__servi__628FA481]
GO
ALTER TABLE [dbo].[Appointments]  WITH CHECK ADD  CONSTRAINT [FK__Appointme__user___6383C8BA] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Appointments] CHECK CONSTRAINT [FK__Appointme__user___6383C8BA]
GO
ALTER TABLE [dbo].[MakeupArtists]  WITH CHECK ADD  CONSTRAINT [FK__MakeupArt__user___6477ECF3] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[MakeupArtists] CHECK CONSTRAINT [FK__MakeupArt__user___6477ECF3]
GO
ALTER TABLE [dbo].[MakeupArtists]  WITH CHECK ADD  CONSTRAINT [FK_MakeupArtists_Location] FOREIGN KEY([location_id])
REFERENCES [dbo].[Location] ([location_id])
GO
ALTER TABLE [dbo].[MakeupArtists] CHECK CONSTRAINT [FK_MakeupArtists_Location]
GO
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK__Messages__receiv__6754599E] FOREIGN KEY([receiver_id])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Messages] CHECK CONSTRAINT [FK__Messages__receiv__6754599E]
GO
ALTER TABLE [dbo].[Messages]  WITH CHECK ADD  CONSTRAINT [FK__Messages__sender__68487DD7] FOREIGN KEY([sender_id])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Messages] CHECK CONSTRAINT [FK__Messages__sender__68487DD7]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK__Payments__appoin__693CA210] FOREIGN KEY([appointment_id])
REFERENCES [dbo].[Appointments] ([appointment_id])
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK__Payments__appoin__693CA210]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK__Reviews__appoint__6B24EA82] FOREIGN KEY([appointment_id])
REFERENCES [dbo].[Appointments] ([appointment_id])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK__Reviews__appoint__6B24EA82]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK__Reviews__artist___6C190EBB] FOREIGN KEY([artist_id])
REFERENCES [dbo].[MakeupArtists] ([artist_id])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK__Reviews__artist___6C190EBB]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK__Reviews__user_id__6D0D32F4] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK__Reviews__user_id__6D0D32F4]
GO
ALTER TABLE [dbo].[ServiceDetails]  WITH CHECK ADD  CONSTRAINT [FK__ServiceDe__artis__6FEA9F9F] FOREIGN KEY([artist_id])
REFERENCES [dbo].[MakeupArtists] ([artist_id])
GO
ALTER TABLE [dbo].[ServiceDetails] CHECK CONSTRAINT [FK__ServiceDe__artis__6FEA9F9F]
GO
ALTER TABLE [dbo].[ServiceDetails]  WITH CHECK ADD  CONSTRAINT [FK__ServiceDe__servi__6E01572D] FOREIGN KEY([service_id])
REFERENCES [dbo].[Services] ([service_id])
GO
ALTER TABLE [dbo].[ServiceDetails] CHECK CONSTRAINT [FK__ServiceDe__servi__6E01572D]
GO
ALTER TABLE [dbo].[ServiceDetails]  WITH CHECK ADD  CONSTRAINT [FK__ServiceDe__user___6EF57B66] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ServiceDetails] CHECK CONSTRAINT [FK__ServiceDe__user___6EF57B66]
GO
ALTER TABLE [dbo].[Services]  WITH CHECK ADD  CONSTRAINT [FK_Services_MakeupArtists_MakeupArtistArtistId] FOREIGN KEY([MakeupArtistArtistId])
REFERENCES [dbo].[MakeupArtists] ([artist_id])
GO
ALTER TABLE [dbo].[Services] CHECK CONSTRAINT [FK_Services_MakeupArtists_MakeupArtistArtistId]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK__Users__location___70DDC3D8] FOREIGN KEY([location_id])
REFERENCES [dbo].[Location] ([location_id])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK__Users__location___70DDC3D8]
GO
USE [master]
GO
ALTER DATABASE [makeup] SET  READ_WRITE 
GO
