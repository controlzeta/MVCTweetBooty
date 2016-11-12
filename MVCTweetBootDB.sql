USE [master]
GO
/****** Object:  Database [MVCTweetBot ]    Script Date: 11/11/2016 09:42:40 p. m. ******/
CREATE DATABASE [MVCTweetBot ]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TweetBotDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TweetBotDB.mdf' , SIZE = 6144KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TweetBotDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TweetBotDB_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [MVCTweetBot ] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MVCTweetBot ].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MVCTweetBot ] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET ARITHABORT OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MVCTweetBot ] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MVCTweetBot ] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MVCTweetBot ] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MVCTweetBot ] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MVCTweetBot ] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET RECOVERY FULL 
GO
ALTER DATABASE [MVCTweetBot ] SET  MULTI_USER 
GO
ALTER DATABASE [MVCTweetBot ] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MVCTweetBot ] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MVCTweetBot ] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MVCTweetBot ] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'MVCTweetBot ', N'ON'
GO
USE [MVCTweetBot ]
GO
/****** Object:  User [x1]    Script Date: 11/11/2016 09:42:41 p. m. ******/
CREATE USER [x1] FOR LOGIN [x1] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [x1]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [x1]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [x1]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [x1]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [x1]
GO
ALTER ROLE [db_datareader] ADD MEMBER [x1]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [x1]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [x1]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [x1]
GO
/****** Object:  Table [dbo].[BannedWords]    Script Date: 11/11/2016 09:42:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BannedWords](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bannedWord] [nvarchar](50) NOT NULL,
	[timestamp] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 11/11/2016 09:42:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Configuration](
	[ConsumerKey] [nvarchar](255) NOT NULL,
	[ConsumerSecret] [nvarchar](255) NOT NULL,
	[AccessToken] [nvarchar](255) NOT NULL,
	[AccessTokenSecret] [nvarchar](255) NOT NULL,
	[Minutes] [int] NOT NULL,
	[RTCount] [int] NOT NULL,
	[TweetLimit] [int] NOT NULL,
	[FavLimit] [int] NOT NULL,
	[FollowLimit] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Hashtags]    Script Date: 11/11/2016 09:42:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hashtags](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[hashtag] [nchar](50) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[repeated] [int] NOT NULL,
 CONSTRAINT [PK_Hashtags] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Links]    Script Date: 11/11/2016 09:42:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Links](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](140) NOT NULL,
	[description] [nvarchar](500) NOT NULL,
	[sortOrder] [int] NOT NULL,
	[link] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SearchTerms]    Script Date: 11/11/2016 09:42:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchTerms](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[SearchTerm] [nvarchar](140) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tweeted]    Script Date: 11/11/2016 09:42:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tweeted](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](250) NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	[Username] [nvarchar](50) NULL,
	[TweetId] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tweets]    Script Date: 11/11/2016 09:42:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tweets](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tweet] [nvarchar](140) NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[tweeted] [int] NOT NULL,
 CONSTRAINT [PK_Tweets] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[BannedWords] ON 

INSERT [dbo].[BannedWords] ([id], [bannedWord], [timestamp]) VALUES (1, N'gay', CAST(0x0000A61500000000 AS DateTime))
INSERT [dbo].[BannedWords] ([id], [bannedWord], [timestamp]) VALUES (4, N'bareback', CAST(0x0000A61500000000 AS DateTime))
INSERT [dbo].[BannedWords] ([id], [bannedWord], [timestamp]) VALUES (6, N'pedofilia', CAST(0x0000A61500000000 AS DateTime))
INSERT [dbo].[BannedWords] ([id], [bannedWord], [timestamp]) VALUES (11, N'nsfw', CAST(0x0000A61500000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[BannedWords] OFF
INSERT [dbo].[Configuration] ([ConsumerKey], [ConsumerSecret], [AccessToken], [AccessTokenSecret], [Minutes], [RTCount], [TweetLimit], [FavLimit], [FollowLimit]) VALUES (N'KjQX1AEwCIwZlkDCbfjGZfxoy', N'kTyR4KOlK8a5l2vMJWa7Yr0VVbWujKYw3Ftizo9tQ7BIRmkgVG', N'737790439093215232-Aftmd49XbDruvJ8UGw32USTwLR8Ed2j', N'2UPcvCR0n0tT92waJthxYHkQsa0bnMv6NF8eDye0AvjGK', 5, 12, 4, 16, 2)
SET IDENTITY_INSERT [dbo].[SearchTerms] ON 

INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (1, N'desarrollo web')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (2, N'microsoft developer')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (3, N'front end developer')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (4, N'C# developer')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (5, N'desarrolladores mexico')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (6, N'UX UI Design')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (7, N'web development business')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (8, N'ethical hacking')
INSERT [dbo].[SearchTerms] ([id], [SearchTerm]) VALUES (9, N'google developers')
SET IDENTITY_INSERT [dbo].[SearchTerms] OFF
SET IDENTITY_INSERT [dbo].[Tweeted] ON 

INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (1, N'Testing... ', CAST(0x0000A6B80130E86C AS DateTime), N'Tweet', N'pakito555', 7.961478151772119E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (2, N'Y es que fui de todo y sin medida, lo siento fui un loco.', CAST(0x0000A6B900C25A51 AS DateTime), N'Tweet', N'pakito555', 7.9640891071443763E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (3, N'Paso 2. Leer un RSS', CAST(0x0000A6B900C469C1 AS DateTime), N'Tweet', N'pakito555', 7.9641079562626662E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (4, N'ok ok.... ', CAST(0x0000A6B900C5002B AS DateTime), N'Tweet', N'pakito555', 7.964113443251159E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (5, N'2016/11/10 03:55:58
部屋の状態⇒気温:20.8℃(-0.4),湿度:65.9％(+0.1),気圧:1022.0hPa(-0.6),予測:はれ
季節性インフルエンザ感染目安→注意 #My気象情報', CAST(0x0000A6B900D5F654 AS DateTime), N'Favorite', N' ', 7.9642613128083046E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (6, N'2016/11/10 03:55:58
部屋の状態⇒気温:20.8℃(-0.4),湿度:65.9％(+0.1),気圧:1022.0hPa(-0.6),予測:はれ
季節性インフルエンザ感染目安→注意 #My気象情報', CAST(0x0000A6B900D601E6 AS DateTime), N'ReTweet', N' ', 7.9642613128083046E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (7, N'コアラのデスクは.
気温 : 22.07℃
湿度 : 37.19%
体感気温 : 20.50℃ です
2016/11/10 04:00:02', CAST(0x0000A6B900D6AD5A AS DateTime), N'ReTweet', N' ', 7.9642714616818893E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (8, N'The @MSFTDynamics365 Developer Toolkit has been released! Get it here: https://t.co/1lvuufMDBQ … #MSDYNCRM #MSDYN365 #CRMUG #eXtremeCRM', CAST(0x0000A6B900DEB4C1 AS DateTime), N'Favorite', N' ', 7.9643417851859354E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (9, N'The @MSFTDynamics365 Developer Toolkit has been released! Get it here: https://t.co/1lvuufMDBQ … #MSDYNCRM #MSDYN365 #CRMUG #eXtremeCRM', CAST(0x0000A6B900DEB6D0 AS DateTime), N'ReTweet', N' ', 7.9643417851859354E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (10, N'Rafael Lang, director de #Turismo de Mota-Engil México y ahora desarrolladores de #CostaCanuva, compartió la misma opinión que @edelamadrid', CAST(0x0000A6B900DF0074 AS DateTime), N'Favorite', N' ', 7.9641155730750259E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (11, N'Rafael Lang, director de #Turismo de Mota-Engil México y ahora desarrolladores de #CostaCanuva, compartió la misma opinión que @edelamadrid', CAST(0x0000A6B900DF01C5 AS DateTime), N'ReTweet', N' ', 7.9641155730750259E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (12, N'RT @SamLetsNurture: Ensure your Growth with Python #webdev . Provide Clients #Python based applications according to the business needs. ht…', CAST(0x0000A6B901166885 AS DateTime), N'Favorite', N' ', 7.9637413963644928E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (13, N'RT @CNNMex: Cómo llegar a los millennials y la falta de desarrolladores, los retos del e-commerce en México https://t.co/4Q1MZQZ4kI', CAST(0x0000A6BA00B929ED AS DateTime), N'Favorite', N' ', 7.9573426134935962E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (14, N'RT @CNNMex: Cómo llegar a los millennials y la falta de desarrolladores, los retos del e-commerce en México https://t.co/4Q1MZQZ4kI', CAST(0x0000A6BA00B92AF7 AS DateTime), N'ReTweet', N' ', 7.9573426134935962E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (15, N'RT @ilyagermanyuk: UI/UX Design Trends For Tabular Content On The Web https://t.co/61azkWPgoR #webdesign &amp; #webdevelopment', CAST(0x0000A6BA00B92BDB AS DateTime), N'Favorite', N' ', 7.9675813767611187E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (16, N'RT @AndroidDev: Learn more about the #GooglePlay Developer Sentiment Survey launching in November https://t.co/TSM9Q1DscT #DSAT #feedback #…', CAST(0x0000A6BA00DFCF5E AS DateTime), N'Favorite', N' ', 7.9678481210318848E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (17, N'RT @cativ_ve: Servicio de Desarrollo Web CATIV, C.A., SERVIWEB EXPRESS, Diferenciate de la competencia y referencia tu negocio. https://t.c…', CAST(0x0000A6BA00DFD5B6 AS DateTime), N'Favorite', N' ', 7.9678917527830118E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (18, N'RT @cativ_ve: Servicio de Desarrollo Web CATIV, C.A., SERVIWEB EXPRESS, Diferenciate de la competencia y referencia tu negocio. https://t.c…', CAST(0x0000A6BA00DFD60F AS DateTime), N'ReTweet', N' ', 7.9678917527830118E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (19, N'RT @Henrywebline: Get the best web design development solutions for your business, #webdev #webdesign #WebDevelopment https://t.co/zdxYIw36…', CAST(0x0000A6BA00F31A45 AS DateTime), N'ReTweet', N' ', 7.96703159406035E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (20, N'RT @startup_2020: we''re live.

#SocialMedia driven #App #Developer.

simulate a 21st Century #Business #Case. Your way to #Success.

https:…', CAST(0x0000A6BA01058905 AS DateTime), N'Favorite', N' ', 7.9680596977067622E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (21, N'RT @GSuiteDevs: Engineer @wescpy introduces new Google Slides API to build automated slide deck generation into your app! https://t.co/xX2P…', CAST(0x0000A6BA01058B80 AS DateTime), N'ReTweet', N' ', 7.9682660471434445E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (22, N'RT @startup_2020: we''re live.

#SocialMedia driven #App #Developer.

simulate a 21st Century #Business #Case. Your way to #Success.

https:…', CAST(0x0000A6BA01058D8A AS DateTime), N'ReTweet', N' ', 7.9680596977067622E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (23, N'RT @ScottDurow: 🌟 Public beta of #MSDYN365 #visualstudio Developer Toolkit released today - https://t.co/A7UiuD3YYF #msdyncrm 🌟', CAST(0x0000A6BA01215EBD AS DateTime), N'Favorite', N' ', 7.9683760025861734E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (24, N'RT @AndroidAuth: Arrested for hacking the FBI, they called him a hero https://t.co/5Cs1hBnxsx https://t.co/LlXE66Wp4p', CAST(0x0000A6BA01216085 AS DateTime), N'Favorite', N' ', 7.9685076958048666E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (25, N'RT @oneplus: Carl met up with @xdadevelopers to talk about #OnePlus, the industry and much more. Read the 3-part interview now! https://t.c…', CAST(0x0000A6BA013412BF AS DateTime), N'ReTweet', N' ', 7.9684100545465139E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (26, N'RT @oneplus: Carl met up with @xdadevelopers to talk about #OnePlus, the industry and much more. Read the 3-part interview now! https://t.c…', CAST(0x0000A6BA013413BF AS DateTime), N'Favorite', N' ', 7.9684100545465139E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (27, N'RT @Delahuntagram: This character creation UI is quite functional.

#design #ux #ui #creative

https://t.co/uuH9BNW5UP https://t.co/jZe23t9…', CAST(0x0000A6BA0134151A AS DateTime), N'ReTweet', N' ', 7.9686441048886067E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (28, N'RT @AndroidAuth: Arrested for hacking the FBI, they called him a hero https://t.co/5Cs1hBnxsx https://t.co/LlXE66Wp4p', CAST(0x0000A6BA01341696 AS DateTime), N'ReTweet', N' ', 7.9685076958048666E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (29, N'RT @JulieKuehl: &lt;- this front end WordPress developer is looking for work', CAST(0x0000A6BA014492D2 AS DateTime), N'ReTweet', N' ', 7.9686842313755443E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (30, N'RT @BetterThan_Cash: How to design the best smartphone interfaces for #MobileMoney? A list of design rules: https://t.co/LpcM8TWX9D @CGAP #…', CAST(0x0000A6BA0185B7AB AS DateTime), N'ReTweet', N' ', 7.9694428270364672E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (31, N'RT @Mybridge_Design: Tooltip Design for Improving User Experience. #UX #UI https://t.co/HZG1tbr3bJ https://t.co/m3FmKZLDuZ', CAST(0x0000A6BB000E450F AS DateTime), N'Favorite', N' ', 7.969628006648791E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (32, N'RT @chr1sa: Google has open sourced more projects than I knew (20 million lines of code):  Google Open Source Report Card https://t.co/YZC4…', CAST(0x0000A6BB000E45DB AS DateTime), N'Favorite', N' ', 7.9696050309223629E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (33, N'RT @chr1sa: Google has open sourced more projects than I knew (20 million lines of code):  Google Open Source Report Card https://t.co/YZC4…', CAST(0x0000A6BB000E462C AS DateTime), N'ReTweet', N' ', 7.9696050309223629E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (34, N'RT @devbattles: Junior C   #Developer #ITJob #Artel Outsourcing https://t.co/EEwRypIyFF https://t.co/D1LXmbLN5z', CAST(0x0000A6BB000E4707 AS DateTime), N'ReTweet', N' ', 7.96882359132033E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (35, N'RT @JohnLaTwC: ICYMI Want MSRC bulletin data programmatically?  Hellllooo Microsoft Security Update API @ https://t.co/JFZrCqJrf9 https://t…', CAST(0x0000A6BB001E36D6 AS DateTime), N'ReTweet', N' ', 7.9698219243812045E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (36, N'RT @Samidzki: Digital Marketing Agency for SEO, SMM, SEM, &amp; Web Development for your GREAT BUSINESS ;) https://t.co/Uy7Upovqk9', CAST(0x0000A6BB0031B986 AS DateTime), N'ReTweet', N' ', 7.9693248583794688E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (37, N'RT @AdhamDannaway: If Satan was a web developer 😜  👹 https://t.co/i0PP7eyHJ8 #design #UX #UI https://t.co/b2qOZSbGtw', CAST(0x0000A6BB0031BB88 AS DateTime), N'Favorite', N' ', 7.9699365179677082E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (38, N'RT @AdhamDannaway: If Satan was a web developer 😜  👹 https://t.co/i0PP7eyHJ8 #design #UX #UI https://t.co/b2qOZSbGtw', CAST(0x0000A6BB0031BBE0 AS DateTime), N'ReTweet', N' ', 7.9699365179677082E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (39, N'RT @VinculoCL: Haz Crecer tu Negocio con Tu Propia Página Web &gt;&gt; https://t.co/SYxbjLbbdo &lt;&lt; Contáctate con nosotros https://t.co/oGampmgJVT', CAST(0x0000A6BB003F7A59 AS DateTime), N'ReTweet', N' ', 7.9698503689355264E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (40, N'RT @moyheen: Are you a Nigerian Android UI/UX designer who knows what to do with Material design and meaningful motion? Please DM me with y…', CAST(0x0000A6BB00538924 AS DateTime), N'Favorite', N' ', 7.9703134781036954E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (41, N'RT @ziozec: @Musement is hiring frontend developers, join our wizards tech team! https://t.co/ew4MQbMmsP #ChromeDevSummit #reactjs #progres…', CAST(0x0000A6BB005389DB AS DateTime), N'Favorite', N' ', 7.97023213180031E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (42, N'RT @ziozec: @Musement is hiring frontend developers, join our wizards tech team! https://t.co/ew4MQbMmsP #ChromeDevSummit #reactjs #progres…', CAST(0x0000A6BB00538A4E AS DateTime), N'ReTweet', N' ', 7.97023213180031E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (43, N'RT @moyheen: Are you a Nigerian Android UI/UX designer who knows what to do with Material design and meaningful motion? Please DM me with y…', CAST(0x0000A6BB0064957B AS DateTime), N'ReTweet', N' ', 7.9704043859104973E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (44, N'RT @JohnLaTwC: ICYMI Want MSRC bulletin data programmatically?  Hellllooo Microsoft Security Update API @ https://t.co/JFZrCqJrf9 https://t…', CAST(0x0000A6BB0087361A AS DateTime), N'Favorite', N' ', 7.97051194992685E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (45, N'RT @jcTwittMouse: 🐭 Introduction to #AngularJS #JS #WebDevelopment #sviluppoweb  #webGeliştirme ➡ https://t.co/eeSccmDBVl https://t.co/UqRt…', CAST(0x0000A6BB00A94A13 AS DateTime), N'Favorite', N' ', 7.9710520509557146E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (46, N'RT @jcTwittMouse: 🐭 Introduction to #AngularJS #JS #WebDevelopment #sviluppoweb  #webGeliştirme ➡ https://t.co/eeSccmDBVl https://t.co/UqRt…', CAST(0x0000A6BB00A94A90 AS DateTime), N'ReTweet', N' ', 7.9710520509557146E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (47, N'RT @owencm: 🎉 We put together a Progressive Web App checklist to help you build great experiences! (Feedback super appreciated!) https://t.…', CAST(0x0000A6BB00C62942 AS DateTime), N'Favorite', N' ', 7.9713347698209587E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (48, N'RT @owencm: 🎉 We put together a Progressive Web App checklist to help you build great experiences! (Feedback super appreciated!) https://t.…', CAST(0x0000A6BB00C62D86 AS DateTime), N'ReTweet', N' ', 7.9713347698209587E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (49, N'RT @EffectiveSoft: Find out most important skills that describe a top-notch #webdesigner
https://t.co/PwdyU6llzk
#design #webdesign #UI #UX…', CAST(0x0000A6BB0145F172 AS DateTime), N'ReTweet', N' ', 7.9723125481067315E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (50, N'RT @jaffathecake: 📝 Async functions are enabled by default in Chrome 55. Here''s how they work, and why I love them: https://t.co/cuvjBu7Jvi…', CAST(0x0000A6BB0145F3FD AS DateTime), N'Favorite', N' ', 7.9725042600535654E+17)
INSERT [dbo].[Tweeted] ([Id], [Text], [Timestamp], [Action], [Username], [TweetId]) VALUES (51, N'RT @jaffathecake: 📝 Async functions are enabled by default in Chrome 55. Here''s how they work, and why I love them: https://t.co/cuvjBu7Jvi…', CAST(0x0000A6BB0145F48B AS DateTime), N'ReTweet', N' ', 7.9725042600535654E+17)
SET IDENTITY_INSERT [dbo].[Tweeted] OFF
ALTER TABLE [dbo].[Hashtags] ADD  CONSTRAINT [DF_Hashtags_repeated]  DEFAULT ((0)) FOR [repeated]
GO
ALTER TABLE [dbo].[Links] ADD  DEFAULT ((0)) FOR [sortOrder]
GO
ALTER TABLE [dbo].[Tweets] ADD  CONSTRAINT [DF_Tweets_tweeted]  DEFAULT ((0)) FOR [tweeted]
GO
USE [master]
GO
ALTER DATABASE [MVCTweetBot ] SET  READ_WRITE 
GO
