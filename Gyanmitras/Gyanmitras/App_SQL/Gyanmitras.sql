USE [Gyanmitras_Dev]
GO
/****** Object:  Schema [SiteUsers]    Script Date: 5/29/2020 7:32:46 PM ******/
CREATE SCHEMA [SiteUsers]
GO
/****** Object:  UserDefinedTableType [SiteUsers].[PlannedCommunicationData]    Script Date: 5/29/2020 7:32:46 PM ******/
CREATE TYPE [SiteUsers].[PlannedCommunicationData] AS TABLE(
	[FK_CounselorID] [bigint] NOT NULL,
	[FK_StudentID] [bigint] NOT NULL,
	[DateTimeFrom] [nvarchar](20) NOT NULL,
	[DateTimeTo] [nvarchar](20) NOT NULL,
	[CommunicationPlan] [nvarchar](200) NULL,
	[IsActive] [bit] NULL DEFAULT ((1)),
	[IsDeleted] [bit] NULL DEFAULT ((1))
)
GO
/****** Object:  UserDefinedTableType [SiteUsers].[Type_AcademicDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
CREATE TYPE [SiteUsers].[Type_AcademicDetails] AS TABLE(
	[FK_UserID] [bigint] NULL,
	[Education_Type] [varchar](20) NULL,
	[Class] [varchar](10) NULL,
	[FK_BoardID] [int] NULL,
	[FK_StreamID] [int] NULL,
	[Currentsemester] [varchar](50) NULL,
	[UniversityName] [varchar](100) NULL,
	[NatureOFCompletion] [varchar](50) NULL,
	[Percentage] [decimal](5, 0) NULL,
	[Previous_Class] [varchar](10) NULL,
	[FK_Previous_Class_Board] [int] NULL,
	[Previous_Class_Percentage] [decimal](5, 0) NULL,
	[Year_of_Passing] [varchar](10) NULL,
	[OtherWork] [varchar](500) NULL,
	[Specification] [varchar](50) NULL,
	[CourseName] [varchar](50) NULL
)
GO
/****** Object:  UserDefinedTableType [SiteUsers].[Type_FeedBackCriteria]    Script Date: 5/29/2020 7:32:47 PM ******/
CREATE TYPE [SiteUsers].[Type_FeedBackCriteria] AS TABLE(
	[PK_FeedBackId] [bigint] NULL,
	[FK_CounselorID] [bigint] NULL,
	[FK_StudentID] [nvarchar](100) NULL,
	[FK_FeedBackCriteriaID] [bigint] NULL,
	[FeedBackBy] [nvarchar](100) NULL,
	[IsLikeThisClass] [bit] NULL,
	[FeedBackSuggesstion] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[RateFeedBack] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SplitString]  
(      
      @Input NVARCHAR(MAX),  
      @Character CHAR(1)  
)  
RETURNS @Output TABLE (  
      Item NVARCHAR(MAX)  
)  
AS  
BEGIN  
      DECLARE @StartIndex INT, @EndIndex INT  
   
      SET @StartIndex = 1  
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character  
      BEGIN  
            SET @Input = @Input + @Character  
      END  
   
      WHILE CHARINDEX(@Character, @Input) > 0  
      BEGIN  
            SET @EndIndex = CHARINDEX(@Character, @Input)  
             
            INSERT INTO @Output(Item)  
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)  
             
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))  
      END  
   
      RETURN  
END



GO
/****** Object:  UserDefinedFunction [dbo].[udf-Str-JSON]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf-Str-JSON] (@IncludeHead int,@ToLowerCase int,@XML xml)
Returns varchar(max)
AS
Begin
    Declare @Head varchar(max) = '',@JSON varchar(max) = ''
    ; with cteEAV as (Select RowNr=Row_Number() over (Order By (Select NULL))
                            ,Entity    = xRow.value('@*[1]','varchar(100)')
                            ,Attribute = xAtt.value('local-name(.)','varchar(100)')
                            ,Value     = xAtt.value('.','varchar(max)') 
                       From  @XML.nodes('/row') As R(xRow) 
                       Cross Apply R.xRow.nodes('./@*') As A(xAtt) )
          ,cteSum as (Select Records=count(Distinct Entity)
                            ,Head = IIF(@IncludeHead=0,IIF(count(Distinct Entity)<=1,'[getResults]','[[getResults]]'),Concat('{"status":{"successful":"true","timestamp":"',Format(GetUTCDate(),'yyyy-MM-dd hh:mm:ss '),'GMT','","rows":"',count(Distinct Entity),'"},"results":[[getResults]]}') ) 
                       From  cteEAV)
          ,cteBld as (Select *
                            ,NewRow=IIF(Lag(Entity,1)  over (Partition By Entity Order By (Select NULL))=Entity,'',',{')
                            ,EndRow=IIF(Lead(Entity,1) over (Partition By Entity Order By (Select NULL))=Entity,',','}')
                            ,JSON=Concat('"',IIF(@ToLowerCase=1,Lower(Attribute),Attribute),'":','"',Value,'"') 
                       From  cteEAV )
    Select @JSON = @JSON+NewRow+JSON+EndRow,@Head = Head From cteBld, cteSum
    Return Replace(@Head,'[getResults]',Stuff(@JSON,1,1,''))
End
-- Parameter 1: @IncludeHead 1/0
-- Parameter 2: @ToLowerCase 1/0 (converts field name to lowercase
-- Parameter 3: (Select * From ... for XML RAW)
GO
/****** Object:  Table [dbo].[Config_PageColumn]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Config_PageColumn](
	[PK_PageColumnConfigId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_FormColumnId] [bigint] NULL,
	[FK_AccountId] [bigint] NULL,
	[Column_Name] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[FK_FormId] [bigint] NULL,
	[UpdatedBy] [bigint] NULL,
	[Updated_DateTime] [datetime] NULL,
	[FK_CustomerId] [bigint] NULL,
	[icon] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_PageColumnConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ErrorLog_App]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog_App](
	[ErrorLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[Source] [nvarchar](100) NOT NULL,
	[Assembly_Name] [nvarchar](100) NOT NULL,
	[Class_Name] [nvarchar](100) NOT NULL,
	[Method_Name] [nvarchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](300) NOT NULL,
	[ErrorType] [nvarchar](100) NOT NULL,
	[Remarks] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK__ErrorLog__D65247C2D0B8C695] PRIMARY KEY CLUSTERED 
(
	[ErrorLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ErrorLog_Service]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog_Service](
	[ErrorLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[Source] [nvarchar](100) NOT NULL,
	[Assembly_Name] [nvarchar](100) NOT NULL,
	[Class_Name] [nvarchar](100) NOT NULL,
	[Method_Name] [nvarchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](max) NOT NULL,
	[Remarks] [nvarchar](max) NOT NULL,
	[ErrorType] [nvarchar](250) NULL,
 CONSTRAINT [PK__ErrorLog__D65247C2FB77C137] PRIMARY KEY CLUSTERED 
(
	[ErrorLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LKP_CalibrationType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LKP_CalibrationType](
	[PK_CalibrationTypeId] [bigint] NULL,
	[CalibrationTypeName] [nvarchar](130) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LKP_ExcludeFormByCategoryType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LKP_ExcludeFormByCategoryType](
	[PK_ExcludeId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryType] [nvarchar](250) NULL,
	[FormNames] [nvarchar](max) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LKP_Language]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LKP_Language](
	[PK_LanguageId] [int] IDENTITY(1,1) NOT NULL,
	[LanguageFullName] [nvarchar](100) NULL,
	[LanguageCultureName] [nvarchar](30) NULL,
	[LanguageIcon] [nvarchar](30) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LKP_MobileApps]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LKP_MobileApps](
	[PK_MobileApp_Id] [int] IDENTITY(1,1) NOT NULL,
	[App_Name] [varchar](50) NULL,
	[OSType] [varchar](50) NULL,
	[App_Description] [varchar](500) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_LKP_MobileApps] PRIMARY KEY CLUSTERED 
(
	[PK_MobileApp_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Map_FormAccount]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Map_FormAccount](
	[PK_FormAccountId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_FormId] [bigint] NULL,
	[FK_AccountId] [bigint] NULL,
	[FK_CategoryId] [bigint] NULL,
	[IsCustomerAccount] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[FK_CustomerId] [bigint] NULL,
	[InsertionMode] [varchar](20) NULL,
	[CanAdd] [bit] NULL,
	[CanEdit] [bit] NULL,
	[CanDelete] [bit] NULL,
	[CanView] [bit] NULL,
 CONSTRAINT [PK_Map_FormAccount] PRIMARY KEY CLUSTERED 
(
	[PK_FormAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Map_FormLanguage]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Map_FormLanguage](
	[PK_FormLanguageId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_FormId] [bigint] NULL,
	[TranslatedFormName] [nvarchar](100) NULL,
	[FK_LanguageId] [bigint] NULL,
	[IsActive] [bit] NULL CONSTRAINT [df_IsActive]  DEFAULT ('0'),
	[IsDeleted] [bit] NULL CONSTRAINT [df_IsDeleted]  DEFAULT ('0'),
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[FK_CompanyID] [bigint] NULL,
	[FK_AccountID] [bigint] NULL,
	[FK_CustomerID] [bigint] NULL,
 CONSTRAINT [PK_Map_FormLanguage] PRIMARY KEY CLUSTERED 
(
	[PK_FormLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Map_FormRole]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Map_FormRole](
	[PK_FormRoleId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_FormId] [bigint] NULL,
	[FK_RoleId] [bigint] NULL,
	[CanAdd] [bit] NULL,
	[CanEdit] [bit] NULL,
	[CanDelete] [bit] NULL,
	[CanView] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[InsertionMode] [varchar](20) NULL,
 CONSTRAINT [PK__MST_M__2DC2CA694A71FA24] PRIMARY KEY CLUSTERED 
(
	[PK_FormRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MAP_FormRole_MobileApp]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAP_FormRole_MobileApp](
	[PK_FormRoleId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_FormId] [bigint] NULL,
	[FK_RoleId] [bigint] NULL,
	[CanAdd] [bit] NULL,
	[CanEdit] [bit] NULL,
	[CanDelete] [bit] NULL,
	[CanView] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MAP_UserAccount]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAP_UserAccount](
	[PK_UserAccountId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_UserId] [bigint] NULL,
	[FK_AccountId] [bigint] NULL,
	[FK_CategoryId] [bigint] NULL,
	[IsCustomerAccount] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_Account]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_Account](
	[PK_AccountId] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountName] [nvarchar](150) NOT NULL,
	[FK_CategoryId] [bigint] NOT NULL,
	[FK_CompanyId] [bigint] NULL,
	[FK_ResellerId] [bigint] NULL,
	[FK_AffiliateId] [bigint] NULL,
	[ParentAccountId] [bigint] NULL,
	[AccountAddress] [nvarchar](500) NULL,
	[ZipCode] [nvarchar](30) NULL,
	[FK_CountryId] [bigint] NOT NULL,
	[FK_StateId] [bigint] NOT NULL,
	[FK_CityId] [bigint] NOT NULL,
	[BillingAddress] [nvarchar](500) NULL,
	[ContactPerson] [nvarchar](150) NULL,
	[MobileNo] [nvarchar](20) NULL,
	[AlternateMobileNo] [nvarchar](30) NULL,
	[EmailId] [nvarchar](100) NULL,
	[AlternateEmailId] [nvarchar](100) NULL,
	[AccountLogo] [nvarchar](max) NULL,
	[AccountRegistrationNo] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[ZipCode_Billing] [nvarchar](6) NULL,
	[FK_CountryId_Billing] [bigint] NULL,
	[FK_StateId_Billing] [bigint] NULL,
	[FK_CityId_Billing] [bigint] NULL,
	[UserLimit] [int] NULL,
	[FK_UserId] [bigint] NULL,
	[FK_CategoryId_Referrer] [bigint] NULL DEFAULT ('0'),
	[FK_AccountId_Referrer] [bigint] NULL DEFAULT ('0'),
	[ShareVia] [varchar](50) NULL,
 CONSTRAINT [PK__MST_A__FEE2E2D6BBA5160B] PRIMARY KEY CLUSTERED 
(
	[PK_AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_Category]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Category](
	[PK_CategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](150) NULL,
	[FK_CompanyId] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_City]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_City](
	[PK_CityId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_CountryId] [bigint] NOT NULL,
	[FK_StateId] [bigint] NOT NULL,
	[CityName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
 CONSTRAINT [PK__MST_C__60A2AE21211687C0] PRIMARY KEY CLUSTERED 
(
	[PK_CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_Company]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_Company](
	[PK_CompanyId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_CompanyId] [bigint] NULL,
	[CompanyName] [varchar](500) NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[CompanyPhoneNo] [nvarchar](50) NULL,
	[Email] [nvarchar](200) NULL,
	[FK_CountryId] [bigint] NULL,
	[FK_StateId] [bigint] NULL,
	[FK_CityId] [bigint] NULL,
	[GSTNo] [nvarchar](50) NULL,
	[PanNo] [nvarchar](50) NULL,
	[CIN] [nvarchar](50) NULL,
	[CompanyLogo_Name] [nvarchar](200) NULL,
	[AlternateMobileNo] [nvarchar](50) NULL,
	[AlternateEmailID] [nvarchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[Address] [nvarchar](500) NULL,
	[AddressSame] [nvarchar](500) NULL,
	[PinCode] [nvarchar](50) NULL,
	[PinCode_Billing] [nvarchar](50) NULL,
	[FK_CountryId_Billing] [bigint] NULL,
	[FK_CityId_Billing] [bigint] NULL,
	[FK_StateId_Billing] [bigint] NULL,
	[logoClass] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_Country]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_Country](
	[PK_CountryId] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[TimeZone] [varchar](10) NULL,
 CONSTRAINT [PK__MST_C__0A4C9D57EDE917B5] PRIMARY KEY CLUSTERED 
(
	[PK_CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_Form]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_Form](
	[PK_FormId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_SolutionId] [bigint] NULL,
	[FormName] [nvarchar](100) NULL,
	[ControllerName] [nvarchar](100) NULL,
	[ActionName] [nvarchar](100) NULL,
	[FK_ParentId] [bigint] NULL,
	[FK_MainId] [int] NULL,
	[LevelId] [int] NULL,
	[SortId] [int] NULL,
	[Image] [varchar](80) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDate] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[ClassName] [nvarchar](50) NULL,
	[Area] [nvarchar](100) NULL,
	[FormFor] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_FormColumn]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_FormColumn](
	[PK_FormColumnId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_FormId] [bigint] NULL,
	[Form_Name] [nvarchar](50) NULL,
	[Column_Name] [nvarchar](50) NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[IsActive] [bit] NULL,
	[FK_AccountId] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_FormColumnId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_MapFormCompany]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_MapFormCompany](
	[PK_FormCompanyId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_FormId] [bigint] NULL,
	[FK_CompanyId] [bigint] NULL,
	[CanAdd] [bit] NULL,
	[CanEdit] [bit] NULL,
	[CanDelete] [bit] NULL,
	[CanView] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
 CONSTRAINT [PK__MST_M__BCC642B20C2EB111] PRIMARY KEY CLUSTERED 
(
	[PK_FormCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_MobileAppStatus]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_MobileAppStatus](
	[PK_AppStatus_ID] [int] IDENTITY(1,1) NOT NULL,
	[App_Name] [varchar](50) NULL,
	[App_Current_Version] [varchar](30) NULL,
	[AppUpdateCompulsary] [bit] NULL,
	[UpdateDatetime] [datetime] NULL,
	[IsActive] [bit] NULL,
	[IsUpdateAvailable] [bit] NULL,
	[ClearAppData] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDatetime] [datetime] NULL,
	[RecordUpdatedBy] [int] NULL,
	[RecordUpdatedDatetime] [datetime] NULL,
 CONSTRAINT [PK_MST_MobileAppStatus] PRIMARY KEY CLUSTERED 
(
	[PK_AppStatus_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_Role]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_Role](
	[PK_RoleId] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[FK_CategoryId] [bigint] NULL,
	[FK_AccountId] [bigint] NULL,
	[HomePage] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[FK_CustomerId] [bigint] NULL,
	[FK_InstallerId] [bigint] NULL,
	[FK_DriverId] [bigint] NULL,
	[FK_CompanyId] [bigint] NULL,
 CONSTRAINT [PK__MST_R__B09F5DC9B50FEDCF] PRIMARY KEY CLUSTERED 
(
	[PK_RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_State]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_State](
	[PK_StateId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_CountryId] [bigint] NOT NULL,
	[StateName] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
 CONSTRAINT [PK__MST_S__B650CB33CE7D908E] PRIMARY KEY CLUSTERED 
(
	[PK_StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_User]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_User](
	[PK_UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NULL,
	[FK_CategoryId] [bigint] NULL,
	[FK_RoleId] [bigint] NULL,
	[FK_CustomerId] [bigint] NULL,
	[FK_AccountId] [bigint] NULL,
	[UserPassword] [nvarchar](50) NULL,
	[MobileNo] [nvarchar](20) NULL,
	[AlternateMobileNo] [nvarchar](20) NULL,
	[EmailId] [nvarchar](100) NULL,
	[AlternateEmailId] [nvarchar](100) NULL,
	[Gender] [nvarchar](10) NULL,
	[DateOfBirth] [nvarchar](150) NULL,
	[UserAddress] [nvarchar](500) NULL,
	[ZipCode] [nvarchar](30) NULL,
	[FK_CountryId] [bigint] NULL,
	[FK_StateId] [bigint] NULL,
	[FK_CityId] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[FullName] [nvarchar](250) NULL,
	[ShareBy] [nvarchar](250) NULL,
	[FK_InstallerId] [bigint] NULL,
	[FK_DriverId] [bigint] NULL,
	[AppRegId] [varchar](500) NULL,
	[IMEINo] [varchar](100) NULL,
	[OSType] [varchar](100) NULL,
	[LastLoginDt] [datetime] NULL,
	[IsVehicleSpecific] [bit] NULL,
	[LastWebLogInDatetime] [datetime] NULL,
 CONSTRAINT [PK_MST_User] PRIMARY KEY CLUSTERED 
(
	[PK_UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_VehicleBrand]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_VehicleBrand](
	[PK_VehicleBrandId] [bigint] IDENTITY(1,1) NOT NULL,
	[VehicleBrandName] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[FK_AccountId] [bigint] NULL,
 CONSTRAINT [PK_MST_VehicleBrand] PRIMARY KEY CLUSTERED 
(
	[PK_VehicleBrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MST_VehicleType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MST_VehicleType](
	[PK_VehicleTypeId] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VehicleType] [nvarchar](100) NULL,
	[MovingIcon] [nvarchar](100) NULL,
	[IdlingIcon] [nvarchar](100) NULL,
	[StopIcon] [nvarchar](100) NULL,
	[OfflineIcon] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
 CONSTRAINT [PK_MST_VehicleType] PRIMARY KEY CLUSTERED 
(
	[PK_VehicleTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PROC_ERROR]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROC_ERROR](
	[ErrorNumber] [bigint] NULL,
	[ErrorSeverity] [bigint] NULL,
	[ErrorState] [bigint] NULL,
	[ErrorProcedure] [nvarchar](128) NULL,
	[ErrorLine] [bigint] NULL,
	[ErrorMessage] [nvarchar](4000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[Board]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[Board](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BoardName] [char](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[LKP_Languages]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[LKP_Languages](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LanguageName] [char](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[MAP_SiteUserFeedBack]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MAP_SiteUserFeedBack](
	[PK_FeedBackId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_CounselorID] [bigint] NULL,
	[FK_StudentID] [bigint] NULL,
	[FK_FeedBackCriteriaID] [bigint] NULL,
	[FeedBackBy] [nvarchar](100) NULL,
	[IsLikeThisClass] [bit] NULL,
	[FeedBackSuggesstion] [nvarchar](100) NULL,
	[RateFeedBack] [int] NULL,
	[RatedBy] [bigint] NULL,
	[RateDateTme] [datetime] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_FeedBackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_AcademicDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[MST_AcademicDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FK_UserID] [bigint] NULL,
	[Education_Type] [varchar](20) NULL,
	[Class] [varchar](10) NULL,
	[FK_BoardID] [int] NULL,
	[FK_StreamID] [int] NULL,
	[Currentsemester] [varchar](50) NULL,
	[UniversityName] [varchar](100) NULL,
	[NatureOFCompletion] [varchar](50) NULL,
	[Percentage] [decimal](5, 2) NULL,
	[Previous_Class] [varchar](10) NULL,
	[FK_Previous_Class_Board] [int] NULL,
	[Previous_Class_Percentage] [decimal](5, 2) NULL,
	[Year_of_Passing] [varchar](10) NULL,
	[CourseName] [varchar](50) NULL,
	[Specification] [varchar](50) NULL,
	[OtherWork] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[MST_AcademicGroup]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_AcademicGroup](
	[PK_AcademicGroupId] [bigint] IDENTITY(1,1) NOT NULL,
	[AcademicGroupName] [nvarchar](200) NULL,
	[IsActive] [bit] NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[PK_AcademicGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_AreaOfInterest]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[MST_AreaOfInterest](
	[PK_AreaOfInterest] [bigint] IDENTITY(1,1) NOT NULL,
	[AreaOfInterest] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_LKP_AreaOfInterest_IsActive]  DEFAULT ((1)),
	[TYPE] [varchar](20) NULL CONSTRAINT [DF_LKP_AreaOfInterest_TYPE]  DEFAULT ('counselor'),
 CONSTRAINT [PK_LKP_AreaOfInterest] PRIMARY KEY CLUSTERED 
(
	[PK_AreaOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[MST_BenifitType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_BenifitType](
	[PK_BenifitTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[BenifitTypeName] [nvarchar](200) NULL,
	[IsActive] [bit] NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[PK_BenifitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_ContentResourcePage]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_ContentResourcePage](
	[PK_ContantResourceId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_RoleId] [bigint] NULL,
	[FK_StateId] [bigint] NULL,
	[FK_SearchCategoryId] [bigint] NULL,
	[FK_SubSearchCategoryId] [bigint] NULL,
	[Heading] [nvarchar](100) NULL,
	[Description] [nvarchar](500) NULL,
	[ResourceType] [nvarchar](50) NULL,
	[ResourceFileName] [nvarchar](200) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[DeletedBy] [bit] NULL,
	[DeletedDateTime] [datetime] NULL,
	[UpdatedBy] [bit] NULL,
	[UpdatedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_ContantResourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_DET_StreamCourses]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_DET_StreamCourses](
	[PK_DET_Stream] [bigint] IDENTITY(1,1) NOT NULL,
	[StreamCourses] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_LKP_DET_StreamCourses_IsActive]  DEFAULT ((1)),
	[FK_StreamType] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_DET_Stream] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_EmployedExpertise]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_EmployedExpertise](
	[PK_EmployedExpertise] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployedExpertise] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_LKP_EmployedExpertise_IsActive]  DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[PK_EmployedExpertise] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_FeedBackCriteria]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_FeedBackCriteria](
	[PK_FeedBackCriteriaID] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_SiteUserCategoryID] [bigint] NULL,
	[FeedbackCriteria] [nvarchar](100) NULL,
	[MarkCriteria_Yes] [int] NULL,
	[MarkCriteria_No] [int] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_FeedBackCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[Mst_Feeds]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[Mst_Feeds](
	[PK_FeedID] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_UserID] [bigint] NULL,
	[FeedSubject] [varchar](200) NULL,
	[FeedDescription] [varchar](500) NULL,
	[MediaType] [varchar](100) NULL,
	[VideoUrl] [varchar](100) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[ResourceFile] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_FeedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[MST_MAP_PlannedCommunication]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[MST_MAP_PlannedCommunication](
	[PK_PlannedCommunicationID] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_CounselorID] [bigint] NOT NULL,
	[FK_StudentID] [bigint] NOT NULL,
	[DateTimeFrom] [varchar](20) NOT NULL,
	[DateTimeTo] [varchar](20) NOT NULL,
	[CommunicationPlan] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF__MST_MAP_P__IsAct__4B0D20AB]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL CONSTRAINT [DF__MST_MAP_P__IsDel__4C0144E4]  DEFAULT ((1)),
	[CreatedDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK__MST_MAP___66FD41D1D63B3E64] PRIMARY KEY CLUSTERED 
(
	[PK_PlannedCommunicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[MST_MAP_SiteUserCategory]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_MAP_SiteUserCategory](
	[PK_MAP_UserCategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_CategoryId] [bigint] NULL,
	[FK_UserId] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_MAP_UserCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_RetiredExpertise]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_RetiredExpertise](
	[PK_RetiredExpertise] [bigint] IDENTITY(1,1) NOT NULL,
	[RetiredExpertise] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_LKP_RetiredExpertise_IsActive]  DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[PK_RetiredExpertise] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_SiteUser]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[MST_SiteUser](
	[PK_UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NULL,
	[FK_CategoryId] [bigint] NULL,
	[FK_RoleId] [bigint] NULL,
	[UserPassword] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
	[Name] [nvarchar](100) NULL,
	[LastWebLogInDatetime] [datetime] NULL,
	[Mobile_Number] [nvarchar](50) NULL,
	[Alternate_Mobile_Number] [nvarchar](50) NULL,
	[Address] [varchar](200) NULL,
	[Zipcode] [varchar](10) NULL,
	[FK_StateID] [bigint] NULL,
	[FK_CityID] [bigint] NULL,
	[FK_LanguageKnown] [varchar](100) NULL,
	[FK_AreaOfInterest] [varchar](100) NULL,
	[Image] [nvarchar](200) NULL,
	[HaveSmartPhone] [bit] NULL,
	[HavePC] [bit] NULL,
	[AdoptionWish] [bit] NULL,
	[Email] [nvarchar](200) NULL,
	[Fk_AreaOfInterest_State] [bigint] NULL,
	[Fk_AreaOfInterest_District] [bigint] NULL,
	[AreYou] [nvarchar](50) NULL,
	[JoinUsDescription] [nvarchar](200) NULL,
	[Declaration] [bit] NULL,
	[LikeAdoptStudentLater] [bit] NULL,
	[RecoverBy] [bigint] NULL,
	[RecoverDateTime] [datetime] NULL,
	[IsPendingForReply] [bit] NULL,
	[PendingForReplyDateTime] [datetime] NULL,
	[IsManageCreiticalSupport] [bit] NULL,
	[LastManageCreiticalSupportDateTime] [datetime] NULL,
	[IsApprovedCounselor] [bit] NULL,
	[ApprovedCounselorDateTime] [datetime] NULL,
	[Retired_expertise] [varchar](50) NULL,
	[Employed_expertise] [varchar](50) NULL,
	[IsAdoptedStudent] [bit] NULL,
	[IsAdoptedStudentCounselor] [bit] NULL,
	[AdoptedStudentCounselorDateTime] [datetime] NULL,
	[IsAdoptedStudentDateTime] [datetime] NULL,
	[IsAdoptedStudentByCounselor] [bigint] NULL,
	[ApprovedCounselorBy] [bigint] NULL,
	[IsEmailVerified] [bit] NULL,
	[EmailVerifiedDateTime] [datetime] NULL,
 CONSTRAINT [PK__MST_User__7C1FCE7F972E8FAE] PRIMARY KEY CLUSTERED 
(
	[PK_UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[MST_SiteUserCategory]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_SiteUserCategory](
	[PK_CategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_SiteUserChat]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[MST_SiteUserChat](
	[PK_ChatID] [bigint] IDENTITY(1,1) NOT NULL,
	[Chat_From] [bigint] NULL,
	[Chat_To] [bigint] NULL,
	[Query_From] [varchar](max) NULL,
	[Query_To] [varchar](max) NULL,
	[QueryDateTime_From] [datetime] NULL,
	[QueryDateTime_To] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [bigint] NULL,
	[IsSeen_From] [bit] NULL,
	[IsSeen_To] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_ChatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [SiteUsers].[MST_SiteUserRole]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_SiteUserRole](
	[PK_RoleId] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[FK_CategoryId] [bigint] NULL,
	[HomePage] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [bigint] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedBy] [bigint] NULL,
	[DeletedDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_StateUT]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_StateUT](
	[PK_StateUT] [bigint] IDENTITY(1,1) NOT NULL,
	[StateUT] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_LKP_StateUT_IsActive]  DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[PK_StateUT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_StateUTBoard]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_StateUTBoard](
	[PK_StateUTBoard] [bigint] IDENTITY(1,1) NOT NULL,
	[StateUTBoard] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_LKP_StateUTBoard_IsActive]  DEFAULT ((1)),
	[FK_StateUT] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PK_StateUTBoard] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[MST_StreamType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SiteUsers].[MST_StreamType](
	[PK_StreamType] [bigint] IDENTITY(1,1) NOT NULL,
	[StreamType] [nvarchar](200) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_LKP_StreamType_IsActive]  DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[PK_StreamType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [SiteUsers].[stream]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [SiteUsers].[stream](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EducationLevel] [char](50) NULL,
	[StreamName] [char](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ErrorLog_App] ON 

GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (1, CAST(N'2020-03-19 16:14:41.807' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (2, CAST(N'2020-03-19 16:14:55.627' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (3, CAST(N'2020-03-19 16:14:56.460' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (4, CAST(N'2020-03-19 16:15:17.790' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (5, CAST(N'2020-03-19 16:20:12.643' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (6, CAST(N'2020-03-19 16:20:12.710' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (7, CAST(N'2020-03-19 16:20:13.080' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (8, CAST(N'2020-03-19 16:20:35.337' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MstFormDAL', N'GetFormsDetails', N'Invalid object name ''dboGyanmitrasMST_Solution''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (9, CAST(N'2020-03-19 16:20:38.143' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MstFormDAL', N'GetFormsDetails', N'Invalid object name ''dboGyanmitrasMST_Solution''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10, CAST(N'2020-03-19 16:20:38.420' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MstFormDAL', N'GetFormsDetails', N'Invalid object name ''dboGyanmitrasMST_Solution''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (11, CAST(N'2020-03-19 18:41:45.590' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (12, CAST(N'2020-03-19 18:41:46.333' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (13, CAST(N'2020-03-19 18:41:47.003' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (14, CAST(N'2020-03-20 14:47:42.670' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (15, CAST(N'2020-03-20 14:47:43.490' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (16, CAST(N'2020-03-20 14:47:44.307' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (17, CAST(N'2020-03-20 14:49:20.280' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (18, CAST(N'2020-03-20 14:49:24.797' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (19, CAST(N'2020-03-20 14:49:26.043' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (20, CAST(N'2020-03-20 14:49:33.403' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (21, CAST(N'2020-03-20 14:49:41.833' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (22, CAST(N'2020-03-20 15:25:30.280' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (23, CAST(N'2020-03-20 15:25:31.243' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (24, CAST(N'2020-03-20 15:25:31.987' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (25, CAST(N'2020-03-20 15:25:36.470' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (26, CAST(N'2020-03-20 15:25:42.770' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (27, CAST(N'2020-03-20 15:40:38.563' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (28, CAST(N'2020-03-20 15:40:47.490' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (29, CAST(N'2020-03-20 15:40:49.877' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (30, CAST(N'2020-04-20 23:28:28.533' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (31, CAST(N'2020-04-20 23:28:50.350' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (32, CAST(N'2020-04-20 23:28:54.223' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (33, CAST(N'2020-04-20 23:29:14.257' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (34, CAST(N'2020-04-20 23:29:14.410' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (35, CAST(N'2020-04-20 23:29:16.930' AS DateTime), N'', N'Gyanmitras', N'EBuddeeDAL', N'EBuddeeDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (36, CAST(N'2020-04-21 21:23:33.813' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (37, CAST(N'2020-04-21 21:23:35.223' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (38, CAST(N'2020-04-21 21:23:36.487' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (39, CAST(N'2020-04-21 21:23:43.787' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (40, CAST(N'2020-04-21 21:23:48.237' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (41, CAST(N'2020-04-21 21:23:49.923' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTUserAccountMappingDAL', N'GetMSTUserAccountMappingDetails', N'Invalid object name ''MST_Category''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (42, CAST(N'2020-04-21 21:23:55.267' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTUserAccountMappingDAL', N'GetMSTUserAccountMappingDetails', N'Invalid object name ''MST_Category''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (43, CAST(N'2020-04-21 21:23:55.980' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTUserAccountMappingDAL', N'GetMSTUserAccountMappingDetails', N'Invalid object name ''MST_Category''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (44, CAST(N'2020-04-21 21:24:00.447' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTFormLanguageMappingDAL', N'GetFormLanguageMappingDetails', N'Invalid object name ''dboGyanmitrasMST_Customer''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (45, CAST(N'2020-04-21 21:24:01.080' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTFormLanguageMappingDAL', N'GetFormLanguageMappingDetails', N'Invalid object name ''dboGyanmitrasMST_Customer''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (46, CAST(N'2020-04-21 21:24:01.490' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTFormLanguageMappingDAL', N'GetFormLanguageMappingDetails', N'Invalid object name ''dboGyanmitrasMST_Customer''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (47, CAST(N'2020-04-21 21:24:06.977' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTFormLanguageMappingDAL', N'GetFormLanguageMappingDetails', N'Invalid object name ''dboGyanmitrasMST_Customer''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (48, CAST(N'2020-04-21 22:38:45.030' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (49, CAST(N'2020-04-21 22:38:51.463' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (50, CAST(N'2020-04-21 22:38:59.497' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (51, CAST(N'2020-04-21 22:39:24.647' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (52, CAST(N'2020-04-21 22:39:24.753' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (53, CAST(N'2020-04-21 22:39:25.183' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (54, CAST(N'2020-04-21 22:39:58.763' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (55, CAST(N'2020-04-21 22:40:00.520' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (56, CAST(N'2020-04-21 22:40:00.657' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (57, CAST(N'2020-04-21 22:40:01.103' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (58, CAST(N'2020-04-21 22:40:06.590' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (59, CAST(N'2020-04-21 22:43:35.920' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (60, CAST(N'2020-04-21 22:43:41.550' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (61, CAST(N'2020-04-21 22:43:42.670' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dboGyanmitrasMST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (62, CAST(N'2020-04-21 22:43:48.787' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Invalid object name ''dboGyanmitrasMST_Solution''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (63, CAST(N'2020-04-21 22:43:49.480' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Invalid object name ''dboGyanmitrasMST_Solution''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (64, CAST(N'2020-04-21 22:43:49.990' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Invalid object name ''dboGyanmitrasMST_Solution''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (65, CAST(N'2020-04-21 22:58:04.250' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (66, CAST(N'2020-04-21 22:58:05.590' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (67, CAST(N'2020-04-21 22:58:06.740' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (68, CAST(N'2020-04-21 23:02:04.977' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Invalid object name ''dbo.MST_Solution''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (69, CAST(N'2020-04-21 23:02:09.177' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Specified cast is not valid.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (70, CAST(N'2020-04-21 23:02:15.297' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Specified cast is not valid.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (71, CAST(N'2020-04-21 23:02:15.420' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Cannot find table 0.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (72, CAST(N'2020-04-21 23:02:16.743' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Specified cast is not valid.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (73, CAST(N'2020-04-21 23:07:36.487' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Specified cast is not valid.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (74, CAST(N'2020-04-21 23:07:37.973' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Specified cast is not valid.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (75, CAST(N'2020-04-21 23:07:39.767' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'GetFormsDetails', N'Specified cast is not valid.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (76, CAST(N'2020-04-21 23:30:53.447' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (77, CAST(N'2020-04-21 23:30:54.213' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (78, CAST(N'2020-04-21 23:30:55.510' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (79, CAST(N'2020-04-22 19:32:32.530' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (80, CAST(N'2020-04-22 19:32:38.673' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (81, CAST(N'2020-04-22 19:32:40.713' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (82, CAST(N'2020-04-22 19:33:49.597' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (83, CAST(N'2020-04-22 19:33:49.730' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (84, CAST(N'2020-04-22 19:33:50.297' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (85, CAST(N'2020-04-22 19:34:56.703' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (86, CAST(N'2020-04-22 19:35:02.160' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (87, CAST(N'2020-04-22 19:35:03.970' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (88, CAST(N'2020-04-22 19:35:17.277' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (89, CAST(N'2020-04-22 19:35:22.897' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (90, CAST(N'2020-04-22 19:35:24.590' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (91, CAST(N'2020-04-22 19:39:02.437' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (92, CAST(N'2020-04-22 19:39:02.630' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (93, CAST(N'2020-04-22 19:39:03.113' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (94, CAST(N'2020-04-22 19:49:51.533' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (95, CAST(N'2020-04-22 19:49:52.963' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (96, CAST(N'2020-04-22 19:49:54.713' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (97, CAST(N'2020-04-22 19:50:02.847' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (98, CAST(N'2020-04-22 19:50:03.003' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (99, CAST(N'2020-04-22 19:50:03.513' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (100, CAST(N'2020-04-22 21:25:38.363' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (101, CAST(N'2020-04-22 21:26:36.753' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (102, CAST(N'2020-04-22 21:26:42.940' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (103, CAST(N'2020-04-22 21:26:43.903' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (104, CAST(N'2020-04-22 21:28:24.730' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (105, CAST(N'2020-04-22 21:28:26.093' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (106, CAST(N'2020-04-22 21:28:26.687' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (107, CAST(N'2020-04-22 21:28:30.557' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (108, CAST(N'2020-04-22 22:45:55.720' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (109, CAST(N'2020-04-22 22:45:57.510' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (110, CAST(N'2020-04-22 22:45:58.420' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (111, CAST(N'2020-04-25 00:27:22.847' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (112, CAST(N'2020-04-25 00:27:24.670' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (113, CAST(N'2020-04-25 00:27:25.717' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (114, CAST(N'2020-04-26 23:03:25.803' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'BindEmployedExpertiseDetailsList', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (115, CAST(N'2020-04-28 18:37:40.207' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (116, CAST(N'2020-04-28 18:37:46.700' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (117, CAST(N'2020-04-28 18:37:49.323' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (118, CAST(N'2020-04-28 18:37:54.180' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (119, CAST(N'2020-04-28 18:37:54.320' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (120, CAST(N'2020-04-28 18:37:54.737' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (121, CAST(N'2020-04-28 18:37:55.610' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (122, CAST(N'2020-04-28 18:37:55.733' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (123, CAST(N'2020-04-28 18:37:57.130' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (124, CAST(N'2020-04-28 18:37:57.823' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (125, CAST(N'2020-04-28 18:37:58.060' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (126, CAST(N'2020-04-28 18:37:58.407' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (127, CAST(N'2020-04-28 18:38:00.220' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (128, CAST(N'2020-04-28 18:38:00.353' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (129, CAST(N'2020-04-28 18:38:00.733' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (130, CAST(N'2020-04-28 18:38:06.540' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (131, CAST(N'2020-04-28 18:38:07.737' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (132, CAST(N'2020-04-28 18:38:07.900' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (133, CAST(N'2020-04-28 18:38:08.313' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (134, CAST(N'2020-04-28 18:38:10.427' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (135, CAST(N'2020-04-28 18:38:10.647' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (136, CAST(N'2020-04-28 18:38:11.310' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (137, CAST(N'2020-04-28 18:38:59.890' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (138, CAST(N'2020-04-28 18:39:05.950' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (139, CAST(N'2020-04-28 18:39:06.080' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (140, CAST(N'2020-04-28 18:39:54.303' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (141, CAST(N'2020-04-28 18:41:47.333' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (142, CAST(N'2020-04-28 18:41:47.507' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (143, CAST(N'2020-04-28 18:44:42.340' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (144, CAST(N'2020-04-28 18:59:16.740' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (145, CAST(N'2020-04-28 18:59:19.740' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (146, CAST(N'2020-04-28 18:59:21.697' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (147, CAST(N'2020-04-28 18:59:58.560' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (148, CAST(N'2020-04-28 18:59:58.690' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (149, CAST(N'2020-04-28 19:00:00.993' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (150, CAST(N'2020-04-28 19:00:02.453' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (151, CAST(N'2020-04-28 19:00:03.697' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (152, CAST(N'2020-04-28 19:00:05.100' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (153, CAST(N'2020-04-28 19:00:10.717' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (154, CAST(N'2020-04-28 19:03:10.180' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (155, CAST(N'2020-04-28 19:03:10.453' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (156, CAST(N'2020-04-28 19:03:17.003' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (157, CAST(N'2020-04-28 19:04:27.693' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (158, CAST(N'2020-04-28 19:04:27.840' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (159, CAST(N'2020-04-28 19:04:29.810' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (160, CAST(N'2020-04-28 19:04:42.880' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (161, CAST(N'2020-04-28 19:04:43.013' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (162, CAST(N'2020-04-28 19:04:43.363' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (163, CAST(N'2020-04-28 19:05:04.557' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (164, CAST(N'2020-04-28 19:05:04.707' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (165, CAST(N'2020-04-28 19:05:06.313' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (166, CAST(N'2020-04-28 19:05:20.063' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (167, CAST(N'2020-04-28 19:05:20.240' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (168, CAST(N'2020-04-28 19:05:21.353' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (169, CAST(N'2020-04-28 19:12:25.517' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (170, CAST(N'2020-04-28 19:12:27.850' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (171, CAST(N'2020-04-28 19:12:29.777' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (172, CAST(N'2020-04-28 19:14:48.593' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (173, CAST(N'2020-04-28 19:14:50.723' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (174, CAST(N'2020-04-28 19:14:52.940' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (175, CAST(N'2020-04-28 19:23:16.800' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (176, CAST(N'2020-04-28 19:23:22.937' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (177, CAST(N'2020-04-28 19:23:25.533' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (178, CAST(N'2020-04-28 19:23:32.980' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (179, CAST(N'2020-04-28 19:25:53.957' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (180, CAST(N'2020-04-28 19:25:55.617' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (181, CAST(N'2020-04-28 19:25:57.653' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (182, CAST(N'2020-04-28 19:26:05.363' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (183, CAST(N'2020-04-28 19:33:42.050' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (184, CAST(N'2020-04-28 19:33:43.847' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (185, CAST(N'2020-04-28 19:33:46.053' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (186, CAST(N'2020-04-28 19:34:04.987' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (187, CAST(N'2020-04-28 19:34:08.180' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (188, CAST(N'2020-04-28 19:34:14.360' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (189, CAST(N'2020-04-28 19:34:26.340' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (190, CAST(N'2020-04-28 19:34:54.017' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (191, CAST(N'2020-04-28 19:35:32.293' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (192, CAST(N'2020-04-28 19:35:32.463' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (193, CAST(N'2020-04-28 19:35:33.880' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (194, CAST(N'2020-04-28 19:35:37.153' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (195, CAST(N'2020-04-28 19:35:37.330' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (196, CAST(N'2020-04-28 19:35:38.887' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (197, CAST(N'2020-04-28 19:35:44.997' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (198, CAST(N'2020-04-28 19:35:45.130' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (199, CAST(N'2020-04-28 19:35:45.503' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (200, CAST(N'2020-04-28 19:36:15.380' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (201, CAST(N'2020-04-28 19:36:15.663' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (202, CAST(N'2020-04-28 19:37:37.540' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (203, CAST(N'2020-04-28 19:37:47.407' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (204, CAST(N'2020-04-28 19:37:51.560' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (205, CAST(N'2020-04-28 19:41:21.507' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (206, CAST(N'2020-04-28 19:41:55.837' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (207, CAST(N'2020-04-28 19:42:04.930' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (208, CAST(N'2020-04-28 19:42:07.943' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (209, CAST(N'2020-04-28 19:42:08.163' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (210, CAST(N'2020-04-28 19:49:02.560' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (211, CAST(N'2020-04-28 19:49:11.803' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (212, CAST(N'2020-04-28 19:49:17.193' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (213, CAST(N'2020-04-28 19:49:19.767' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (214, CAST(N'2020-04-28 19:49:21.097' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (215, CAST(N'2020-04-28 19:49:24.480' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (216, CAST(N'2020-04-28 19:49:26.490' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (217, CAST(N'2020-04-28 19:54:05.060' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (218, CAST(N'2020-04-28 19:54:06.743' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (219, CAST(N'2020-04-28 19:54:12.467' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (220, CAST(N'2020-04-28 19:54:12.670' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (221, CAST(N'2020-04-28 19:54:13.860' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (222, CAST(N'2020-04-28 19:54:16.077' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (223, CAST(N'2020-04-28 19:54:16.770' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (224, CAST(N'2020-04-28 19:54:17.227' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (225, CAST(N'2020-04-28 19:54:17.433' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (226, CAST(N'2020-04-28 19:56:01.557' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'@iFK_CompanyId is not a parameter for procedure USP_GetRoleDetails.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (227, CAST(N'2020-04-28 19:56:03.410' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Column ''RoleFor'' does not belong to table Table1.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (228, CAST(N'2020-04-28 19:56:07.383' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Column ''RoleFor'' does not belong to table Table1.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (229, CAST(N'2020-04-28 20:07:30.120' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (230, CAST(N'2020-04-28 20:07:31.393' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (231, CAST(N'2020-04-28 20:07:32.097' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (232, CAST(N'2020-04-28 20:07:43.130' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Column ''RoleFor'' does not belong to table Table1.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (233, CAST(N'2020-04-28 20:07:50.343' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Column ''RoleFor'' does not belong to table Table1.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (234, CAST(N'2020-04-28 20:07:52.543' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Column ''RoleFor'' does not belong to table Table1.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (235, CAST(N'2020-04-28 20:07:54.390' AS DateTime), N'getRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Column ''RoleFor'' does not belong to table Table1.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (236, CAST(N'2020-04-28 20:23:30.430' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (237, CAST(N'2020-04-28 20:23:31.957' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (238, CAST(N'2020-04-28 20:23:32.897' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (239, CAST(N'2020-04-28 20:26:10.063' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (240, CAST(N'2020-04-28 20:26:11.390' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (241, CAST(N'2020-04-28 20:26:12.140' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (242, CAST(N'2020-04-28 20:27:58.107' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (243, CAST(N'2020-04-28 20:27:59.660' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (244, CAST(N'2020-04-28 20:28:00.923' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (245, CAST(N'2020-04-29 09:56:30.990' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (246, CAST(N'2020-04-29 09:56:37.647' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (247, CAST(N'2020-04-29 09:56:38.500' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (248, CAST(N'2020-04-29 10:00:44.473' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (249, CAST(N'2020-04-29 10:00:44.633' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (250, CAST(N'2020-04-29 10:00:45.223' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (251, CAST(N'2020-04-29 10:20:52.817' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (252, CAST(N'2020-04-29 10:20:53.137' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (253, CAST(N'2020-04-29 10:20:54.810' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (254, CAST(N'2020-04-29 11:25:16.140' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (255, CAST(N'2020-04-29 11:25:17.533' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (256, CAST(N'2020-04-29 11:25:18.357' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (257, CAST(N'2020-04-29 11:29:19.693' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (258, CAST(N'2020-04-29 11:29:19.703' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (259, CAST(N'2020-04-29 11:29:21.147' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (260, CAST(N'2020-04-29 11:34:09.343' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (261, CAST(N'2020-04-29 11:34:09.357' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (262, CAST(N'2020-04-29 11:34:18.440' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (263, CAST(N'2020-04-29 11:43:45.940' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (264, CAST(N'2020-04-29 11:43:46.017' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (265, CAST(N'2020-04-29 11:43:46.760' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (266, CAST(N'2020-04-29 15:27:02.420' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (267, CAST(N'2020-04-29 15:27:02.747' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (268, CAST(N'2020-04-29 15:27:03.697' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (269, CAST(N'2020-05-01 15:38:52.483' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (270, CAST(N'2020-05-01 15:38:54.080' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (271, CAST(N'2020-05-01 15:38:55.337' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (272, CAST(N'2020-05-01 15:40:04.257' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'AddEditFormDetails', N'Invalid object name ''dboGyanmitrasMST_Form''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (273, CAST(N'2020-05-01 15:42:09.857' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'AddEditFormDetails', N'Invalid object name ''dboGyanmitrasMST_Form''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (274, CAST(N'2020-05-01 15:43:49.020' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (275, CAST(N'2020-05-01 15:43:55.280' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (276, CAST(N'2020-05-01 15:43:55.793' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (277, CAST(N'2020-05-01 15:44:18.177' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (278, CAST(N'2020-05-01 15:44:24.627' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (279, CAST(N'2020-05-01 15:44:26.147' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (280, CAST(N'2020-05-01 15:44:32.467' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (281, CAST(N'2020-05-01 15:44:32.640' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (282, CAST(N'2020-05-01 15:44:33.113' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (283, CAST(N'2020-05-01 15:45:55.107' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (284, CAST(N'2020-05-01 15:46:54.973' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MSTAccountDAL', N'GetAccountDetails', N'Invalid object name ''dbo.MST_Category''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (285, CAST(N'2020-05-01 15:47:25.937' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Category''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (286, CAST(N'2020-05-01 15:47:32.577' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Category''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (287, CAST(N'2020-05-01 15:47:33.103' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Category''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (288, CAST(N'2020-05-01 15:56:28.150' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (289, CAST(N'2020-05-01 15:57:06.350' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (290, CAST(N'2020-05-01 15:57:06.483' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (291, CAST(N'2020-05-01 15:57:06.963' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (292, CAST(N'2020-05-01 15:57:16.370' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (293, CAST(N'2020-05-01 15:57:35.603' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (294, CAST(N'2020-05-01 16:01:48.893' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (295, CAST(N'2020-05-01 16:01:49.050' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (296, CAST(N'2020-05-01 16:01:49.493' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (297, CAST(N'2020-05-01 16:17:31.150' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'AddEditFormDetails', N'Invalid object name ''dboGyanmitrasMST_Form''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (298, CAST(N'2020-05-01 16:18:16.220' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstFormDAL', N'AddEditFormDetails', N'Invalid object name ''dboGyanmitrasMST_Form''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (299, CAST(N'2020-05-01 16:19:39.697' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (300, CAST(N'2020-05-01 16:19:44.933' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (301, CAST(N'2020-05-01 16:19:45.407' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (302, CAST(N'2020-05-01 16:19:58.460' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (303, CAST(N'2020-05-01 16:22:47.120' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (304, CAST(N'2020-05-01 16:22:53.213' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Invalid object name ''MST_Customer''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (305, CAST(N'2020-05-01 16:25:44.353' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Specified cast is not valid.', N'System.Data.DataSetExtensions', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (306, CAST(N'2020-05-01 16:25:46.427' AS DateTime), N'GyanmitrasDAL.MstUserDAL', N'Gyanmitras', N'MstUserDAL', N'GyanmitrasDAL', N'Specified cast is not valid.', N'System.Data.DataSetExtensions', N'EXCEPTION IN: GetUserDetails METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (307, CAST(N'2020-05-01 16:32:14.183' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (308, CAST(N'2020-05-01 16:50:55.840' AS DateTime), N'AddEditRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Procedure or function ''USP_AddEditRole'' expects parameter ''@iFK_CategoryId'', which was not supplied.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (309, CAST(N'2020-05-01 16:52:24.680' AS DateTime), N'AddEditRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Procedure or function ''USP_AddEditRole'' expects parameter ''@iFK_CategoryId'', which was not supplied.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (310, CAST(N'2020-05-01 16:52:42.533' AS DateTime), N'AddEditRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Procedure or function ''USP_AddEditRole'' expects parameter ''@iFK_CategoryId'', which was not supplied.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (311, CAST(N'2020-05-01 16:55:29.633' AS DateTime), N'AddEditRole', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstRoleDAL', N'Procedure or function USP_AddEditRole has too many arguments specified.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (312, CAST(N'2020-05-01 16:57:19.900' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (313, CAST(N'2020-05-01 16:57:34.777' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (314, CAST(N'2020-05-01 16:59:23.720' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (315, CAST(N'2020-05-01 17:05:16.927' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (316, CAST(N'2020-05-01 17:06:11.567' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (317, CAST(N'2020-05-01 17:14:23.940' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (318, CAST(N'2020-05-01 17:14:54.547' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (319, CAST(N'2020-05-01 17:15:10.637' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (320, CAST(N'2020-05-02 12:40:09.720' AS DateTime), N'SaveRoleMapping', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MapFormRoleDAL', N'Could not find stored procedure ''dbo.USP_MapFormRoleAddEdit''.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (321, CAST(N'2020-05-02 13:12:40.547' AS DateTime), N'SaveRoleMapping', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MapFormRoleDAL', N'Procedure or function USP_MapFormRoleAddEdit has too many arguments specified.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (322, CAST(N'2020-05-02 13:13:54.807' AS DateTime), N'SaveRoleMapping', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MapFormRoleDAL', N'Cannot find table 0.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (323, CAST(N'2020-05-02 13:51:23.247' AS DateTime), N'SaveRoleMapping', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MapFormRoleDAL', N'Procedure or function ''USP_MapFormRoleAddEdit'' expects parameter ''@FK_ParentFormId'', which was not supplied.', N'', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (324, CAST(N'2020-05-06 21:09:02.717' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetBoardType', N'Invalid object name ''siteusers.usp_GetBoardType''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (325, CAST(N'2020-05-07 12:56:47.703' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.AdminDashboardDAL', N'GetAdminDashboardDetails', N'There is no row at position 0.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (326, CAST(N'2020-05-07 12:56:57.863' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.AdminDashboardDAL', N'GetAdminDashboardDetails', N'There is no row at position 0.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (327, CAST(N'2020-05-07 16:22:16.190' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'GetCounselorDetails', N'Procedure or function ''USP_GetSiteUserDetails'' expects parameter ''@iFK_CategoryId'', which was not su', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (328, CAST(N'2020-05-07 16:22:35.960' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'GetCounselorDetails', N'Unable to cast object of type ''System.Int32'' to type ''System.String''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (329, CAST(N'2020-05-07 16:23:15.327' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'GetCounselorDetails', N'Unable to cast object of type ''System.Int32'' to type ''System.String''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (330, CAST(N'2020-05-07 17:16:49.570' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'GetCounselorDetails', N'Column ''AreYou'' does not belong to table Table1.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (331, CAST(N'2020-05-07 17:16:57.790' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'GetCounselorDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (332, CAST(N'2020-05-08 23:29:08.173' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'DeleteSiteUser', N'Could not find stored procedure ''dbo.USP_SiteUserDeleteUser''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (333, CAST(N'2020-05-08 23:30:16.343' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'DeleteSiteUser', N'Could not find stored procedure ''dbo.USP_SiteUserDeleteUser''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (334, CAST(N'2020-05-09 13:30:25.390' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Column ''TotalItem'' does not belong to table Table2.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (335, CAST(N'2020-05-09 13:31:26.907' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Column ''TotalItem'' does not belong to table Table2.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (336, CAST(N'2020-05-09 13:32:00.930' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Column ''TotalItem'' does not belong to table Table2.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (337, CAST(N'2020-05-10 15:37:46.473' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (338, CAST(N'2020-05-10 15:37:52.420' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (339, CAST(N'2020-05-10 19:32:40.743' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (340, CAST(N'2020-05-10 19:32:46.560' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (341, CAST(N'2020-05-13 15:37:27.443' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.StudentDAL', N'RegisterStudent', N'Input string was not in a correct format.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (342, CAST(N'2020-05-13 22:09:52.200' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Column ''ID'' does not belong to table Table1.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (343, CAST(N'2020-05-14 01:25:28.593' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.StudentDAL', N'GetPlannedCommunication', N'Unable to cast object of type ''System.DateTime'' to type ''System.String''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (344, CAST(N'2020-05-14 15:19:43.740' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.StudentDAL', N'AddPlannedCommunication', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (345, CAST(N'2020-05-14 21:27:31.870' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'RegisterCounselor', N'Input string was not in a correct format.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (346, CAST(N'2020-05-14 21:41:11.920' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'RegisterCounselor', N'Conversion failed when converting the nvarchar value ''Commerce'' to data type int.
The data for tabl', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (347, CAST(N'2020-05-14 21:45:12.573' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.CounselorDAL', N'RegisterCounselor', N'Conversion failed when converting the nvarchar value ''Commerce'' to data type int.
The data for tabl', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (348, CAST(N'2020-05-14 21:48:41.207' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'BindAreaOfInterestList', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (349, CAST(N'2020-05-14 22:21:35.980' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.StudentDAL', N'AddPlannedCommunication', N'Column ''Message_Id'' does not belong to table Table.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (350, CAST(N'2020-05-15 12:49:12.060' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Column ''TotalItem'' does not belong to table Table2.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (351, CAST(N'2020-05-15 12:49:38.630' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Column ''TotalItem'' does not belong to table Table2.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (352, CAST(N'2020-05-15 13:41:54.430' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Column ''Message_Id'' does not belong to table Table.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (353, CAST(N'2020-05-15 19:08:19.800' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Counselor', N'UserProfile', N'Value cannot be null.
Parameter name: items', N'System.ArgumentNullException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (354, CAST(N'2020-05-15 19:09:31.760' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Counselor', N'UserProfile', N'Value cannot be null.
Parameter name: items', N'System.ArgumentNullException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (355, CAST(N'2020-05-15 19:09:44.543' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Counselor', N'UserProfile', N'Value cannot be null.
Parameter name: items', N'System.ArgumentNullException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (356, CAST(N'2020-05-15 19:09:54.250' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (357, CAST(N'2020-05-15 19:09:59.290' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (358, CAST(N'2020-05-15 19:10:02.627' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (359, CAST(N'2020-05-15 19:10:03.397' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (360, CAST(N'2020-05-15 19:10:03.780' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (361, CAST(N'2020-05-15 19:10:04.083' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (362, CAST(N'2020-05-15 19:10:04.370' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (363, CAST(N'2020-05-15 19:10:04.700' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (364, CAST(N'2020-05-15 19:10:05.037' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (365, CAST(N'2020-05-15 19:10:05.363' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (366, CAST(N'2020-05-15 19:10:05.673' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (367, CAST(N'2020-05-15 19:10:05.997' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (368, CAST(N'2020-05-15 19:10:19.397' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Account', N'Login', N'The view ''Login'' or its master was not found or no view engine supports the searched locations. The following locations were searched:
~/Views/Account/Login.aspx
~/Views/Account/Login.ascx
~/Views/Shared/Login.aspx
~/Views/Shared/Login.ascx
~/Views/Account/Login.cshtml
~/Views/Account/Login.vb', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (369, CAST(N'2020-05-15 19:20:59.483' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'MSTAccount', N'GetCityDetailsByStateId', N'The parameters dictionary contains a null entry for parameter ''stateId'' of non-nullable type ''System.Int64'' for method ''System.Web.Mvc.JsonResult GetCityDetailsByStateId(Int64)'' in ''Gyanmitras.Areas.Admin.Controllers.MSTAccountController''. An optional parameter must be a reference type, a nullable t', N'System.ArgumentException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (370, CAST(N'2020-05-16 22:06:01.843' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Index', N'Connection Timeout Expired.  The timeout period elapsed during the post-login phase.  The connection could have timed out while waiting for server to complete the login process and respond; Or it could have timed out while attempting to create multiple active connections.  The duration spent while a', N'System.Data.SqlClient.SqlException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (371, CAST(N'2020-05-16 22:06:01.843' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Index', N'ExecuteReader requires an open and available Connection. The connection''s current state is connecting.', N'System.InvalidOperationException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (372, CAST(N'2020-05-20 15:10:16.027' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Register', N'Unexpected "if" keyword after "@" character.  Once inside code, you do not need to prefix constructs like "if" with "@".
', N'System.Web.HttpParseException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (373, CAST(N'2020-05-20 15:10:31.900' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Register', N'Unexpected "if" keyword after "@" character.  Once inside code, you do not need to prefix constructs like "if" with "@".
', N'System.Web.HttpParseException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (374, CAST(N'2020-05-20 15:10:37.727' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Register', N'Unexpected "if" keyword after "@" character.  Once inside code, you do not need to prefix constructs like "if" with "@".
', N'System.Web.HttpParseException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (375, CAST(N'2020-05-20 15:10:41.313' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Register', N'Unexpected "if" keyword after "@" character.  Once inside code, you do not need to prefix constructs like "if" with "@".
', N'System.Web.HttpParseException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (376, CAST(N'2020-05-20 15:10:44.023' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Register', N'Unexpected "if" keyword after "@" character.  Once inside code, you do not need to prefix constructs like "if" with "@".
', N'System.Web.HttpParseException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (377, CAST(N'2020-05-20 15:10:57.490' AS DateTime), N'FleetTrackingSystem WebApp', N'Gyanmitras', N'Home', N'Register', N'Unexpected "if" keyword after "@" character.  Once inside code, you do not need to prefix constructs like "if" with "@".
', N'System.Web.HttpParseException', N'Application Level Error')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (378, CAST(N'2020-05-20 21:44:56.693' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@AdoptionWish'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (379, CAST(N'2020-05-20 21:58:55.710' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@AdoptionWish'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (380, CAST(N'2020-05-20 22:00:48.330' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@AdoptionWish'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (381, CAST(N'2020-05-20 22:01:34.527' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@AdoptionWish'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (382, CAST(N'2020-05-20 22:03:04.880' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@AdoptionWish'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (383, CAST(N'2020-05-20 22:03:55.557' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@AdoptionWish'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (384, CAST(N'2020-05-20 22:06:02.733' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@AdoptionWish'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (385, CAST(N'2020-05-21 12:58:31.387' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.User.VolunteerDAL', N'UpdateVolunteerProfile', N'Could not find stored procedure ''siteusers.sp_UpdateRegistration''.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (386, CAST(N'2020-05-21 14:23:20.953' AS DateTime), N'GyanmitrasDAL.Common.CommonDAL', N'Gyanmitras', N'CommonDal', N'GyanmitrasDAL', N'Could not find stored procedure ''USP_CheckUserName''.', N'.Net SqlClient Data Provider', N'EXCEPTION IN: CheckUserName METHOD')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10385, CAST(N'2020-05-22 09:53:25.737' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''FK_Education_DetailsID''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10386, CAST(N'2020-05-22 09:53:26.200' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''FK_Education_DetailsID''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10387, CAST(N'2020-05-22 09:53:36.073' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''FK_Education_DetailsID''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10388, CAST(N'2020-05-22 09:54:42.913' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''FK_Education_DetailsID''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10389, CAST(N'2020-05-22 09:57:12.623' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''FK_Education_DetailsID''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10390, CAST(N'2020-05-22 09:57:19.437' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10391, CAST(N'2020-05-22 10:01:19.157' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10392, CAST(N'2020-05-22 10:41:05.657' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUsers', N'Could not find stored procedure ''SiteUsers.USP_AddEditSiteUser''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10393, CAST(N'2020-05-22 10:41:21.403' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10394, CAST(N'2020-05-22 10:42:44.360' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUsers', N'Could not find stored procedure ''SiteUsers.USP_AddEditSiteUser''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10395, CAST(N'2020-05-22 11:25:57.607' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''Fk_UserName''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10396, CAST(N'2020-05-22 11:25:57.957' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''Fk_UserName''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10397, CAST(N'2020-05-22 11:26:00.733' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Invalid column name ''Fk_UserName''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10398, CAST(N'2020-05-22 11:31:52.513' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUsers', N'@FK_Education_DetailsID             is not a parameter for procedure USP_AddEditSiteUser.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10399, CAST(N'2020-05-22 11:56:25.467' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10400, CAST(N'2020-05-22 11:56:25.737' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10401, CAST(N'2020-05-22 12:02:57.613' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10402, CAST(N'2020-05-22 13:42:58.687' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10403, CAST(N'2020-05-22 14:08:42.473' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10404, CAST(N'2020-05-22 14:13:16.770' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10405, CAST(N'2020-05-22 14:14:30.290' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10406, CAST(N'2020-05-22 14:17:11.427' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10407, CAST(N'2020-05-22 14:26:08.720' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10408, CAST(N'2020-05-22 14:26:34.477' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10409, CAST(N'2020-05-22 14:29:20.157' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10410, CAST(N'2020-05-22 21:25:58.153' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@Name'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10411, CAST(N'2020-05-22 21:27:17.293' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@Name'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10412, CAST(N'2020-05-22 21:28:42.147' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@Name'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10413, CAST(N'2020-05-22 21:46:51.433' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@Name'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10414, CAST(N'2020-05-22 22:24:17.537' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'SiteUserSignUp', N'Procedure or function ''SiteUserSignUp'' expects parameter ''@Name'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10415, CAST(N'2020-05-22 23:34:53.940' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUsers', N'Procedure or function ''USP_AddEditSiteUser'' expects parameter ''@UserName'', which was not supplied.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10416, CAST(N'2020-05-23 11:26:48.307' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10417, CAST(N'2020-05-23 11:26:55.010' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10418, CAST(N'2020-05-23 14:26:57.870' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserDetails', N'Specified cast is not valid.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10419, CAST(N'2020-05-24 23:03:59.347' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedBackDAL', N'AddEditFeedBackCriteria', N'Procedure or function ''USP_AddEditManageFeedBackCriteria'' expects parameter ''@IsActive'', which was n', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10420, CAST(N'2020-05-24 23:04:36.103' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedBackDAL', N'AddEditFeedBackCriteria', N'Procedure or function ''USP_AddEditManageFeedBackCriteria'' expects parameter ''@IsActive'', which was n', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10421, CAST(N'2020-05-24 23:09:36.717' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedBackDAL', N'AddEditFeedBackCriteria', N'Procedure or function ''USP_AddEditManageFeedBackCriteria'' expects parameter ''@CreatedBy'', which was ', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10422, CAST(N'2020-05-27 13:44:38.893' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Column ''Message_Id'' does not belong to table Table.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10423, CAST(N'2020-05-27 13:44:59.863' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Column ''Message_Id'' does not belong to table Table.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10424, CAST(N'2020-05-27 13:46:24.287' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Column ''Message_Id'' does not belong to table Table.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10425, CAST(N'2020-05-27 13:49:08.607' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUserChat', N'Procedure or function ''USP_AddEditSiteUserChat'' expects parameter ''@Query_From'', which was not suppl', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10426, CAST(N'2020-05-27 13:50:12.070' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUserChat', N'Column ''Message_Id'' does not belong to table Table.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10427, CAST(N'2020-05-27 13:52:17.760' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Unable to cast object of type ''System.DateTime'' to type ''System.String''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10428, CAST(N'2020-05-27 13:52:51.627' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Unable to cast object of type ''System.DateTime'' to type ''System.String''.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10429, CAST(N'2020-05-27 14:24:01.070' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10430, CAST(N'2020-05-27 14:44:07.187' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUserChat', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10431, CAST(N'2020-05-27 14:44:13.997' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Object reference not set to an instance of an object.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10432, CAST(N'2020-05-27 14:47:21.830' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Object reference not set to an instance of an object.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10433, CAST(N'2020-05-27 14:47:21.940' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Invalid operation. The connection is closed.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10434, CAST(N'2020-05-27 14:47:29.767' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10435, CAST(N'2020-05-27 14:48:22.540' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Execution Timeout Expired.  The timeout period elapsed prior to completion of the operation or the s', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10436, CAST(N'2020-05-27 14:48:37.047' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10437, CAST(N'2020-05-27 14:48:55.810' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Object reference not set to an instance of an object.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10438, CAST(N'2020-05-27 14:48:55.920' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Invalid operation. The connection is closed.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10439, CAST(N'2020-05-27 14:49:02.437' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10440, CAST(N'2020-05-27 14:49:02.450' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'ExecuteReader requires an open and available Connection. The connection''s current state is closed.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10441, CAST(N'2020-05-27 14:49:55.457' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10442, CAST(N'2020-05-27 14:52:58.340' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10443, CAST(N'2020-05-27 14:59:47.040' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10444, CAST(N'2020-05-27 15:23:09.400' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Column ''PK_ChatID'' does not belong to table Table1.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10445, CAST(N'2020-05-27 15:23:13.907' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10446, CAST(N'2020-05-27 15:26:44.587' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'GetSiteUserChatDetails', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10447, CAST(N'2020-05-27 15:27:42.640' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUserChat', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10448, CAST(N'2020-05-27 15:27:44.090' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUserChat', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10449, CAST(N'2020-05-27 15:29:14.710' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUserChat', N'Cannot find table 0.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10450, CAST(N'2020-05-27 15:30:04.267' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.Common.CommonDAL', N'AddEditSiteUserChat', N'Column ''Message_Id'' does not belong to table Table.', N'')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10451, CAST(N'2020-05-28 00:34:34.107' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedDAL', N'AddEditManageFeed', N'Procedure or function ''USP_AddEditFeed'' expects parameter ''@ResourceFile'', which was not supplied.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10452, CAST(N'2020-05-28 00:35:14.483' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedDAL', N'AddEditManageFeed', N'Procedure or function ''USP_AddEditFeed'' expects parameter ''@ResourceFile'', which was not supplied.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10453, CAST(N'2020-05-28 00:36:19.337' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedDAL', N'AddEditManageFeed', N'Procedure or function ''USP_AddEditFeed'' expects parameter ''@ResourceFile'', which was not supplied.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10454, CAST(N'2020-05-28 00:37:51.530' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedDAL', N'AddEditManageFeed', N'Procedure or function ''USP_AddEditFeed'' expects parameter ''@IsDeleted'', which was not supplied.', N'ADDITIONAL REMARKS')
GO
INSERT [dbo].[ErrorLog_App] ([ErrorLogId], [ErrorTime], [Source], [Assembly_Name], [Class_Name], [Method_Name], [ErrorMessage], [ErrorType], [Remarks]) VALUES (10455, CAST(N'2020-05-28 00:40:26.220' AS DateTime), N'', N'Gyanmitras', N'GyanmitrasDAL', N'GyanmitrasDAL.MstManageFeedDAL', N'AddEditManageFeed', N'Cannot find table 0.', N'ADDITIONAL REMARKS')
GO
SET IDENTITY_INSERT [dbo].[ErrorLog_App] OFF
GO
SET IDENTITY_INSERT [dbo].[LKP_Language] ON 

GO
INSERT [dbo].[LKP_Language] ([PK_LanguageId], [LanguageFullName], [LanguageCultureName], [LanguageIcon]) VALUES (1, N'English', N'', N'')
GO
INSERT [dbo].[LKP_Language] ([PK_LanguageId], [LanguageFullName], [LanguageCultureName], [LanguageIcon]) VALUES (2, N'Hindi', N'', N'')
GO
INSERT [dbo].[LKP_Language] ([PK_LanguageId], [LanguageFullName], [LanguageCultureName], [LanguageIcon]) VALUES (3, N'Urdu', N'', N'')
GO
INSERT [dbo].[LKP_Language] ([PK_LanguageId], [LanguageFullName], [LanguageCultureName], [LanguageIcon]) VALUES (4, N'Punjabi', N'', N'')
GO
SET IDENTITY_INSERT [dbo].[LKP_Language] OFF
GO
SET IDENTITY_INSERT [dbo].[Map_FormAccount] ON 

GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (1, 1, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (2, 2, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (3, 3, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (4, 4, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (5, 5, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (6, 6, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (7, 7, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (8, 8, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (9, 9, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (10, 10, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (11, 11, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (12, 12, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (13, 13, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (14, 14, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (15, 15, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (16, 16, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (17, 17, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (18, 18, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (19, 19, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (20, 20, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
INSERT [dbo].[Map_FormAccount] ([PK_FormAccountId], [FK_FormId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [InsertionMode], [CanAdd], [CanEdit], [CanDelete], [CanView]) VALUES (21, 21, 1, 1, 0, 1, 0, 1, CAST(N'2020-03-19 15:37:25.017' AS DateTime), NULL, NULL, NULL, NULL, 0, N'BACKEND BULK', 1, 1, 1, 1)
GO
SET IDENTITY_INSERT [dbo].[Map_FormAccount] OFF
GO
SET IDENTITY_INSERT [dbo].[Map_FormLanguage] ON 

GO
INSERT [dbo].[Map_FormLanguage] ([PK_FormLanguageId], [FK_FormId], [TranslatedFormName], [FK_LanguageId], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CompanyID], [FK_AccountID], [FK_CustomerID]) VALUES (1, 1, N'test', 1, 1, 0, 1, CAST(N'2020-01-14 19:36:47.110' AS DateTime), 1, CAST(N'2020-02-07 11:25:49.473' AS DateTime), NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[Map_FormLanguage] ([PK_FormLanguageId], [FK_FormId], [TranslatedFormName], [FK_LanguageId], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CompanyID], [FK_AccountID], [FK_CustomerID]) VALUES (2, 1, N'test', 2, 1, 0, 1, CAST(N'2020-01-15 16:26:49.253' AS DateTime), NULL, NULL, NULL, NULL, NULL, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[Map_FormLanguage] OFF
GO
SET IDENTITY_INSERT [dbo].[Map_FormRole] ON 

GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (1, 1, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (2, 2, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (3, 3, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (4, 4, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (5, 5, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (6, 6, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (7, 7, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (8, 8, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (9, 9, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (10, 10, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (11, 11, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (12, 12, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (13, 13, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (14, 14, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (15, 15, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (16, 16, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (17, 17, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (18, 18, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (19, 19, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (20, 20, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (21, 21, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-03-19 15:26:38.727' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (22, 22, 1, 1, 1, 1, 1, 1, 0, 1, CAST(N'2020-05-01 17:37:20.850' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (26, 8, 1, 1, 1, 1, 1, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (49, 1, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (50, 8, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (53, 26, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (54, 27, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (55, 28, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (56, 29, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (61, 3, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (62, 12, 2, 0, 0, 0, 0, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (63, 15, 2, 0, 0, 0, 0, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (64, 25, 2, 0, 0, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (65, 24, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (66, 23, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (67, 31, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (68, 32, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Map_FormRole] ([PK_FormRoleId], [FK_FormId], [FK_RoleId], [CanAdd], [CanEdit], [CanDelete], [CanView], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [InsertionMode]) VALUES (69, 33, 2, 1, 1, 1, 1, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Map_FormRole] OFF
GO
SET IDENTITY_INSERT [dbo].[MAP_UserAccount] ON 

GO
INSERT [dbo].[MAP_UserAccount] ([PK_UserAccountId], [FK_UserId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, 1, 1, 1, 0, 1, NULL, 1, CAST(N'2020-01-14 17:27:43.627' AS DateTime), 1, CAST(N'2020-02-07 12:24:42.563' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[MAP_UserAccount] ([PK_UserAccountId], [FK_UserId], [FK_AccountId], [FK_CategoryId], [IsCustomerAccount], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (2, 2, 2, NULL, NULL, 1, 0, 1, CAST(N'2020-05-01 17:06:16.830' AS DateTime), NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[MAP_UserAccount] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_Account] ON 

GO
INSERT [dbo].[MST_Account] ([PK_AccountId], [AccountName], [FK_CategoryId], [FK_CompanyId], [FK_ResellerId], [FK_AffiliateId], [ParentAccountId], [AccountAddress], [ZipCode], [FK_CountryId], [FK_StateId], [FK_CityId], [BillingAddress], [ContactPerson], [MobileNo], [AlternateMobileNo], [EmailId], [AlternateEmailId], [AccountLogo], [AccountRegistrationNo], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [ZipCode_Billing], [FK_CountryId_Billing], [FK_StateId_Billing], [FK_CityId_Billing], [UserLimit], [FK_UserId], [FK_CategoryId_Referrer], [FK_AccountId_Referrer], [ShareVia]) VALUES (1, N'Gyanmitras', 1, 0, 0, 0, 0, N'Plot 15, Eletronic City, Gurgaon, Haryana', N'220015', 1, 1, 1, N'Plot 15, Eletronic City, Gurgaon, Haryana', N'Akhil', N'9876546644', N'9876546644', N'akhil.c@abc.com', N'akhil.c@abc.com', NULL, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, 0, 0, NULL)
GO
INSERT [dbo].[MST_Account] ([PK_AccountId], [AccountName], [FK_CategoryId], [FK_CompanyId], [FK_ResellerId], [FK_AffiliateId], [ParentAccountId], [AccountAddress], [ZipCode], [FK_CountryId], [FK_StateId], [FK_CityId], [BillingAddress], [ContactPerson], [MobileNo], [AlternateMobileNo], [EmailId], [AlternateEmailId], [AccountLogo], [AccountRegistrationNo], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [ZipCode_Billing], [FK_CountryId_Billing], [FK_StateId_Billing], [FK_CityId_Billing], [UserLimit], [FK_UserId], [FK_CategoryId_Referrer], [FK_AccountId_Referrer], [ShareVia]) VALUES (2, N'Gyanmitras Admin', 2, 1, 0, 0, 1, N'Test', N'220015', 1, 1, 1, NULL, NULL, N'09876546644', NULL, N'admin@gyanmitras.com', NULL, NULL, NULL, 1, NULL, 1, CAST(N'2020-05-01 17:06:16.777' AS DateTime), NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 2, 0, 0, NULL)
GO
SET IDENTITY_INSERT [dbo].[MST_Account] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_Category] ON 

GO
INSERT [dbo].[MST_Category] ([PK_CategoryId], [CategoryName], [FK_CompanyId], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, N'Super Admin', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[MST_Category] ([PK_CategoryId], [CategoryName], [FK_CompanyId], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (2, N'Admin', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[MST_Category] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_City] ON 

GO
INSERT [dbo].[MST_City] ([PK_CityId], [FK_CountryId], [FK_StateId], [CityName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, 1, 1, N'Gurgaon', 1, NULL, 1, CAST(N'2020-01-15 11:25:09.890' AS DateTime), 1, CAST(N'2020-01-15 11:41:54.903' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[MST_City] ([PK_CityId], [FK_CountryId], [FK_StateId], [CityName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (2, 1, 1, N'Faridabad', 1, NULL, 1, CAST(N'2020-01-15 11:41:00.147' AS DateTime), NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[MST_City] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_Country] ON 

GO
INSERT [dbo].[MST_Country] ([PK_CountryId], [CountryName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [TimeZone]) VALUES (1, N'India', 0, 1, 1, CAST(N'2020-01-15 11:24:00.003' AS DateTime), NULL, NULL, 2, CAST(N'2020-05-08 23:30:29.197' AS DateTime), N'+05:30')
GO
SET IDENTITY_INSERT [dbo].[MST_Country] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_Form] ON 

GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (1, 1, N'Dashboard', N'#', N'#', 0, 0, 1, 1, NULL, 1, 0, 1, CAST(N'2019-11-12 12:55:58.440' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-dashboard', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (2, 1, N'Account Management', N'#', N'#', 0, 0, 0, 2, NULL, 1, 0, 1, CAST(N'2019-11-12 12:55:58.440' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-account', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (3, 1, N'User Management', N'#', N'#', 0, 0, 0, 3, NULL, 1, 0, 1, CAST(N'2019-11-12 12:55:58.440' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-user', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (4, 1, N'Form Company', N'#', N'#', 0, 0, 0, 4, NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (5, 1, N'Mapping', N'#', N'#', 0, 0, 0, 5, NULL, 1, 0, 1, CAST(N'2020-01-09 12:11:43.703' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-mapping', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (6, 1, N'System Configuration', N'#', N'#', 0, 0, 0, 6, NULL, 1, NULL, 1, CAST(N'2020-01-14 12:27:17.520' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-systemC', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (7, 1, N'Setting', N'#', N'#', 0, 0, 0, 7, NULL, 1, 0, 1, CAST(N'2019-12-18 14:58:40.007' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-setting', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (8, 1, N'Admin Dashboard', N'AdminDashboard', N'Index', 1, 1, 1, 1, NULL, 1, 0, 1, CAST(N'2019-12-19 13:06:59.793' AS DateTime), NULL, NULL, 1, CAST(N'2020-05-01 15:42:22.483' AS DateTime), NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (9, 1, N'Accounts', N'MstAccount', N'Index', 2, 2, 1, 1, NULL, 1, 0, 1, CAST(N'2019-11-12 12:55:58.440' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (10, 1, N'Roles', N'MstRole', N'Index', 2, 2, 1, 2, NULL, 1, 0, 1, CAST(N'2019-12-16 12:52:17.887' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (11, 1, N'User', N'UserMaster', N'Index', 3, 3, 1, 1, NULL, 0, 1, 1, CAST(N'2019-11-12 12:55:58.440' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (12, 1, N'Form Master', N'MstForm', N'Index', 3, 3, 1, 2, NULL, 1, 0, 1, CAST(N'2019-12-18 10:04:44.227' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (13, 1, N'User Account Mapping', N'MSTUserAccountMapping', N'Index', 5, 5, 1, 3, NULL, 1, 0, 1, CAST(N'2019-12-18 13:58:17.887' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (14, 1, N'Form Account Mapping', N'FormAccountMapping', N'Index', 5, 5, 1, 4, NULL, 1, 0, 1, CAST(N'2019-12-18 19:17:13.063' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (15, 1, N'Users', N'MstUser', N'Index', 3, 3, 1, 5, NULL, 1, 0, 1, CAST(N'2019-12-23 12:26:48.420' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (16, 1, N'Form Language Mapping', N'MstFormLanguageMapping', N'Index', 5, 5, 1, 6, NULL, 1, 0, 1, CAST(N'2019-11-12 12:55:58.440' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (17, 1, N'Form Column Configuration', N'MapFormColumnConfiguration', N'Index', 7, 7, 1, 1, NULL, 1, 0, 1, CAST(N'2020-01-02 16:06:10.350' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (18, 1, N'Form Column Assignment', N'FormColumnAssignment', N'Index', 7, 7, 1, 2, NULL, 1, 0, 1, CAST(N'2020-01-02 11:58:41.123' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (19, 1, N'Country Master', N'MstCountry', N'Index', 6, 6, 1, 1, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (20, 1, N'City Master', N'MstCity', N'Index', 6, 6, 1, 2, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (21, 1, N'State Master', N'MstState', N'Index', 6, 6, 1, 3, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (22, 1, N'Form Role Mapping', N'MapFormRole', N'Index', 5, 5, 1, 2, NULL, 1, 0, 1, CAST(N'2019-12-16 12:52:17.887' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (23, NULL, N'Manage Pages Content', N'ManagePagesContent', N'Index', 24, 24, 1, 8, NULL, 1, NULL, 1, CAST(N'2020-05-02 10:38:50.680' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (24, 24, N'Site Management', N'#', N'#', NULL, NULL, 1, 9, NULL, 1, NULL, 1, CAST(N'2020-05-02 10:40:05.310' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-mapping', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (25, NULL, N'Site Users', N'SiteUsers', N'Index', 3, 3, 1, 7, NULL, 1, NULL, 1, CAST(N'2020-05-02 10:41:49.750' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (26, 26, N'Module Management', N'#', N'#', NULL, NULL, 1, 10, NULL, 1, NULL, 1, CAST(N'2020-05-02 10:43:23.440' AS DateTime), NULL, NULL, NULL, NULL, N'vfIcon vf-systemC', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (27, NULL, N'Counselor Management', N'CounselorManagement', N'Index', 26, 26, 1, NULL, NULL, 1, NULL, 1, CAST(N'2020-05-02 10:44:16.533' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (28, NULL, N'Student Management', N'StudentManagement', N'Index', 26, 26, 1, 1, NULL, 1, NULL, 1, CAST(N'2020-05-02 10:44:40.990' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (29, NULL, N'Volunteer Management', N'VolunteerManagement', N'Index', 26, 26, 1, 2, NULL, 1, NULL, 1, CAST(N'2020-05-02 10:45:27.553' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (31, NULL, N'Model Help Desk', N'ModulesHelpDesk', N'Index', 24, 24, 1, 9, NULL, 1, NULL, 1, CAST(N'2020-05-10 18:11:35.237' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (32, NULL, N'Manage Feedback', N'ManageFeedback', N'Index', NULL, NULL, 1, 11, NULL, 1, NULL, 1, CAST(N'2020-05-24 17:44:42.903' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
INSERT [dbo].[MST_Form] ([PK_FormId], [FK_SolutionId], [FormName], [ControllerName], [ActionName], [FK_ParentId], [FK_MainId], [LevelId], [SortId], [Image], [IsActive], [IsDeleted], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDateTime], [ClassName], [Area], [FormFor]) VALUES (33, NULL, N'Manage Feed', N'ManageFeed', N'Index', NULL, NULL, 1, 12, NULL, 1, NULL, 1, CAST(N'2020-05-27 22:17:12.267' AS DateTime), NULL, NULL, NULL, NULL, N'', N'Admin', NULL)
GO
SET IDENTITY_INSERT [dbo].[MST_Form] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_FormColumn] ON 

GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (1, 8, N'Vehicle Dashboard', N'Signal Strength', NULL, NULL, CAST(N'2020-01-16 12:08:23.067' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (2, 8, N'Vehicle Dashboard', N'CheckAll', NULL, NULL, CAST(N'2020-01-16 12:04:55.023' AS DateTime), 1, NULL, NULL, CAST(N'2020-01-21 12:15:00.450' AS DateTime), 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (3, 8, N'Vehicle Dashboard', N'Status', NULL, NULL, CAST(N'2020-01-16 12:05:16.773' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (4, 8, N'Vehicle Dashboard', N'Vehicle No.', NULL, NULL, CAST(N'2020-01-16 12:05:33.063' AS DateTime), 1, CAST(N'2020-01-16 12:10:06.223' AS DateTime), 1, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (5, 8, N'Vehicle Dashboard', N'Ignition', NULL, NULL, CAST(N'2020-01-16 12:06:03.490' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (6, 8, N'Vehicle Dashboard', N'AC / DC', NULL, NULL, CAST(N'2020-01-16 12:06:29.360' AS DateTime), 1, CAST(N'2020-01-16 12:09:51.680' AS DateTime), 1, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (7, 8, N'Vehicle Dashboard', N'Alarm', NULL, NULL, CAST(N'2020-01-16 12:06:40.970' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (8, 8, N'Vehicle Dashboard', N'Speed', NULL, NULL, CAST(N'2020-01-16 12:06:51.843' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (9, 8, N'Vehicle Dashboard', N'Power Mode', NULL, NULL, CAST(N'2020-01-16 12:07:06.513' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (10, 8, N'Vehicle Dashboard', N'Battery Level', NULL, NULL, CAST(N'2020-01-16 12:07:48.970' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (11, 8, N'Vehicle Dashboard', N'Fuel', NULL, NULL, CAST(N'2020-01-16 12:08:00.580' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (12, 8, N'Vehicle Dashboard', N'Geofence Status', NULL, NULL, CAST(N'2020-01-16 12:08:11.797' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
INSERT [dbo].[MST_FormColumn] ([PK_FormColumnId], [FK_FormId], [Form_Name], [Column_Name], [IsDeleted], [DeletedBy], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy], [DeletedDateTime], [IsActive], [FK_AccountId]) VALUES (13, 8, N'Vehicle Dashboard', N'Geofence Name', NULL, NULL, CAST(N'2020-01-16 12:08:23.067' AS DateTime), 1, NULL, NULL, NULL, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[MST_FormColumn] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_Role] ON 

GO
INSERT [dbo].[MST_Role] ([PK_RoleId], [RoleName], [FK_CategoryId], [FK_AccountId], [HomePage], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [FK_InstallerId], [FK_DriverId], [FK_CompanyId]) VALUES (1, N'Super Admin', 1, 1, 9, 1, 0, 1, NULL, 1, CAST(N'2020-02-20 13:14:43.693' AS DateTime), NULL, NULL, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[MST_Role] ([PK_RoleId], [RoleName], [FK_CategoryId], [FK_AccountId], [HomePage], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_CustomerId], [FK_InstallerId], [FK_DriverId], [FK_CompanyId]) VALUES (2, N'Admin', 2, 2, 8, 1, NULL, 1, CAST(N'2020-05-01 16:55:41.420' AS DateTime), 1, CAST(N'2020-05-02 11:38:18.220' AS DateTime), NULL, NULL, 0, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[MST_Role] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_State] ON 

GO
INSERT [dbo].[MST_State] ([PK_StateId], [FK_CountryId], [StateName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, 1, N'Haryana', 1, 0, 1, CAST(N'2020-01-15 11:24:00.003' AS DateTime), NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[MST_State] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_User] ON 

GO
INSERT [dbo].[MST_User] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [FK_CustomerId], [FK_AccountId], [UserPassword], [MobileNo], [AlternateMobileNo], [EmailId], [AlternateEmailId], [Gender], [DateOfBirth], [UserAddress], [ZipCode], [FK_CountryId], [FK_StateId], [FK_CityId], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FirstName], [LastName], [FullName], [ShareBy], [FK_InstallerId], [FK_DriverId], [AppRegId], [IMEINo], [OSType], [LastLoginDt], [IsVehicleSpecific], [LastWebLogInDatetime]) VALUES (1, N'dadmin', 1, 1, 0, 1, N'0o6ba1MX6fU=', N'9876549878', N'9876549870', N'dadmin@gyanmitras.com', N'dadmin@abc.com', N'M', N'Invalid date', N'Test', N'11888', 1, 1, 1, 1, 0, 1, NULL, 1, CAST(N'2020-05-01 16:30:22.203' AS DateTime), NULL, NULL, NULL, NULL, N'dadmin', N'Email', NULL, NULL, N'3211321313213131313131313131312313131', N'787878787878"', N'Android', CAST(N'2020-02-27 12:59:14.050' AS DateTime), 1, CAST(N'2020-05-27 22:15:28.737' AS DateTime))
GO
INSERT [dbo].[MST_User] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [FK_CustomerId], [FK_AccountId], [UserPassword], [MobileNo], [AlternateMobileNo], [EmailId], [AlternateEmailId], [Gender], [DateOfBirth], [UserAddress], [ZipCode], [FK_CountryId], [FK_StateId], [FK_CityId], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FirstName], [LastName], [FullName], [ShareBy], [FK_InstallerId], [FK_DriverId], [AppRegId], [IMEINo], [OSType], [LastLoginDt], [IsVehicleSpecific], [LastWebLogInDatetime]) VALUES (2, N'admin', 2, 2, 0, 2, N'0o6ba1MX6fU=', N'09876546644', NULL, N'admin@gyanmitras.com', NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 1, CAST(N'2020-05-01 17:06:16.827' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, N'admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2020-05-29 14:58:06.070' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[MST_User] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_VehicleBrand] ON 

GO
INSERT [dbo].[MST_VehicleBrand] ([PK_VehicleBrandId], [VehicleBrandName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [FK_AccountId]) VALUES (1, N'Car', 0, 1, NULL, CAST(N'2020-01-24 17:34:31.090' AS DateTime), NULL, NULL, 1, CAST(N'2020-02-06 16:23:08.780' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[MST_VehicleBrand] OFF
GO
SET IDENTITY_INSERT [dbo].[MST_VehicleType] ON 

GO
INSERT [dbo].[MST_VehicleType] ([PK_VehicleTypeId], [VehicleType], [MovingIcon], [IdlingIcon], [StopIcon], [OfflineIcon], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, N'Tata420', N'Tata420MovingIcon.png', N'Tata420IdlingIcon.png', N'Tata420StopIcon.png', N'Tata420OfflineIcon.png', 0, 1, 1, CAST(N'2020-01-15 15:11:49.280' AS DateTime), 1, CAST(N'2020-01-22 16:45:51.120' AS DateTime), 1, CAST(N'2020-01-22 17:12:53.557' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[MST_VehicleType] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[Board] ON 

GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (1, N'ICSE                                                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (2, N'CBSE                                                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (3, N'NIOS                                                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (4, N'Andhra Pradesh Board of Secondary Education                                                         ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (5, N'Bihar School Examination Board                                                                      ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (6, N'Board of High School and Intermediate Education Board of Uttar Pradesh                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (7, N'Assam Board of Secondary Education                                                                  ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (8, N'Madhya Pradesh Board of Secondary Education                                                         ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (9, N'Odisha Board of Secondary Education                                                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (10, N'Rajasthan Board of Secondary Education                                                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (11, N'Central Board of Secondary Education                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (12, N'COUNCIL FOR THE INDIAN SCHOOL CERTIFICATE EXAMINATIONS                                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (13, N'Chhattisgarh Board of Secondary Education                                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (14, N'Goa Board of Secondary & Higher Secondary Education                                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (15, N'Himachal Pradesh Board of School Education                                                          ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (16, N'Haryana Board of School Education (HBSE)                                                            ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (17, N'International Baccalaureate (IB)                                                                    ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (18, N'Jammu and Kashmir State Board of School Education                                                   ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (19, N'Jharkhand Academic Council                                                                          ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (20, N'Karnataka State Secondary Education Examination Board                                               ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (21, N'Kerala Higher Secondary Examination Board                                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (22, N'Maharashtra State Board of Secondary and Higher Secondary Education                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (23, N'Meghalaya Board of School Education                                                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (24, N'Mizoram Board of School Education                                                                   ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (25, N'Nagaland Board of School Education                                                                  ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (26, N'Punjab School Education Board                                                                       ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (27, N'Kerala State Council of Educational Research and Training                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (28, N'School Selection Board                                                                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (29, N'Telangana Board of Intermediate Education                                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (30, N'Tripura Board of Secondary Education (TBSE)                                                         ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (31, N'Uttarakhand Board of School Education                                                               ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (32, N'West Bengal Board of Secondary Education                                                            ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (33, N'West Bengal Council of Higher Secondary Education                                                   ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (34, N'ICSE                                                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (35, N'CBSE                                                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (36, N'NIOS                                                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (37, N'Andhra Pradesh Board of Secondary Education                                                         ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (38, N'Bihar School Examination Board                                                                      ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (39, N'Board of High School and Intermediate Education Board of Uttar Pradesh                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (40, N'Assam Board of Secondary Education                                                                  ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (41, N'Madhya Pradesh Board of Secondary Education                                                         ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (42, N'Odisha Board of Secondary Education                                                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (43, N'Rajasthan Board of Secondary Education                                                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (44, N'Central Board of Secondary Education                                                                ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (45, N'COUNCIL FOR THE INDIAN SCHOOL CERTIFICATE EXAMINATIONS                                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (46, N'Chhattisgarh Board of Secondary Education                                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (47, N'Goa Board of Secondary & Higher Secondary Education                                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (48, N'Himachal Pradesh Board of School Education                                                          ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (49, N'Haryana Board of School Education (HBSE)                                                            ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (50, N'International Baccalaureate (IB)                                                                    ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (51, N'Jammu and Kashmir State Board of School Education                                                   ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (52, N'Jharkhand Academic Council                                                                          ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (53, N'Karnataka State Secondary Education Examination Board                                               ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (54, N'Kerala Higher Secondary Examination Board                                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (55, N'Maharashtra State Board of Secondary and Higher Secondary Education                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (56, N'Meghalaya Board of School Education                                                                 ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (57, N'Mizoram Board of School Education                                                                   ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (58, N'Nagaland Board of School Education                                                                  ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (59, N'Punjab School Education Board                                                                       ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (60, N'Kerala State Council of Educational Research and Training                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (61, N'School Selection Board                                                                              ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (62, N'Telangana Board of Intermediate Education                                                           ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (63, N'Tripura Board of Secondary Education (TBSE)                                                         ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (64, N'Uttarakhand Board of School Education                                                               ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (65, N'West Bengal Board of Secondary Education                                                            ')
GO
INSERT [SiteUsers].[Board] ([ID], [BoardName]) VALUES (66, N'West Bengal Council of Higher Secondary Education                                                   ')
GO
SET IDENTITY_INSERT [SiteUsers].[Board] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[LKP_Languages] ON 

GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (1, N'Hindi                                             ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (2, N'English                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (3, N'Assamese                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (4, N'Bengali                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (5, N'Gujarati                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (6, N'Kannada                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (7, N'Malayalam                                         ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (8, N'Marathi                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (9, N'Punjabi                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (10, N'Tamil                                             ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (11, N'Telugu                                            ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (12, N'Oriya                                             ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (13, N'Sanskrit                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (14, N'Urdu                                              ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (15, N'Konkani                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (16, N'Garhwali                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (17, N'Kumaoni                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (18, N'Kashmiri                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (19, N'Hindi                                             ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (20, N'English                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (21, N'Assamese                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (22, N'Bengali                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (23, N'Gujarati                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (24, N'Kannada                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (25, N'Malayalam                                         ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (26, N'Marathi                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (27, N'Punjabi                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (28, N'Tamil                                             ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (29, N'Telugu                                            ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (30, N'Oriya                                             ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (31, N'Sanskrit                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (32, N'Urdu                                              ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (33, N'Konkani                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (34, N'Garhwali                                          ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (35, N'Kumaoni                                           ')
GO
INSERT [SiteUsers].[LKP_Languages] ([ID], [LanguageName]) VALUES (36, N'Kashmiri                                          ')
GO
SET IDENTITY_INSERT [SiteUsers].[LKP_Languages] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MAP_SiteUserFeedBack] ON 

GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (1, 3, 2, 8, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 3, CAST(N'2020-05-25 15:41:45.987' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (2, 3, 2, 7, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 3, CAST(N'2020-05-25 15:41:45.987' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (3, 3, 2, 6, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 3, CAST(N'2020-05-25 15:41:45.987' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (4, 6, 5, 8, N'Counselor', 1, N'kjsahdakshdsad', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:18:04.410' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (5, 6, 5, 6, N'Counselor', 1, N'kjsahdakshdsad', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:18:04.410' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (6, 6, 5, 5, N'Counselor', 1, N'kjsahdakshdsad', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:18:04.410' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (7, 6, 5, 8, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:20:14.270' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (8, 6, 5, 6, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:20:14.270' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (9, 6, 5, 5, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:20:14.270' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (10, 6, 5, 6, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:20:14.270' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (11, 6, 5, 7, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:20:14.270' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (12, 6, 5, 8, N'Counselor', 1, N'ahdashds', 0, NULL, NULL, 1, NULL, NULL, 6, CAST(N'2020-05-25 17:20:14.270' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (13, 3, 2, 8, N'Counselor', 0, N'Test', 0, NULL, NULL, 1, NULL, NULL, 3, CAST(N'2020-05-25 21:18:59.587' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (14, 3, 2, 5, N'Counselor', 0, N'Test', 0, NULL, NULL, 1, NULL, NULL, 3, CAST(N'2020-05-25 21:18:59.587' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (15, 3, 2, 8, N'Counselor', 0, N',ahdkasds', 12, 2, CAST(N'2020-05-26 00:01:18.393' AS DateTime), 1, NULL, NULL, 3, CAST(N'2020-05-25 21:20:19.500' AS DateTime), NULL, NULL)
GO
INSERT [SiteUsers].[MAP_SiteUserFeedBack] ([PK_FeedBackId], [FK_CounselorID], [FK_StudentID], [FK_FeedBackCriteriaID], [FeedBackBy], [IsLikeThisClass], [FeedBackSuggesstion], [RateFeedBack], [RatedBy], [RateDateTme], [IsActive], [IsDeleted], [DeletedDateTime], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (16, 3, 2, 7, N'Counselor', 0, N',ahdkasds', 12, 2, CAST(N'2020-05-26 00:01:18.393' AS DateTime), 1, NULL, NULL, 3, CAST(N'2020-05-25 21:20:19.500' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [SiteUsers].[MAP_SiteUserFeedBack] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_AcademicDetails] ON 

GO
INSERT [SiteUsers].[MST_AcademicDetails] ([ID], [FK_UserID], [Education_Type], [Class], [FK_BoardID], [FK_StreamID], [Currentsemester], [UniversityName], [NatureOFCompletion], [Percentage], [Previous_Class], [FK_Previous_Class_Board], [Previous_Class_Percentage], [Year_of_Passing], [CourseName], [Specification], [OtherWork]) VALUES (1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_AcademicDetails] ([ID], [FK_UserID], [Education_Type], [Class], [FK_BoardID], [FK_StreamID], [Currentsemester], [UniversityName], [NatureOFCompletion], [Percentage], [Previous_Class], [FK_Previous_Class_Board], [Previous_Class_Percentage], [Year_of_Passing], [CourseName], [Specification], [OtherWork]) VALUES (2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_AcademicDetails] ([ID], [FK_UserID], [Education_Type], [Class], [FK_BoardID], [FK_StreamID], [Currentsemester], [UniversityName], [NatureOFCompletion], [Percentage], [Previous_Class], [FK_Previous_Class_Board], [Previous_Class_Percentage], [Year_of_Passing], [CourseName], [Specification], [OtherWork]) VALUES (3, 2, N'Secondry', N'6', 2, 0, NULL, NULL, NULL, CAST(45.00 AS Decimal(5, 2)), NULL, 0, CAST(0.00 AS Decimal(5, 2)), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_AcademicDetails] ([ID], [FK_UserID], [Education_Type], [Class], [FK_BoardID], [FK_StreamID], [Currentsemester], [UniversityName], [NatureOFCompletion], [Percentage], [Previous_Class], [FK_Previous_Class_Board], [Previous_Class_Percentage], [Year_of_Passing], [CourseName], [Specification], [OtherWork]) VALUES (4, 5, N'Secondry', N'6', 1, 0, NULL, NULL, NULL, CAST(67.00 AS Decimal(5, 2)), NULL, 0, CAST(0.00 AS Decimal(5, 2)), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_AcademicDetails] ([ID], [FK_UserID], [Education_Type], [Class], [FK_BoardID], [FK_StreamID], [Currentsemester], [UniversityName], [NatureOFCompletion], [Percentage], [Previous_Class], [FK_Previous_Class_Board], [Previous_Class_Percentage], [Year_of_Passing], [CourseName], [Specification], [OtherWork]) VALUES (5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_AcademicDetails] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_AcademicGroup] ON 

GO
INSERT [SiteUsers].[MST_AcademicGroup] ([PK_AcademicGroupId], [AcademicGroupName], [IsActive]) VALUES (1, N'Primary', 1)
GO
INSERT [SiteUsers].[MST_AcademicGroup] ([PK_AcademicGroupId], [AcademicGroupName], [IsActive]) VALUES (2, N'Upper primary', 1)
GO
INSERT [SiteUsers].[MST_AcademicGroup] ([PK_AcademicGroupId], [AcademicGroupName], [IsActive]) VALUES (3, N'Secondary', 1)
GO
INSERT [SiteUsers].[MST_AcademicGroup] ([PK_AcademicGroupId], [AcademicGroupName], [IsActive]) VALUES (4, N'Senior Secondary', 1)
GO
INSERT [SiteUsers].[MST_AcademicGroup] ([PK_AcademicGroupId], [AcademicGroupName], [IsActive]) VALUES (5, N'Higher education', 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_AcademicGroup] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_AreaOfInterest] ON 

GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (1, N'Agriculture', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (2, N'Armed Forces', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (3, N'Aviation', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (4, N'Computer and Information Science', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (5, N'Designing', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (6, N'Education (B.Ed./M.Ed.)', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (7, N'Engineering and technology', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (8, N'Health Science /Medical', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (9, N'Humanities', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (10, N'Journalism and Media', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (11, N'Language', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (12, N'Science', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (13, N'Social Science', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (14, N'Social Work', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (15, N'Tourism', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (16, N'Vocational Studies', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (17, N'Beauty', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (18, N'Music', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (19, N'Performing Arts', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (20, N'Sports', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (21, N'Wellness', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (22, N'RJ', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (23, N'DJ', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (24, N'Gym', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (25, N'Photography', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (26, N'Event management', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (27, N'Blogging', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (28, N'Travel writing', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (29, N'Visual arts', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (30, N'Animation', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (31, N'Dance', 1, N'counselor')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (32, N'Agriculture', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (33, N'Armed Forces', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (34, N'Aviation', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (35, N'Computer and Information Science', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (36, N'Designing', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (37, N'Education (B.Ed./M.Ed.)', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (38, N'Engineering and technology', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (39, N'Health Science /Medical', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (40, N'Humanities', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (41, N'Journalism and Media', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (42, N'Language', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (43, N'Science', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (44, N'Social Science', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (45, N'Social Work', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (46, N'Tourism', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (47, N'Vocational Studies', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (48, N'Beauty', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (49, N'Music', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (50, N'Performing Arts', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (51, N'Sports', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (52, N'Wellness', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (53, N'RJ', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (54, N'DJ', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (55, N'Gym', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (56, N'Photography', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (57, N'Event management', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (58, N'Blogging', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (59, N'Travel writing', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (60, N'Visual arts', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (61, N'Animation', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (62, N'Dance', 1, N'student')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (63, N'Agriculture', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (64, N'Armed Forces', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (65, N'Aviation', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (66, N'Computer and Information Science', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (67, N'Designing', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (68, N'Education (B.Ed./M.Ed.)', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (69, N'Engineering and technology', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (70, N'Health Science /Medical', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (71, N'Humanities', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (72, N'Journalism and Media', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (73, N'Language', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (74, N'Science', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (75, N'Social Science', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (76, N'Social Work', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (77, N'Tourism', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (78, N'Vocational Studies', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (79, N'Beauty', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (80, N'Music', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (81, N'Performing Arts', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (82, N'Sports', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (83, N'Wellness', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (84, N'RJ', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (85, N'DJ', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (86, N'Gym', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (87, N'Photography', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (88, N'Event management', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (89, N'Blogging', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (90, N'Travel writing', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (91, N'Visual arts', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (92, N'Animation', 1, N'volunteer')
GO
INSERT [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest], [AreaOfInterest], [IsActive], [TYPE]) VALUES (93, N'Dance', 1, N'volunteer')
GO
SET IDENTITY_INSERT [SiteUsers].[MST_AreaOfInterest] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_BenifitType] ON 

GO
INSERT [SiteUsers].[MST_BenifitType] ([PK_BenifitTypeId], [BenifitTypeName], [IsActive]) VALUES (1, N'Entrance based govt schools', 1)
GO
INSERT [SiteUsers].[MST_BenifitType] ([PK_BenifitTypeId], [BenifitTypeName], [IsActive]) VALUES (2, N'Current Govt schemes', 1)
GO
INSERT [SiteUsers].[MST_BenifitType] ([PK_BenifitTypeId], [BenifitTypeName], [IsActive]) VALUES (3, N'Available scholarships', 1)
GO
INSERT [SiteUsers].[MST_BenifitType] ([PK_BenifitTypeId], [BenifitTypeName], [IsActive]) VALUES (4, N'Entrance based Private schools ', 1)
GO
INSERT [SiteUsers].[MST_BenifitType] ([PK_BenifitTypeId], [BenifitTypeName], [IsActive]) VALUES (5, N'Sports schemes ', 1)
GO
INSERT [SiteUsers].[MST_BenifitType] ([PK_BenifitTypeId], [BenifitTypeName], [IsActive]) VALUES (6, N'Available NGOs', 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_BenifitType] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_ContentResourcePage] ON 

GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (1, 1, 1, 1, 1, N'kasjdhksajhkh', N'kjh', N'Video Embed Url', N'https://www.youtube.com/embed/tgbNymZ7vqY', 1, 0, 1, CAST(N'2020-05-29 00:46:30.550' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (2, 1, 1, 1, 1, N'kjahdksajhk', N'jhkjh', N'Resource File', N'04.0_Volunteers signup_page__29052020010903.pdf', 1, 0, 1, CAST(N'2020-05-29 00:50:16.693' AS DateTime), NULL, NULL, 1, CAST(N'2020-05-29 01:09:04.010' AS DateTime))
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (3, 0, 1, 1, 1, N'Test', N'khkhkahsk', N'Video Embed Url', N'https://www.youtube.com/embed/tgbNymZ7vqY', 1, 0, 1, CAST(N'2020-05-29 14:27:41.497' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (4, 0, 1, 1, 1, N'kjahsdkj', N'Test', N'Resource File', N'img_5terre__29052020025938.jpg', 1, 0, 1, CAST(N'2020-05-29 14:59:38.380' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (5, 0, 1, 1, 1, N'kjahsd', N'Test', N'Resource File', N'img_forest__29052020030001.jpg', 1, 0, 1, CAST(N'2020-05-29 15:00:01.680' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (6, 0, 1, 1, 1, N'kjashdkjh', N'kjh hgsa', N'Resource File', N'img_lights__29052020030020.jpg', 1, 0, 1, CAST(N'2020-05-29 15:00:20.563' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (7, 0, 1, 1, 1, N'jagd', N'ghghgd', N'Resource File', N'img_mountains__29052020030039.jpg', 1, 0, 1, CAST(N'2020-05-29 15:00:39.020' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (8, 0, 1, 1, 1, N'kjshdkjh', N'kjhkjsahdk', N'Video Embed Url', N'https://www.youtube.com/embed/tgbNymZ7vqY', 1, 0, 1, CAST(N'2020-05-29 15:01:18.480' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (9, 0, 1, 1, 1, N'ajsdgjhg', N'hjg', N'Video Embed Url', N'https://www.youtube.com/embed/tgbNymZ7vqY', 1, 0, 1, CAST(N'2020-05-29 15:01:35.760' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (10, 0, 1, 1, 1, N'akjsdhkjh', N'kjh', N'Video Embed Url', N'https://www.youtube.com/embed/tgbNymZ7vqY', 1, 0, 1, CAST(N'2020-05-29 15:01:51.660' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (11, 0, 1, 1, 1, N'kjasdkjh', N'kjh', N'Resource File', N'04.0_Volunteers signup_page__29052020030447.pdf', 1, 0, 1, CAST(N'2020-05-29 15:04:47.620' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_ContentResourcePage] ([PK_ContantResourceId], [FK_RoleId], [FK_StateId], [FK_SearchCategoryId], [FK_SubSearchCategoryId], [Heading], [Description], [ResourceType], [ResourceFileName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [DeletedBy], [DeletedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (12, 0, 1, 1, 1, N'jgdhjg', N'hjghjgdsf', N'Resource File', N'Doc_013_Volunteer working page layout and working details__29052020030809.docx', 1, 0, 1, CAST(N'2020-05-29 15:08:09.853' AS DateTime), NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_ContentResourcePage] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_DET_StreamCourses] ON 

GO
INSERT [SiteUsers].[MST_DET_StreamCourses] ([PK_DET_Stream], [StreamCourses], [IsActive], [FK_StreamType]) VALUES (1, N'B.Sc in Agriculture', 1, 1)
GO
INSERT [SiteUsers].[MST_DET_StreamCourses] ([PK_DET_Stream], [StreamCourses], [IsActive], [FK_StreamType]) VALUES (2, N'B.Sc in Agriculture Economics and Farm Management', 1, 1)
GO
INSERT [SiteUsers].[MST_DET_StreamCourses] ([PK_DET_Stream], [StreamCourses], [IsActive], [FK_StreamType]) VALUES (3, N'B.Sc in Animal Husbandry', 1, 1)
GO
INSERT [SiteUsers].[MST_DET_StreamCourses] ([PK_DET_Stream], [StreamCourses], [IsActive], [FK_StreamType]) VALUES (4, N'B.Sc in Forestry', 1, 1)
GO
INSERT [SiteUsers].[MST_DET_StreamCourses] ([PK_DET_Stream], [StreamCourses], [IsActive], [FK_StreamType]) VALUES (5, N'B.Sc Soil and water management', 1, 1)
GO
INSERT [SiteUsers].[MST_DET_StreamCourses] ([PK_DET_Stream], [StreamCourses], [IsActive], [FK_StreamType]) VALUES (6, N'B.Sc in Horticulture', 1, 1)
GO
INSERT [SiteUsers].[MST_DET_StreamCourses] ([PK_DET_Stream], [StreamCourses], [IsActive], [FK_StreamType]) VALUES (7, N'B.Sc Agriculture and Food Business', 1, 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_DET_StreamCourses] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_EmployedExpertise] ON 

GO
INSERT [SiteUsers].[MST_EmployedExpertise] ([PK_EmployedExpertise], [EmployedExpertise], [IsActive]) VALUES (1, N'Agriculture engineer', 1)
GO
INSERT [SiteUsers].[MST_EmployedExpertise] ([PK_EmployedExpertise], [EmployedExpertise], [IsActive]) VALUES (2, N'Software Engineer', 1)
GO
INSERT [SiteUsers].[MST_EmployedExpertise] ([PK_EmployedExpertise], [EmployedExpertise], [IsActive]) VALUES (3, N'Journalists', 1)
GO
INSERT [SiteUsers].[MST_EmployedExpertise] ([PK_EmployedExpertise], [EmployedExpertise], [IsActive]) VALUES (4, N'Armed force employee', 1)
GO
INSERT [SiteUsers].[MST_EmployedExpertise] ([PK_EmployedExpertise], [EmployedExpertise], [IsActive]) VALUES (5, N'Teacher', 1)
GO
INSERT [SiteUsers].[MST_EmployedExpertise] ([PK_EmployedExpertise], [EmployedExpertise], [IsActive]) VALUES (6, N'Professor', 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_EmployedExpertise] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_FeedBackCriteria] ON 

GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, 2, N'Was the student capable to get you?', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:30:39.820' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (2, 2, N'Was there not a proper response?', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:32:42.763' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (3, 2, N'Were they requesting financial support?', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:32:58.900' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (4, 2, N'Was the student in hurry? ', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:33:11.913' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (5, 2, N'Were you asked for external communication?', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:33:25.033' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (6, 2, N'Was your student on time? ', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:33:43.237' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (7, 2, N'Did your student lie?', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:33:57.587' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (8, 2, N'Don’t Your student have sufficient infrastructure ', 1, -1, 1, NULL, 2, CAST(N'2020-05-24 23:34:12.000' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_FeedBackCriteria] ([PK_FeedBackCriteriaID], [FK_SiteUserCategoryID], [FeedbackCriteria], [MarkCriteria_Yes], [MarkCriteria_No], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (9, 2, N'Report Abuse ->1.Explain your concern 2.Submit doc', 1, -1, 0, 1, 2, CAST(N'2020-05-24 23:34:27.713' AS DateTime), NULL, NULL, 2, CAST(N'2020-05-24 23:45:24.627' AS DateTime))
GO
SET IDENTITY_INSERT [SiteUsers].[MST_FeedBackCriteria] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[Mst_Feeds] ON 

GO
INSERT [SiteUsers].[Mst_Feeds] ([PK_FeedID], [FK_UserID], [FeedSubject], [FeedDescription], [MediaType], [VideoUrl], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [IsActive], [IsDeleted], [DeletedDateTime], [DeletedBy], [ResourceFile]) VALUES (1, 1, N'agdjh', N'ghjg', NULL, NULL, 2, CAST(N'2020-05-28 00:42:34.160' AS DateTime), NULL, NULL, 1, 0, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[Mst_Feeds] ([PK_FeedID], [FK_UserID], [FeedSubject], [FeedDescription], [MediaType], [VideoUrl], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [IsActive], [IsDeleted], [DeletedDateTime], [DeletedBy], [ResourceFile]) VALUES (2, 3, N'aksjhdkjh', N'kjh', N'Resource File', N'https://www.youtube.com/embed/tgbNymZ7vqY', 2, CAST(N'2020-05-28 22:06:16.867' AS DateTime), NULL, NULL, 1, 0, NULL, NULL, N'000000_Front_page__28052020100222.pdf')
GO
SET IDENTITY_INSERT [SiteUsers].[Mst_Feeds] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ON 

GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (1, 2, 1, N'14/05/2020 23:59:59', N'14/05/2020 23:59:59', N'kdkasd', 1, 0, CAST(N'2020-05-14 16:13:27.380' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (2, 2, 4, N'14/05/2020 23:59:59', N'14/05/2020 23:59:59', N'asdasd', 1, 0, CAST(N'2020-05-14 16:14:48.147' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (3, 2, 4, N'15/05/2020 23:59:00', N'15/05/2020 23:59:00', N'ladjlaskjdlsa', 1, 0, CAST(N'2020-05-14 16:14:48.147' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (4, 2, 5, N'14/05/2020 23:59:59', N'14/05/2020 23:59:59', N'lkjaslkdasd', 1, 0, CAST(N'2020-05-14 16:15:51.923' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (5, 20, 17, N'15/05/2020 18:59:00', N'15/05/2020 19:59:00', N'HDKJSADSAD', 1, 0, CAST(N'2020-05-14 22:14:55.350' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (6, 20, 17, N'22/05/2020 18:59:00', N'22/05/2020 19:59:00', N'KJAHDKSA', 1, 0, CAST(N'2020-05-14 22:14:55.350' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (7, 20, 17, N'14/05/2020 23:59:59', N'14/05/2020 23:59:59', N'AKJSHDSAD', 1, 0, CAST(N'2020-05-14 22:18:02.000' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (8, 20, 17, N'14/05/2020 23:59:59', N'14/05/2020 23:59:59', N'ASD', 1, 0, CAST(N'2020-05-14 22:20:29.793' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (9, 21, 22, N'15/05/2020 23:59:59', N'15/05/2020 23:59:59', N'Testing', 1, 0, CAST(N'2020-05-15 13:12:26.813' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (10, 21, 22, N'16/05/2020 23:59:00', N'16/05/2020 23:59:00', N'Testing 2', 1, 0, CAST(N'2020-05-15 13:13:13.607' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (11, 21, 22, N'21/05/2020 23:59:00', N'21/05/2020 23:59:00', N'kjhsakd', 1, 0, CAST(N'2020-05-15 13:16:46.313' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (12, 21, 22, N'29/05/2020 23:59:00', N'29/05/2020 23:59:00', N'asd', 1, 0, CAST(N'2020-05-15 19:07:30.767' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (13, 3, 11, N'24/05/2020 23:59:59', N'24/05/2020 23:59:59', N'kjhasdhjsad', 1, 0, CAST(N'2020-05-24 00:50:09.580' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (10013, 3, 0, N'25/05/2020 23:59:59', N'25/05/2020 23:59:59', N'jaksd', 1, 0, CAST(N'2020-05-25 00:12:45.967' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (10014, 3, 0, N'25/05/2020 23:59:59', N'25/05/2020 23:59:59', N'jh\kjhakdss', 1, 0, CAST(N'2020-05-25 00:16:49.203' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (10015, 3, 0, N'25/05/2020 23:59:59', N'25/05/2020 23:59:59', N'asd', 1, 0, CAST(N'2020-05-25 00:24:49.203' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (10016, 3, 2, N'25/05/2020 23:59:59', N'25/05/2020 23:59:59', N'hjjgjg', 1, 0, CAST(N'2020-05-25 00:26:07.987' AS DateTime))
GO
INSERT [SiteUsers].[MST_MAP_PlannedCommunication] ([PK_PlannedCommunicationID], [FK_CounselorID], [FK_StudentID], [DateTimeFrom], [DateTimeTo], [CommunicationPlan], [IsActive], [IsDeleted], [CreatedDateTime]) VALUES (20013, 6, 5, N'25/05/2020 23:59:59', N'25/05/2020 23:59:59', N'kjahsd', 1, 0, CAST(N'2020-05-25 17:12:41.630' AS DateTime))
GO
SET IDENTITY_INSERT [SiteUsers].[MST_MAP_PlannedCommunication] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_RetiredExpertise] ON 

GO
INSERT [SiteUsers].[MST_RetiredExpertise] ([PK_RetiredExpertise], [RetiredExpertise], [IsActive]) VALUES (1, N'Agriculture engineer', 1)
GO
INSERT [SiteUsers].[MST_RetiredExpertise] ([PK_RetiredExpertise], [RetiredExpertise], [IsActive]) VALUES (2, N'Software Engineer', 1)
GO
INSERT [SiteUsers].[MST_RetiredExpertise] ([PK_RetiredExpertise], [RetiredExpertise], [IsActive]) VALUES (3, N'Journalists', 1)
GO
INSERT [SiteUsers].[MST_RetiredExpertise] ([PK_RetiredExpertise], [RetiredExpertise], [IsActive]) VALUES (4, N'Armed force employee', 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_RetiredExpertise] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUser] ON 

GO
INSERT [SiteUsers].[MST_SiteUser] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [UserPassword], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [Name], [LastWebLogInDatetime], [Mobile_Number], [Alternate_Mobile_Number], [Address], [Zipcode], [FK_StateID], [FK_CityID], [FK_LanguageKnown], [FK_AreaOfInterest], [Image], [HaveSmartPhone], [HavePC], [AdoptionWish], [Email], [Fk_AreaOfInterest_State], [Fk_AreaOfInterest_District], [AreYou], [JoinUsDescription], [Declaration], [LikeAdoptStudentLater], [RecoverBy], [RecoverDateTime], [IsPendingForReply], [PendingForReplyDateTime], [IsManageCreiticalSupport], [LastManageCreiticalSupportDateTime], [IsApprovedCounselor], [ApprovedCounselorDateTime], [Retired_expertise], [Employed_expertise], [IsAdoptedStudent], [IsAdoptedStudentCounselor], [AdoptedStudentCounselorDateTime], [IsAdoptedStudentDateTime], [IsAdoptedStudentByCounselor], [ApprovedCounselorBy], [IsEmailVerified], [EmailVerifiedDateTime]) VALUES (1, N'Vinish.volunteer.a', 3, 4, N'9BZmF4gg+zL8+eHsxrGAPQ==', 1, 0, 0, CAST(N'2020-05-24 16:09:11.817' AS DateTime), 1, CAST(N'2020-05-24 16:12:48.483' AS DateTime), 0, NULL, N'Vinish', CAST(N'2020-05-28 01:10:50.930' AS DateTime), N'9847298473', N'9274329742', N'kjsahdaksjdhk', N'123123', 1, 1, NULL, NULL, N'vinish__24052020041248.png', 0, 0, 0, N'vinishmaurya0@gmail.com', 1, 1, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [SiteUsers].[MST_SiteUser] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [UserPassword], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [Name], [LastWebLogInDatetime], [Mobile_Number], [Alternate_Mobile_Number], [Address], [Zipcode], [FK_StateID], [FK_CityID], [FK_LanguageKnown], [FK_AreaOfInterest], [Image], [HaveSmartPhone], [HavePC], [AdoptionWish], [Email], [Fk_AreaOfInterest_State], [Fk_AreaOfInterest_District], [AreYou], [JoinUsDescription], [Declaration], [LikeAdoptStudentLater], [RecoverBy], [RecoverDateTime], [IsPendingForReply], [PendingForReplyDateTime], [IsManageCreiticalSupport], [LastManageCreiticalSupportDateTime], [IsApprovedCounselor], [ApprovedCounselorDateTime], [Retired_expertise], [Employed_expertise], [IsAdoptedStudent], [IsAdoptedStudentCounselor], [AdoptedStudentCounselorDateTime], [IsAdoptedStudentDateTime], [IsAdoptedStudentByCounselor], [ApprovedCounselorBy], [IsEmailVerified], [EmailVerifiedDateTime]) VALUES (2, N'Gyanmitras_jgedg', 1, 1, N'9BZmF4gg+zL8+eHsxrGAPQ==', 1, 0, 1, CAST(N'2020-05-24 16:13:51.077' AS DateTime), 2, CAST(N'2020-05-24 16:17:13.370' AS DateTime), 0, NULL, N'Vinish', CAST(N'2020-05-29 15:23:14.130' AS DateTime), N'9287349274', N'9827298374', N'kjsahdkajshd', N'123123', 1, 1, N'1,2,3', N'2,3,4', N'vinish__24052020041713.png', 1, 1, 1, N'vinishmaurya1@gmail.com', 0, 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, CAST(N'2020-05-25 00:26:07.990' AS DateTime), NULL, 3, NULL, 1, CAST(N'2020-05-24 16:14:42.410' AS DateTime))
GO
INSERT [SiteUsers].[MST_SiteUser] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [UserPassword], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [Name], [LastWebLogInDatetime], [Mobile_Number], [Alternate_Mobile_Number], [Address], [Zipcode], [FK_StateID], [FK_CityID], [FK_LanguageKnown], [FK_AreaOfInterest], [Image], [HaveSmartPhone], [HavePC], [AdoptionWish], [Email], [Fk_AreaOfInterest_State], [Fk_AreaOfInterest_District], [AreYou], [JoinUsDescription], [Declaration], [LikeAdoptStudentLater], [RecoverBy], [RecoverDateTime], [IsPendingForReply], [PendingForReplyDateTime], [IsManageCreiticalSupport], [LastManageCreiticalSupportDateTime], [IsApprovedCounselor], [ApprovedCounselorDateTime], [Retired_expertise], [Employed_expertise], [IsAdoptedStudent], [IsAdoptedStudentCounselor], [AdoptedStudentCounselorDateTime], [IsAdoptedStudentDateTime], [IsAdoptedStudentByCounselor], [ApprovedCounselorBy], [IsEmailVerified], [EmailVerifiedDateTime]) VALUES (3, N'Vinish.counselor.a', 2, 4, N'jRP6gcIvz+H0selbm6BUMQ==', 1, NULL, NULL, CAST(N'2020-05-24 16:44:52.120' AS DateTime), 0, CAST(N'2020-05-27 22:10:29.490' AS DateTime), NULL, NULL, N'Vinish', CAST(N'2020-05-29 15:21:53.557' AS DateTime), N'9238472987', N'8326832764', N'kjfdkjsdhf', N'', 0, 0, N'', N'1,2,3', N'vinish__25052020092047.png', 0, 1, 1, N'vinishmaurya3@gmail.com', 0, 0, N'', N'', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-05-24 23:55:03.503' AS DateTime), NULL, NULL, NULL, 1, CAST(N'2020-05-25 21:13:46.540' AS DateTime), NULL, NULL, 2, 1, NULL)
GO
INSERT [SiteUsers].[MST_SiteUser] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [UserPassword], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [Name], [LastWebLogInDatetime], [Mobile_Number], [Alternate_Mobile_Number], [Address], [Zipcode], [FK_StateID], [FK_CityID], [FK_LanguageKnown], [FK_AreaOfInterest], [Image], [HaveSmartPhone], [HavePC], [AdoptionWish], [Email], [Fk_AreaOfInterest_State], [Fk_AreaOfInterest_District], [AreYou], [JoinUsDescription], [Declaration], [LikeAdoptStudentLater], [RecoverBy], [RecoverDateTime], [IsPendingForReply], [PendingForReplyDateTime], [IsManageCreiticalSupport], [LastManageCreiticalSupportDateTime], [IsApprovedCounselor], [ApprovedCounselorDateTime], [Retired_expertise], [Employed_expertise], [IsAdoptedStudent], [IsAdoptedStudentCounselor], [AdoptedStudentCounselorDateTime], [IsAdoptedStudentDateTime], [IsAdoptedStudentByCounselor], [ApprovedCounselorBy], [IsEmailVerified], [EmailVerifiedDateTime]) VALUES (4, N'Vinish.counselor.b', 2, 3, N'jRP6gcIvz+H0selbm6BUMQ==', 1, NULL, NULL, CAST(N'2020-05-24 20:49:40.243' AS DateTime), 0, CAST(N'2020-05-29 18:15:27.210' AS DateTime), NULL, NULL, N'Vinish', CAST(N'2020-05-29 18:15:39.970' AS DateTime), N'9287429837', N'9273498723', N'kajhdakjshdkasjdh', N'823764', 1, 1, N'3', N'', N'vinish__29052020061508.png', 0, 1, 1, N'vinishmaurya4@gmail.com', 0, 0, N'StudentDiv', N'kjahsdksad', 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL)
GO
INSERT [SiteUsers].[MST_SiteUser] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [UserPassword], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [Name], [LastWebLogInDatetime], [Mobile_Number], [Alternate_Mobile_Number], [Address], [Zipcode], [FK_StateID], [FK_CityID], [FK_LanguageKnown], [FK_AreaOfInterest], [Image], [HaveSmartPhone], [HavePC], [AdoptionWish], [Email], [Fk_AreaOfInterest_State], [Fk_AreaOfInterest_District], [AreYou], [JoinUsDescription], [Declaration], [LikeAdoptStudentLater], [RecoverBy], [RecoverDateTime], [IsPendingForReply], [PendingForReplyDateTime], [IsManageCreiticalSupport], [LastManageCreiticalSupportDateTime], [IsApprovedCounselor], [ApprovedCounselorDateTime], [Retired_expertise], [Employed_expertise], [IsAdoptedStudent], [IsAdoptedStudentCounselor], [AdoptedStudentCounselorDateTime], [IsAdoptedStudentDateTime], [IsAdoptedStudentByCounselor], [ApprovedCounselorBy], [IsEmailVerified], [EmailVerifiedDateTime]) VALUES (5, N'Vinish.student.a', 1, 1, N'jRP6gcIvz+H0selbm6BUMQ==', 1, NULL, NULL, CAST(N'2020-05-25 16:48:34.110' AS DateTime), 5, CAST(N'2020-05-25 16:52:37.417' AS DateTime), NULL, NULL, N'Vinish', CAST(N'2020-05-28 20:27:31.703' AS DateTime), N'9824283643', N'9823742937', N'kjhkjads', N'123123', 1, 1, N'1', N'1,2', N'vinish__25052020045236.png', 1, 1, 1, N'vinishmaurya5@gmail.com', 0, 0, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, CAST(N'2020-05-25 17:12:41.650' AS DateTime), NULL, 3, NULL, 1, NULL)
GO
INSERT [SiteUsers].[MST_SiteUser] ([PK_UserId], [UserName], [FK_CategoryId], [FK_RoleId], [UserPassword], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime], [Name], [LastWebLogInDatetime], [Mobile_Number], [Alternate_Mobile_Number], [Address], [Zipcode], [FK_StateID], [FK_CityID], [FK_LanguageKnown], [FK_AreaOfInterest], [Image], [HaveSmartPhone], [HavePC], [AdoptionWish], [Email], [Fk_AreaOfInterest_State], [Fk_AreaOfInterest_District], [AreYou], [JoinUsDescription], [Declaration], [LikeAdoptStudentLater], [RecoverBy], [RecoverDateTime], [IsPendingForReply], [PendingForReplyDateTime], [IsManageCreiticalSupport], [LastManageCreiticalSupportDateTime], [IsApprovedCounselor], [ApprovedCounselorDateTime], [Retired_expertise], [Employed_expertise], [IsAdoptedStudent], [IsAdoptedStudentCounselor], [AdoptedStudentCounselorDateTime], [IsAdoptedStudentDateTime], [IsAdoptedStudentByCounselor], [ApprovedCounselorBy], [IsEmailVerified], [EmailVerifiedDateTime]) VALUES (6, N'Vinish.counselor.c', 2, 3, N'jRP6gcIvz+H0selbm6BUMQ==', 1, NULL, NULL, CAST(N'2020-05-25 17:07:22.670' AS DateTime), 0, CAST(N'2020-05-25 17:10:46.783' AS DateTime), NULL, NULL, N'Vinish', CAST(N'2020-05-25 17:16:30.460' AS DateTime), N'8749827329', N'8239827983', N'kjhkjahds', N'', 0, 0, N'', N'', N'vinish__25052020051046.png', 0, 1, 1, N'vinishmaurya@gmail.com', 0, 0, N'', N'', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2020-05-25 17:08:10.883' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 1, NULL)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUser] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUserCategory] ON 

GO
INSERT [SiteUsers].[MST_SiteUserCategory] ([PK_CategoryId], [CategoryName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, N'Student', 1, 0, 1, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserCategory] ([PK_CategoryId], [CategoryName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (2, N'Counselor', 1, 0, 1, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserCategory] ([PK_CategoryId], [CategoryName], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (3, N'Volunteer', 1, 0, 1, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUserCategory] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUserChat] ON 

GO
INSERT [SiteUsers].[MST_SiteUserChat] ([PK_ChatID], [Chat_From], [Chat_To], [Query_From], [Query_To], [QueryDateTime_From], [QueryDateTime_To], [IsDeleted], [DeletedBy], [IsSeen_From], [IsSeen_To]) VALUES (1, 3, 2, N'Hi Student', N'', CAST(N'2020-05-27 15:36:36.323' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserChat] ([PK_ChatID], [Chat_From], [Chat_To], [Query_From], [Query_To], [QueryDateTime_From], [QueryDateTime_To], [IsDeleted], [DeletedBy], [IsSeen_From], [IsSeen_To]) VALUES (2, 3, 2, N'ajshdkas', N'Fine', CAST(N'2020-05-27 15:39:50.187' AS DateTime), CAST(N'2020-05-27 15:44:34.533' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserChat] ([PK_ChatID], [Chat_From], [Chat_To], [Query_From], [Query_To], [QueryDateTime_From], [QueryDateTime_To], [IsDeleted], [DeletedBy], [IsSeen_From], [IsSeen_To]) VALUES (3, 3, 5, N'akjgdsad', N'', CAST(N'2020-05-27 15:39:57.900' AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserChat] ([PK_ChatID], [Chat_From], [Chat_To], [Query_From], [Query_To], [QueryDateTime_From], [QueryDateTime_To], [IsDeleted], [DeletedBy], [IsSeen_From], [IsSeen_To]) VALUES (4, 3, 2, N'Ok', N'hi', CAST(N'2020-05-27 15:50:23.260' AS DateTime), CAST(N'2020-05-27 15:50:44.580' AS DateTime), NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserChat] ([PK_ChatID], [Chat_From], [Chat_To], [Query_From], [Query_To], [QueryDateTime_From], [QueryDateTime_To], [IsDeleted], [DeletedBy], [IsSeen_From], [IsSeen_To]) VALUES (5, 3, 5, N'Kya be', N'Ha be', CAST(N'2020-05-27 15:51:10.703' AS DateTime), CAST(N'2020-05-27 15:51:30.070' AS DateTime), NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUserChat] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUserRole] ON 

GO
INSERT [SiteUsers].[MST_SiteUserRole] ([PK_RoleId], [RoleName], [FK_CategoryId], [HomePage], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (1, N'Adopted Student', 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserRole] ([PK_RoleId], [RoleName], [FK_CategoryId], [HomePage], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (2, N'Non-Adopted Student', 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserRole] ([PK_RoleId], [RoleName], [FK_CategoryId], [HomePage], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (3, N'Counselor', 2, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [SiteUsers].[MST_SiteUserRole] ([PK_RoleId], [RoleName], [FK_CategoryId], [HomePage], [IsActive], [IsDeleted], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime], [DeletedBy], [DeletedDateTime]) VALUES (4, N'Volunteer', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_SiteUserRole] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_StateUT] ON 

GO
INSERT [SiteUsers].[MST_StateUT] ([PK_StateUT], [StateUT], [IsActive]) VALUES (1, N'Andhra Pradesh', 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_StateUT] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_StateUTBoard] ON 

GO
INSERT [SiteUsers].[MST_StateUTBoard] ([PK_StateUTBoard], [StateUTBoard], [IsActive], [FK_StateUT]) VALUES (1, N'Andhra Pradesh Board of Secondary Education', 1, 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_StateUTBoard] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[MST_StreamType] ON 

GO
INSERT [SiteUsers].[MST_StreamType] ([PK_StreamType], [StreamType], [IsActive]) VALUES (1, N'Agriculture', 1)
GO
SET IDENTITY_INSERT [SiteUsers].[MST_StreamType] OFF
GO
SET IDENTITY_INSERT [SiteUsers].[stream] ON 

GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (1, N'Higher Secondry                                   ', N'Science                                                                                             ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (2, N'Higher Secondry                                   ', N'Biology                                                                                             ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (3, N'Higher Secondry                                   ', N'Arts                                                                                                ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (4, N'Higher Secondry                                   ', N'Commerce                                                                                            ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (5, N'Graduation                                        ', N'BCA                                                                                                 ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (6, N'Graduation                                        ', N'B.com                                                                                               ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (7, N'Higher Secondry                                   ', N'Science                                                                                             ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (8, N'Higher Secondry                                   ', N'Biology                                                                                             ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (9, N'Higher Secondry                                   ', N'Arts                                                                                                ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (10, N'Higher Secondry                                   ', N'Commerce                                                                                            ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (11, N'Graduation                                        ', N'BCA                                                                                                 ')
GO
INSERT [SiteUsers].[stream] ([ID], [EducationLevel], [StreamName]) VALUES (12, N'Graduation                                        ', N'B.com                                                                                               ')
GO
SET IDENTITY_INSERT [SiteUsers].[stream] OFF
GO
/****** Object:  StoredProcedure [dbo].[BindAllAccountsByCategory]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BindAllAccountsByCategory]
@iFK_CategoryId bigint
AS
BEGIN
	SELECT * FROM MST_ACCOUNT WHERE FK_CategoryId  = @iFK_CategoryId and ISNULL(IsActive,0) = 1 AND ISNULL(IsDeleted,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditAccount]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************              
CreatedBy:sandeep Kumar             
CreatedDate:28-11-2019            
purpos:Add edit Account Master            
          
Updated:Vinish          
UpdatedDate:2019-12-16 18:31:40.523          
purpos:Added some fields and maped with UI          
          
[dbo].[USP_AddEditAccount]            
select * from MST_Account              
EXEC [dbo].[USP_AddEditAccount]    
0,1,'Binary',2,0,2,0,1,'pryagraj','1104089',1,1,1,  
'delhi','vivek','77766666','66667777','sqq@1231',  
'sqq@1231','reg8785','logo',1,1,1          
********************************************************************/                  
CREATE PROCEDURE [dbo].[USP_AddEditAccount]                    
(                 
   @iPK_AccountId               BIGINT,            
   @cAccountName                NVARCHAR(30),              
   @iFK_CategoryId              BIGINT,             
   --@iFK_CompanyId               BIGINT,             
   --@iFK_ResellerId              BIGINT,             
   --@iFK_AffiliateId             BIGINT,     
     @iParentCategoryID            BIGINT,          
   @iParentAccountId            BIGINT,               
   @cAccountAddress             NVARCHAR(30),               
   @cZipCode                    NVARCHAR(30),                 
   @iFK_CountryId               BIGINT,                 
   @iFK_StateId                 BIGINT,                 
   @iFK_CityId                  BIGINT,              
   @cBillingAddress             NVARCHAR(30),             
   @cContactPerson              NVARCHAR(30),                  
   @cMobileNo                   NVARCHAR(20),            
   @cAlternateMobileNo          NVARCHAR(30),                
   @cEmailId                    NVARCHAR(200),             
   @cAlternateEmailId           NVARCHAR(200),             
   @cAccountRegistrationNo      NVARCHAR(30),             
   @cAccountLogo                NVARCHAR(max),             
   @bIsActive                   BIT,             
   @CreatedBy                     BIGINT          
--By Vinish          
,@Username                   nvarchar(100)          
,@Password                   nvarchar(20)          
,@FK_RoleId                  bigint          
,@ZipCode_Billing            nvarchar(6)          
,@FK_CountryId_Billing      bigint          
,@FK_StateId_Billing      bigint          
,@FK_CityId_Billing          bigint          
,@UserLimit                  int  
,@FK_CategoryId_Referrer bigint = 0          
,@FK_AccountId_Referrer bigint = 0          
,@ShareVia varchar(50) = 0  
 ,@cUnEncryptedPassword  NVARCHAR(500)='' 
 --End Vinish          
)                    
AS                    
BEGIN TRY    
Declare  @iFK_CompanyId               BIGINT,             
@iFK_ResellerId              BIGINT,             
@iFK_AffiliateId             BIGINT  
      
Select @iFK_CompanyId=  
FK_CompanyId,@iFK_ResellerId=FK_ResellerId,@iFK_AffiliateId=FK_AffiliateId  
      
from [dbo].[MST_Account]   where PK_AccountId=@iParentAccountId   
  
                 
 IF(@iPK_AccountId=0)                     
    BEGIN                
  IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Account] (NOLOCK) WHERE AccountName=LTRIM(RTRIM(@cAccountName)) AND IsActive =1 and CreatedBy = @CreatedBy)            
  BEGIN            
   IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Account] WHERE MobileNo=@cMobileNo  AND IsActive=1 and CreatedBy = @CreatedBy)                    
            BEGIN             
    IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Account] WHERE EmailId=@cEmailId  AND IsActive=1 and CreatedBy = @CreatedBy)                    
    BEGIN     
       --Check User  
  IF not EXISTS (SELECT * FROM MST_User WHERE rtrim(ltrim(UserName)) = rtrim(ltrim(@Username)) and isnull(IsDeleted,0) = 0)  
  BEGIN  
     INSERT INTO [dbo].[MST_Account]  
     (                    
      AccountName,                          
      FK_CategoryId,                       
      FK_CompanyId,                     
      FK_ResellerId,                   
      FK_AffiliateId,    
      ParentAccountId,      
AccountAddress,       
      ZipCode,                           
      FK_CountryId,                   
      FK_StateId,                       
      FK_CityId,                       
      BillingAddress,        
 ContactPerson,                   
      MobileNo,            
      AlternateMobileNo,                       
      EmailId,            
      AlternateEmailId,                            
      AccountRegistrationNo,               
      AccountLogo,                       
      IsActive,            
      --IsDeleted,                         
      CreatedBy,                       
      CreatedDatetime,          
      --By Vinish          
      ZipCode_Billing,          
      FK_CountryId_Billing,          
      FK_StateId_Billing,          
      FK_CityId_Billing,          
      UserLimit  ,  
   FK_CategoryId_Referrer,      
   FK_AccountId_Referrer   ,  
   ShareVia     
      --End          
     )               
     VALUES                    
     (               
      rtrim(ltrim(@cAccountName)),                      
      @iFK_CategoryId,                       
      @iParentAccountId,  
   --CASE WHEN @iParentCategoryID=  
   --(SELECT TOP 1 PK_CategoryId FROM [dbo].[MST_Category] CA WHERE 'company' = lower(RTRIM((LTRIM(CA.CategoryName)))) AND  ISNULL(CA.IsActive,0) = 1 AND ISNULL(CA.IsDeleted,0) = 0)  
   --   THEN @iParentAccountId ELSE @iFK_CompanyId END ,  
      CASE WHEN @iParentCategoryID=  
   (SELECT TOP 1 PK_CategoryId FROM [dbo].[MST_Category] CA WHERE 'reseller' = lower(RTRIM((LTRIM(CA.CategoryName)))) AND  ISNULL(CA.IsActive,0) = 1 AND ISNULL(CA.IsDeleted,0) = 0)  
    THEN @iParentAccountId ELSE @iFK_ResellerId END ,  
      CASE WHEN @iParentCategoryID=  
   (SELECT TOP 1 PK_CategoryId FROM [dbo].[MST_Category] CA WHERE 'affiliate' = lower(RTRIM((LTRIM(CA.CategoryName)))) AND  ISNULL(CA.IsActive,0) = 1 AND ISNULL(CA.IsDeleted,0) = 0)   
   THEN @iParentAccountId ELSE @iFK_AffiliateId END ,  
     -- @iFK_CompanyId,                      
     -- @iFK_ResellerId,                    
     -- @iFK_AffiliateId,                  
      @iParentAccountId,                  
      rtrim(ltrim(@cAccountAddress)),                        
      rtrim(ltrim(@cZipCode)),                        
      @iFK_CountryId,                     
      @iFK_StateId,                    
      @iFK_CityId,                        
      rtrim(ltrim(@cBillingAddress)),                
      rtrim(ltrim(@cContactPerson)),                    
      rtrim(ltrim(@cMobileNo)),            
      rtrim(ltrim(@cAlternateMobileNo)),                  
      rtrim(ltrim(@cEmailId)),            
      rtrim(ltrim(@cAlternateEmailId)),                         
      rtrim(ltrim(@cAccountRegistrationNo)),              
      rtrim(ltrim(@cAccountLogo)),                    
      @bIsActive,                        
      --CASE WHEN @bIsActive = 1 THEN 0 ELSE 1 END,   by sandeep         
      @CreatedBy,                        
      GETDATE(),          
      rtrim(ltrim(@ZipCode_Billing)),          
      @FK_CountryId_Billing,          
      @FK_StateId_Billing,          
      @FK_CityId_Billing,          
      @UserLimit    ,  
   @FK_CategoryId_Referrer,      
   @FK_AccountId_Referrer,  
   @ShareVia  
     )              
     declare @AccountId bigint = @@IDENTITY;          
       
   
  Insert Into [dbo].[MST_Role] (RoleName,FK_CategoryId,FK_AccountId,FK_CustomerId,IsActive,HomePage,CreatedBy,CreatedDateTime)   
  values ('Admin',@iFK_CategoryId,@AccountId,0,1,36,@CreatedBy,getdate());  
  set @FK_RoleId = @@IDENTITY;  
  INSERT INTO [dbo].[MST_User]           
     (FullName,UserName,UserPassword,FK_RoleId,FK_CustomerId,FK_CategoryId,          
     FK_AccountId,FK_CountryId,FK_StateId,FK_CityId,IsActive,IsDeleted,          
     CreatedBy,CreatedDateTime,MobileNo,EmailId)           
     VALUES (rtrim(ltrim(@Username)),rtrim(ltrim(@Username)),rtrim(ltrim(@Password)),@FK_RoleId,0,@iFK_CategoryId,@AccountId ,@iFK_CountryId,@iFK_StateId,@iFK_CityId,1,0,@CreatedBy,GETDATE(),@cMobileNo,@cEmailId);          
     declare @UserId bigint = @@IDENTITY;          
       
     INSERT INTO [dbo].[MAP_UserAccount] (FK_UserId,FK_AccountId,IsActive,IsDeleted,CreatedBy,CreatedDateTime) VALUES(@UserId,@AccountId,1,0,@CreatedBy,GETDATE())                        
     UPDATE [dbo].[MST_Account] SET FK_UserId = @UserId where PK_AccountId = @AccountId;    
  
  
  -- AS PER VINISH/SHIVAM, EDIT MODE DOES NOT ALLOW TO CHANGE CATEGORY SO NO NEED TO ADD THIS QUERY IN EDIT QUERY's BLOCK :: 17 FEB 20 - 16:38 PM  
  DECLARE @cCategoryType NVARCHAR(250)=''  
  SET @cCategoryType = (SELECT UPPER(ISNULL(CategoryName,'')) FROM MST_Category(NOLOCK) WHERE PK_CategoryId = @iFK_CategoryId)  
  
  DECLARE @cRoleName NVARCHAR(250)=''  
  SET @cRoleName = (SELECT UPPER(ISNULL(RoleName,'')) FROM MST_Role(NOLOCK) WHERE PK_RoleId = @FK_RoleId)  
  
  IF(ISNULL(@AccountId,0)<>0 AND ISNULL(@cCategoryType,'')<>'')  
  BEGIN  
  
  IF EXISTS(SELECT 1 FROM [dbo].[LKP_ExcludeFormByCategoryType](NOLOCK) WHERE  LTRIM(RTRIM(ISNULL(CategoryType,''))) = LTRIM(RTRIM(ISNULL(@cCategoryType,''))) AND IsActive = 1)  
  BEGIN  
  
  INSERT INTO dboGyanmitrasMap_FormRole   
  (  
   FK_FormId,  
   FK_RoleId,   
   CanAdd,    
   CanEdit,  
   CanDelete,  
   CanView,  
   IsActive,  
   CreatedBy,  
   CreatedDateTime,  
   InsertionMode  
  )  
    
  SELECT  
  DISTINCT  
  PK_FormId FK_FormId,  
  @FK_RoleId FK_RoleId,  
  
  CASE   
   WHEN   
    @cCategoryType = 'RESELLER'  
   THEN 0      
   ELSE 1   
  END CanAdd,    
    
  CASE   
   WHEN   
    @cCategoryType = 'RESELLER'  
   THEN 0      
   ELSE 1   
  END CanEdit,  
  
  CASE   
   WHEN   
    @cCategoryType = 'RESELLER'  
   THEN 0      
   ELSE 1   
  END CanDelete,  
  
  CASE   
    WHEN @cCategoryType = 'RESELLER' AND  @cRoleName = 'Admin' AND (LTRIM(RTRIM(form.FormName)) = 'User Management' OR  LTRIM(RTRIM(form.FormName)) = 'Users') THEN 1   
    WHEN @cCategoryType = 'RESELLER' AND  @cRoleName <> 'Admin' AND (LTRIM(RTRIM(form.FormName)) = 'User Management' OR  LTRIM(RTRIM(form.FormName)) = 'Users') THEN 0  
    WHEN @cCategoryType = 'RESELLER' AND  (LTRIM(RTRIM(form.FormName)) = 'Accounts' OR LTRIM(RTRIM(form.FormName)) = 'Customers' OR  LTRIM(RTRIM(form.FormName)) = 'Account Management' OR   
     LTRIM(RTRIM(form.FormName)) = 'User Management' OR  LTRIM(RTRIM(form.FormName)) = 'Users')  THEN 1  
    WHEN @cCategoryType = 'RESELLER' AND  (LTRIM(RTRIM(form.FormName)) = 'Mapping' OR  LTRIM(RTRIM(form.FormName)) = 'Installations')  THEN 1  
   ELSE 1  
   END  
   CanView,  
  
  
  
  1 IsActive,  
  @CreatedBy CreatedBy,  
  GETDATE() CreatedDateTime,  
  'ONE BY ONE'   
  FROM [dbo].[MST_Form](NOLOCK) form  
  WHERE   
  --FK_SolutionId IN  
  --(  
  -- SELECT DISTINCT FK_SolutionId FROM DET_PackageSolution(NOLOCK) WHERE FK_PackageId = @iFK_PackageId  
  --)  
  --AND   
  form.IsActive = 1  
  
  AND form.PK_FormId NOT IN  
  (  
   SELECT FK_FormId FROM Map_FormRole(NOLOCK) WHERE FK_RoleId = @FK_RoleId  
  )  
  AND LTRIM(RTRIM(form.FormName))  IN  
  (  
   SELECT LTRIM(RTRIM(ISNULL(Item,''))) FROM dbo.SplitString((SELECT FormNames FROM [dbo].[LKP_ExcludeFormByCategoryType](NOLOCK) WHERE  CategoryType = @cCategoryType  AND IsActive = 1),',')  WHERE ISNULL(Item,'') <> ''  
  )  
  
  INSERT INTO MAP_FormAccount  
    (   
    FK_FormId,   
    FK_AccountId,   
    FK_CategoryId,   
    IsCustomerAccount,   
    IsActive,   
    IsDeleted,   
    CreatedBy,   
    CreatedDateTime,  
    FK_CustomerId,  
    InsertionMode,  
    CanAdd,  
    CanDelete,  
    CanView,  
    CanEdit  
   )  
     
   SELECT  
   DISTINCT  
   formNew.PK_FormId FK_FormId,  
   ISNULL(@AccountId,0) FK_AccountId,  
   @iFK_CategoryId FK_CategoryId,  
   0 IsCustomerAccount,  
   1 IsActive,  
   0 IsDeleted,  
   @CreatedBy CreatedBy,  
   GETDATE() CreatedDateTime,  
   0,  
   'ONE BY ONE' ,  
   CASE   
   WHEN   
    @cCategoryType = 'RESELLER'  
   THEN 0      
   ELSE 1   
   END CanAdd,  
   CASE   
   WHEN   
    @cCategoryType = 'RESELLER'  
   THEN 0      
   ELSE 1   
   END CanDelete,  
   CASE   
    WHEN @cCategoryType = 'RESELLER' AND @cRoleName = 'Admin' AND (LTRIM(RTRIM(formNew.FormName)) = 'User Management' OR  LTRIM(RTRIM(formNew.FormName)) = 'Users') THEN 1   
    WHEN @cCategoryType = 'RESELLER' AND  @cRoleName <> 'Admin' AND (LTRIM(RTRIM(formNew.FormName)) = 'User Management' OR  LTRIM(RTRIM(formNew.FormName)) = 'Users') THEN 0  
    WHEN @cCategoryType = 'RESELLER' AND  (LTRIM(RTRIM(formNew.FormName)) = 'Accounts' OR LTRIM(RTRIM(formNew.FormName)) = 'Customers' OR  LTRIM(RTRIM(formNew.FormName)) = 'Account Management' OR    
    LTRIM(RTRIM(formNew.FormName)) = 'User Management' OR  LTRIM(RTRIM(formNew.FormName)) = 'Users')  THEN 1  
    WHEN @cCategoryType = 'RESELLER' AND  (LTRIM(RTRIM(formNew.FormName)) = 'Mapping' OR  LTRIM(RTRIM(formNew.FormName)) = 'Installations')  THEN 1  
   ELSE 1  
   END  
   CanView,  
   CASE   
   WHEN   
    @cCategoryType = 'RESELLER'  
   THEN 0      
   ELSE 1   
   END CanEdit  
   FROM [dbo].[MST_Form](NOLOCK) formNew  
   WHERE   
   LTRIM(RTRIM(formNew.FormName))  IN  
   (  
    SELECT LTRIM(RTRIM(ISNULL(Item,''))) FROM dbo.SplitString((SELECT FormNames FROM [dbo].[LKP_ExcludeFormByCategoryType](NOLOCK) WHERE  CategoryType = @cCategoryType  AND IsActive = 1),',')  WHERE ISNULL(Item,'') <> ''  
   )  
   AND  
   formNew.PK_FormId NOT IN   
   (  
    SELECT FormsAlready.FK_FormId FROM MAP_FormAccount(NOLOCK) FormsAlready   
    WHERE ISNULL(FormsAlready.FK_AccountId,0) = ISNULL(@AccountId,0)  AND FormsAlready.IsActive = 1  
   )  
  
   END  
  END  
  SELECT 1 AS Message_Id,'Account Added Successfully.' As Message   
    
  SELECT @UserId AS NewlyAddedUserId  
  end  
  else  
  begin  
    SELECT 6 AS Message_Id,'User Name Already Exist.' As Message     
  end  
  --End Check User            
    END          
    ELSE                    
   BEGIN                    
       SELECT 3 AS Message_Id,'EmailId Already In Use.' AS Message                    
   END            
              
   END          
          
   ELSE                    
   BEGIN                   
       SELECT 4 AS Message_Id,'Mobile No. Already In Use.' AS Message                    
   END             
  END            
  ELSE                  
  BEGIN                 
   SELECT 5 AS Message_Id,'Account Name Already Exists.' AS Message                
  END            
 END           
                
 ELSE                    
    BEGIN                        
  IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Account](NOLOCK) WHERE AccountName=LTRIM(RTRIM(@cAccountName)) And PK_AccountId<>@iPK_AccountId AND IsActive =1 and CreatedBy = @CreatedBy)            
  BEGIN            
   IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Account] WHERE MobileNo=@cMobileNo  And PK_AccountId<>@iPK_AccountId AND IsActive=1  and CreatedBy = @CreatedBy)                    
   BEGIN          
             
   IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Account] WHERE EmailId=@cEmailId  AND IsActive=1  And PK_AccountId<>@iPK_AccountId and CreatedBy = @CreatedBy)                    
   BEGIN          
    if(isnull(@cAccountLogo,'') = '')        
 begin        
       if (isnull((SELECT AccountLogo FROM [dbo].[MST_Account] WHERE PK_AccountId =11),'') <> '')        
       begin        
     set @cAccountLogo = (SELECT AccountLogo FROM [dbo].[MST_Account] WHERE PK_AccountId =@iPK_AccountId)        
       end        
    end        
           
    UPDATE  [dbo].[MST_Account]     SET             
    AccountName            =     rtrim(ltrim(@cAccountName)),   
    --FK_CategoryId          =     @iFK_CategoryId,    
   
 FK_CompanyId = @iParentAccountId,  
 --CASE WHEN @iParentCategoryID=  
 --(SELECT TOP 1 PK_CategoryId FROM [dbo].[MST_Category] CA WHERE 'company' = lower(RTRIM((LTRIM(CA.CategoryName)))) AND  ISNULL(CA.IsActive,0) = 1 AND ISNULL(CA.IsDeleted,0) = 0)  
 --THEN @iParentAccountId ELSE @iFK_CompanyId END ,  
    FK_ResellerId          =CASE WHEN @iParentCategoryID=  
 (SELECT TOP 1 PK_CategoryId FROM [dbo].[MST_Category] CA WHERE 'company' = lower(RTRIM((LTRIM(CA.CategoryName)))) AND  ISNULL(CA.IsActive,0) = 1 AND ISNULL(CA.IsDeleted,0) = 0)  
  THEN @iParentAccountId ELSE @iFK_ResellerId END ,  
    FK_AffiliateId         =  CASE WHEN @iParentCategoryID=  
 (SELECT TOP 1 PK_CategoryId FROM [dbo].[MST_Category] CA WHERE 'company' = lower(RTRIM((LTRIM(CA.CategoryName)))) AND  ISNULL(CA.IsActive,0) = 1 AND ISNULL(CA.IsDeleted,0) = 0)  
  THEN @iParentAccountId ELSE @iFK_AffiliateId END ,  
     
                   
    --FK_CompanyId =     @iFK_CompanyId,                  
    --FK_ResellerId          =     @iFK_ResellerId,                  
    --FK_AffiliateId         =     @iFK_AffiliateId,                  
    ParentAccountId        =     @iParentAccountId,                  
    AccountAddress         =     rtrim(ltrim(@cAccountAddress)),                  
    ZipCode  =     @cZipCode,                        
    FK_CountryId           =     @iFK_CountryId,                  
    FK_StateId             =     @iFK_StateId,                    
    FK_CityId              =     @iFK_CityId,                      
    BillingAddress         =     rtrim(ltrim(@cBillingAddress)),                
    ContactPerson          =     rtrim(ltrim(@cContactPerson)),         
    MobileNo               =     rtrim(ltrim(@cMobileNo)),            
    AlternateMobileNo      =     rtrim(ltrim(@cAlternateMobileNo)),              
    EmailId                =     rtrim(ltrim(@cEmailId)),            
    AlternateEmailId       =     rtrim(ltrim(@cAlternateEmailId)),             
    AccountRegistrationNo  =     rtrim(ltrim(@cAccountRegistrationNo)),            
    AccountLogo            =     rtrim(ltrim(@cAccountLogo)),                    
    IsActive               =     @bIsActive,                        
    --IsDeleted   =     CASE WHEN @bIsActive = 1 THEN 0 ELSE 1 END,            
    UpdatedBy              =     @CreatedBy,                      
    UpdatedDatetime        =     GETDATE() ,          
    ZipCode_Billing        =     rtrim(ltrim(@ZipCode_Billing)),          
    FK_CountryId_Billing   =     @FK_CountryId_Billing,          
    FK_StateId_Billing     =     @FK_StateId_Billing,          
    FK_CityId_Billing      =     @FK_CityId_Billing,            
    UserLimit              =     @UserLimit  ,  
 FK_CategoryId_Referrer = @FK_CategoryId_Referrer,      
 FK_AccountId_Referrer = @FK_AccountId_Referrer,  
 ShareVia = @ShareVia  
    WHERE PK_AccountId=@iPK_AccountId            
    SELECT 2 AS Message_Id,'Account Updated Successfully.' AS Message       
 declare @UserId_  bigint =  0;  
 SELECT @UserId_ AS NewlyAddedUserId       
   END          
   ELSE            
   BEGIN            
    SELECT 3 AS Message_Id,'EmailId Already In Use.' AS Message          
   END     
               
                
 END            
   ELSE            
   BEGIN            
    SELECT 4 AS Message_Id,'Mobile No. Already In Use.' AS Message          
   END            
  END           
             
  ELSE            
  BEGIN            
    SELECT 5 AS Message_Id,'Account Name Already Exists.' AS Message             
  END            
 END          
          
END TRY                    
BEGIN CATCH                    
    SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                    
END CATCH  
  
  
  
  
  



GO
/****** Object:  StoredProcedure [dbo].[Usp_AddEditAccountType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************            
CREATED BY : Mohd. Sarfaraz            
CREATED DATE: 12 Dec 2019            
Purpose: To Add Edit Account Type            
EXEC [DBO].[Usp_AddEditAccountType]      
**************************************************************************/   
           
CREATE PROCEDURE   [dbo].[Usp_AddEditAccountType]            
(              
 @PK_CategoryId INT,              
 @CategoryName varchar(100),  
 @IsActive BIT ,  
 @CreatedBy INT  
)              
AS              
BEGIN TRY   
IF(@PK_CategoryId = 0)  
BEGIN  
INSERT INTO DBOGyanmitrasMST_Category  
  (  
    CategoryName ,  
    IsActive ,  
    CreatedBy ,  
    CreatedDateTime   
  )  
VALUES  
  (  
    @CategoryName ,  
    @IsActive ,  
    @CreatedBy,  
    GETDATE()  
  )  
  SELECT 1 AS Message_Id,'Account Type  Added Successfully.' AS Message   
END  
ELSE       
BEGIN  
UPDATE DBOGyanmitrasMST_Category SET   
    CategoryName = @CategoryName ,  
    IsActive     = @IsActive,  
    UpdatedBy    =@CreatedBy,  
    UpdatedDateTime = GETDATE()  
    WHERE PK_CategoryId = @PK_CategoryId  
    SELECT 1 AS Message_Id,'Account Type  Updated Successfully.' AS Message   
END     
END TRY   
   
BEGIN CATCH    
 SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message                   
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditCategory]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************          
CreatedBy:sandeep Kumar         
CreatedDate:28-11-2019        
purpos:Add edit Category Master       
select * from mst_category       
[dbo].[USP_AddEditCategory]            
EXEC [dbo].[USP_AddEditCategory] 0,'Company2',1,1    
****************************************************/              
CREATE PROCEDURE [dbo].[USP_AddEditCategory]      
(             
 @iPK_CategoryId              BIGINT,           
 @cCategoryName               NVARCHAR(30),         
 @bIsActive                   BIT,         
 @iUserId                     BIGINT        
)                
 AS                
 BEGIN TRY                
 IF(@iPK_CategoryId=0)        
    BEGIN                
       BEGIN            
         IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Category](NOLOCK) WHERE CategoryName=LTRIM(RTRIM(@cCategoryName)) AND Isnull(IsDeleted,0) =0 )        
           BEGIN             
            INSERT INTO [dbo].[MST_Category]               
            (            
             CategoryName,         
             IsActive,               
             CreatedBy,              
             CreatedDatetime,  
    FK_CompanyId                     
            )                
            VALUES                
           (                  
             @cCategoryName,                   
             @bIsActive,                        
             @iUserId,                   
             GETDATE(),  
    1            
          )                
             SELECT 1 AS Message_Id,'Account Category Added Successfully.' As Message            
       END         
  ELSE              
      BEGIN             
         SELECT 0 AS Message_Id,'Account Category Name Already Exists.' AS Message            
      END                      
          END         
   END       
               
 ELSE                
 BEGIN             
 IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Category](NOLOCK) WHERE CategoryName=LTRIM(RTRIM(@cCategoryName)) And PK_CategoryId<>@iPK_CategoryId AND Isnull(IsDeleted,0) =0 )        
         BEGIN      
         UPDATE  [dbo].[MST_Category]     SET             
         CategoryName          =        @cCategoryName,        
         IsActive              =        @bIsActive,                     
         UpdatedBy             =        @iUserId,              
         UpdatedDatetime       =        GETDATE(),  
   FK_CompanyId          =        1    
         WHERE PK_CategoryId=@iPK_CategoryId        
         SELECT 2 AS Message_Id,'Account Category Updated Successfully.' AS Message          
         END      
   ELSE        
       BEGIN        
            SELECT 0 AS Message_Id,'Account Category Name Already Exists.' AS Message         
       END      
 END            
END TRY                
BEGIN CATCH                
    SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditCity]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:04-12-2019  
purpos:Add edit city Master  
[dbo].[USP_AddEditCity]  
select * from MST_CITY    
EXEC [dbo].[USP_AddEditCity] 0,1,1,'',1,1
****************************************************/        
CREATE PROCEDURE [dbo].[USP_AddEditCity]          
   (   
		@iPK_CityId                  bigint, 
		@iFK_CountryId               bigint,
		@iFK_StateId                 bigint,       
		@cCityName                   nvarchar(50),    
		@bIsActive                   bit,       
		@iUserId                     bigint    
	)          
 AS          
 BEGIN TRY          
 IF(@iPK_CityId =0)  
    BEGIN          
       BEGIN      
         IF NOT EXISTS
		    (
			SELECT 1 FROM [dbo].[MST_City](NOLOCK) 
			WHERE CityName=LTRIM(RTRIM(@cCityName)) AND IsActive =1
			AND FK_CountryId = @iFK_CountryId
			AND FK_StateId = @iFK_StateId	
		    )  
       BEGIN       
            INSERT INTO [dbo].[MST_City]
			 (          
				CityName, 
				FK_CountryId,
				FK_StateId,         
				IsActive,          
				CreatedBy,          
				CreatedDatetime    
              )          
             VALUES 
			  (
				@cCityName,    
				@iFK_CountryId,
				@iFK_StateId,     
				@bIsActive,          	    
				@iUserId,         
				GETDATE()       
	           ) 
			 SELECT 1 AS Message_Id,'City Added Successfully.' As Message      
        END   
   ELSE        
        BEGIN       
             SELECT 0 AS Message_Id,'City Name Already Exists.' AS Message      
        END                
     END   
   END       
 ELSE          
       BEGIN
                 IF NOT EXISTS
				 (
					SELECT 1 FROM [dbo].[MST_City](NOLOCK) 
					WHERE CityName=LTRIM(RTRIM(@cCityName)) 
					AND FK_CountryId = @iFK_CountryId
					AND FK_StateId = @iFK_StateId	
					AND PK_CityId <> @iPK_CityId AND IsActive =1
				 )  
                
				 BEGIN
					  UPDATE  [dbo].[MST_City]     SET  
					  CityName        = @cCityName,   
					  FK_CountryId    = @iFK_CountryId,
					  FK_StateId      = @iFK_StateId,
					  IsActive        = @bIsActive,    
					  UpdatedBy       = @iUserId,   
					  UpdatedDatetime = GETDATE()
					  WHERE PK_CityId=@iPK_CityId  
					  SELECT 2 AS Message_Id,'City Details Updated Successfully.' AS Message 
				END  
				ELSE  
                BEGIN  
                    SELECT 0 AS Message_Id,'City Name Already Exists.' AS Message   
                END   
      END      
  END TRY          
  BEGIN CATCH          
      SELECT 0 AS Message_Id,'Process Failed' AS Message          
  END CATCH  



GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditCountry]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:sandeep Kumar     
CreatedDate:28-11-2019    
purpos:Add edit Category Master    
[dbo].[USP_AddEditCountry]  
SELECT * FROM MST_COUNTRY      
EXEC [dbo].[USP_AddEditCountry] 1,'japan1',0,1
****************************************************/          
CREATE PROCEDURE [dbo].[USP_AddEditCountry]            
   (         
    @iPK_CountryId               BIGINT,       
    @cCountryName                NVARCHAR(50),      
    @bIsActive                   BIT,     
    @iUserId                     BIGINT
   )            
 AS            
 BEGIN TRY            
 IF(@iPK_CountryId=0)    
    BEGIN  
         IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Country](NOLOCK) WHERE CountryName=LTRIM(RTRIM(@cCountryName)) AND IsActive =1 AND  ISNULL(IsDeleted,0)=0 )    
           BEGIN         
            INSERT INTO [dbo].[MST_Country]           
            (            
            CountryName,            
            IsActive,                 
            CreatedBy,            
            CreatedDatetime      
            )            
            VALUES            
           (       
            @cCountryName,       
            @bIsActive,                          
            @iUserId,                  
            GETDATE()         
            )            
            SELECT 1 AS Message_Id,'Country Added Successfully.' As Message        
          END     
         ELSE          
           BEGIN         
             SELECT 0 AS Message_Id,'Country Name Already Exists.' AS Message        
           END                  
       
    END         
 ELSE            
       BEGIN        
	     DECLARE @iCountryExist INT
         SET @iCountryExist = (SELECT COUNT(*) FROM [dbo].[MST_State](NOLOCK) WHERE FK_CountryId =@iPK_CountryId  AND IsActive=1 AND ISNULL(IsDeleted,0)=0)
	     IF(@iCountryExist=0)
              BEGIN           
                 IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Country](NOLOCK) WHERE  CountryName=LTRIM(RTRIM(@cCountryName)) And PK_CountryId<>@iPK_CountryId AND IsActive =1 AND ISNULL(IsDeleted,0)=0)  
				   BEGIN 
					   UPDATE  [dbo].[MST_Country]     SET   
					   CountryName       =      @cCountryName,   
					   IsActive          =      @bIsActive,      
					   UpdatedBy         =      @iUserId,          
					   UpdatedDatetime   =      GETDATE()             
					   WHERE PK_CountryId=@iPK_CountryId    
					   SELECT 2 AS Message_Id,'Country Updated Successfully.' AS Message      
                   END
				ELSE    
                    BEGIN    
                       SELECT 0 AS Message_Id,'Country Name Already Exists.' AS Message     
                    END 
              END
         ELSE
            BEGIN
		       IF(@bIsActive<>0)
		          BEGIN
		               IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Country](NOLOCK) WHERE  CountryName=LTRIM(RTRIM(@cCountryName)) And PK_CountryId<>@iPK_CountryId AND IsActive =1 AND ISNULL(IsDeleted,0)=0)  
                          BEGIN 	  
                          UPDATE  [dbo].[MST_Country]     SET   
					      CountryName       =      @cCountryName,   
					      IsActive          =      @bIsActive,      
					      UpdatedBy         =      @iUserId,          
					      UpdatedDatetime   =      GETDATE()             
					      WHERE PK_CountryId=@iPK_CountryId  
					         SELECT 2 AS Message_Id,'Country Updated successfully.' AS Message     
                          END  
	                   ELSE
		       	          BEGIN
						    SELECT 0 AS Message_Id,'Country Name Already Exists' AS Message 
				          END	
	
                  END
	           ELSE
		          BEGIN
			        SELECT 3 AS Message_Id, 'State  Exists For this Country, So You Cannot Make Country InActive' AS Message
			       END 
	        END
       END

               
  END TRY            
  BEGIN CATCH            
      SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message            
  END CATCH    




GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditForm]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---ALTER PROCEDURE---------
/******************************************                
CREATED BY:Sandeep Kumar               
CREATED DATE:11 December 2019                
PURPOSE:To Add Form Details           
select * from MST_Form             
EXEC [dbo].[usp_AddEditForm]         
****************************************************/            
CREATE PROCEDURE [dbo].[USP_AddEditForm]                  
  (             
 @iPK_FormId            BIGINT,        
 @cFormName             NVARCHAR(100),          
 @cControllerName       NVARCHAR(100),           
 @cActionName           NVARCHAR(30),          
 @iFK_ParentId          BIGINT,       
     
 --@iFK_MainId   INT,    
 --@iLevelId    INT,    
 --@iSortId    INT,    
     
        
 @iFK_SolutionId        BIGINT,          
 @cClassName            NVARCHAR(30),                
 @cArea                 NVARCHAR(30),           
 @bIsActive             BIT,                
 @iUserId               BIGINT   ,        
 @cImageName            NVARCHAR(200)  ='' ,
 @cPlatFormType         NVARCHAR(30)
   )                  
AS           
BEGIN TRY                    
        IF(IsNull(@iPK_FormId,0)=0)            
         BEGIN            
    DECLARE @isortid_ bigint          
    SET @isortid_=(SELECT MAX(ISNULL(SortId,0)) FROM dbo.MST_Form(NOLOCK) WHERE ISNULL(FK_ParentId,0) = ISNULL(@iFK_ParentId,0))+1            
    IF NOT EXISTS (SELECT 1 FROM dbo.MST_Form(NOLOCK) WHERE ISNuLL(Area,'') =ISNULL(@cArea,'') AND FormName=@cFormName  AND IsActive=1)            
                   BEGIN            
      INSERT INTO [dbo].[MST_Form]            
                     (          
      FK_SolutionId,    
      FormName,    
      ControllerName,    
      ActionName,    
      FK_ParentId,    
      FK_MainId,    
      LevelId,    
      SortId,    
      [Image],    
      IsActive,    
      CreatedBy,    
      CreatedDate,          
      ClassName,    
      Area ,
	  FormFor    
                     )                    
                     VALUES                    
                     (                   
       @iFK_SolutionId,     
      LTRIM(RTRIM( @cFormName)),                      
       @cControllerName,    
       @cActionName,                    
       @iFK_ParentId,      
       @iFK_ParentId,    
       1,    
       @isortid_,    
       @cImageName,    
       @bIsActive,                
       @iUserId,        
       GETDATE() ,        
       @cClassName,               
       @cArea ,
	   @cPlatFormType    
                       )                 
      SELECT 1 AS Message_Id,'Form Added Successfully.' As Message                
                   END            
                   ELSE            
                   BEGIN            
      SELECT 0 AS Message_Id, 'Form Name Already Exists.' As Message              
                   END             
           END                   
           ELSE             
               IF NOT EXISTS(SELECT 1 FROM dbo.MST_Form(NOLOCK) WHERE ISNuLL(Area,'') =ISNULL(@cArea,'') AND FormName=@cFormName AND IsActive=1 And PK_FormId<>@iPK_FormId)               
                 BEGIN                 
      UPDATE [dbo].[MST_Form]                     
      SET                  
      FK_SolutionId    = @iFK_SolutionId,    
   FormName     =  ltrim(rtrim( @cFormName)),     
   ControllerName   = @cControllerName,    
   ActionName    = @cActionName,    
   FK_ParentId    = @iFK_ParentId,    
   FK_MainId     = @iFK_ParentId,    
   LevelId     = 1,    
   [Image]      = @cImageName,    
   IsActive     = @bIsActive,    
   ClassName     = @cClassName,    
   Area      = @cArea   ,
   FormFor= @cPlatFormType
      WHERE PK_FormId=@iPK_FormId            
      SELECT 2 AS Message_Id,'Form Details Updated Successfully.' AS Message                    
                 END         
    ELSE        
     BEGIN        
       SELECT 0 AS Message_Id,'Form Name Already Exists.' AS Message        
     END               
END TRY                    
BEGIN CATCH                    
       SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message                    
END CATCH




GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditFormColumn]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /******************************************                  
CREATED BY:Sandeep Kumar                 
CREATED DATE:02 January 2020                  
PURPOSE:To Add Edit Form Column      
select * from MST_FormColumn               
EXEC [dbo].[usp_AddEditFormColumn] 0,1,1,'Account','Coumn Name',1          
****************************************************/       
CREATE PROCEDURE [dbo].[USP_AddEditFormColumn]                  
(                  
 @iPK_FormColumnId                   BIGINT,         
 @iFK_FormId                         BIGINT,   
 @iFK_AccountId                      BIGINT,            
 @cFormName                          NVARCHAR(50),                 
 @cColumnName                        NVARCHAR(50),               
 @iUserId                            BIT =1            
)                  
AS                  
BEGIN TRY                  
 IF(@iPK_FormColumnId =0)          
 BEGIN        
    IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_FormColumn](NOLOCK) WHERE Form_Name=LTRIM(RTRIM(@cFormName))AND Column_Name=LTRIM(RTRIM(@cColumnName)) )            
               BEGIN            
               INSERT INTO [dbo].[MST_FormColumn]                   
               (       
                FK_FormId,                
                Form_Name,  
                FK_AccountId,                  
                Column_Name,  
                CreatedDateTime,  
                CreatedBy ,
		        IsActive
		  
               )                  
               VALUES         
               (       
                @iFK_FormId,             
                @cFormName,  
                @iFK_AccountId,              
                @cColumnName ,  
                GETDATE(),  
                @iUserId ,
			    1         
                )       
                SELECT 1 AS Message_Id,'Form Column Added Successfully.' As Message                
                END          
          ELSE            
             BEGIN          
                 SELECT 0 AS Message_Id,'Same Form Column Already Exists.' AS Message                    
               END         
      END             
   ELSE                    
                 BEGIN                        
                    IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_FormColumn](NOLOCK) WHERE Form_Name=LTRIM(RTRIM(@cFormName))AND Column_Name=LTRIM(RTRIM(@cColumnName)) And PK_FormColumnId<>@iPK_FormColumnId )           
                    BEGIN            
                    UPDATE  [dbo].[MST_FormColumn] SET       
                    FK_FormId       =  @iFK_FormId,             
                    Form_Name       =  @cFormName,   
                    FK_AccountId    =  @iFK_AccountId,                    
                    Column_Name     =  @cColumnName,  
                    UpdatedDateTime =  GETDATE(),  
                    UpdatedBy       =@iUserId     
                    WHERE PK_FormColumnId=@iPK_FormColumnId           
                    SELECT 2 AS Message_Id,'Form Column Updated Successfully.' AS Message              
                    END            
                    ELSE            
                    BEGIN            
                        SELECT 0 AS Message_Id,'Same Form Column Already Exists.' AS Message             
                    END            
              END         
  END TRY                  
  BEGIN CATCH                  
      SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                  
  END CATCH 






GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditMapFormLanguage]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                
CreatedBy:sandeep Kumar               
CreatedDate:28-11-2019              
purpos:Get Category Master Details              
ModifiedBy: Vinish            
ModifiedDate: 2019-12-11 15:41:55.200            
purpos: Some fields are missing to mapping at the time of CURD            
[dbo].[USP_GetCategoryDetails]                 
SELECT * FROM [dbo].[MST_Category]               
EXEC [dbo].[USP_AddEditMapFormLanguage] 0,1,'english1','employeeDetails',1,1,1              
select * from Map_FormLanguage              
****************************************************/                
CREATE PROCEDURE [dbo].[USP_AddEditMapFormLanguage]              
(             
@iPK_FormLanguageId     bigint,              
@iFK_FormId             bigint,              
@cTranslatedFormName          nvarchar(100),              
@iFK_LanguageId                      bigint,              
@bIsActive              bit,                      
@iUserId                bigint ,           
@iFK_AccountID bigint    ,        
@iFK_CustomerID bigint            
)              
AS                          
 BEGIN TRY                          
 IF(@iPK_FormLanguageId=0)                  
 BEGIN                               
  IF NOT EXISTS(SELECT 1 FROM [dbo].[Map_FormLanguage](NOLOCK) WHERE FK_FormId=@iFK_FormId AND FK_LanguageId = @IFK_LanguageId AND IsActive =1            
     AND CreatedBy = @iUserId-- and FK_CompanyID  = @iFK_CompanyID            
     )                  
     BEGIN                                                         
     INSERT INTO [dbo].[Map_FormLanguage]                         
     (               
     FK_FormId,              
     TranslatedFormName,              
     FK_LanguageId,              
     IsActive,                       
     CreatedBy,              
     CreatedDateTime            
     ,FK_AccountID               
	 ,FK_CustomerID               
     )                          
     VALUES                          
     (                
     @iFK_FormId,              
     rtrim(ltrim(@cTranslatedFormName)),              
     @iFK_LanguageId,              
     @bIsActive,              
     @iUserId,              
     GETDATE()              
     ,@iFK_AccountID               
	 ,@iFK_CustomerID
     )              
     SELECT 1 AS Message_Id,'Form Language Mapping Inserted Successfully.' As Message                      
     END                   
     ELSE                        
     BEGIN                       
     SELECT 3 AS Message_Id,'This Form Language Mapping Already Exists.' AS Message                       
     END                              
 END              
 ELSE  --Update Start                    
 BEGIN                              
  IF not EXISTS(SELECT 1 FROM [dbo].[Map_FormLanguage](NOLOCK) WHERE  FK_FormId=@iFK_FormId And FK_LanguageId = @IFK_LanguageId and PK_FormLanguageId<>@iPK_FormLanguageId AND IsActive =1 
  and CreatedBy = @iUserId
     )                  
     begin            
      UPDATE  [dbo].[Map_FormLanguage]     SET                 
      FK_FormId         = @iFK_FormId,              
      TranslatedFormName      = rtrim(ltrim(@cTranslatedFormName)),              
      FK_LanguageId          = @iFK_LanguageId,              
      IsActive          = @bIsActive,                          
      UpdatedBy         = @iUserId,                        
      UpdatedDatetime   = GETDATE()  
	  ,FK_AccountID = @iFK_AccountID               
	 ,FK_CustomerID = @iFK_CustomerID                        
      WHERE PK_FormLanguageId=@iPK_FormLanguageId                  
      SELECT 2 AS Message_Id,'Form Language Mapping Updated Successfully.' AS Message                    
     END                  
     ELSE                  
     BEGIN                  
   SELECT 3 AS Message_Id,'This Form Language Mapping Already Exists.' AS Message       
     END         
 end --Update End                    
  END TRY                          
  BEGIN CATCH                          
      SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                          
  END CATCH 






GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditRole]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************        
CREATED BY:Sandeep Kr.       
CREATED DATE:4 December 2019        
PURPOSE:To AddEditAlertDetails   
select * from mst_role(nolock)      
EXEC [dbo].[USP_AddEditRole] 30,'ttttt',3,1,1,1,1,1
****************************************************/  
CREATE PROCEDURE [dbo].[USP_AddEditRole]        
   (     
    @iPK_RoleId	                  BIGINT,	  
    @cRoleName	                  NVARCHAR(30),  
    @iFK_CategoryId               BIGINT,
	@iFK_AccountId	              BIGINT,
	@iHomePage                    BIGINT,
	@bIsActive                    BIT, 
    @iUserId	                  BIGINT ,
	@iFK_CustomerId				  BIGINT = 0 
   )        
AS        
BEGIN TRY        
 IF(@iPK_RoleId	=0)
                 BEGIN    
                      IF NOT  EXISTS(SELECT 1 FROM [dbo].[MST_Role](NOLOCK) 
										WHERE RoleName=LTRIM(RTRIM(@cRoleName))  
										AND  FK_CustomerId=@iFK_CustomerId	 
										AND FK_AccountId=@iFK_AccountId 
										AND ISNULL(IsActive,0)=1
									)
			                    BEGIN     
							          INSERT INTO [dbo].[MST_Role]       
								     (        
									  RoleName,	     
									  FK_CategoryId,  
									  FK_AccountId,	 
									  HomePage,       
									  IsActive,        
									  CreatedBy,	      
									  CreatedDatetime,
									  FK_CustomerId
								      )        
							         VALUES        
								     (   
									  LTRIM(RTRIM(@cRoleName)),	            
									  @iFK_CategoryId,         
									  @iFK_AccountId,	          
									  @iHomePage,              
									  @bIsActive,              
									  @iUserId,	           
									  GETDATE()	,
									  @iFK_CustomerId
								      )        
						
					                 SELECT 1 AS Message_Id,'Role Added Successfully.' As Message    
					              END        
		              ELSE      
			          BEGIN     
			            	SELECT 0 AS Message_Id,'Role Already Exists.' AS Message    
			          END              
                 END 	   
    
   ELSE        
  	   BEGIN 				       
			IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Role](NOLOCK) 
										WHERE RoleName=LTRIM(RTRIM(@cRoleName))  
										AND  FK_CustomerId=@iFK_CustomerId	 
										AND FK_AccountId=@iFK_AccountId 
										AND ISNULL(IsActive,0)=1
										AND PK_RoleId<>@iPK_RoleId
						  )
				 BEGIN
				 UPDATE  [dbo].[MST_Role]     SET 
				 RoleName	            =  LTRIM(RTRIM(@cRoleName)),	                
				 FK_CategoryId          =  @iFK_CategoryId,           
				 FK_AccountId	        =  @iFK_AccountId,	           
				 HomePage               =  @iHomePage,             
				 IsActive               =  @bIsActive,                   
		         UpdatedBy   	        =  @iUserId,	     
				 UpdatedDatetime 		=  GETDATE(),
				 FK_CustomerId			=  @iFK_CustomerId	
				 WHERE PK_RoleId=@iPK_RoleId
			     SELECT 2 AS Message_Id,'Role Updated Successfully.' AS Message 	
				 END
		  ELSE
		  BEGIN
		      SELECT 0 AS Message_Id,'Role Already Exists.' AS Message 
		  END 
	  END
END TRY        
BEGIN CATCH        
		  SELECT 0 AS Message_Id, ERROR_MESSAGE()  AS Message        
END CATCH






GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditState]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditState]    Script Date: 11-12-2019 15:56:34 ******/

/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:28-11-2019  
purpose:Add edit State Master  
[dbo].[USP_AddEditState] 
select * from MST_State     
EXEC [dbo].[USP_AddEditState] 1,1,1,'UP',1,1,1
****************************************************/        
CREATE PROCEDURE [dbo].[USP_AddEditState]          
   (   
    @iPK_StateId                 BIGINT,   
	@iFK_CountryId               BIGINT,       
    @cStateName                  NVARCHAR(50),    
    @bIsActive                   BIT,      
    @iUserId                     BIGINT    
	)          
 AS          
 BEGIN TRY          
 IF(@iPK_StateId=0)  
    BEGIN    
         IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_State](NOLOCK) WHERE StateName=LTRIM(RTRIM(@cStateName)) AND FK_CountryId = @iFK_CountryId AND IsActive =1 AND  ISNULL(IsDeleted,0)=0 )  
            BEGIN       
            INSERT INTO [dbo].[MST_State]
			(          
				StateName, 
				FK_CountryId,         
				IsActive,          
				CreatedBy,          
				CreatedDatetime    
            )          
            VALUES 
			(
				@cStateName,    
				@iFK_CountryId,     
				@bIsActive,          
				@iUserId,         
				GETDATE()       
	        ) 
			 SELECT 1 AS Message_Id,'State Added Successfully.' As Message      
          END   
         ELSE        
            BEGIN       
              SELECT 0 AS Message_Id,'State Name Already Exists In Selected Country.' AS Message      
            END                
        
     END       
 ELSE    
     BEGIN        
	      DECLARE @iStateExist INT
          SET @iStateExist = (SELECT COUNT(*) FROM [dbo].[MST_City](NOLOCK) WHERE FK_StateId =@iPK_StateId  AND IsActive=1 AND ISNULL(IsDeleted,0)=0)
	      IF(@iStateExist=0)
             BEGIN              
                  IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_State](NOLOCK) WHERE  StateName=LTRIM(RTRIM(@cStateName)) And PK_StateId<>@iPK_StateId AND  FK_CountryId = @iFK_CountryId AND IsActive =1 AND ISNULL(IsDeleted,0)=0)  
                    BEGIN  
				        UPDATE  [dbo].[MST_State] SET  
				        StateName       = @cStateName,   
				        FK_CountryId    = @iFK_CountryId,
				        IsActive        = @bIsActive,    
				        UpdatedBy       = @iUserId,   
				        UpdatedDatetime = GETDATE()
				        WHERE PK_StateId= @iPK_StateId  
                        SELECT 2 AS Message_Id,'State Details Updated Successfully.' AS Message    
                    END  
                  ELSE  
                     BEGIN  
                        SELECT 0 AS Message_Id,'State Name Already Exists In Selected Country.' AS Message    
                      END   
             END  
	   
	      ELSE
            BEGIN
		       IF(@bIsActive<>0)
		          BEGIN
		               IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_State](NOLOCK) WHERE  StateName=LTRIM(RTRIM(@cStateName)) And PK_StateId<>@iPK_StateId AND  FK_CountryId = @iFK_CountryId AND IsActive =1 AND ISNULL(IsDeleted,0)=0)  
                          BEGIN 	  
                             UPDATE  [dbo].[MST_State] SET  
				             StateName       = @cStateName,   
				             FK_CountryId    = @iFK_CountryId,
				             IsActive        = @bIsActive,    
				             UpdatedBy       = @iUserId,   
				             UpdatedDatetime = GETDATE()
				             WHERE PK_StateId= @iPK_StateId  
                             SELECT 2 AS Message_Id,'State Details Updated Successfully.' AS Message       
                          END  
	                  ELSE
		       	          BEGIN
                              SELECT 0 AS Message_Id,'State Name Already Exists In Selected Country.' AS Message    
				          END	
	
                  END
	           ELSE
		          BEGIN
			          SELECT 3 AS Message_Id, 'City Exists For this State, So You Cannot Make State InActive' AS Message
			      END 
	        END
  
		  
	 END 
  END TRY          
  BEGIN CATCH          
      SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message          
  END CATCH  




GO
/****** Object:  StoredProcedure [dbo].[USP_AddEditUser]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                
CreatedBy:sandeep Kumar               
CreatedDate:28-11-2019              
purpos:Add edit User Master              
[dbo].[USP_AddEditUser]            
select * from [dbo].[MST_User]                
EXEC [dbo].[USP_AddEditUser]  42,'SHYAM_CUST41','email',1,1,1,1,'sintde@123','9852147197','stsie7d@1231',          
'ssi7id@129731','sestid@1231','M','2018-01-23','NDLS','3456',1,1,1,1,1,'abhishek'             
****************************************************/                    
CREATE PROCEDURE [dbo].[USP_AddEditUser]                      
(                   
    @iPK_UserId            BIGINT,                 
    @cUserName             NVARCHAR(30),           
     @cShareBy              NVARCHAR(250),           
    @iFK_CategoryId        BIGINT,                   
    @iFK_RoleId            BIGINT,                   
    @iFK_CustomerId         BIGINT,                   
    @iFK_AccountId         BIGINT,                 
    @cUserPassword         NVARCHAR(30),                    
    @cMobileNo             NVARCHAR(20),                    
    @iAlternateMobileNo    NVARCHAR (20),                   
    @cEmailId              NVARCHAR (30),                   
    @cAlternateEmailId     NVARCHAR (30),                   
    @bGender               NVARCHAR(10),                    
    @cDateOfBirth          nvarchar(50),                   
    @cUserAddress          NVARCHAR(100),                    
    @iZipCode              NVARCHAR(30),                    
    @iFK_CountryId         BIGINT,                   
    @iFK_StateId           BIGINT,                   
    @iFK_CityId            BIGINT,                   
    @bIsActive             BIT,             
    @iUserId               BIGINT   ,          
    @cFullName             NVARCHAR(250),    
 @bIsVehicleSpecific    BIT,      --Added By Meenakshi Jha (20-Feb-2020)    
 @cUnEncryptedPassword  NVARCHAR(500) --USED TO SHARE PASSWORD VIA EMAIL, FOR THAT UNECRYPTED PASSWORD IS NEEDED. :: BY TARIQ : 28th FEB 20    
           
)                      
AS                      
BEGIN TRY                      
  IF(@iPK_UserId=0)              
              
     BEGIN                  
           IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_User](NOLOCK) WHERE UserName=LTRIM(RTRIM(@cUserName)) AND IsActive =1)                      
            -- BEGIN                  
              -- IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_User](NOLOCK) WHERE MobileNo=LTRIM(RTRIM(@cMobileNo)) AND IsActive =1 )              
                 --BEGIN              
                 --   IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_User](NOLOCK) WHERE EmailId=@cEmailId  AND IsActive=1 )                      
                       BEGIN              
                       INSERT INTO [dbo].[MST_User]                     
                       (                
                        UserName,           
                        FullName,            
                        ShareBy,                       
                        FK_CategoryId,                  
                        FK_RoleId,                       
                        FK_CustomerId,                     
                        FK_AccountId,                  
                        UserPassword,                      
                        MobileNo,                      
                        AlternateMobileNo,              
                        EmailId,                      
                        AlternateEmailId,               
                        Gender,                      
                        DateOfBirth,                  
                        UserAddress,                        
                        ZipCode,                      
                        FK_CountryId,                  
                        FK_StateId,                  
                        FK_CityId,                      
                        IsActive,            
                        CreatedBy,             
                 CreatedDateTime,    
      IsVehicleSpecific            
                       )                      
                       VALUES                  
                       (                    
                        @cUserName,           
                        @cFullName,        
                        @cShareBy ,                    
                        @iFK_CategoryId,                  
                        @iFK_RoleId,                       
                        @iFK_CustomerId,                  
                        @iFK_AccountId,                 
                        @cUserPassword,                      
                        @cMobileNo,                      
                        @iAlternateMobileNo,            
                        @cEmailId,                      
                        @cAlternateEmailId,               
                        @bGender,          
                        @cDateOfBirth,       
       --CONVERT(VARCHAR(10),@cDateOfBirth,127),                 
                        --CONVERT(VARCHAR(10),@cDateOfBirth,103),                  
                        @cUserAddress,                        
                        @iZipCode,                      
                        @iFK_CountryId,                  
                        @iFK_StateId,                  
                        @iFK_CityId,                      
                        @bIsActive,                         
                        @iUserId,          
                        GETDATE(),    
      @bIsVehicleSpecific          
                        )                      
                       SELECT 1 AS Message_Id,'User Created Successfully.' As Message                  
                       END                   
                --   ELSE              
                --   BEGIN            
                --        SELECT 0 AS Message_Id,'Same User EmailId Already Exists.' AS Message                      
                --   END               
                --END              
            --ELSE                    
            --BEGIN                   
              --   SELECT 0 AS Message_Id,'Mobile No. Already Exists.' AS Message                  
            --END           
      -- END            
 ELSE              
    BEGIN            
        SELECT 0 AS Message_Id,'Same User Name already Exists For The Company.' AS Message                      
    END              
 END                          
                        
 ELSE                      
           
       --BEGIN                          
             --  IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_User](NOLOCK) WHERE  UserName=LTRIM(RTRIM(@cUserName)) And PK_UserId<>@iPK_UserId  AND IsActive =1)                  
                 --BEGIN                          
                 --  IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_User](NOLOCK) WHERE MobileNo=LTRIM(RTRIM(@cMobileNo)) And PK_UserId<>@iPK_UserId  AND IsActive =1)              
                 --     BEGIN              
                 --       IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_User](NOLOCK) WHERE EmailId=@cEmailId  And PK_UserId<>@iPK_UserId AND IsActive=1)                      
                          BEGIN              
                          UPDATE  [dbo].[MST_User] SET               
                          UserName           =    @cUserName,            
                          FullName    =    @cFullName,            
                          ShareBy    =   @cShareBy ,                         
                          FK_CategoryId      =    @iFK_CategoryId,               
                          FK_RoleId          =    @iFK_RoleId,                   
                          FK_CustomerId       =    @iFK_CustomerId,                  
                          FK_AccountId       =    @iFK_AccountId,                  
                          UserPassword       =    @cUserPassword,                      
                          MobileNo           =    @cMobileNo,                      
                       AlternateMobileNo  =    @iAlternateMobileNo,              
                          EmailId            =    @cEmailId,                      
                          AlternateEmailId   =    @cAlternateEmailId,               
                          Gender             =    @bGender,                      
                          DateOfBirth        =    @cDateOfBirth,                  
 UserAddress        =    @cUserAddress,                      
                          ZipCode            =    @iZipCode,                      
                          FK_CountryId       =    @iFK_CountryId,                  
                          FK_StateId         =    @iFK_StateId,                  
                          FK_CityId          =    @iFK_CityId,                    
                          IsActive           =    @bIsActive,             
                          UpdatedBy          =    @iUserId,                  
                          UpdatedDatetime    =    GETDATE(),    
        IsVehicleSpecific  =    @bIsVehicleSpecific                           
                          WHERE PK_UserId=@iPK_UserId              
                          SELECT 2 AS Message_Id,'User Updated Successfully.' AS Message          
                          END           
       --              ELSE              
       --                   BEGIN              
       --                        SELECT 0 AS Message_Id,'Same User EmailId Already Exists.' AS Message               
       --                   END              
       --       END              
       --   ELSE              
       --       BEGIN              
       --             SELECT 0 AS Message_Id,'Mobile No. Already Exists.' AS Message               
       --       END              
                                
       --END             
             
   --ELSE              
   --BEGIN              
   --     SELECT 0 AS Message_Id,'User Name Already Exists.' AS Message               
   --END              
                
--END                       
          
END TRY                      
BEGIN CATCH                      
    SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                      
END CATCH    



GO
/****** Object:  StoredProcedure [dbo].[USP_AddFormRoleMapping]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************
CREATED BY-sandeep kumar
Date-02-Dec-2019
EXEC  [dbo].[USP_AddFormRoleMapping]   3,3,3,1,1,1
******************************************/
CREATE PROCEDURE [dbo].[USP_AddFormRoleMapping]  
(
	@iRoleId		BIGINT,
	@iFormId		BIGINT,  
	@iFK_CategoryId BIGINT,
	@IsActive		BIT,
	@iCompanyId		BIGINT,
	@iUserId		BIGINT
)    
AS    
BEGIN TRY
	IF NOT EXISTS(SELECT 1 FROM MAP_FormRole (NOLOCK) frmrole WHERE frmrole.FK_FormId=@iFormId AND frmrole.FK_RoleId=@iRoleId AND frmrole.IsActive=1)
	BEGIN     
		IF(@iRoleId=0)
		BEGIN
			IF OBJECT_ID('tempdb..#tmpformrole') IS NOT NULL

			DROP TABLE #tmpformrole
			
			CREATE TABLE #tmpformrole
			(
				FK_RoleId INT
			) 
			  
			INSERT INTO #tmpformrole
			(
				FK_RoleId
			)

			SELECT			 
			PK_RoleId 
			FROM MST_Role(NOLOCK) roletb
			WHERE 
			roletb.FK_CategoryId IN (SELECT PK_CategoryId FROM MST_Category(NOLOCK) category WHERE 
			category.PK_CategoryId=@iFK_CategoryId OR category.FK_CompanyId=@iCompanyId) 
			AND PK_RoleId  NOT IN (Select  FK_RoleId from MAP_FormRole where FK_FormId=@iFormId)
			
			INSERT INTO MAP_FormRole
			(  
				FK_FormId, 
				FK_RoleId,
				CreatedBy,  
				IsActive,
				CanAdd,
				CanDelete,
				CanEdit,
				CanView,
				IsDeleted,
				CreatedDateTime 
			)  
			SELECT 
			DISTINCT  
			@iFormId,  
			Tmp.FK_RoleId,
			@iUserId,  
			@IsActive,
			0,
			0,
			0,
			1,
			0,
			GETDATE()
			FROM #tmpformrole Tmp
													
			SELECT 1 AS Message_Id,'Form Role Mapping Successfully Done.' As Message
		END

		ELSE
		BEGIN
			INSERT INTO  MAP_FormRole  
			(  
				FK_FormId, 
				FK_RoleId,
				CreatedBy,  
				IsActive,
				CanAdd,
				CanDelete,
				CanEdit,
				CanView,
				IsDeleted,
				CreatedDateTime 
			)  
			VALUES  
			(  
				@iFormId,  
				@iRoleId,
				@iUserId,  
				@IsActive,
				0,
				0,
				0,
				1,
				0,
				GETDATE()
			)    
			SELECT 1 AS Message_Id,'Form Role Mapping Successfully Done.' As Message    
		END
	END  
	ELSE      
	BEGIN      
		SELECT 0 AS Message_Id,'Form Is Already Mapped With Selected Role.' AS Message      
	END

END TRY

BEGIN CATCH
	SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message     
END CATCH




GO
/****** Object:  StoredProcedure [dbo].[USP_AuthenticateUser]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************          
Created By: Sandeep Kr.          
Created Date: 2019-12-10          
Purpose: To Authenticate User And Fetch Its Rights  
EXEC [dbo].[usp_AuthenticateUser]   'dadmin','0o6ba1MX6fU=', ''       
*******************************************************************/          
CREATE PROCEDURE [dbo].[USP_AuthenticateUser]          
(  

@cUserName    nvarchar(100),          
 @cPassword    nvarchar(50),
 @cLanguage    nvarchar(100)=''   

 --DECLARE        
 --@cUserName    nvarchar(100) ='dadmin',          
 --@cPassword    nvarchar(50)='0o6ba1MX6fU=',
 --@cLanguage    nvarchar(100)='English'          
)          
AS          
BEGIN TRY          
          
 IF  EXISTS          
 (          
  SELECT 1           
  FROM  [dbo].[MST_User](NOLOCK)           
  WHERE           
  UserName = @cUserName AND           
  UserPassword = @cPassword          
  AND Isnull(IsActive,0) = 1 and Isnull(IsDeleted,0) = 0
 )          
 BEGIN          
  DECLARE          
  @iRoleID   BIGINT         ,
   @iUserID   BIGINT=0; 
          
  SELECT           
  @iRoleID  = FK_RoleId  ,
  @iUserID=USR.PK_UserId   
  FROM MST_User(NOLOCK) USR          
  --INNER JOIN MST_Category (NOLOCK)  CTGR ON          
  --USR.FK_CategoryId=CTGR.PK_CategoryId          
  WHERE           
  UserName = @cUserName AND           
  UserPassword = @cPassword          
  AND ISNULL(USR.IsActive,0) = 1 
  and ISNULL(USR.IsDeleted,0) = 0 
  --and ISNULL(CTGR.IsActive,0) = 1  
  AND ISNULL(USR.IsDeleted,0) = 0 
  --and ISNULL(CTGR.IsDeleted,0) = 0    
            
  SELECT 1 AS Message_Id,'Success' AS Message         
  
  /*********************************/
  UPDATE MST_User
  SET LastWebLogInDatetime=GETDATE()
  WHERE PK_UserId=ISNULL(@iUserID,0)
              
  SELECT            
  Usr.[PK_UserId]  'UserId',          
  ISNULL(Usr.UserName,'')UserName,  
  ISNULL(Usr.UserPassword,'')UserPassword,      
  ISNULL(Usr.[FullName],'') 'Name',          
  Usr.[FK_RoleId]  'RoleId',  
  Usr.EmailId ,          
  Rol.RoleName 'RoleName',            
  Usr.FK_AccountId   FK_AccountId,             
  acc.AccountName AccountName,          
  Usr.FK_CustomerId,          
  --ISNULL(cust.CustomerName,'')CustomerName,          
  Usr.FK_CategoryId FK_CategoryId,           
  --cat.CategoryName CategoryName,             
  Usr.[FK_CityId]  'CityId',          
  City.[CityName],          
  City.[FK_StateId]    'StateId' ,          
  State.[StateName],          
  Country.[PK_CountryId] 'CountryId',          
  Country.[CountryName],            
  ISNULL(acc.AccountLogo,'') logoClass,        
  'COMPANY'  AS LoginType,        
  ISNULL(acc.FK_ResellerId ,0) FK_ResellerId,          
  ISNULL(acc.FK_AffiliateId,0) FK_AffiliateId          
  FROM  [dbo].[MST_User](NOLOCK) Usr          
  INNER JOIN MST_Role(NOLOCK) Rol ON Rol.PK_RoleId=Usr.FK_RoleId          
  LEFT JOIN [dbo].[MST_City](NOLOCK) City ON Usr.FK_CityId=[PK_CityId]           
  LEFT JOIN [dbo].[MST_State](NOLOCK) State ON City.[FK_StateId]=State.[PK_StateId]          
  LEFT JOIN [dbo].[MST_Country] Country ON Country.[PK_CountryId]=state.[FK_CountryId]          
  INNER JOIN [MST_Account](NOLOCK) acc ON Rol.FK_AccountId=acc.PK_AccountId                  
  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword    
  AND ISNULL(Usr.IsActive,0) = 1 and ISNULL(Usr.IsDeleted,0) = 0
          
  EXEC [dbo].[usp_GetFormRoleMapping] @iRoleID, @cLanguage          
 END          
          
  ELSE          
   BEGIN          
    SELECT 0 AS Message_Id,'UserId & Password Did Not Match.' AS Message          
   END          
END TRY           
BEGIN CATCH           
 SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message          
          
 --INSERT INTO [dbo].[ErrorLog_App]           
 --(ErrorTime,Source,Assembly_Name,Class_Name,Method_Name,ErrorMessage,ErrorType,Remarks )          
 --VALUES           
 --(GETDATE(),'[dbo].[usp_AuthenticateUser] Stored Procedure','Authentication DAL','Account','AuthenticateUser',Error_Message(),'Exception In Stored Procedure','Error In Stored Procedure : Logged In Catch Block')          
END CATCH;






GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteAccount]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:28-11-2019  
purpos:Delete Account Master  Deatils 
[dbo].[USP_DeleteAccount]      
EXEC [dbo].[USP_DeleteAccount] 2,1
********** ******************************************/  
CREATE PROCEDURE [dbo].[USP_DeleteAccount]        
   (
	@iPK_AccountId	  bigint,
	@iUserId       bigint  
   )
  AS  
  BEGIN TRY       	
	  if(('dadmin') not in (select UserName from MST_USER WHERE FK_AccountId = @iPK_AccountId)) 
	  begin
		 if not exists (select PK_AccountId from [MST_Account] WHERE ParentAccountId = @iPK_AccountId AND ISNULL(IsActive,0) = 1 AND ISNULL(IsDeleted,0) = 0)
		begin
		 if not exists (select PK_CustomerId from [MST_Customer] WHERE FK_AccountId = @iPK_AccountId  AND ISNULL(IsActive,0) = 1 AND ISNULL(IsDeleted,0) = 0)
		begin
	     UPDATE [dbo].[MST_Account]
         SET 
	     IsActive=0, 
         IsDeleted=1,  
         DeletedBy=@iUserId,  
         DeletedDateTime=GETDATE() 
         WHERE   
         PK_AccountId=@iPK_AccountId 	
	     
	     UPDATE MST_USER 
	     SET 
	     IsActive=0,
	     IsDeleted=1,  
         DeletedBy=@iUserId,  
         DeletedDateTime=GETDATE()  WHERE FK_AccountId = @iPK_AccountId 	
	     
	     UPDATE MST_ROLE
	     SET 
	     IsActive=0,
	     IsDeleted=1,  
         DeletedBy=@iUserId,  
         DeletedDateTime=GETDATE()  WHERE FK_AccountId = @iPK_AccountId 	
		 SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
		 end--Can''t delete due to some childs customer exists
		  else
		 begin
			SELECT -1 AS Message_Id,'Can''t delete due to some childs customer exists' AS Message   
		 end
		 end--Can''t delete due to some childs exists
		 else
		 begin
			SELECT -1 AS Message_Id,'Can''t delete due to some childs exists' AS Message   
		 end
	  end
	  else
	  begin
		
      SELECT 0 AS Message_Id,'Process Faild.' AS Message   
	  end
      

	    
  
              
  END TRY  
       BEGIN CATCH  
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
       END CATCH



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteCategory]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:sandeep Kumar     
CreatedDate:28-11-2019    
purpos:Get User Master  Deatils   
[dbo].[USP_DeleteUser]        
EXEC [dbo].[USP_DeleteCategory] 2,1  
********** ******************************************/    
  
CREATE PROCEDURE [dbo].[USP_DeleteCategory]          
   (  
 @iPK_CategoryId   BIGINT,  
 @iUserId          BIGINT    
   )  
  AS    
  BEGIN TRY     
   IF NOT EXISTS(SELECT 1 FROM [dbo].[MST_Account](NOLOCK) WHERE FK_CategoryId=@iPK_CategoryId AND Isnull(IsDeleted,0) =0  and IsActive=1)   
      BEGIN         
      UPDATE [dbo].[MST_Category]  
      SET    
   IsActive=0,  
      IsDeleted=1,    
      DeletedBy=@iUserId,    
      DeletedDateTime=GETDATE()   
      WHERE     
      PK_CategoryId=@iPK_CategoryId     
    
      SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
   END    
       ELSE                
      BEGIN               
         SELECT 2 AS Message_Id,' Category Id Already Mapped With Account .' AS Message              
      END                        
                  
  END TRY    
       BEGIN CATCH    
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message    
       END CATCH    
    



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteCity]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:04-12-2019  
purpos:Delete  City
[dbo].[USP_DeleteCity]      
EXEC [dbo].[USP_DeleteCity] 1,1
********** ******************************************/  

CREATE PROCEDURE [dbo].[USP_DeleteCity]        
   (
	@iPK_CityId	      bigint,
	@iUserId          bigint  
   )
  AS  
  BEGIN TRY             
      UPDATE [dbo].[MST_City]
      SET 
	  IsActive=0, 
      IsDeleted=1,  
      DeletedBy=@iUserId,  
      DeletedDateTime=GETDATE() 
      WHERE   
      PK_CityId=@iPK_CityId	  
  
      SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
              
  END TRY  
       BEGIN CATCH  
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
       END CATCH  
  



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteCountry]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteCountry]    Script Date: 12/23/2019 6:08:25 PM ******/

/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:04-12-2019  
purpos:Delete  Country
[dbo].[USP_DeleteCountry]      
EXEC [dbo].[USP_DeleteCountry] 3
********** ******************************************/  

CREATE PROCEDURE [dbo].[USP_DeleteCountry]        
   (
	@iPK_CountryId	  BIGINT,
	@iUserId          BIGINT  
   )
  AS  
  BEGIN TRY 
  
      DECLARE @iCountryExist INT
	  SET @iCountryExist = (SELECT COUNT(*) FROM [dbo].[MST_State](NOLOCK) WHERE FK_CountryId =@iPK_CountryId) 
	  IF(ISNULL(@iCountryExist,0)=0) 
	    BEGIN            
             UPDATE [dbo].[MST_Country]
             SET 
			   IsActive=0, 
               IsDeleted=1,  
               DeletedBy=@iUserId,  
               DeletedDateTime=GETDATE() 
               WHERE   
               PK_CountryId=@iPK_CountryId	  
               SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message 
	    END
       ELSE
	     BEGIN
		  SELECT 0 AS Message_Id,'You Cannot Delete Country As it Exists in state master.' AS Message 

		 END
	 	    
              
  END TRY  
       BEGIN CATCH  
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
       END CATCH  
  




GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteForm]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:12-12-2019  
purpos:Get Delete Form
[dbo].[USP_DeleteForm]      
EXEC [dbo].[USP_DeleteForm] 2,1
********** ******************************************/  
CREATE Procedure [dbo].[USP_DeleteForm] 
  (
	@iPK_FormId	  BIGINT,
	@iUserId      BIGINT  
   )
    AS  
BEGIN TRY             
      UPDATE [dbo].[MST_Form]
      SET 
	  IsActive=0, 
      IsDeleted=1,  
      DeletedBy=@iUserId,  
      DeletedDateTime=GETDATE() 
      WHERE   
      PK_FormId=@iPK_FormId 
      SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
END TRY  
BEGIN CATCH  
      SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
END CATCH  
  
      





GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteFormAccountMapping]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************          
Created By: Sandeep Kumar    
Created Date:20-12-2019         
Purpose: Delete Form Account Mapping        
EXEC [dbo].[usp_DeleteFormAccountMapping] 1        
*******************************************************************/      
    
CREATE PROCEDURE [dbo].[usp_DeleteFormAccountMapping]      
(      
--declare    
 @iPK_FormAccountId BIGINT ,  
 @iUserId BIGINT  
)      
AS      
BEGIN TRY      
 UPDATE Map_FormAccount    
 SET
 IsActive=0,
 IsDeleted=1,
 DeletedBy=@iUserId,
 DeletedDateTime=GETDATE() 
 WHERE PK_FormAccountId=@iPK_FormAccountId    
SELECT 1 AS Message_Id, 'Form Account Mapping Deleted Successfully.' AS Message     
    
END TRY      
      
BEGIN CATCH      
 SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message      
END CATCH      
      
      
        
    
         
        
    
    
    
    
    
    
    
    
    
    
    



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteFormColumn]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:04-12-2019  
purpos:Delete  form column
[dbo].[USP_DeleteSim]   
select * from [dbo].[MST_FormColumn]   
EXEC [dbo].[USP_DeleteFormColumn] 1,1
********** ******************************************/  

CREATE PROCEDURE [dbo].[USP_DeleteFormColumn]       
   (
	@iPK_FormColumnId	      BIGINT,
	@iUserId                  BIGINT  
   )
  AS  
  BEGIN TRY             
           UPDATE [dbo].[MST_FormColumn]
           SET  
		   IsActive=0,
           IsDeleted=1,  
           DeletedBy=@iUserId ,
           DeletedDateTime=GETDATE() 
           WHERE   
           PK_FormColumnId=@iPK_FormColumnId 
           SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message      
  END TRY  
  BEGIN CATCH  
        SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
  END CATCH  
  



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteMapFormLanguage]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************    
CreatedBy:Vinish
CreatedDate:2019-12-12 12:24:01.227
purpos: Delete 
[dbo].[USP_DeleteUser]      
EXEC [dbo].[USP_DeleteCategory] 2,1
********** ******************************************/  

CREATE PROCEDURE [dbo].[USP_DeleteMapFormLanguage]
   (
	@iPK_FormLanguageId	  bigint,
	@iUserId       bigint  
	--,@iFK_CompanyID bigint 
   )
  AS  
  BEGIN TRY  
	  
      UPDATE [dbo].[Map_FormLanguage]
      SET  
      --IsActive=0,  sandeep
      IsDeleted=1,  
      DeletedBy=@iUserId,  
      DeletedDateTime=GETDATE() 
      WHERE   
      PK_FormLanguageId=@iPK_FormLanguageId
  
      SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
	          
  END TRY  
       BEGIN CATCH  
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
       END CATCH  
  



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteRoleName]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:28-11-2019  
purpos:Delete RoleName Master  Deatils
select * from mst_role 
[dbo].[USP_DeleteRoleName]      
EXEC [dbo].[USP_DeleteRoleName] 3,1
********** ******************************************/  
CREATE PROCEDURE [dbo].[USP_DeleteRoleName]        
   (
	@iPK_RoleId  	  BIGINT,
	@iUserId          BIGINT  
   )
  AS  
  BEGIN TRY 
           IF NOT EXISTS(SELECT 1 FROM Mst_Role (NOLOCK) Rol WHERE Rol.RoleName='Admin'  and  PK_RoleId=@iPK_RoleId)
	       BEGIN      
           UPDATE [dbo].[MST_Role]
           SET
		   IsActive=0,
		   IsDeleted=1,  
           DeletedBy=@iUserId,  
           DeletedDateTime=GETDATE() 
           WHERE   
           PK_RoleId=@iPK_RoleId	 	  
           SELECT 1 AS Message_Id,'Role Deleted Successfully.' AS Message
	       END  
	       ELSE      
           BEGIN    
           SELECT 2 AS Message_Id,'You Are Not Authorized  To Delete Admin  Role.' AS Message              
           END     
  END TRY  
       BEGIN CATCH  
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
       END CATCH  
  




GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteState]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:04-12-2019  
purpos:Delete  State
[dbo].[USP_DeleteState]      
EXEC [dbo].[USP_DeleteState] 2,1
********** ******************************************/  

CREATE PROCEDURE [dbo].[USP_DeleteState]        
   (
	@iPK_StateId	  bigint,
	@iUserId          bigint  
   )
  AS  
  BEGIN TRY
      DECLARE @iStateExist INT
	  SET @iStateExist = (SELECT COUNT(*) FROM [dbo].[MST_City](NOLOCK) WHERE FK_StateId =@iPK_StateId) 
	  IF(ISNULL(@iStateExist,0)=0) 
	    BEGIN             
           UPDATE [dbo].[MST_State]
           SET 
		   IsActive=0, 
           IsDeleted=1,  
           DeletedBy=@iUserId,  
           DeletedDateTime=GETDATE() 
           WHERE   
           PK_StateId=@iPK_StateId	
           SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message
	    END
      ELSE
	     BEGIN
		     SELECT 0 AS Message_Id,'You Cannot Delete State As it Exists in City master.' AS Message 
		 END   
              
  END TRY  
       BEGIN CATCH  
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
       END CATCH  
  



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteUser]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:28-11-2019  
purpos:Get User Master  Deatils 
[dbo].[USP_DeleteUser] 
SELECT * FROM MST_User     
EXEC [dbo].[USP_DeleteUser] 3,1100
********** ******************************************/  
CREATE PROCEDURE [dbo].[USP_DeleteUser]        
   (
	@iPK_UserId bigint,
	@iUserId    bigint  
   )
  AS  
  BEGIN TRY             
	if(('dadmin') not in (select UserName from MST_USER WHERE PK_UserId = @iPK_UserId)) 
	  begin

      UPDATE [dbo].[MST_User]
      SET 
	  IsActive=0, 
      IsDeleted=1,  
      DeletedBy=@iUserId,  
      DeletedDateTime=GETDATE() 
      WHERE   
      PK_UserId=@iPK_UserId  
	    SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
	end
	else
	begin
	 SELECT 0 AS Message_Id,'Process Faild.' AS Message   
	end
    
              
  END TRY  
       BEGIN CATCH  
             SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
       END CATCH




GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteUserAccountMapping]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************          
Created By: Prince kumar srivastva      
Created Date:12-12-2019         
Purpose: Deleted User Account Mapping        
EXEC [dbo].[usp_DeleteUserAccountMapping] 1        
*******************************************************************/      
    
CREATE PROCEDURE [dbo].[usp_DeleteUserAccountMapping]      
(      
--declare    
 @iPK_UserAccountId BIGINT ,  
 @iUserId BIGINT  
)      
AS      
BEGIN TRY      
 UPDATE MAP_UserAccount    
 SET
 
 IsActive=0,
 IsDeleted=1,
 DeletedBy=@iUserId,
 DeletedDateTime=GETDATE()
 WHERE PK_UserAccountId=@iPK_UserAccountId    
    
SELECT 1 AS Message_Id, 'User Account Mapping Deleted Successfully.' AS Message     
    
END TRY      
      
BEGIN CATCH      
 SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message      
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteVehicleBrand]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************        
CreatedBy:sandeep Kumar       
CreatedDate:17-12-2019      
purpos:Delete Vehicle Brand    
EXEC [dbo].[USP_DeleteVehicleBrand]    
********** ******************************************/      
CREATE PROCEDURE [dbo].[USP_DeleteVehicleBrand]            
   (    
 @iPK_VehicleBrandId bigint,    
 @iUserId        bigint      
   )    
  AS   
  BEGIN TRY  
  IF NOT EXISTS (SELECT * FROM Mst_Vehicle fmv
  INNER JOIN MAP_VehicleDevice fmpv on fmpv.FK_VehicleId  =    fmv.PK_VehicleId
  WHERE FK_VehicleBrandId = @iPK_VehicleBrandId
  AND ISNULL(fmpv.IsDeleted,0) = 0 
  AND ISNULL(fmpv.IsActive,0) =1
  )     
      BEGIN          
      UPDATE [dbo].[MST_VehicleBrand]    
      SET      
      IsActive=0,    
      IsDeleted=1,      
      DeletedBy=@iUserId,      
      DeletedDateTime=GETDATE()     
      WHERE       
      PK_VehicleBrandId=@iPK_VehicleBrandId   
   END     
  ELSE          
    BEGIN          
         SELECT 0 AS Message_Id,'Vehicle cannot be deleted as it is mapped with device.' AS Message           
    END      
      SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message       
  END TRY      
      BEGIN CATCH      
            SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message      
      END CATCH      



GO
/****** Object:  StoredProcedure [dbo].[USP_Get_ServiceErrorLog]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
Created By: Deepak Singh
Created Date: 2019-12-17
Purpose: Get Error log
*******************************************************************/
CREATE PROCEDURE [dbo].[USP_Get_ServiceErrorLog]
   (
	@FromDatetime datetime,
	@ToDatetime Datetime,
	@cErrorLogType varchar(50)
   )
AS
	BEGIN
		 IF(@cErrorLogType='ApplicationErrorLog')
			BEGIN
			     SELECT 1 AS Message_Id,'Successfully' AS Message
				 SELECT ErrorLogId,Assembly_Name,Class_Name,ErrorMessage,ErrorTime,ErrorType,Method_Name,
				 Remarks,Source from [dbo].[ErrorLog_App] where ErrorTime between @FromDatetime and @ToDatetime
			END
		ELSE
			IF(@cErrorLogType='ServiceErrorLog')
				 BEGIN
				 SELECT 1 AS Message_Id,'Successfully' AS Message
				 SELECT ErrorLogId,Assembly_Name,Class_Name,ErrorMessage,ErrorTime,'' as ErrorType,Method_Name,
				 Remarks,Source 
			     from [dbo].[ErrorLog_Service]
				 
				 where ErrorTime between @FromDatetime and @ToDatetime
				 END

		
	END





GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                  
CreatedBy:sandeep Kumar                 
CreatedDate:3-12-2019                
purpos:Get Account Details                
                
EXEC [dbo].[USP_GetAccountDetails]                 
0,10,1,'',''                
    select * from mst_account(nolock)            
EXEC [dbo].[USP_GetAccountDetails]                 
0,10,1,'CategoryName','Reseller'                
                
EXEC [dbo].[USP_GetAccountDetails] 10029,54,10,1,'','',15,0,1,'COMPANY'               
****************************************************/                  
CREATE PROCEDURE [dbo].[USP_GetAccountDetails]                
(    
          
 @iPK_AccountId               BIGINT,                     
 @iPK_UserId                  BIGINT,                
 @iRowperPage                 BIGINT,                
 @iCurrentPage                BIGINT,                
 @cSearchBy                   NVARCHAR(50)='',                
 @cSearchValue                NVARCHAR(50)='',
 @iFK_AccountId     BIGINT = 0,
 @iFK_CustomerId   BIGINT = 0,
 @iUserId           BIGINT = 0,
 @cLoginType          nvarchar(100) = ''               
)                
AS                
BEGIN TRY                
 SELECT 1 AS Message_Id, 'SUCCESS' AS Message                 
      SELECT        
  

      ISNULL(fma.PK_AccountId, 0) PK_AccountId,                
      ISNULL(fma.AccountName,'')AccountName,                  
      CASE                 
      WHEN fma.FK_ResellerId IS NULL AND fma.FK_AffiliateId IS NULL THEN 'COMPANY'                
      WHEN fma.FK_ResellerId IS NOT NULL THEN 'RESELLER'                
      WHEN fma.FK_AffiliateId IS NOT NULL THEN 'AFFILIATE'                 
      ELSE 'NA' END AS AccountType,                
      ISNULL(msa.CategoryName,'')CategoryName,                        
      ISNULL(fma.AccountAddress,'')   AccountAddress,                    
      ISNULL(fma.ZipCode,''  )ZipCode,                            
      ISNULL(cntry.CountryName, '' )CountryName,                    
      ISNULL(st.StateName, '' ) StateName,                        
      ISNULL(ct.CityName,  '')CityName,                          
      ISNULL(fma.BillingAddress,'')BillingAddress,                       
      ISNULL(fma.ContactPerson, '')ContactPerson,                       
      ISNULL(fma.MobileNo, '')MobileNo,                            
      ISNULL(fma.AlternateMobileNo,  '')AlternateMobileNo,                  
      ISNULL(fma.EmailId,'') EmailId ,                            
      ISNULL(fma.AlternateEmailId, '')AlternateEmailId,                    
      ISNULL(fma.AccountRegistrationNo,'')AccountRegistrationNo,                
      ISNULL(fma.AccountLogo, '')AccountLogo,                         
      ISNULL(fma.IsActive,0) IsActive,               
      --By Vinish                
      ISNULL(p_fma.AccountName,'') ParentAccountName,                
      ISNULL(us.UserPassword,'')[Password],                              
      ISNULL(p_fma.FK_CategoryId,'') Parent_FK_CategoryId,                
      ISNULL(fma.FK_CategoryId,'') FK_CategoryId,                
      ISNULL(fma.FK_CountryId,'') FK_CountryId,                
      ISNULL(fma.FK_StateId,'') FK_StateId,                
      ISNULL(fma.FK_CityId,'') FK_CityId,                
      ISNULL(fma.ParentAccountId,'') ParentAccountId,                
      ISNULL(fma.FK_CountryId_Billing,'') FK_CountryId_Billing,                
      ISNULL(fma.FK_StateId_Billing ,'') FK_StateId_Billing,                
      ISNULL(fma.FK_CityId_Billing ,'') FK_CityId_Billing ,                
      ISNULL(fma.UserLimit,'') UserLimit,                
      ISNULL(fma.ZipCode,'') ZipCode,                
      ISNULL(fma.ZipCode_Billing,'') ZipCode_Billing,                
      ISNULL(cntry_bill.CountryName,'')       CountryId_Billing_Name,                
      ISNULL(st_bill.StateName,'')           State_Billing_Name,                
      ISNULL(ct_bill.CityName,'') City_Billing_Name,       
      ISNULL(cntry_bill.PK_CountryId,'') FK_CountryId_Billing,                
      ISNULL(st_bill.PK_StateId,'')  FK_StateId_Billing    ,                
      ISNULL(ct_bill.PK_CityId,'') FK_CityId_Billing,                
      ISNULL(us.UserName,'')UserName,       
      ISNULL(us.FK_RoleId,0)FK_RoleId ,               

	  ISNULL(fma.FK_AccountId_Referrer,0)  FK_AccountId_Referrer    ,                
      ISNULL(p_fma_ref.AccountName,'') AccountName_Referrer,                
      ISNULL(fma.FK_CategoryId_Referrer,'') FK_CategoryId_Referrer,       
      ISNULL(msa_ref.CategoryName,0) CategoryName_Referrer      ,
	  ISNULL(fma.ShareVia,'') ShareVia



      --End Vinish                
      FROM  [dbo].[MST_Account]  fma (NOLOCK)                
      LEFT JOIN [dbo].[MST_Category]  msa   (NOLOCK)    ON fma.FK_CategoryId=msa.PK_CategoryId                
      --LEFT JOIN [dbo].[MST_Category]  catReseller   (NOLOCK)    ON fma.FK_ResellerId=catReseller.PK_CategoryId                
      --LEFT JOIN [dbo].[MST_Category]  catAffiliate   (NOLOCK)    ON fma.FK_ResellerId=catAffiliate.PK_CategoryId                
      LEFT JOIN [dbo].[MST_Country]   cntry (NOLOCK)    ON fma.FK_CountryId=cntry.PK_CountryId                
      LEFT JOIN [dbo].[MST_State]     st    (NOLOCK)    ON fma.FK_StateId=st.PK_StateId                
      LEFT JOIN [dbo].[MST_City]      ct    (NOLOCK)    ON fma.FK_CityId=ct.PK_CityId                
      --By Vinish                
      LEFT JOIN [dbo].[MST_User]  us (NOLOCK)    ON fma.FK_UserId=us.PK_UserId                
      left JOIN [dbo].[MST_Country]   cntry_bill (NOLOCK)    ON fma.FK_CountryId=cntry_bill.PK_CountryId                
      left JOIN [dbo].[MST_State]     st_bill    (NOLOCK)    ON fma.FK_StateId=     st_bill.PK_StateId                
      left JOIN [dbo].[MST_City]      ct_bill    (NOLOCK)    ON fma.FK_CityId=      ct_bill.PK_CityId                
      left JOIN [dbo].[MST_Account]     p_fma    (NOLOCK)    ON fma.ParentAccountId=p_fma.PK_AccountId                

	  LEFT JOIN [dbo].[MST_Account]     p_fma_ref    (NOLOCK)    ON fma.FK_AccountId_Referrer =p_fma_ref.PK_AccountId  
	  LEFT JOIN [dbo].[MST_Category]  msa_ref   (NOLOCK)    ON fma.FK_CategoryId_Referrer =msa_ref.PK_CategoryId

      --End                
      WHERE             
		Isnull(fma.IsDeleted,0)=0   AND   
      fma.PK_AccountId= CASE WHEN @iPK_AccountId <> 0 THEN @iPK_AccountId ELSE fma.PK_AccountId END                
                
      --AND                      
 --(                    
 -- fma.FK_AccountId IN                    
 -- (                    
 --  SELECT AccountId from MAP_UserAccount(NOLOCK) FMUA                     
 --  INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId                     
 --  WHERE FK_UserId=@iPK_UserId and                 
 --  FMUA.IsActive=1 and FMU.IsActive=1                    
 --  AND @iFK_AccountId=1                    
 -- )                    
 -- OR                     
 -- fma.FK_AccountId =@iFK_AccountId                    
 --)                  
                
                
                
    ---By Vinish          
           
 and          
 (                    
    (case when CONVERT(CHAR(1),ISNULL(fma.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
    CASE                           
      WHEN                             
       (                          
        @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
       )                           
      THEN @cSearchValue          
      ELSE  (case when CONVERT(CHAR(1),ISNULL(fma.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
    END               
    )                    
          
 and          
 (                    
    convert(varchar(10),concat(isnull(month(fma.CreatedDateTime),'0'),isnull(year(fma.CreatedDateTime),'0'))) =                         
    CASE                           
      WHEN                             
       (                          
        @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
    )                           
      THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
   ELSE convert(varchar(10),concat(isnull(month(fma.CreatedDateTime),'0'),isnull(year(fma.CreatedDateTime),'0')))          
    END                    
    )                     
    AND                
      ISNULL(msa.CategoryName,'') LIKE                    
     CASE                     
       WHEN                       
     (                    
      @cSearchBy <> '' AND @cSearchBy = 'AccountCategory' AND @cSearchValue <> ''                    
     )                     
       THEN '%'+@cSearchValue+'%'                     
       ELSE  ISNULL(msa.CategoryName,'')                   
     END   
	   --End               
      AND                       
      ISNULL(fma.AccountName,'') LIKE                    
     CASE                     
       WHEN                       
     (                    
      @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND @cSearchValue <> ''                    
     )                     
       THEN '%'+@cSearchValue+'%'         
       ELSE  ISNULL(fma.AccountName,'')                   
     END                 
       AND                
          ISNULL(msa.CategoryName,'') LIKE                    
                  CASE                     
                    WHEN                       
                     (                    
                      @cSearchBy <> '' AND @cSearchBy = 'CategoryName' AND @cSearchValue <> ''                    
                     )                     
                    THEN '%'+@cSearchValue+'%'                     
                    ELSE  ISNULL(msa.CategoryName,'')                   
                  END                 
      AND                
    ISNULL(cntry.CountryName,'') LIKE                    
                    CASE                     
                      WHEN                       
                       (                    
                        @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''                    
                       )                     
                      THEN '%'+@cSearchValue+'%'                     
                      ELSE  ISNULL(cntry.CountryName,'')                   
                    END                  
        AND                
    ISNULL(st.StateName,'') LIKE                    
                    CASE                     
                      WHEN                       
                       (                    
                        @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''                    
                       )                     
                      THEN '%'+@cSearchValue+'%'                     
                      ELSE  ISNULL(st.StateName,'')                   
                    END                
        AND                
    ISNULL(ct.CityName,'') LIKE                    
                    CASE                     
                      WHEN                       
                       (                    
  @cSearchBy <> '' AND @cSearchBy = 'CityName' AND @cSearchValue <> ''                    
                       )                     
                      THEN '%'+@cSearchValue+'%'                     
                      ELSE  ISNULL(ct.CityName,'')                   
                    END

						AND                
          ISNULL(fma.EmailId,'') LIKE                    
               CASE                     
                    WHEN                       
                     (                    
                      @cSearchBy <> '' AND @cSearchBy = 'Email' AND @cSearchValue <> ''                    
                     )                     
                    THEN '%'+@cSearchValue+'%'                     
                    ELSE  ISNULL(fma.EmailId,'')                   
                  END                 
      AND  
          ISNULL(fma.MobileNo,'') LIKE                    
                  CASE                     
                    WHEN                       
                     (                    
                      @cSearchBy <> '' AND @cSearchBy = 'MobileNo' AND @cSearchValue <> ''                    
                     )                     
                    THEN '%'+@cSearchValue+'%'                     
                    ELSE  ISNULL(fma.MobileNo,'')                   
                  END        
					                 
     	-------User Wise Data 
					-------Added By Vinish 2020-01-14 12:30:26.640
						and 
					1=(
                            CASE 
				
                             WHEN @cLoginType='COMPANY' AND (
							 ISNULL(fma.PK_AccountId,0)=@iFK_AccountId 
							 or ISNULL(fma.FK_CompanyId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_CompanyId=@iFK_AccountId)
							 or ISNULL(fma.PK_AccountId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_CompanyId=@iFK_AccountId)
											)
		
                                                                 THEN 1
                            WHEN @cLoginType='RESELLER' 


							AND (
							
							 ISNULL(fma.PK_AccountId,0)=@iFK_AccountId 
							 or ISNULL(fma.FK_ResellerId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_ResellerId=@iFK_AccountId)
							 or ISNULL(fma.PK_AccountId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_ResellerId=@iFK_AccountId)
							)
					
																				
																				THEN 1
                            WHEN @cLoginType='AFFILIATE' 
		
							AND (
							 ISNULL(fma.PK_AccountId,0)=@iFK_AccountId 
							 or ISNULL(fma.FK_AffiliateId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_AffiliateId=@iFK_AccountId)
							 or ISNULL(fma.PK_AccountId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_AffiliateId=@iFK_AccountId)
							)
												

																				
																				THEN 1
                      ELSE 0
                            END
            )
					 -------End 2020-01-14 12:31:17.690 

					                
                
                 ORDER BY fma.PK_AccountId  desc                 
  OFFSET (@iCurrentPage-1)*@iRowperPage ROWS                     
                 FETCH NEXT @iRowperPage ROWS ONLY                
                     
       SELECT           
         ISNULL(COUNT (1),0)  AS TotalItem,          
           (          
         SELECT           
       ISNULL(SUM(          
    CASE           
    WHEN YEAR(fma.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(fma.CreatedDateTime)=MONTH(GETDATE())           
    THEN 1           
    ELSE 0 END),0          
      )          
          ) AS TotalCurrentMonth,         
      ISNULL(SUM(CASE WHEN isnull(fma.IsActive,0) =1 THEN 1 ELSE 0 END),0)AS TotalActive,          
      ISNULL(SUM(CASE WHEN isnull(fma.IsActive,0) =0 THEN 1 ELSE 0 END),0)AS TotalInActive             
                     
      FROM  [dbo].[MST_Account]  fma (NOLOCK)                
      INNER JOIN [dbo].[MST_Category]  msa   (NOLOCK)    ON fma.FK_CategoryId=msa.PK_CategoryId                
      --LEFT JOIN [dbo].[MST_Category]  catReseller   (NOLOCK)    ON fma.FK_ResellerId=catReseller.PK_CategoryId                
      --LEFT JOIN [dbo].[MST_Category]  catAffiliate   (NOLOCK)    ON fma.FK_ResellerId=catAffiliate.PK_CategoryId                
      LEFT JOIN [dbo].[MST_Country]   cntry (NOLOCK)    ON fma.FK_CountryId=cntry.PK_CountryId                
      LEFT JOIN [dbo].[MST_State]     st    (NOLOCK)    ON fma.FK_StateId=st.PK_StateId                
      LEFT JOIN [dbo].[MST_City]      ct    (NOLOCK)    ON fma.FK_CityId=ct.PK_CityId                
      --By Vinish                
      left JOIN [dbo].[MST_User]  us (NOLOCK)    ON fma.FK_UserId=us.PK_UserId                
      left JOIN [dbo].[MST_Country]   cntry_bill (NOLOCK)    ON fma.FK_CountryId=cntry_bill.PK_CountryId                
      left JOIN [dbo].[MST_State]     st_bill    (NOLOCK)    ON fma.FK_StateId=     st_bill.PK_StateId                
      left JOIN [dbo].[MST_City]      ct_bill    (NOLOCK)    ON fma.FK_CityId=      ct_bill.PK_CityId                
      left JOIN [dbo].[MST_Account]     p_fma    (NOLOCK)    ON fma.ParentAccountId=p_fma.PK_AccountId 
	  
	  
	  LEFT JOIN [dbo].[MST_Account]     p_fma_ref    (NOLOCK)    ON fma.FK_AccountId_Referrer =p_fma_ref.PK_AccountId  
	  LEFT JOIN [dbo].[MST_Category]  msa_ref   (NOLOCK)    ON fma.FK_CategoryId_Referrer =msa_ref.PK_CategoryId                
      --End                
      WHERE                 
      Isnull(fma.IsDeleted,0)=0   AND   
      fma.PK_AccountId= CASE WHEN @iPK_AccountId <> 0 THEN @iPK_AccountId ELSE fma.PK_AccountId END                
           --AND                      
 --(               
 -- fma.FK_AccountId IN                    
 -- (                    
 --  SELECT AccountId from MAP_UserAccount(NOLOCK) FMUA                     
 --  INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId                     
 --  WHERE FK_UserId=@iPK_UserId and                 
 --  FMUA.IsActive=1 and FMU.IsActive=1                    
 --  AND @iFK_AccountId=1                    
 -- )                    
 -- OR                     
 -- fma.FK_AccountId =@iFK_AccountId                    
 --)                  
                
  ---By Vinish          
           
 and          
 (                    
    (case when CONVERT(CHAR(1),ISNULL(fma.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
    CASE                           
      WHEN                             
       (                          
        @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
       )                           
      THEN @cSearchValue          
      ELSE  (case when CONVERT(CHAR(1),ISNULL(fma.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
    END                    
    )                    
          
 and          
 (                    
    convert(varchar(10),concat(isnull(month(fma.CreatedDateTime),'0'),isnull(year(fma.CreatedDateTime),'0'))) =                         
    CASE                           
      WHEN          
       (                          
        @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
    )                           
      THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
      ELSE convert(varchar(10),concat(isnull(month(fma.CreatedDateTime),'0'),isnull(year(fma.CreatedDateTime),'0')))          
    END                    
    )                     
    AND                
      ISNULL(msa.CategoryName,'') LIKE                    
     CASE                     
       WHEN                       
     (                    
      @cSearchBy <> '' AND @cSearchBy = 'AccountCategory' AND @cSearchValue <> ''                    
     )                     
       THEN '%'+@cSearchValue+'%'                     
       ELSE  ISNULL(msa.CategoryName,'')                   
     END                 
      AND                
   --End     
                
      ISNULL(fma.AccountName,'') LIKE                    
     CASE             
  WHEN                       
     (                    
      @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND @cSearchValue <> ''              
     )                     
       THEN '%'+@cSearchValue+'%'                     
       ELSE  ISNULL(fma.AccountName,'')                   
     END       
       AND       
            ISNULL(msa.CategoryName,'') LIKE                    
                  CASE                     
                    WHEN                       
                     (                    
                      @cSearchBy <> '' AND @cSearchBy = 'CategoryName' AND @cSearchValue <> ''                    
                     )            
                    THEN '%'+@cSearchValue+'%'      
                    ELSE  ISNULL(msa.CategoryName,'')                   
                  END                 
      AND                
      ISNULL(cntry.CountryName,'') LIKE                    
                    CASE                     
                      WHEN                       
 (                    
                        @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''                    
                       )                     
                      THEN '%'+@cSearchValue+'%'                     
                      ELSE  ISNULL(cntry.CountryName,'')                   
                END                  
        AND                
     ISNULL(st.StateName,'') LIKE                    
                    CASE                     
                      WHEN                       
                       (                    
                        @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''                    
             )                     
                      THEN '%'+@cSearchValue+'%'                     
                      ELSE  ISNULL(st.StateName,'')                   
                    END                
        AND                
     ISNULL(ct.CityName,'') LIKE                    
                    CASE                     
                      WHEN       
                       (                    
                        @cSearchBy <> '' AND @cSearchBy = 'CityName' AND @cSearchValue <> ''                    
                       )                     
                      THEN '%'+@cSearchValue+'%'                     
                      ELSE  ISNULL(ct.CityName,'')                   
                    END   
					
					AND                
          ISNULL(fma.EmailId,'') LIKE                    
                  CASE                     
                    WHEN                       
                     (                    
                      @cSearchBy <> '' AND @cSearchBy = 'Email' AND @cSearchValue <> ''                    
                     )                     
                    THEN '%'+@cSearchValue+'%'                     
                    ELSE  ISNULL(fma.EmailId,'')                   
                  END                 
      AND  
          ISNULL(fma.MobileNo,'') LIKE                    
                  CASE                     
                    WHEN                       
                     (             
                      @cSearchBy <> '' AND @cSearchBy = 'MobileNo' AND @cSearchValue <> ''                    
                     )                     
                    THEN '%'+@cSearchValue+'%'                     
                    ELSE  ISNULL(fma.MobileNo,'')                   
                  END        
					 
					-------User Wise Data 
					-------Added By Vinish 2020-01-14 12:30:26.640
						and 
					1=(
                            CASE 
				
                             WHEN @cLoginType='COMPANY' AND (
							 ISNULL(fma.PK_AccountId,0)=@iFK_AccountId 
							 or ISNULL(fma.FK_CompanyId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_CompanyId=@iFK_AccountId)
							 or ISNULL(fma.PK_AccountId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_CompanyId=@iFK_AccountId)
											)
		
                                                                 THEN 1
                            WHEN @cLoginType='RESELLER' 


							AND (
							
							 ISNULL(fma.PK_AccountId,0)=@iFK_AccountId 
							 or ISNULL(fma.FK_ResellerId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_ResellerId=@iFK_AccountId)
							 or ISNULL(fma.PK_AccountId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_ResellerId=@iFK_AccountId)
							)
					
																				
																				THEN 1
                            WHEN @cLoginType='AFFILIATE' 
		
							AND (
							 ISNULL(fma.PK_AccountId,0)=@iFK_AccountId 
							 or ISNULL(fma.FK_AffiliateId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_AffiliateId=@iFK_AccountId)
							 or ISNULL(fma.PK_AccountId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_AffiliateId=@iFK_AccountId)
							)
												

																				
																				THEN 1
                      ELSE 0
                            END
            )
					 -------End 2020-01-14 12:31:17.690                                 
END TRY                
BEGIN CATCH                 
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                 
END CATCH;









GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountListByCategoryId]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:sandeep Kumar     
CreatedDate:12-12-2019    
purpos:Get All Account Name by Category Id  
[dbo].[USP_GetAccountListByCategoryId]        
EXEC [dbo].[USP_GetAccountListByCategoryId] 1  
****************************************************/    
CREATE PROCEDURE [dbo].[USP_GetAccountListByCategoryId]      
(    
 @iFK_CategoryId BIGINT = 0    
)            
AS    
BEGIN     
SELECT 1 AS Message_Id,'Success' AS Message     
    SELECT     
    PK_AccountId,    
    AccountName    
    FROM MST_Account(NOLOCK)    
    WHERE FK_CategoryId=@iFK_CategoryId    
    AND isnull(IsActive,0) = 1  AND isnull(IsDeleted,0) <> 1  
END




GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllAccounts]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************  
CreatedBy:sandeep Kumar 
CreatedDate:3-12-2019
purpos:Get Account Details By Optional Conditions

EXEC [dbo].[USP_GetAllAccounts] 0
****************************************************/  
CREATE PROCEDURE [dbo].[USP_GetAllAccounts]
(
	@iFK_ParentAccountId	BIGINT		=0,
	@iFK_UserId             BIGINT=0,  
	@cAccountName			NVARCHAR(50)='',	
	@iFK_CategoryId			BIGINT		=0,
	@cMobileNo				NVARCHAR(50)='',
	@cEmailId				NVARCHAR(50)='',
	@cZipCode				NVARCHAR(50)=''
 )
AS          
BEGIN TRY  
	     SELECT
	        ISNULL(PK_AccountId,0)PK_AccountId,
	        ISNULL(AccountName,'')AccountName,
	        ISNULL(ParentAccountId,0)ParentAccountId
	        --(SELECT   
         --   CONVERT(varchar(50),
         --   STUFF((  
         --   SELECT  DISTINCT ', ' + CONVERT(varchar(50), UMP.FK_AccountId,0) 
         --   FROM map_UserAccount(NOLOCK)UMP  
         --   INNER JOIN dboGyanmitrasMST_Account(NOLOCK)acc  
         --   ON acc.PK_AccountId=UMP.FK_AccountId 
 	       -- WHERE
 	       -- UMP.FK_UserId=@iFK_UserId
         --   FOR XML PATH('')), 1, 1, '')) As AlreadyExist)
	        FROM MST_Account(NOLOCK)  
	        WHERE 
			ISNULL(IsDeleted,0)=0 AND
	        AccountName LIKE '%'+LTRIM(RTRIM(ISNULL(@cAccountName,'')))+'%'
	        AND
	        ISNULL(MobileNo,'') LIKE '%'+LTRIM(RTRIM(ISNULL(@cMobileNo,'')))+'%'
	        AND
	        ISNULL(EmailId,'') LIKE '%'+LTRIM(RTRIM(ISNULL(@cEmailId,'')))+'%'
	        AND
	        ISNULL(ZipCode,'') LIKE '%'+LTRIM(RTRIM(ISNULL(@cZipCode,'')))+'%'
	        AND
	        FK_CategoryId = CASE WHEN @iFK_CategoryId <> 0 THEN @iFK_CategoryId ELSE FK_CategoryId END
	        
	        AND ParentAccountId = CASE WHEN @iFK_ParentAccountId <> 0 THEN @iFK_ParentAccountId ELSE ParentAccountId END 
END TRY          
BEGIN CATCH          
  SELECT 0 [Message_Id], ERROR_MESSAGE() [Message]           
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllBrandDetailsToValidate]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************    
CREATED BY:Sandeep Kr  
CREATED DATE:08 Jan 2020  
Purpose: To Get All DATA To Validate    
    
EXEC [dbo].[USP_GetAllBrandDetailsToValidate]      
*******************************************************************************************/    
CREATE PROCEDURE [dbo].[USP_GetAllBrandDetailsToValidate]    
(    
 @iFK_AccountId BIGINT =0   
)    
AS    
BEGIN TRY    
 SELECT 1 AS Message_Id,'SUCCESSFULL' AS Message    
    
 SELECT     
 ISNULL(PK_vehiclebrandId,0) AS PK_vehiclebrandId,    
 ISNULL(VehicleBrandName,'')AS VehicleBrandName   
 FROM MST_vehiclebrand (NOLOCK) 
 WHERE 
 ISNULL(IsDeleted,0)=0
 -- AND 
-- WHERE FK_AccountId=@iFK_AccountId      
END TRY    
BEGIN CATCH    
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message    
END CATCH    
    




GO
/****** Object:  StoredProcedure [dbo].[USP_GetALLCategoryByLoginType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:13-01-2020  
purpos:Get All Category BY LOGINT TYPE  
  
EXEC [dbo].[USP_GetAllCategoryByLoginType]  'reseller'  
****************************************************/   
CREATE PROCEDURE [dbo].[USP_GetALLCategoryByLoginType]  
  (  
   @LoginType VARCHAR(100)=''  
   )  
   AS              
   BEGIN TRY   
   IF(@LoginType='COMPANY')  
   BEGIN  
        SELECT  
              ISNULL(PK_CategoryId,0)PK_CategoryId,  
              ISNULL(CategoryName,'')CategoryName  
              FROM MST_Category(NOLOCK) cat  
			  WHERE ISNULL(Isdeleted,0)=0
   END  
   ELSE IF(@LoginType='RESELLER')  
   BEGIN  
         SELECT  
              ISNULL(PK_CategoryId,0)PK_CategoryId,  
              ISNULL(CategoryName,'')CategoryName  
              FROM MST_Category(NOLOCK) cat  
              WHERE LTRIM(RTRIM(UPPER(CategoryName)))<>'COMPANY'  AND ISNULL(Isdeleted,0)=0 
   END  
   ELSE IF(@LoginType='AFFILIATE')  
   BEGIN  
          SELECT  
                ISNULL(PK_CategoryId,0)PK_CategoryId,  
                ISNULL(CategoryName,'')CategoryName  
                FROM MST_Category(NOLOCK) cat  
                WHERE LTRIM(RTRIM(UPPER(CategoryName)))<>('COMPANY')  
                AND LTRIM(RTRIM(UPPER(CategoryName)))<>('RESELLER')  AND ISNULL(Isdeleted,0)=0
    END  
    ELSE IF(@LoginType='CUSTOMER')  
    BEGIN  
          SELECT  
                ISNULL(PK_CategoryId,0)PK_CategoryId,  
                ISNULL(CategoryName,'')CategoryName  
                FROM MST_Category(NOLOCK) cat  
                WHERE LTRIM(RTRIM(UPPER(CategoryName)))=('CUSTOMER')  AND ISNULL(Isdeleted,0)=0
            END  
    ELSE  
    BEGIN  
            SELECT  
                 ISNULL(PK_CategoryId,0)PK_CategoryId,  
                 ISNULL(CategoryName,'')CategoryName  
                 FROM MST_Category(NOLOCK) cat  
				 WHERE ISNULL(Isdeleted,0)=0
END  
END TRY          
BEGIN CATCH          
    SELECT 0 [Message_Id], ERROR_MESSAGE() [Message]           
END CATCH




GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllCategoryList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************  
CreatedBy:Vinish
CreatedDate:2020-05-01 15:54:20.423
purpos:Get All Category List

EXEC [dbo].[USP_GetAllCategoryList]  
****************************************************/  
CREATE PROCEDURE [dbo].[USP_GetAllCategoryList]          
AS
BEGIN
	SELECT
	ISNULL(PK_CategoryId,0)PK_CategoryId,
	ISNULL(CategoryName,'')CategoryName
    FROM MST_Category(NOLOCK)
	WHERE 
	ISNULL(IsDeleted,0)=0 and ISNULL(IsActive,0)=1
END




GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllCityDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:11-12-2019  
purpos:Get City Details 
[dbo].[USP_GetAllCityDetails]       
EXEC [dbo].[USP_GetAllCityDetails]  2
****************************************************/    
CREATE PROCEDURE [dbo].[USP_GetAllCityDetails]  
(
@iFK_StateId NVARCHAR(100)
)        
AS
BEGIN
     SELECT	1 AS Message_Id,'Success' AS Message 
     SELECT 
	 ISNULL(ct.PK_CityId,0)PK_CityId,
	 ISNULL(cont.CountryName,'')CountryName,
     ISNULL(st.StateName,'') StateName,
	 ISNULL(ct.CityName,'')CityName
     FROM MST_City(NOLOCK) ct
     JOIN MST_State st ON ct.FK_StateId = st.PK_StateId
     JOIN MST_Country cont ON cont.PK_CountryId = st.FK_CountryId
	 WHERE st.PK_StateId=@iFK_StateId
	 AND
	 ISNULL(ct.IsDeleted,0)=0
END



GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCompany]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************
CREATED BY:Vinish
Created Date: 2020-04-28 17:54:09.177
Purpose :To GEt All Company Details
EXEC [dbo].[usp_GetAllCompany]
**************************************************************************/
CREATE PROCEDURE [dbo].[usp_GetAllCompany]
AS
BEGIN TRY

	SELECT 1 AS Message_Id,'Success' AS Message
	SELECT 
	PK_CompanyId,
	ISNULL(CompanyName,'')AS CompanyName 
	FROM MST_Company
	WHERE ISNULL(IsActive,0)=1 AND ISNULL(IsDeleted,0) = 0

END TRY
BEGIN CATCH
	SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message
END CATCH




  
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllEmployedExpertiseDetailsList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vinish
-- Create date: 2020-04-25 23:02:22.520
-- Description:	Get All Employed Expertise 
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetAllEmployedExpertiseDetailsList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SELECT [PK_EmployedExpertise]
	  ,[EmployedExpertise]
	FROM [dbo].[LKP_EmployedExpertise] WHERE ISNULL([IsActive],0) = 1 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllForms]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************
CREATED BY :Shivam Saluja
CREATED DATE : 11 December 2019
Purpose: To Get Form Details

EXEC [dbo].[usp_GetAllForms]
********************************************************************************************/
CREATE PROCEDURE [dbo].[usp_GetAllForms]
AS 
BEGIN 
SELECT 
PK_FormId AS ID,
FormName AS Value
FROM [dbo].[MST_Form](NOLOCK)
WHERE --ISNULL(FK_ParentId,0)<>0 AND 
ISNULL(IsDeleted,0)=0
END






GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllRoles]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:13-12-2019  
select * from mst_role  
purpos:Get Role Details By Optional Conditions  
EXEC [dbo].[USP_GetAllRoles] '',0,1,0	
****************************************************/    
CREATE Procedure [dbo].[USP_GetAllRoles]  
(  
@cRoleName       NVARCHAR(50)='',  
@iFK_CategoryId   BIGINT  =0,  
@iFK_AccountId   BIGINT  =0,  
@iFK_CustomerId   BIGINT  =0  
)  
AS  
BEGIN   
     SELECT   
        ISNULL(PK_RoleId,0)PK_RoleId,  
        ISNULL(RoleName,'')RoleName 
        From MST_Role(NOLOCK)  
        Where  
     ISNULL(IsDeleted,0)=0 AND    ISNULL(IsActive,0)=1  and
        RoleName LIKE '%'+LTRIM(RTRIM(ISNULL(@cRoleName,'')))+'%'  
        AND  
        FK_CategoryId = CASE WHEN @iFK_CategoryId <> 0 THEN @iFK_CategoryId ELSE FK_CategoryId END  
         
        AND  
        FK_AccountId = CASE WHEN @iFK_AccountId <> 0 THEN @iFK_AccountId ELSE FK_AccountId END  
     AND  
        ISNULL(FK_CustomerId,0) = @iFK_CustomerId   
   
END 



  





GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllRolesByCompany]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:2020-04-28 18:20:35.987
select * from fr_mst_role    
purpos:Get Role Details By Optional Conditions    
EXEC [dbo].[[USP_GetAllRolesByCompany]]    
****************************************************/      
CREATE PROCEDURE [dbo].[USP_GetAllRolesByCompany]    
(       
@iFK_CompanyId   BIGINT  =0    
)    
AS    
BEGIN     
     SELECT     
        ISNULL(PK_RoleId,0)PK_RoleId,    
        ISNULL(RoleName,'')RoleName   
        From MST_Role(NOLOCK)    
        Where    
     ISNULL(IsDeleted,0)=0 AND    ISNULL(IsActive,0)=1  and  
     ISNULL(FK_CompanyId,0) = CASE WHEN @iFK_CompanyId=0 THEN  ISNULL(FK_CompanyId,0) ELSE   @iFK_CompanyId END  
     
END   
 
  
    
  




GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllVehicleBrand]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/******************************************      
CreatedBy:sandeep Kumar     
SELECT * FROM MST_VEHICLEBRAND    
CreatedDate:24-12-2019    
purpos:Get VEHICLE Details By Optional Conditions    
select * from mst_vehiclebrand    
EXEC [dbo].[USP_GetAllVehicleBrand] ''    
****************************************************/      
CREATE PROCEDURE [dbo].[USP_GetAllVehicleBrand]    
(    
 @cVehicleBrandName     NVARCHAR(50)=''     
)    
AS    
BEGIN     
 SELECT    
 ISNULL(PK_VehicleBrandId,0)PK_VehicleBrandId,    
 ISNULL(VehicleBrandName,'')VehicleBrandName    
 FROM MST_VehicleBrand(NOLOCK)    
 WHERE    
 ISNULL(IsDeleted,0)=0 AND ISNULL(IsActive,0)=1 AND  
 VehicleBrandName LIKE '%'+LTRIM(RTRIM(ISNULL(@cVehicleBrandName,'')))+'%'    
     
END



GO
/****** Object:  StoredProcedure [dbo].[USP_GetBrandDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************          
CreatedBy:sandeep Kumar         
CreatedDate:16-12-2019        
purpos:Get Brand Details     
SELECT * FROM MST   
select * from mst_vehiclebrand        
EXEC [dbo].[USP_GetBrandDetails] 0,1,10,1,'VehicleBrand','Maruti'        
        
***************************************************/          
CREATE Procedure [dbo].[USP_GetBrandDetails]         
(     
   @iFK_AccountId                     BIGINT,    
   @iFK_CustomerId                    BIGINT,    
   @iUserId                           BIGINT,    
   @cLoginType                        nvarchar(100),     
   @iPK_VehicleBrandId                BIGINT,        
   @iPK_UserId                        BIGINT,         
   @iRowperPage                       BIGINT,        
   @iCurrentPage                      BIGINT,        
   @cSearchBy                         NVARCHAR(50)='',        
   @cSearchValue                      NVARCHAR(50)=''        
)        
AS        
BEGIN TRY        
      SELECT 1 AS Message_Id, 'SUCCESS' AS Message         
      SELECT         
      ISNULL(PK_VehicleBrandId,0) PK_VehicleBrandId,        
      ISNULL(VehicleBrandName,'')VehicleBrandName,        
      ISNULL(IsActive,0) IsActive,        
      CreatedBy,         
      Isnull(FORMAT(CreatedDateTime,'dd/MM/yyyy HH:mm'),'')CreatedDateTime         
      FROM MST_VehicleBrand    vbn (NOLOCK)        
      WHERE         
      ISNULL(vbn.IsDeleted,0)=0        
      and        
      PK_VehicleBrandId= CASE WHEN @iPK_VehicleBrandId <> 0 THEN @iPK_VehicleBrandId ELSE PK_VehicleBrandId END        
      AND 

	
		  
      ISNULL(VehicleBrandName,'') LIKE            
      CASE             
         WHEN               
        (            
          @cSearchBy <> '' AND @cSearchBy = 'VehicleBrand' AND LTRIM(RTRIM(@cSearchValue)) <> ''            
        )             
        THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'             
        ELSE  ISNULL(VehicleBrandName,'')           
      END         
             
      ORDER BY PK_VehicleBrandId asc         
      OFFSET (@iCurrentPage-1)*@iRowperPage ROWS             
         FETCH NEXT @iRowperPage ROWS ONLY        
        
    SELECT       
         ISNULL(COUNT (1),0)  AS TotalItem,      
         (      
      SELECT       
         ISNULL(SUM (      
      CASE       
      WHEN YEAR(vbn.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(vbn.CreatedDateTime)=MONTH(GETDATE())       
    THEN 1       
    ELSE 0 END),0      
      )      
         ) AS TotalCurrentMonth,       
         ISNULL(SUM(CASE WHEN vbn.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,      
         ISNULL(SUM(CASE WHEN vbn.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive        
         FROM MST_VehicleBrand    vbn (NOLOCK)        
         WHERE         
         ISNULL(vbn.IsDeleted,0)=0        
         AND        
         PK_VehicleBrandId= CASE WHEN @iPK_VehicleBrandId <> 0 THEN @iPK_VehicleBrandId ELSE PK_VehicleBrandId END        
   
		  AND
		 
		 
		   
		 ISNULL(VehicleBrandName,'') LIKE            
         CASE             
         WHEN               
        (            
          @cSearchBy <> '' AND @cSearchBy = 'VehicleBrand' AND LTRIM(RTRIM(@cSearchValue)) <> ''            
        )             
        THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'             
        ELSE  ISNULL(VehicleBrandName,'')           
     END         
END TRY        
BEGIN CATCH         
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message         
END CATCH; 



GO
/****** Object:  StoredProcedure [dbo].[USP_GetCityDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:05-12-2019  
purpos:Get City Master    
EXEC [dbo].[USP_GetCityDetails]
0,'','',10,1,1

EXEC [dbo].[USP_GetCityDetails]
5,'','',10,1,1

EXEC [dbo].[USP_GetCityDetails]
0,'StateName','Haryana',10,1,1

****************************************************/        
CREATE PROCEDURE [dbo].[USP_GetCityDetails]  
(
	@iPK_CityId BIGINT,	
	@cSearchBy NVARCHAR(50)='',
	@cSearchValue NVARCHAR(50)='',
	@iRowperPage  INT  ,  
	@iCurrentPage  INT   ,
	@iUserId       BIGINT   
)        
AS
BEGIN TRY
	   SELECT	1 AS Message_Id,'Success' AS Message 
       SELECT 
	   ISNULL(ct.PK_CityId, 0)PK_CityId,
	   ISNULL(cont.CountryName, '')CountryName,
       ISNULL(st.StateName,'')StateName,
	   ISNULL(ct.CityName,'')CityName,
	   ISNULL(ct.CreatedBy,0)CreatedBy,
	   ISNULL(ct.FK_CountryId,0)FK_CountryId,
	   ISNULL(ct.FK_StateId,0)FK_StateId,
	   ISNULL(ct.IsActive,0)IsActive,
	   CASE WHEN ct.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status]
       FROM MST_City(NOLOCK) ct
       INNER JOIN MST_State st		ON ct.FK_StateId = st.PK_StateId
       INNER JOIN MST_Country cont	ON cont.PK_CountryId = st.FK_CountryId
	   WHERE 
	   Isnull(ct.IsDeleted,0)=0 AND
	   ct.PK_CityId = CASE WHEN @iPK_CityId <> 0 THEN @iPK_CityId ELSE ct.PK_CityId END
	   --AND CT.CreatedBy=@iUserId
	   AND
	   ISNULL(ct.CityName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'CityName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(ct.CityName,'')   
         END  
	   AND
	   ISNULL(cont.CountryName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(cont.CountryName,'')   
         END  
		 AND
	   ISNULL(st.StateName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(st.StateName,'')   
         END  

		 ORDER BY ct.PK_CityId DESC 
		 OFFSET (@iCurrentPage-1)*@iRowperPage ROWS     
		 FETCH NEXT @iRowperPage ROWS ONLY
		       SELECT 
         ISNULL(COUNT (1),0)  AS TotalItem
   
		 FROM MST_City(NOLOCK) ct
         INNER JOIN MST_State st		ON ct.FK_StateId = st.PK_StateId
         INNER JOIN MST_Country cont	ON cont.PK_CountryId = st.FK_CountryId
	     WHERE 
	     Isnull(ct.IsDeleted,0)=0 
		 --AND
	     --CT.CreatedBy=@iUserId
	     AND ct.PK_CityId = CASE WHEN @iPK_CityId <> 0 THEN @iPK_CityId ELSE ct.PK_CityId END

	     AND
	     ISNULL(ct.CityName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'CityName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(ct.CityName,'')   
         END  

	     AND
	    
	    ISNULL(cont.CountryName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(cont.CountryName,'')   
         END  
		 AND
	    ISNULL(st.StateName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(st.StateName,'')   
         END  
END TRY
BEGIN CATCH 
	SELECT	0 AS Message_Id,ERROR_MESSAGE() AS Message 
END CATCH; 




GO
/****** Object:  StoredProcedure [dbo].[USP_GetCityDetailsByStateId]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************          
CreatedBy:Vinish     
CreatedDate:24-03-2020       
purpos:Get State Details       
[dbo].[USP_GetCityDetailsByCityId]             
EXEC [dbo].[USP_GetCityDetailsByStateId] 1       
****************************************************/          
CREATE PROCEDURE [dbo].[USP_GetCityDetailsByStateId]        
(      
 @iFK_StateId BIGINT = 0      
)              
AS      
BEGIN      
SELECT 1 AS Message_Id,'Success' AS Message          
 SELECT       
 ISNULL(PK_CityId,0)  PK_CityId,   
 ISNULL(CT.CityName,'')  CityName   
 FROM MST_City(NOLOCK) CT      
 WHERE CT.FK_StateId=@iFK_StateId      
 AND Isnull(IsDeleted,0)=0  and Isnull(IsActive,0)=1 AND Isnull(CT.IsDeleted,0)=0  and Isnull(CT.IsActive,0)=1  
  
END  


GO
/****** Object:  StoredProcedure [dbo].[USP_GetcolumnConfigList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Sandeep Kumar   
CreatedDate:05-02-2020
purpos:Get Get form list
EXEC dbo.USP_GetcolumnConfigList
****************************************************/  
CREATE PROCEDURE [dbo].[USP_GetcolumnConfigList]  
 (  
  @ControllerName     nvarchar(50)  
, @ActionName         nvarchar(50)  
, @iCustomerId            bigint  
)  
AS  
BEGIN  
      SELECT 1 AS Message_Id,'Get  successfully.' AS Message  
      SELECT config.Column_Name ,
	  ISNULL(MST.IsActive,0) AS IsActive
      FROM Config_PageColumn(nolock) config  
      inner join MST_FormColumn(nolock) MST  
      ON MST.PK_FormColumnId=CONFIG.FK_FormColumnId  
      WHERE  config.FK_FormId=(SELECT TOP 1 PK_FormId FROM mst_form(nolock) frm WHERE ControllerName=@ControllerName and ActionName=@ActionName) 
      and config.FK_CustomerId=@iCustomerId  
      and config.IsActive=1  
      order by PK_PageColumnConfigId ASC  
END  
  
  
  
  
  




GO
/****** Object:  StoredProcedure [dbo].[USP_GetCountryDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:11-12-2019  
purpos: TO BIND COUNTRY GRID

EXEC [dbo].[USP_GetCountryDetails] 
0,'','',20,1,50

EXEC [dbo].[USP_GetCountryDetails] 
0,'','',10,1,1

EXEC [dbo].[USP_GetCountryDetails] 
0,'CountryName','c',10,1,1
****************************************************/    
CREATE PROCEDURE [dbo].[USP_GetCountryDetails]
(
	@iPK_CountryId   BIGINT,
	@cSearchBy       NVARCHAR(50)='',
	@cSearchValue    NVARCHAR(50)='',
	@iRowperPage     INT  ,  
	@iCurrentPage    INT  ,
	@iUserId         BIGINT  
)
AS
BEGIN  TRY  
	      SELECT 1 AS Message_Id, 'SUCCESS' AS Message
	      SELECT 
	      ISNULL(CT.PK_CountryId,0)PK_CountryId,
	      ISNULL(CT.CountryName,'')CountryName,
	      ISNULL(CT.IsActive,0)IsActive,
	      CASE WHEN CT.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status], 
	      ISNULL(FORMAT(CT.CreatedDateTime,'dd/MM/yyyy HH:mm'),'')CreatedDateTime
          FROM MST_Country(NOLOCK) CT
	      WHERE 
	      ISNULL(CT.IsDeleted,0)=0 AND
	      CT.PK_CountryId = CASE WHEN @iPK_CountryId <> 0 THEN @iPK_CountryId ELSE CT.PK_CountryId END
	      --AND CT.CreatedBy=@iUserId
	      AND
	      ISNULL(CT.CountryName,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(CT.CountryName,'')   
          END   
	      
	      
	       ORDER BY   CT.PK_CountryId DESC
	      
	       OFFSET (@iCurrentPage-1)*@iRowperPage ROWS     
           FETCH NEXT @iRowperPage ROWS ONLY		
           SELECT 
           ISNULL(COUNT (1),0)  AS TotalItem
   
           FROM MST_Country(NOLOCK) CT
	       WHERE 
           ISNULL(CT.IsDeleted,0)=0 AND
	       CT.PK_CountryId = CASE WHEN @iPK_CountryId <> 0 THEN @iPK_CountryId ELSE CT.PK_CountryId END
	      
	       --AND CT.CreatedBy=@iUserId
	       AND
	       ISNULL(CT.CountryName,'') LIKE    
           CASE     
               WHEN       
                (    
                 @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''    
                )     
               THEN '%'+@cSearchValue+'%'     
               ELSE  ISNULL(CT.CountryName,'')   
           END   
	      
END TRY

BEGIN CATCH
	SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message

END CATCH





GO
/****** Object:  StoredProcedure [dbo].[USP_GetCountryList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:11-12-2019  
purpos: TO BIND COUNTRY DROPDOWN
EXEC [dbo].[USP_GetCountryList] 
****************************************************/    
CREATE PROCEDURE [dbo].[USP_GetCountryList]
AS
BEGIN    
SELECT 1 AS Message_Id,'Success' AS Message   
	SELECT 
	ISNULL(PK_CountryId, 0)PK_CountryId,
	ISNULL(CountryName,'')CountryName
	
    FROM MST_Country(NOLOCK) CT
	WHERE 
	ISNULL(CT.IsDeleted,0)=0 
	AND 
	ISNULL(CT.IsActive,0)=1
END





GO
/****** Object:  StoredProcedure [dbo].[USP_GetFormColumnDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                    
CREATED BY:Sandeep Kumar                   
CREATED DATE:02 January 2020                    
PURPOSE:To Get  Form Column  Details      
select * from MST_FormColumn                 
EXEC [dbo].[USP_GetFormColumnDetails] 0,10,1,'','',1,1           
****************************************************/      
CREATE PROCEDURE [dbo].[USP_GetFormColumnDetails]      
(      
  @iPK_FormColumnId        BIGINT,      
  @iRowperPage             BIGINT,       
  @iCurrentPage            BIGINT,       
  @cSearchBy               NVARCHAR(50),          
  @cSearchValue            NVARCHAR(50) ,      
  @iFK_AccountId           INT=1,      
  @iUserId                 INT=1 ,
   @iFK_CustomerId   BIGINT=0, 
    @cLoginType          nvarchar(100)=''  
      
)      
AS      
BEGIN TRY      
         SELECT 1 AS Message_Id,'Success' AS Message       
         SELECT       
               ISNULL(FRMCLMN.PK_FormColumnId,0)PK_FormColumnId,      
               ISNULL(FRMCLMN.Column_Name,'')Column_Name,      
               ISNULL(FRMCLMN.FK_AccountId,0)FK_AccountId,    
               ISNULL(acc.AccountName,'')AccountName,      
               ISNULL(FRMCLMN.FK_FormId,0)FK_FormId,      
               ISNULL(FRM.FormName,'') FormName      
               FROM MST_FormColumn (NOLOCK) FRMCLMN      
               LEFT JOIN MST_FORM  (NOLOCK) FRM  ON FRM.PK_FormId = FRMCLMN.FK_FormId     
               LEFT JOIN MST_Account  (NOLOCK) acc  ON acc.PK_AccountId = FRMCLMN.FK_AccountId      
               WHERE  ISNULL(FRMCLMN.IsDeleted,0)=0 AND    
               FRMCLMN.PK_FormColumnId  IN (CASE WHEN @iPK_FormColumnId=0 THEN FRMCLMN.PK_FormColumnId ELSE @iPK_FormColumnId END)    
      and    
               (              
                 (case when CONVERT(CHAR(1),ISNULL(FRMCLMN.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                   
                 CASE                     
                   WHEN                       
                    (                    
                     @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                    
                    )                     
                   THEN @cSearchValue    
                   ELSE  (case when CONVERT(CHAR(1),ISNULL(FRMCLMN.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                  
                 END              
                 )              
                 
                and    
                (              
                 convert(varchar(10),concat(isnull(month(FRMCLMN.CreatedDateTime),'0'),isnull(year(FRMCLMN.CreatedDateTime),'0'))) =                   
                 CASE                     
                   WHEN                       
                    (                    
                     @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                    
                  )                     
                   THEN convert(varchar(10),concat(month(getdate()),year(getdate())))    
                   ELSE convert(varchar(10),concat(isnull(month(FRMCLMN.CreatedDateTime),'0'),isnull(year(FRMCLMN.CreatedDateTime),'0')))    
                 END              
                 )   
               AND      
               ISNULL(FRMCLMN.Form_Name,'') LIKE          
               CASE           
                WHEN             
                 (          
                  @cSearchBy <> '' AND @cSearchBy = 'Form_Name' AND @cSearchValue <> ''          
                 )           
                THEN '%'+@cSearchValue+'%'           
                ELSE  ISNULL(FRMCLMN.Form_Name,'')         
               END        
      
               AND      
               ISNULL(FRMCLMN.Column_Name,'') LIKE          
                CASE           
                  WHEN             
                   (          
                    @cSearchBy <> '' AND @cSearchBy = 'Column_Name' AND @cSearchValue <> ''          
                   )           
               THEN '%'+@cSearchValue+'%'           
               ELSE  ISNULL(FRMCLMN.Column_Name,'')         
 END       
               ORDER BY FRMCLMN.PK_FormColumnId desc          
               OFFSET (@iCurrentPage-1)*@iRowperPage ROWS           
               FETCH NEXT @iRowperPage ROWS ONLY      
               SELECT         
               ISNULL(COUNT (1),0)  AS TotalItem,    
                  (      
               SELECT       
               ISNULL(SUM (      
               CASE       
               WHEN YEAR(FRMCLMN.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(FRMCLMN.CreatedDateTime)=MONTH(GETDATE())       
               THEN 1       
               ELSE 0 END),0      
                )      
                  ) AS TotalCurrentMonth,       
               ISNULL(SUM(CASE WHEN FRMCLMN.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,      
               ISNULL(SUM(CASE WHEN FRMCLMN.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive       
               FROM MST_FormColumn (NOLOCK) FRMCLMN      
               LEFT JOIN MST_FORM  (NOLOCK) FRM  ON FRM.PK_FormId = FRMCLMN.FK_FormId      
               WHERE  ISNULL(FRMCLMN.IsDeleted,0)=0 AND      
               FRMCLMN.PK_FormColumnId  IN (CASE WHEN @iPK_FormColumnId=0 THEN FRMCLMN.PK_FormColumnId ELSE @iPK_FormColumnId END)      
               AND    
               (              
                 (case when CONVERT(CHAR(1),ISNULL(FRMCLMN.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                   
                 CASE                     
                   WHEN                       
                    (                    
                     @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                    
                    )                     
                   THEN @cSearchValue    
                   ELSE  (case when CONVERT(CHAR(1),ISNULL(FRMCLMN.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                  
                 END              
                 )              
                 
                AND    
                (              
                 convert(varchar(10),concat(isnull(month(FRMCLMN.CreatedDateTime),'0'),isnull(year(FRMCLMN.CreatedDateTime),'0'))) =                   
                 CASE                     
                   WHEN                       
                    (                    
                     @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                    
                  )                     
                   THEN convert(varchar(10),concat(month(getdate()),year(getdate())))    
                   ELSE convert(varchar(10),concat(isnull(month(FRMCLMN.CreatedDateTime),'0'),isnull(year(FRMCLMN.CreatedDateTime),'0')))    
                 END              
                 )  
      AND      
               ISNULL(FRMCLMN.Form_Name,'') LIKE          
               CASE           
                WHEN             
                 (          
                  @cSearchBy <> '' AND @cSearchBy = 'Form_Name' AND @cSearchValue <> ''          
                 )           
                THEN '%'+@cSearchValue+'%'           
                ELSE  ISNULL(FRMCLMN.Form_Name,'')         
               END        
      
               AND      
               ISNULL(FRMCLMN.Column_Name,'') LIKE          
                CASE           
                  WHEN             
                   (          
                    @cSearchBy <> '' AND @cSearchBy = 'Column_Name' AND @cSearchValue <> ''          
                   )           
                  THEN '%'+@cSearchValue+'%'           
                  ELSE  ISNULL(FRMCLMN.Column_Name,'')         
                  END       
                 END TRY                
BEGIN CATCH                
    SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                
END CATCH 




GO
/****** Object:  StoredProcedure [dbo].[USP_GetFormDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************              
CreatedBy:sandeep Kumar             
CreatedDate:12-12-2019        
      
        
purpos:Get Form Master Deatils           
[dbo].[USP_GetFormDetails]            
SELECT * FROM MST_Form          
EXEC [dbo].[USP_GetFormDetails] 0,100,1,'ThisMonth',''            
****************************************************/            
CREATE PROCEDURE [dbo].[USP_GetFormDetails]          
 (          
 @iPK_FormId              BIGINT,           
 @iRowperPage             BIGINT,          
 @iCurrentPage            BIGINT,          
 @cSearchBy               NVARCHAR(50),            
 @cSearchValue            NVARCHAR(50)              
 )           
AS              
BEGIN TRY              
         SELECT 1 [Message_Id],'Success' [Message]              
         SELECT          
         ISNULL(frm.PK_FormId,0)PK_FormId,          
         ISNULL(frm.FormName, '')FormName,         
         ISNULL(form.FormName,'NA') AS ParentForm,          
         ISNULL(frm.ControllerName, '') ControllerName,        
         ISNULL(frm.ClassName,'') ClassName,         
         ISNULL(frm.Area, '') Area,        
         ISNULL(frm.FK_ParentId,0)   FK_ParentId,       
         ISNULL(frm.ActionName, '')ActionName,         
         --ISNULL(frm.FK_SolutionId,0) 
		 @iPK_FormId FK_SolutionId,         
         --ISNULL(sol.SolutionName,'NA')
		 'NA' SolutionName,          
         ISNULL(frm.IsActive,0)As IsActive,          
         ISNULL(frm.FK_MainId,0) FK_MainId,          
         ISNULL(frm.LevelId,0) LevelId,          
         ISNULL(frm.SortId,0)  SortId,          
         ISNULL(frm.[Image],'') [Image],          
         CASE WHEN frm.IsActive = 1 THEN 'Active' ELSE 'In-Active' END [Status],          
         ISNULL(FORMAT(frm.CreatedDate,'dd/MM/yyyy HH:mm'),'') CreatedDate,
		 ISNULL(frm.FormFor,'') As FormFor          
         FROM  [dbo].[MST_Form]  (NOLOCK) frm           
         --INNER JOIN  [dbo].[MST_Solution] (NOLOCK) sol          
         --ON frm.FK_SolutionId =sol.PK_SolutionId          
         LEFT JOIN [dbo].[MST_Form] (NOLOCK) form          
         ON form.PK_FormId=frm.FK_ParentId          
         where  Isnull(frm.IsDeleted,0)=0  AND         
         frm.Pk_FormId = CASE WHEN @iPK_FormId=0 THEN frm.Pk_FormId  ELSE   @iPK_FormId END        
         
         And  
    frm.IsActive in    
      (    
        Case When @cSearchBy <>''AND @cSearchBy = 'IsActive' AND @cSearchValue <> ''      
     Then @cSearchValue  ELSE frm.IsActive END      
      )    
      AND    
      convert(varchar(10),concat(isnull(month(frm.CreatedDate),'0'),isnull(year(frm.CreatedDate),'0'))) in     
      (    
        Case When @cSearchBy <>''AND @cSearchBy = 'ThisMonth' AND @cSearchValue = ''      
     Then  convert(varchar(10),concat(month(getdate()),year(getdate())))   ELSE  convert(varchar(10),concat(isnull(month(frm.CreatedDate),'0'),isnull(year(frm.CreatedDate),'0'))) END      
      )    
         
           
         AND          
         ISNULL(frm.FormName,'') LIKE              
         CASE               
           WHEN                 
            (              
             @cSearchBy <> '' AND @cSearchBy = 'FormName' AND @cSearchValue <> ''              
            )               
           THEN '%'+@cSearchValue+'%'               
           ELSE  ISNULL(frm.FormName,'')             
         END           
         AND          
         ISNULL(frm.ControllerName,'') LIKE              
         CASE               
           WHEN                 
            (              
             @cSearchBy <> '' AND @cSearchBy = 'ControllerName' AND @cSearchValue <> ''              
   )               
           THEN '%'+@cSearchValue+'%'               
           ELSE  ISNULL(frm.ControllerName,'')             
         END             
            
         AND          
         ISNULL(frm.Area,'') LIKE              
         CASE               
           WHEN                 
            (              
             @cSearchBy <> '' AND @cSearchBy = 'Area' AND @cSearchValue <> ''   
            )               
           THEN '%'+@cSearchValue+'%'               
           ELSE  ISNULL(frm.Area,'')             
         END             
         AND          
         ISNULL(frm.ActionName,'') LIKE              
         CASE               
           WHEN                 
            (              
             @cSearchBy <> '' AND @cSearchBy = 'ActionName' AND @cSearchValue <> ''              
            )               
          THEN '%'+@cSearchValue+'%'               
          ELSE  ISNULL(frm.ActionName,'')             
          END            
          
          ORDER BY frm.CreatedDate DESC              
          OFFSET (@iCurrentPage-1)*@iRowperPage ROWS               
          FETCH NEXT @iRowperPage ROWS ONLY      
  
/***********************Start Pagination **********************************/             
             
                    SELECT       
         ISNULL(COUNT (1),0)  AS TotalItem,      
         (      
      SELECT       
         ISNULL(SUM (      
      CASE       
      WHEN YEAR(frm.CreatedDate)=YEAR(GETDATE()) AND MONTH(frm.CreatedDate)=MONTH(GETDATE())       
    THEN 1       
    ELSE 0 END),0      
      )      
         ) AS TotalCurrentMonth,       
         ISNULL(SUM(CASE WHEN frm.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,      
         ISNULL(SUM(CASE WHEN frm.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive           
          FROM  [dbo].[MST_Form]  (NOLOCK) frm           
          --INNER JOIN  [dbo].[MST_Solution] (NOLOCK) sol          
          --ON frm.FK_SolutionId =sol.PK_SolutionId          
          LEFT JOIN [dbo].[MST_Form] (NOLOCK) form          
          ON form.PK_FormId=frm.FK_ParentId          
          where Isnull(frm.IsDeleted,0)=0  AND         
          frm.Pk_FormId = CASE WHEN @iPK_FormId=0 THEN frm.Pk_FormId  ELSE   @iPK_FormId END       
          
      and        
        frm.IsActive in    
      (    
        Case When @cSearchBy <>''AND @cSearchBy = 'IsActive' AND @cSearchValue <> ''      
     Then @cSearchValue  ELSE frm.IsActive END      
      )    
      AND    
      convert(varchar(10),concat(isnull(month(frm.CreatedDate),'0'),isnull(year(frm.CreatedDate),'0'))) in     
      (    
        Case When @cSearchBy <>''AND @cSearchBy = 'ThisMonth' AND @cSearchValue = ''      
     Then  convert(varchar(10),concat(month(getdate()),year(getdate())))   ELSE  convert(varchar(10),concat(isnull(month(frm.CreatedDate),'0'),isnull(year(frm.CreatedDate),'0'))) END      
      )    
          AND          
          ISNULL(frm.FormName,'') LIKE              
          CASE               
           WHEN                 
           (              
              @cSearchBy <> '' AND @cSearchBy = 'FormName' AND @cSearchValue <> ''              
             )               
            THEN '%'+@cSearchValue+'%'               
            ELSE  ISNULL(frm.FormName,'')             
          END           
          AND          
          ISNULL(frm.ControllerName,'') LIKE              
          CASE               
            WHEN                 
             (              
              @cSearchBy <> '' AND @cSearchBy = 'ControllerName' AND @cSearchValue <> ''              
             )           
            THEN '%'+@cSearchValue+'%'               
            ELSE  ISNULL(frm.ControllerName,'')             
          END             
              
          AND          
          ISNULL(frm.Area,'') LIKE              
          CASE               
            WHEN                 
             (              
              @cSearchBy <> '' AND @cSearchBy = 'Area' AND @cSearchValue <> ''              
             )               
 THEN '%'+@cSearchValue+'%'               
ELSE  ISNULL(frm.Area,'')             
          END             
         AND          
         ISNULL(frm.ActionName,'') LIKE              
          CASE               
            WHEN                 
             (              
              @cSearchBy <> '' AND @cSearchBy = 'ActionName' AND @cSearchValue <> ''              
             )               
            THEN '%'+@cSearchValue+'%'               
            ELSE  ISNULL(frm.ActionName,'')             
           END            
/***********************End Pagination **********************************/      
END TRY          
BEGIN CATCH          
 SELECT 0 [Message_Id], ERROR_MESSAGE() [Message]           
END CATCH




GO
/****** Object:  StoredProcedure [dbo].[usp_GetFormLanguageMappingList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================          
-- Author:  Vinish          
-- Create date: 2019-12-11 15:59:43.327          
-- Description: EXEC [dbo].[usp_GetFormLanguageMappingList]  0,10,1,'ThisMonth',''          
-- =============================================          
CREATE PROCEDURE [dbo].[usp_GetFormLanguageMappingList]          
@iPK_FormLanguageId               bigint,          
@iRowperPage                      bigint,          
@iCurrentPage                  bigint,          
@cSearchBy                     nvarchar(50),            
@cSearchValue                  nvarchar(50)     ,
@iUserId                INT=1,
@iFK_AccountId     BIGINT = 0,
@iFK_CustomerId   BIGINT = 0,
@cLoginType          nvarchar(100) = ''         
AS          
BEGIN try          
 SET NOCOUNT ON;          
 IF  @iPK_FormLanguageId<>0          
 BEGIN          
  SELECT 1 AS Message_Id,'Success' As Message            
  --Select          
  SELECT  FLM.*,L.LanguageFullName LanguageName,F.FormName FormName FROM          
  [dbo].[Map_FormLanguage]  FLM (NOLOCK)          
  INNER JOIN [dbo].[LKP_Language]  L (NOLOCK) ON L.PK_LanguageId=FLM.FK_LanguageId  and   ISNULL(FLM.IsDeleted,0) = 0 and FLM.PK_FormLanguageId=@iPK_FormLanguageId        
  INNER JOIN [dbo].[MST_Form] F (NOLOCK) ON F.PK_FormId = FLM.FK_FormId and   ISNULL(FLM.IsDeleted,0) = 0  and FLM.PK_FormLanguageId=@iPK_FormLanguageId        
        
  ORDER BY  1 DESC            
            
  --Count          
  SELECT COUNT(1) as TotalItem           
  FROM  [dbo].[Map_FormLanguage]  FLM (NOLOCK)         
  WHERE FLM.PK_FormLanguageId=@iPK_FormLanguageId          
 END          
 ELSE          
 BEGIN          
  SELECT 1 AS Message_Id,'Success' As Message            
  --Select      
          
  SELECT  case when concat(isnull(month(FLM.CreatedDateTime),'0'),isnull(year(FLM.CreatedDateTime),'0')) = concat(month(getdate()),year(FLM.CreatedDateTime))
  then '1' else '0' end thismonth
  ,FLM.*,L.LanguageFullName LanguageName,F.FormName FormName FROM          
  [dbo].[Map_FormLanguage]  FLM (NOLOCK)          
  INNER JOIN [dbo].[LKP_Language]  L (NOLOCK) ON L.PK_LanguageId=FLM.FK_LanguageId   and   ISNULL(FLM.IsDeleted,0) = 0         
  INNER JOIN [dbo].[MST_Form] F (NOLOCK) ON F.PK_FormId = FLM.FK_FormId  and     ISNULL(FLM.IsDeleted,0) = 0   
  where         
  (            
   (          
    ISNULL(F.FormName,'') LIKE                
    CASE                 
      WHEN                   
       (                
        @cSearchBy <> '' AND @cSearchBy = 'FormName' AND @cSearchValue <> ''                
       )                 
      THEN '%'+@cSearchValue+'%'                 
      ELSE  ISNULL(F.FormName,'')               
    END          
    )              
       AND          
   (      
    ISNULL(L.LanguageFullName,'') LIKE                
    CASE                 
      WHEN                   
       (                
        @cSearchBy <> '' AND @cSearchBy = 'LanguageName' AND @cSearchValue <> ''                
       )                 
      THEN '%'+@cSearchValue+'%'                 
      ELSE  ISNULL(L.LanguageFullName,'')               
    END           
    )   
	and
	(          
    (case when CONVERT(CHAR(1),ISNULL(FLM.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like               
    CASE                 
      WHEN                   
       (                
        @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                
       )                 
      THEN @cSearchValue
      ELSE  (case when CONVERT(CHAR(1),ISNULL(FLM.IsActive,'')) = '1' then 'Active' else 'Inactive' end )              
    END          
    )          

	and
	(          
    convert(varchar(10),concat(isnull(month(FLM.CreatedDateTime),'0'),isnull(year(FLM.CreatedDateTime),'0'))) =               
    CASE                 
WHEN                  
       (                
        @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                
    )                 
      THEN convert(varchar(10),concat(month(getdate()),year(getdate())))
      ELSE convert(varchar(10),concat(isnull(month(FLM.CreatedDateTime),'0'),isnull(year(FLM.CreatedDateTime),'0')))
    END          
    )     
   )      
   
 -------User Wise Data 
					-------Added By Vinish 2020-01-14 12:30:26.640
					and 
					1=(
                            CASE 
							WHEN @cLoginType='CUSTOMER' AND   FLM.FK_CustomerId IN (
                                                                                          SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
                                                                                          WHERE
                                                                                          IsActive=1
                                                                                          AND PK_CustomerId    = @iFK_CustomerId
                                                                                          OR ISNULL(FK_ParentCustomerId,0)    = @iFK_CustomerId
                                                                                        )  THEN 1
                             WHEN @cLoginType='COMPANY' AND (FLM.FK_AccountId IN    
                                                                                (    
                                                                                    SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                                                    INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                                                    WHERE
																					FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and
                                                                                    FMUA.IsActive=1 and FMU.IsActive=1    
                                                                                    AND @iFK_AccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')        
																					--FK_UserId=@iUserId and
                                                                                    --FMUA.IsActive=1 and FMU.IsActive=1    
                                                                                    --AND @iFK_AccountId=6  
                                                                                )    
                                                                                OR     
                                                                                ISNULL(FLM.FK_AccountId,0) =@iFK_AccountId
                                                                )  THEN 1
                            WHEN @cLoginType='RESELLER' AND FLM.FK_AccountId IN(
                                                                                 SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                                          WHERE
                                                                                          IsActive=1
                                                                                          AND PK_AccountId    = @iFK_AccountId
                                                                                          OR ISNULL(FK_ResellerId,0)    = @iFK_AccountId    
                                                                                ) THEN 1
                            WHEN @cLoginType='AFFILIATE' AND FLM.FK_AccountId IN(
  SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                WHERE
                                                                                          IsActive=1
                                                                                          AND PK_AccountId    = @iFK_AccountId
                                                                                          OR ISNULL(FK_AffiliateId,0)    = @iFK_AccountId    
                                                     ) THEN 1
                            ELSE 0
                            END
                      )
					  -------End 2020-01-14 12:31:17.690
        
  ORDER BY  1 DESC      
            
  OFFSET (@iCurrentPage-1)*@iRowperPage ROWS           
  FETCH NEXT @iRowperPage ROWS ONLY          
  --Count          
      
   SELECT--added sandeep   
         ISNULL(COUNT (1),0)  AS TotalItem,  
         (  
      SELECT   
         ISNULL(SUM (  
      CASE   
      WHEN YEAR(FLM.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(FLM.CreatedDateTime)=MONTH(GETDATE())   
    THEN 1   
    ELSE 0 END),0  
      )  
         ) AS TotalCurrentMonth,   
         ISNULL(SUM(CASE WHEN FLM.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,  
         ISNULL(SUM(CASE WHEN FLM.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive    
   --end  
   FROM [dbo].[Map_FormLanguage]  FLM (NOLOCK)          
  INNER JOIN [dbo].[LKP_Language]  L (NOLOCK) ON L.PK_LanguageId=FLM.FK_LanguageId   and   ISNULL(FLM.IsDeleted,0) = 0         
  INNER JOIN [dbo].[MST_Form] F (NOLOCK) ON F.PK_FormId = FLM.FK_FormId  and   ISNULL(FLM.IsDeleted,0) = 0   
  where         
  (            
   (          
    ISNULL(F.FormName,'') LIKE                
    CASE                 
      WHEN                   
       (                
        @cSearchBy <> '' AND @cSearchBy = 'FormName' AND @cSearchValue <> ''                
       )                 
      THEN @cSearchValue
      ELSE  ISNULL(F.FormName,'')               
    END          
    )              
       AND          
   (      
    ISNULL(L.LanguageFullName,'') LIKE                
    CASE                 
      WHEN                   
       (                
        @cSearchBy <> '' AND @cSearchBy = 'LanguageName' AND @cSearchValue <> ''                
       )                 
      THEN '%'+@cSearchValue+'%'                 
      ELSE  ISNULL(L.LanguageFullName,'')               
    END           
    )   
	and
	(          
      (case when CONVERT(CHAR(1),ISNULL(FLM.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                
    CASE                 
      WHEN                   
       (                
        @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                
       )                 
      THEN '%'+@cSearchValue+'%' 
      ELSE  (case when CONVERT(CHAR(1),ISNULL(FLM.IsActive,'')) = '1' then 'Active' else 'Inactive' end )
    END          
    )    
	and
	(          
    concat(isnull(month(FLM.CreatedDateTime),'0'),isnull(year(FLM.CreatedDateTime),'0')) =               
    CASE                 
      WHEN                   
       (                
        @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                
       )                 
      THEN concat(month(getdate()),year(getdate()))
      ELSE  concat(isnull(month(FLM.CreatedDateTime),'0'),isnull(year(FLM.CreatedDateTime),'0'))
    END          
    )           
   )     
   
   
 -------User Wise Data 
					-------Added By Vinish 2020-01-14 12:30:26.640
					and 
					1=(
                            CASE 
							WHEN @cLoginType='CUSTOMER' AND   FLM.FK_CustomerId IN (
                                                                                          SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
           WHERE
                                    IsActive=1
                                                                                          AND PK_CustomerId    = @iFK_CustomerId
                                                                                          OR ISNULL(FK_ParentCustomerId,0)    = @iFK_CustomerId
                 )  THEN 1
                             WHEN @cLoginType='COMPANY' AND (FLM.FK_AccountId IN    
                                                                                (    
                                                                                    SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                                                    INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                                                    WHERE
																					FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and
                                                                                    FMUA.IsActive=1 and FMU.IsActive=1    
                                                                                    AND @iFK_AccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')        
																					--FK_UserId=@iUserId and
                                                                                    --FMUA.IsActive=1 and FMU.IsActive=1    
                                                                                    --AND @iFK_AccountId=6    
                                                                                )    
                                                                                OR     
                                                                                ISNULL(FLM.FK_AccountId,0) =@iFK_AccountId
                                                                )  THEN 1
                            WHEN @cLoginType='RESELLER' AND FLM.FK_AccountId IN(
                                                                                 SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                                          WHERE
                                                                                          IsActive=1
                                                                                          AND PK_AccountId    = @iFK_AccountId
                                                                                          OR ISNULL(FK_ResellerId,0)    = @iFK_AccountId    
                                                                                ) THEN 1
                            WHEN @cLoginType='AFFILIATE' AND FLM.FK_AccountId IN(
                                                                                 SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                                          WHERE
                                                                                          IsActive=1
                                                                                          AND PK_AccountId    = @iFK_AccountId
                                                                                          OR ISNULL(FK_AffiliateId,0)    = @iFK_AccountId    
                                                                                ) THEN 1
                            ELSE 0
                            END
                      )
					  -------End 2020-01-14 12:31:17.690      
  ORDER BY  1 DESC             
 END          
end TRY          
BEGIN CATCH           
SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message           
END CATCH; 








GO
/****** Object:  StoredProcedure [dbo].[USP_GetFormRoleMapping]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
Created By: Sandeep kumar
Created Date: 2019-12-02
select * from Map_FormLanguage
Purpose: Get user form role rights
EXEC [dbo].[usp_GetFormRoleMapping] 1,''
*******************************************************************/	
CREATE PROCEDURE [dbo].[USP_GetFormRoleMapping]
(
	@iRoleId   bigint,
	@cLanguage nvarchar(100)
)
AS	
BEGIN	

	IF(ISNULL(@cLanguage,'')<> '' AND LTRIM(RTRIM(ISNULL(@cLanguage,'')))<>'' AND UPPER(LTRIM(RTRIM(ISNULL(@cLanguage,''))))<>'ENGLISH')
	BEGIN
		SELECT
		 ISNULL(PK_FormId,0)PK_FormId
		,ISNULL(form.FK_ParentId,0) ParentId
		,ISNULL(form.FK_SolutionId,0)FK_SolutionId
		,ISNULL(RoleName,'')RoleName
		,ISNULL(ControllerName,'')ControllerName	
		,ISNULL(ActionName,'')ActionName		
		,ISNULL(LevelId,0)LevelId
		,ISNULL(FK_MainId,0) MainId
		,ISNULL(SortId,0)	SortId
		,IsNULL([Image],'') [Image]
		,IsNULL(CanAdd	,0)CanAdd
		,IsNULL(CanEdit,0)CanEdit	
		,IsNULL(CanDelete,0)CanDelete	
		,IsNULL(CanView,0)CanView
		,IsNULL(ClassName,'') ClassName
		,ISNULL(frole.HomePage,0) HomePage
		,ISNULL(form.Area,'') Area
		,ISNULL(lkplang.LanguageFullName,0) LanguageFullName
		 FROM MAP_FormRole  (NOLOCK) map
		 INNER JOIN MST_Form(NOLOCK) form  on form.PK_FormId=map.FK_FormId
		 INNER JOIN MST_Role(NOLOCK) frole on map.FK_RoleId=frole.PK_RoleId
		 LEFT JOIN [dbo].[Map_FormLanguage](NOLOCK) mapFormLang ON form.PK_FormId = mapFormLang.FK_FormId
	     LEFT JOIN LKP_Language(NOLOCK)  lkplang ON  mapFormLang.FK_LanguageId=lkplang.PK_LanguageId
		 WHERE map.CanView=1  and  map.FK_RoleId=@iRoleId and  ISNULL(form.IsDeleted,0)=0
		 AND ISNULL(lkplang.[LanguageFullName],'')  = @cLanguage	
		 ORDER BY FormName
	END
	ELSE
	BEGIN
		 SELECT
		 DISTINCT
		 form.FormName FormName
		,PK_FormId
		,ISNULL(form.FK_ParentId,0) ParentId
	    ,ISNULL(form.FK_SolutionId,0)FK_SolutionId
		,ISNULL(RoleName,''	)RoleName	
		,ISNULL(ControllerName,'')ControllerName
		,ISNULL(ActionName,'')ActionName		
		,ISNULL(LevelId,0)LevelId
		,ISNULL(FK_MainId,0) MainId
		,ISNULL(SortId,0)SortId	 
		,IsNULL([Image],'') [Image]
	    ,IsNULL(CanAdd	,0)CanAdd
		,IsNULL(CanEdit,0)CanEdit	
		,IsNULL(CanDelete,0)CanDelete	
		,IsNULL(CanView,0)CanView
		,IsNULL(ClassName,'') ClassName
		,ISNULL(frole.HomePage,0) HomePage
		,ISNULL(form.Area,'') Area
		,'English' LanguageFullName
		FROM MAP_FormRole  (NOLOCK) map
		INNER JOIN MST_Form(NOLOCK) form  on form.PK_FormId=map.FK_FormId
		INNER JOIN MST_Role(NOLOCK) frole on map.FK_RoleId=frole.PK_RoleId		
		WHERE map.CanView=1  and  map.FK_RoleId=@iRoleId and ISNULL(form.IsDeleted,0)=0
		ORDER BY FormName
	END
END








GO
/****** Object:  StoredProcedure [dbo].[usp_getForms]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************  
CREATED BY:Vinish 
CREATED DATE : 2019-12-12 11:43:02.987
PURPOSE:  To get all Forms
EXEC [dbo].[usp_getForms]
**********************************************************/  
CREATE PROCEDURE [dbo].[usp_getForms]   
AS  
BEGIN   
SELECT FRM.PK_FormId ,FRM.FormName  
from MST_Form FRM
where IsActive = 1 and IsDeleted = 0
END   



GO
/****** Object:  StoredProcedure [dbo].[USP_GetMapFormAccountDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************                                
Created By: Sandeep Kumar        
Created Date:18-12-2019          
Purpose: Get Form Account Mapping Details                       
EXEC [dbo].[USP_GetMapFormAccountDetails]   0,1,10,1,'',' ',1                        
*******************************************************************/         
CREATE PROCEDURE [dbo].[USP_GetMapFormAccountDetails]                      
(           
    --declare                    
  @iPK_FormAccountId  BIGINT--=0               
 ,@iFK_AccountID     BIGINT--=1                   
 ,@iRowperPage       INT --=10 --=10    --2                    
 ,@iCurrentPage      INT=1--=0    --1                    
 ,@cSearchBy         NVARCHAR(50) --='FormName' --=''--''                        
 ,@cSearchValue      NVARCHAR(50)--='user'--='' --''                    
 ,@iUserid           BIGINT--=1  
 ,@iFK_CustomerId     BIGINT--=1  
 ,@cLoginType      NVARCHAR(50)=''                
)                          
AS                          
BEGIN TRY                    
        SELECT 1 AS Message_Id,'Success' AS Message                    
  SELECT        
  frma.PK_FormAccountId AS PK_FormAccountId,         
  frma.FK_CategoryId AS FK_CategoryId,        
  frma.IsCustomerAccount AS IsCustomerAccount,        
  ISNULL(ct.CategoryName,'') AS CategoryName,        
  frma.FK_AccountId AS FK_AccountId,        
  ISNULL(acc.AccountName,'')AS  AccountName,        
  frma.FK_FormId AS FK_FormId,        
  ISNULL(fm.FormName,'')  AS FormName,        
  frma.IsActive AS IsActive,        
  CASE WHEN frma.IsActive = 1 THEN 'Active' ELSE 'InActive' END AS [Status],        
  FORMAT(frma.CreatedDateTime,'dd/MM/yyyy HH:mm') AS CreatedDateTime        
  FROM Map_FormAccount(NOLOCK) frma        
  LEFT JOIN MST_Category(NOLOCK)   ct  ON frma.FK_CategoryId = ct.PK_CategoryId        
  LEFT JOIN MST_Account(NOLOCK)    acc     ON frma.FK_AccountId = acc.PK_AccountId        
  LEFT JOIN [dbo].[MST_Form] (NOLOCK) fm ON frma.FK_FormId = fm.PK_FormId        
  WHERE 
         PK_FormAccountId= CASE 
                                WHEN @iPK_FormAccountId <> 0 
					        	THEN @iPK_FormAccountId 
					        	ELSE PK_FormAccountId
				            END        
  AND 
  ISNULL(frma.IsDeleted,0)=0
  AND
     1=(
         CASE WHEN @cLoginType='CUSTOMER' AND  @iFK_CustomerId IN (
                                                                       SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
                                                                       WHERE
                                                                       IsActive=1
                                                                       AND PK_CustomerId    = @iFK_CustomerId
                                                                       OR ISNULL(FK_ParentCustomerId,0)    = @iFK_CustomerId
                                                                     )  THEN 1
          WHEN @cLoginType='COMPANY' AND (frma.FK_AccountId IN    
                                                             (    
                                                                 SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                                 INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                                 WHERE FK_UserId=@iUserId and
                                                                 FMUA.IsActive=1 and FMU.IsActive=1    
                                                                 AND @iFK_AccountId=6    
                                                             )    
                                                             OR     
                                                             ISNULL(frma.FK_AccountId,0) =@iFK_AccountId
                 )  THEN 1
         WHEN @cLoginType='RESELLER' AND frma.FK_AccountId IN(
                                                              SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                       WHERE
                                                                       IsActive=1
                                                                       AND PK_AccountId    = @iFK_AccountId
                                                                       OR ISNULL(FK_ResellerId,0)    = @iFK_AccountId    
                                                             ) THEN 1
         WHEN @cLoginType='AFFILIATE' AND frma.FK_AccountId IN(
                                                              SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                       WHERE
                                                                       IsActive=1
                                                                       AND PK_AccountId    = @iFK_AccountId
                                                                       OR ISNULL(FK_AffiliateId,0)    = @iFK_AccountId    
                                                             ) THEN 1
         ELSE 0
         END
      )
   AND  
      (           
      (CASE WHEN CONVERT(CHAR(1),ISNULL(frma.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) LIKE                 
        CASE                   
             WHEN                     
                 (                  
                  @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue)) <> ''                  
                 )                   
              THEN @cSearchValue  
              ELSE  (case when CONVERT(CHAR(1),ISNULL(frma.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                
        END            
      )           
   AND  
      (            
      CONVERT(varchar(10),concat(isnull(month(frma.CreatedDateTime),'0'),ISNULL(year(frma.CreatedDateTime),'0'))) =                 
      CASE                   
        WHEN                     
         (                  
          @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                  
         )                   
        THEN convert(varchar(10),concat(month(getdate()),year(getdate())))  
        ELSE convert(varchar(10),concat(isnull(month(frma.CreatedDateTime),'0'),isnull(year(frma.CreatedDateTime),'0')))  
      END            
      )
   AND                         
     (                        
       ISNULL(acc.AccountName,'') LIKE                            
            CASE                             
                WHEN                               
                   (                            
                      @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
                   )                             
                THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                              
                ELSE  ISNULL(acc.AccountName,'')                           
            END                        
      )                                       
   AND                         
      (                        
         ISNULL(fm.FormName,'') LIKE                            
           CASE                             
               WHEN                               
                   (                            
                    @cSearchBy <> '' AND @cSearchBy = 'FormName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
                    )                             
               THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                              
               ELSE  ISNULL(fm.FormName,'')                           
           END                        
      )                                    
   AND                         
      (                        
        ISNULL(ct.CategoryName,'') LIKE                            
          CASE                             
             WHEN                               
                 (                            
                   @cSearchBy <> '' AND @cSearchBy = 'CategoryName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                           )                             
            THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                              
            ELSE  ISNULL(ct.CategoryName,'')                           
          END                        
      )                       
                        
      ORDER BY 1 DESC                        
                            
      OFFSET (@iCurrentPage-1)*@iRowperPage ROWS                             
      FETCH NEXT @iRowperPage ROWS ONLY                        
          
		  
		  
		  
		  /*Query For Count Total Items In Grid*/              
     SELECT 
     ISNULL(COUNT (1),0)  AS TotalItem,
     (
      SELECT 
      ISNULL(SUM(
       CASE 
           WHEN YEAR(frma.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(frma.CreatedDateTime)=MONTH(GETDATE()) 
           THEN 1 
           ELSE 0 
	    END),0
                )
     ) AS TotalCurrentMonth, 
     ISNULL(SUM(CASE WHEN frma.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,
     ISNULL(SUM(CASE WHEN frma.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive         
     FROM Map_FormAccount(NOLOCK) frma        
     LEFT JOIN MST_Category(NOLOCK)   ct  ON frma.FK_CategoryId = ct.PK_CategoryId        
     LEFT JOIN MST_Account(NOLOCK)    acc     ON frma.FK_AccountId = acc.PK_AccountId        
     LEFT JOIN [dbo].[MST_Form] (NOLOCK) fm ON frma.FK_FormId = fm.PK_FormId        
     WHERE 
     PK_FormAccountId= CASE WHEN @iPK_FormAccountId <> 0 THEN @iPK_FormAccountId ELSE PK_FormAccountId END        
     AND
     ISNULL(frma.IsDeleted,0)=0
     AND
     1=(
         CASE WHEN @cLoginType='CUSTOMER' AND  @iFK_CustomerId IN (
                                                                       SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
                                                                       WHERE
                                                                       IsActive=1
                                                                       AND PK_CustomerId    = @iFK_CustomerId
                                                                       OR ISNULL(FK_ParentCustomerId,0)    = @iFK_CustomerId
                                                                     )  THEN 1
          WHEN @cLoginType='COMPANY' AND (frma.FK_AccountId IN    
                                                             (    
                                                                 SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                                 INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                                 WHERE FK_UserId=@iUserId and
                                                                 FMUA.IsActive=1 and FMU.IsActive=1    
                                                                 AND @iFK_AccountId=6    
                                                             )    
                                                             OR     
                                                             ISNULL(frma.FK_AccountId,0) =@iFK_AccountId
                                             )  THEN 1
         WHEN @cLoginType='RESELLER' AND frma.FK_AccountId IN(
                                    SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                       WHERE
                                                                       IsActive=1
                                                                       AND PK_AccountId    = @iFK_AccountId
                                                                       OR ISNULL(FK_ResellerId,0)    = @iFK_AccountId    
                                                             ) THEN 1
         WHEN @cLoginType='AFFILIATE' AND frma.FK_AccountId IN(
                                                              SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                       WHERE
                                                                       IsActive=1
                                                                       AND PK_AccountId    = @iFK_AccountId
                                                                       OR ISNULL(FK_AffiliateId,0)    = @iFK_AccountId    
                                                             ) THEN 1
         ELSE 0
         END
        )
     AND  
       (            
          (case when CONVERT(CHAR(1),ISNULL(frma.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                 
           CASE                   
               WHEN                     
                (                  
                 @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue)) <> ''                  
                )                   
               THEN @cSearchValue  
               ELSE  (case when CONVERT(CHAR(1),ISNULL(frma.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                
            END            
        )            
    AND  
       (            
        CONVERT(varchar(10),concat(isnull(month(frma.CreatedDateTime),'0'),isnull(year(frma.CreatedDateTime),'0'))) =                 
        CASE                   
            WHEN                     
             (                  
              @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                  
             )                   
            THEN convert(varchar(10),concat(month(getdate()),year(getdate())))  
            ELSE convert(varchar(10),concat(isnull(month(frma.CreatedDateTime),'0'),isnull(year(frma.CreatedDateTime),'0')))  
        END            
       )
    AND                         
      (                        
           ISNULL(acc.AccountName,'') LIKE                            
           CASE                             
               WHEN                               
                   (                            
                      @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
                   )                             
                THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                              
                ELSE  ISNULL(acc.AccountName,'')                           
            END                        
       )                                     
     AND                         
      (                        
           ISNULL(fm.FormName,'') LIKE                            
           CASE                             
              WHEN                               
                  (                            
                   @cSearchBy <> '' AND @cSearchBy = 'FormName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
                   )                             
              THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                              
              ELSE  ISNULL(fm.FormName,'')                  
           END                        
        )                                
    AND                         
      (                        
           ISNULL(ct.CategoryName,'') LIKE                            
           CASE                             
           WHEN                               
                 (                            
                  @cSearchBy <> '' AND @cSearchBy = 'CategoryName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                           )                             
             THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                              
            ELSE  ISNULL(ct.CategoryName,'')                           
           END                        
       )
 END TRY                    
 BEGIN CATCH                                                                                    
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                     
                                                                                
 END CATCH   









GO
/****** Object:  StoredProcedure [dbo].[usp_GetMapUserAccountDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************                    
Created By: Prince kumar srivastva                
Created Date:12-12-2019                   
Purpose: Get User Account Mapping Details   
SELECT * FROM MAP_UserAccount              
EXEC [dbo].[usp_GetMapUserAccountDetails]   0,1,100,1,'',''               
*******************************************************************/                    
CREATE PROCEDURE [dbo].[usp_GetMapUserAccountDetails]                
(     
--declare                   
  @PK_UserAccountId  BIGINT=0--0              
 ,@iFK_AccountID    BIGINT=1--1              
 ,@iRowperPage   INT =1 --=10    --2              
 ,@iCurrentPage  INT=10--=0    --1              
 ,@cSearchBy     VARCHAR(50) ='' --=''--''                  
 ,@cSearchValue     VARCHAR(50)=''--='' --''              
 ,@iUserid BIGINT=''--=1 
 ,@iFK_CustomerId BIGINT=0,
  @cLoginType nvarchar(100)=''      --1              
)                    
AS                    
BEGIN TRY              
        SELECT 1 AS Message_Id,'Success' AS Message              
               
        SELECT   
        ISNULL(MAPUA.FK_CategoryId,0) AS  FK_CategoryId,         
        ISNULL(MSTCAT.CategoryName,'')AS CategoryName,            
        ISNULL(FMA.AccountName,'')AS AccountName,                 
        ISNULL(FMU.UserName,'') AS UserName,              
        ISNULL(MAPUA.PK_UserAccountId,0) AS PK_UserAccountId,              
        ISNULL(MAPUA.FK_UserId,0) AS FK_UserId,              
        ISNULL(MAPUA.FK_AccountId,0) AS FK_AccountId,              
        ISNULL(MAPUA.IsActive,0) AS IsActive,            
        ISNULL(FMR.RoleName,'') AS RoleName,          
        CASE WHEN ISNULL(MAPUA.IsActive,0)=0 THEN 'InActive' ELSE 'Active' END AS CurrentStatus,           
        ISNULL(CONVERT(VARCHAR(20),MAPUA.CreatedDateTime,103),'') AS CreatedDateTime,              
        ISNULL(MAPUA.UpdatedBy,0) AS UpdatedBy,              
        ISNULL(CONVERT(VARCHAR(20),MAPUA.UpdatedDateTime,103),'')AS UpdatedDateTime ,      
        ISNULL(MAPUA.IsCustomerAccount,0) AS IsCustomerAccount            
        FROM MAP_UserAccount(NOLOCK)MAPUA              
        INNER JOIN MST_User(NOLOCK)FMU              
        ON FMU.PK_UserId=MAPUA.FK_UserId              
        LEFT JOIN MST_Account(NOLOCK)FMA              
        ON FMA.PK_AccountId=MAPUA.FK_AccountId             
        LEFT JOIN MST_Category(NOLOCK)MSTCAT               
        ON MSTCAT.PK_CategoryId=FMA.FK_CategoryId            
        LEFT JOIN MST_Role(NOLOCK)FMR            
        ON FMR.PK_RoleId=FMU.FK_RoleId            
        WHERE 
		ISNULL(MAPUA.IsDeleted,0)=0  
        AND  
		MAPUA.PK_UserAccountId=CASE WHEN @PK_UserAccountId=0 THEN MAPUA.PK_UserAccountId ELSE @PK_UserAccountId END 
		AND 
		1=(
                CASE WHEN @cLoginType='CUSTOMER' AND   @iFK_CustomerId IN (
                                                                              SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
                                                                              WHERE
                                                                              IsActive=1
                                                                              AND PK_CustomerId    = @iFK_CustomerId
                                                                              OR ISNULL(FK_ParentCustomerId,0)    = @iFK_CustomerId
                                                                            )  THEN 1
                 WHEN @cLoginType='COMPANY' AND (MAPUA.FK_AccountId IN    
                                                                    (    
                                                                        SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                                        INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                                        WHERE FK_UserId=@iUserId and
                                                                        FMUA.IsActive=1 and FMU.IsActive=1    
                                                                        AND @iFK_AccountId=6    
                                                                    )    
                                                                    OR     
                                                                    ISNULL(MAPUA.FK_AccountId,0) =@iFK_AccountId
                                                    )  THEN 1
                WHEN @cLoginType='RESELLER' AND @iFK_AccountID IN(
                                                                     SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                              WHERE
                                                                              IsActive=1
                                                                              AND PK_AccountId    = @iFK_AccountId
                                                                              OR ISNULL(FK_ResellerId,0)    = @iFK_AccountId    
                                                                    ) THEN 1
                WHEN @cLoginType='AFFILIATE' AND @iFK_AccountID IN(
                                                                     SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                              WHERE
                                                                              IsActive=1
                                                                              AND PK_AccountId    = @iFK_AccountId
                                                                              OR ISNULL(FK_AffiliateId,0)    = @iFK_AccountId    
                                                                    ) THEN 1
                ELSE 0
                END
          )
		AND  
         (            
          (CASE WHEN CONVERT(CHAR(1),ISNULL(MAPUA.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                 
                CASE                   
                    WHEN                     
                     (                  
                      @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue)) <> ''                  
                     )                   
                    THEN @cSearchValue  
                    ELSE  (case when CONVERT(CHAR(1),ISNULL(MAPUA.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                
                END            
         )            
        AND  
        (            
          CONVERT(varchar(10),concat(isnull(month(MAPUA.CreatedDateTime),'0'),isnull(year(MAPUA.CreatedDateTime),'0'))) =                 
          CASE                   
            WHEN                     
             (                  
              @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                  
             )                   
            THEN convert(varchar(10),concat(month(getdate()),year(getdate())))  
            ELSE convert(varchar(10),concat(isnull(month(MAPUA.CreatedDateTime),'0'),isnull(year(MAPUA.CreatedDateTime),'0')))  
          END            
        )                
        AND                   
         (                  
            ISNULL(FMU.UserName,'') LIKE    
            CASE                       
                WHEN                         
                   (                      
                      @cSearchBy <> '' AND @cSearchBy = 'UserName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                      
                   )                       
                THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                        
                ELSE  ISNULL(FMU.UserName,'')                     
            END         
           )                          
       AND     
          (                
              ISNULL(FMA.AccountName,'') LIKE                      
                CASE                       
                   WHEN                         
                       (                      
                       @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                      
                        )                       
                   THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                        
                   ELSE  ISNULL(FMA.AccountName,'')                     
                  END                  
           )                         
       AND                   
          (                  
              ISNULL(MSTCAT.CategoryName,'') LIKE                      
                CASE                       
                    WHEN                         
                      (                      
                       @cSearchBy <> '' AND @cSearchBy = 'AccountCategory' AND LTRIM(RTRIM(@cSearchValue)) <> ''
					  )                                                    
                   THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                        
                   ELSE  ISNULL(MSTCAT.CategoryName,'')                     
                END                  
            )                 
                     
      ORDER BY 1 DESC                        
      OFFSET (@iCurrentPage-1)*@iRowperPage ROWS                       
      FETCH NEXT @iRowperPage ROWS ONLY                  
            
			
			
			/*Query For Total Count On Grid*/      
        SELECT 
        ISNULL(COUNT (1),0)  AS TotalItem,
        (
	    SELECT 
        ISNULL(SUM (
	    CASE 
	    WHEN YEAR(MAPUA.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(MAPUA.CreatedDateTime)=MONTH(GETDATE()) 
	 	THEN 1 
	 	ELSE 0 END),0
	    )
        ) AS TotalCurrentMonth, 
        ISNULL(SUM(CASE WHEN MAPUA.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,
        ISNULL(SUM(CASE WHEN MAPUA.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive                          
        FROM MAP_UserAccount(NOLOCK)MAPUA              
        INNER JOIN MST_User(NOLOCK)FMU              
        ON FMU.PK_UserId=MAPUA.FK_UserId              
        LEFT JOIN MST_Account(NOLOCK)FMA              
        ON FMA.PK_AccountId=MAPUA.FK_AccountId             
        LEFT JOIN MST_Category(NOLOCK)MSTCAT               
        ON MSTCAT.PK_CategoryId=FMA.FK_CategoryId            
        LEFT JOIN MST_Role(NOLOCK)FMR            
        ON FMR.PK_RoleId=FMU.FK_RoleId               
        WHERE
		ISNULL(MAPUA.IsDeleted,0)=0  
        AND  
		MAPUA.PK_UserAccountId= ( CASE WHEN @PK_UserAccountId=0 THEN MAPUA.PK_UserAccountId ELSE @PK_UserAccountId END)              
        AND 
		    1=(
                CASE WHEN @cLoginType='CUSTOMER' AND   @iFK_CustomerId IN (
                                                                              SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
                                                                              WHERE
                                                                              IsActive=1
                                                                              AND PK_CustomerId    = @iFK_CustomerId
                                                                              OR ISNULL(FK_ParentCustomerId,0)    = @iFK_CustomerId
                                                                            )  THEN 1
                 WHEN @cLoginType='COMPANY' AND (MAPUA.FK_AccountId IN    
                                                                    (    
                                                                        SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                                        INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                                        WHERE FK_UserId=@iUserId and
                                                                        FMUA.IsActive=1 and FMU.IsActive=1    
                                                                        AND @iFK_AccountId=6    
                                                                    )    
                                                                    OR     
                                                                    ISNULL(MAPUA.FK_AccountId,0) =@iFK_AccountId
                                                    )  THEN 1
                WHEN @cLoginType='RESELLER' AND @iFK_AccountID IN(
                                                                     SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                              WHERE
                                                                              IsActive=1
                                                                              AND PK_AccountId    = @iFK_AccountId
                                                                              OR ISNULL(FK_ResellerId,0)    = @iFK_AccountId    
                                                                    ) THEN 1
                WHEN @cLoginType='AFFILIATE' AND @iFK_AccountID IN(
                                                                     SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
                                                                              WHERE
                                                                              IsActive=1
                                                                              AND PK_AccountId    = @iFK_AccountId
                                                                              OR ISNULL(FK_AffiliateId,0)    = @iFK_AccountId    
                                                                    ) THEN 1
                ELSE 0
                END
              )
		AND  
        (            
          (CASE WHEN CONVERT(CHAR(1),ISNULL(MAPUA.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                 
              CASE                   
                 WHEN                     
                  (                  
                   @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue ))<> ''                  
                  )                   
                 THEN @cSearchValue  
                 ELSE  (case when CONVERT(CHAR(1),ISNULL(MAPUA.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                
             END            
         )            
       AND  
           (            
             CONVERT(varchar(10),concat(isnull(month(MAPUA.CreatedDateTime),'0'),isnull(year(MAPUA.CreatedDateTime),'0'))) =                 
              CASE                   
                WHEN                     
                 (                  
                  @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                  
                 )                   
                THEN convert(varchar(10),concat(month(getdate()),year(getdate())))  
                ELSE convert(varchar(10),concat(isnull(month(MAPUA.CreatedDateTime),'0'),isnull(year(MAPUA.CreatedDateTime),'0')))  
              END            
            )        
      AND                   
        (                  
         ISNULL(FMU.UserName,'') LIKE                      
            CASE                       
                WHEN                         
                   (                      
                      @cSearchBy <> '' AND @cSearchBy = 'UserName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                      
                   )                       
                THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                        
                ELSE  ISNULL(FMU.UserName,'')                     
            END                  
        )                         
      AND                   
        (                  
           ISNULL(FMA.AccountName,'') LIKE                      
           CASE                       
                WHEN                         
                   (                      
                   @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                      
                    )       
                 THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                        
                 ELSE  ISNULL(FMA.AccountName,'')                     
            END                  
        )                      
      AND    
       (                  
           ISNULL(MSTCAT.CategoryName,'') LIKE                      
           CASE                       
              WHEN                         
                  (                      
                    @cSearchBy <> '' AND @cSearchBy = 'AccountCategory' AND LTRIM(RTRIM(@cSearchValue)) <> ''
				  )                       
              THEN '%'+RTRIM(LTRIM(@cSearchValue))+'%'                        
              ELSE  ISNULL(MSTCAT.CategoryName,'')                     
              END                  
       )                       
       ORDER BY 1 DESC               
 END TRY              
 BEGIN CATCH   
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message               
                                                                          
 END CATCH              
              
                   
                  
              
              
              
              
              
              
              











GO
/****** Object:  StoredProcedure [dbo].[USP_GetParentForms]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/******************************************        
CreatedBy:sandeep Kumar       
CreatedDate:12-12-2019      
purpos: GetParentId DROPDOWN    
EXEC [dbo].[USP_GetParentForms]   
****************************************************/        
CREATE PROCEDURE [dbo].[USP_GetParentForms]    
AS    
BEGIN 
SELECT 1 AS Message_Id,'Success' AS Message        
 SELECT     
      ISNULL(Pk_FormId,0)Pk_FormId,
      ISNULL(FormName ,'') FormName  
      FROM MST_Form(NOLOCK)     
      WHERE IsActive = 1 AND ISNULL(FK_ParentId,0) = 0    
END    
  
  



GO
/****** Object:  StoredProcedure [dbo].[USP_GetRoleDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Vinish 
CreatedDate:12-12-2019  
purpos:Get Role Master  Deatils 
[dbo].[USP_GetRoleDetails]      

EXEC [dbo].[USP_GetRoleDetails] 0,10,1,'','',1,1,'COMPANY',0

****************************************************/  
CREATE PROCEDURE [dbo].[USP_GetRoleDetails]    
(    
  @iPK_RoleId        BIGINT,
  @iRowperPage       BIGINT, 
  @iCurrentPage      BIGINT, 
  @cSearchBy         NVARCHAR(50),    
  @cSearchValue      NVARCHAR(50) ,
  @iFK_AccountId     INT=1,
  @iUserId           INT=1,
  @cLogInType VARCHAR(100)='',
  @iFK_CompanyId BIGINT=0
  )  
AS
BEGIN TRY 
	     SELECT 1 AS Message_Id,'Success' AS Message 
         SELECT 
         ISNULL(rol.PK_Roleid,0)PK_Roleid,
	     ISNULL(rol.RoleName,'')RoleName,
		 ISNULL(null,'') RoleFor,
		 '' CustomerName,
		 '' CompanyName,
		 ISNULL(rol.FK_CustomerId,0)FK_CustomerId,
		 ISNULL(rol.FK_CompanyId,0)FK_CompanyId,
	     ISNULL(rol.FK_CategoryId,0)FK_CategoryId,
	     ''  CategoryName,
	     ISNULL(rol.FK_AccountId,0)FK_AccountId,
	     ISNULL(acc.AccountName,'')  AccountName,
	     ISNULL(frm.FormName,'')     FormName,
	     ISNULL(rol.IsActive,0)IsActive,
	     CASE WHEN rol.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status],
	     FORMAT(rol.CreatedDateTime,'dd/MM/yyyy') CreatedDateTime,
	     ISNULL(rol.HomePage,0)HomePage,
		 ISNULL(acc.FK_CategoryId,0)AS AccountCategoryId
	      FROM MST_Role(NOLOCK) rol

         INNER JOIN MST_Account      (NOLOCK)   acc ON rol.FK_AccountId = acc.PK_AccountId AND   Isnull(acc.IsDeleted,0)=0 
	     INNER JOIN [dbo].[MST_Form] (NOLOCK)   frm ON rol.HomePage = frm.PK_FormId AND  Isnull(frm.IsDeleted,0)=0
		 
	     WHERE 
	     Isnull(rol.IsDeleted,0)=0    
		 
	   AND
	   rol.PK_RoleId  IN (CASE WHEN @iPK_RoleId=0 THEN rol.PK_RoleId ELSE @iPK_RoleId END) 
	   AND
	   ISNULL(rol.RoleName,'') LIKE    
       CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'RoleName' AND LTRIM(RTRIM(@cSearchValue)) <> ''    
            )     
           THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'     
           ELSE  ISNULL(rol.RoleName,'')   
     END  
	  
	 AND
	   (
			ISNULL(acc.AccountName,'') LIKE    
				CASE     
					WHEN       
					(    
					 @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''    
					)     
				THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'     
			ELSE  ISNULL(acc.AccountName,'')   
			END
		
		)
		    AND
	    ISNULL(frm.FormName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'FormName' AND LTRIM(RTRIM(@cSearchValue)) <> ''    
            )     
           THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'     
           ELSE  ISNULL(frm.FormName,'')   
         END 
		 
	and  
    (            
    (case when CONVERT(CHAR(1),ISNULL(rol.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                 
    CASE                   
      WHEN                     
       (                  
        @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue)) <> ''                  
       )                   
      THEN @cSearchValue  
      ELSE  (case when CONVERT(CHAR(1),ISNULL(rol.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                
    END            
    )            
  
 and  
 (            
    convert(varchar(10),concat(isnull(month(rol.CreatedDateTime),'0'),isnull(year(rol.CreatedDateTime),'0'))) =                 
    CASE 
      WHEN                     
       (     
       @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                  
    )                   
      THEN convert(varchar(10),concat(month(getdate()),year(getdate())))  
      ELSE convert(varchar(10),concat(isnull(month(rol.CreatedDateTime),'0'),isnull(year(rol.CreatedDateTime),'0')))  
    END   
    )   
	     ORDER BY rol.CreatedDateTime DESC    
         OFFSET (@iCurrentPage-1)*@iRowperPage ROWS     
         FETCH NEXT @iRowperPage ROWS ONLY 
	     SELECT 
         ISNULL(COUNT (1),0)  AS TotalItem,
         (
	     SELECT 
         ISNULL(SUM (
	     CASE 
	     WHEN YEAR(rol.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(rol.CreatedDateTime)=MONTH(GETDATE()) 
	 	 THEN 1 
	 	 ELSE 0 END),0
	     )
         ) AS TotalCurrentMonth, 
         ISNULL(SUM(CASE WHEN rol.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,
         ISNULL(SUM(CASE WHEN rol.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive  
	     FROM MST_Role(NOLOCK) rol
         
         INNER JOIN MST_Account      (NOLOCK)   acc ON rol.FK_AccountId = acc.PK_AccountId AND   Isnull(acc.IsDeleted,0)=0 
	     INNER JOIN [dbo].[MST_Form] (NOLOCK)   frm ON rol.HomePage = frm.PK_FormId AND  Isnull(frm.IsDeleted,0)=0
		 
	     WHERE 
	     Isnull(rol.IsDeleted,0)=0  
		 
	   AND
	   rol.PK_RoleId  IN (CASE WHEN @iPK_RoleId=0 THEN rol.PK_RoleId ELSE @iPK_RoleId END) 
	   AND
			ISNULL(rol.RoleName,'') LIKE    
			CASE     
			    WHEN       
			     (    
			      @cSearchBy <> '' AND @cSearchBy = 'RoleName' AND LTRIM(RTRIM(@cSearchValue)) <> ''    
			     )     
			    THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'     
			    ELSE  ISNULL(rol.RoleName,'')   
			END  
	 
	   AND
	   (
			ISNULL(acc.AccountName,'') LIKE    
				CASE     
					WHEN       
					(    
					 @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''    
					)     
				THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'     
			ELSE  ISNULL(acc.AccountName,'')   
			END
		
		)  
		AND
			ISNULL(frm.FormName,'') LIKE    
				CASE     
					WHEN       
					(    
					  @cSearchBy <> '' AND @cSearchBy = 'FormName' AND LTRIM(RTRIM(@cSearchValue)) <> ''    
					)     
			THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'     
			ELSE  ISNULL(frm.FormName,'')   
			END 
		 
	AND  
    (            
		(
			CASE WHEN CONVERT(CHAR(1),ISNULL(rol.IsActive,'')) = '1' then 'Active' else 'Inactive' end 
		) LIKE                 
		CASE                   
			WHEN                     
			 (                  
			  @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue)) <> ''                  
			 )                   
		THEN @cSearchValue  
		ELSE  (case when CONVERT(CHAR(1),ISNULL(rol.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                
		END            
    )            
  
 AND  
 (            
    convert(varchar(10),concat(isnull(month(rol.CreatedDateTime),'0'),isnull(year(rol.CreatedDateTime),'0'))) =                 
    CASE 
      WHEN                     
       (     
        @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                  
    )                   
      THEN convert(varchar(10),concat(month(getdate()),year(getdate())))  
      ELSE convert(varchar(10),concat(isnull(month(rol.CreatedDateTime),'0'),isnull(year(rol.CreatedDateTime),'0')))  
    END            
    )   
END TRY
BEGIN CATCH

	SELECT 0 [Message_Id], ERROR_MESSAGE() [Message] 
END CATCH


GO
/****** Object:  StoredProcedure [dbo].[USP_GetRoleDetailsForExcel]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************  
CreatedBy:sandeep Kumar 
CreatedDate:16-12-2019

purpos:Get  Role Details For Excel
EXEC [dbo].[USP_GetRoleDetailsForExcel]
****************************************************/ 
CREATE PROCEDURE [dbo].[USP_GetRoleDetailsForExcel]
(
  @iPK_RoleId        BIGINT,
  @cPK_RoleIds       NVARCHAR(300),
  @cSearchBy         NVARCHAR(50),    
  @cSearchValue      NVARCHAR(50) ,
  @iFK_AccountId     INT=1,
  @iUserId           INT=0
)
AS
BEGIN TRY 
   IF(ISNULL(@cPK_RoleIds,'') ='')	    
         BEGIN 
	     SELECT 1 AS Message_Id,'Success' AS Message 
         SELECT 
         rol.PK_Roleid,
	     rol.RoleName,
	     rol.FK_CategoryId,
	     ISNULL(ct.CategoryName,'')  CategoryName,
	     rol.FK_AccountId,
	     ISNULL(acc.AccountName,'')  AccountName,
	     ISNULL(frm.FormName,'')     FormName,
	     rol.IsActive,
	     CASE WHEN rol.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status],
	     FORMAT(rol.CreatedDateTime,'dd/MM/yyyy HH:mm') CreatedDateTime,
	     rol.HomePage
	     FROM MST_Role(NOLOCK) rol
         INNER JOIN MST_Category(NOLOCK)   ct		ON rol.FK_CategoryId = ct.PK_CategoryId
         INNER JOIN MST_Account(NOLOCK)    acc	    ON rol.FK_AccountId = acc.PK_AccountId
	     LEFT JOIN [dbo].[MST_Form] (NOLOCK) frm ON rol.HomePage = frm.PK_FormId
	     WHERE
	     Isnull(rol.IsDeleted ,0)=0

	   AND      
	   (    
		rol.FK_AccountId IN    
		(    
			SELECT FMUA.FK_AccountId  from MAP_UserAccount(NOLOCK) FMUA     
			INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
			WHERE FK_UserId=@iUserId and 
			FMUA.IsActive=1 and FMU.IsActive=1    
			AND @iFK_AccountId=1    
		)    
		OR     
		rol.FK_AccountId =@iFK_AccountId    
	   )  
	   AND
	   ISNULL(rol.RoleName,'') LIKE    
       CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'RoleName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(rol.RoleName,'')   
         END  

		   AND
	    ISNULL(acc.AccountName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(acc.AccountName,'')   
          END  
		    AND
	    ISNULL(ct.CategoryName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'CategoryName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(ct.CategoryName,'')   
           END 
		   ORDER BY rol.PK_RoleId asc 
	       END
	ELSE
	       BEGIN 
	       SELECT 1 AS Message_Id,'Success' AS Message 
           SELECT 
           rol.PK_Roleid,
	       rol.RoleName,
	       rol.FK_CategoryId,
	       ISNULL(ct.CategoryName,'')  CategoryName,
	       rol.FK_AccountId,
	       ISNULL(acc.AccountName,'')  AccountName,
	       ISNULL(frm.FormName,'')     FormName,
	       rol.IsActive,
	       CASE WHEN rol.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status],
	       FORMAT(rol.CreatedDateTime,'dd/MM/yyyy HH:mm') CreatedDateTime,
	       rol.HomePage
	       FROM MST_Role(NOLOCK) rol
           INNER JOIN MST_Category(NOLOCK)   ct		ON rol.FK_CategoryId = ct.PK_CategoryId
           INNER JOIN MST_Account(NOLOCK)    acc	    ON rol.FK_AccountId = acc.PK_AccountId
	       LEFT JOIN [dbo].[MST_Form] (NOLOCK) frm ON rol.HomePage = frm.PK_FormId
	       WHERE
		    Isnull(rol.IsDeleted ,0)=0
	        AND      
		    rol.PK_RoleId IN (SELECT Item FROM SplitString(@cPK_RoleIds ,','))
	       END
END TRY

BEGIN CATCH
	SELECT	0 AS Message_Id, ERROR_MESSAGE() AS Message 
END CATCH	



GO
/****** Object:  StoredProcedure [dbo].[USP_GetRoleFormMappingWithFormId]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************  
Created By: Sandeep Kr.
Created Date: 2019-12-12  
Purpose: Get Role Form Mapping With FormId And RoleId
EXEC [dbo].[USP_GetRoleFormMappingWithFormId]   2,1,'WebApp',0
*******************************************************************/  
CREATE PROCEDURE [dbo].[USP_GetRoleFormMappingWithFormId]  
(  
	@iPK_RoleId BIGINT, 
	@iPK_FormId  BIGINT ,
	@cMappingFor VARCHAR(20),
	@iFK_CompanyId BIGINT=0,
	@iAccountId BIGINT=0
)  
AS   
BEGIN   
	set @iAccountId = (SELECT FK_AccountId FROM MST_Role(NOLOCK) acc WHERE PK_RoleId =  @iPK_RoleId )
	IF(@cMappingFor='WebApp')  
		BEGIN
			IF NOT EXISTS(	SELECT 1 
							FROM MST_Account(NOLOCK) acc 
							INNER JOIN MST_Category(NOLOCK) cat 
							ON cat.PK_CategoryId=acc.FK_CategoryId 
							AND acc.PK_AccountId=@iAccountId
							
						)
				BEGIN
					;WITH FormList      
						AS      
						   (      
						           SELECT  PK_FormId, FormName,FK_ParentId,LevelId,SortId   
						 
						           FROM MST_Form(NOLOCK) where ISNULL(FK_ParentId,0) =0     
						           and PK_FormId=@iPK_FormId AND isActive=1  AND (UPPER(ISNULL(FormFor,'ALL'))='WEB'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' ) 
						           UNION ALL      
						           SELECT  a.PK_FormId, a.FormName, a.FK_ParentId ,a.LevelId,a.SortId      
						           FROM MST_Form a      
						           --JOIN FormList b on a.FK_ParentId=b.PK_FormId      
						          WHERE a.FK_ParentId =@iPK_FormId AND ISNULL(a.isActive,0)=1   AND (UPPER(ISNULL(FormFor,'ALL'))='WEB'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' )   
						   )      
						   SELECT  
						   @iAccountId as CompanyId,  
						   --ISNULL(FRMCMP.FK_CompanyId,0),  
						   --0 AS PK_FormRoleId,   
						   FRMLIST.PK_FormId AS FK_FormId,   
						   FRMLIST.FormName,  
						   FRMLIST.FK_ParentId,  
						   FRMLIST.LevelId,  
						   FRMLIST.SortId,  
						   ISNULL(FRMCMP.CanAdd   ,0)CanAdd,  
						   ISNULL(FRMCMP.CanDelete,0)CanDelete,  
						   ISNULL(FRMCMP.CanView  ,0)CanView,  
						   ISNULL(FRMCMP.CanEdit ,0)CanEdit--,
						   --ISNULL(FRMROLE.PK_FormRoleId,0)PK_FormRoleId
						   INTO #TEMPFormCompany
						   FROM  FormList FRMLIST      
						   LEFT JOIN Map_FormAccount(NOLOCK) FRMCMP   
						   ON FRMLIST.PK_FormId=FRMCMP.FK_FormId
						   AND 
						   1=(
								CASE WHEN ISNULL(FRMCMP.FK_AccountId,0)=@iAccountId THEN 1
									 
							ELSE 0 END
							)
							
 						   WHERE  
						   (
								FRMCMP.CanAdd=1 OR FRMCMP.CanDelete=1 OR FRMCMP.CanEdit=1 OR FRMCMP.CanView=1
						   )
						  
						   ORDER BY FK_ParentId ASC

					;WITH FormList1      
						AS      
						   (      
						           SELECT  PK_FormId, FormName,FK_ParentId,LevelId,SortId   
						 
						           FROM MST_Form(NOLOCK) where FK_ParentId =0     
						           and PK_FormId=@iPK_FormId AND isActive=1   AND (UPPER(ISNULL(FormFor,'ALL'))='WEB'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' )    
						           UNION ALL      
						           SELECT  a.PK_FormId, a.FormName, a.FK_ParentId ,a.LevelId,a.SortId      
						           FROM MST_Form a      
						           --JOIN FormList b on a.FK_ParentId=b.PK_FormId      
						          WHERE a.FK_ParentId =@iPK_FormId AND a.isActive=1     AND (UPPER(ISNULL(FormFor,'ALL'))='WEB'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' ) 
						   )
						   
						    SELECT  
						   @iAccountId as CompanyId,  
						   FRMRLE.FK_RoleId,   
						   FRMLIST1.PK_FormId AS FK_FormId,   
						   FRMLIST1.FormName,  
						   FRMLIST1.FK_ParentId,  
						   FRMLIST1.LevelId,  
						   FRMLIST1.SortId,  
						   ISNULL(FRMRLE.CanAdd   ,0)CanAdd,  
						   ISNULL(FRMRLE.CanDelete,0)CanDelete,  
						   ISNULL(FRMRLE.CanView  ,0)CanView,  
						   ISNULL(FRMRLE.CanEdit ,0)CanEdit,
						   ISNULL(FRMRLE.PK_FormRoleId,0) PK_FormRoleId
						   INTO #TEMPFormRole
						   FROM  FormList1 FRMLIST1      
						   LEFT JOIN MAP_FormRole (NOLOCK) FRMRLE   
						   ON FRMLIST1.PK_FormId=FRMRLE.FK_FormId
						   AND FRMRLE.FK_RoleId=@iPK_RoleId
						   WHERE  
						   (
								FRMRLE.CanAdd=1 OR FRMRLE.CanDelete=1 OR FRMRLE.CanEdit=1 OR FRMRLE.CanView=1
						   )
						  
						   ORDER BY FK_ParentId ASC 

						   SELECT
						   --FRMCOMP.*,
						   @iPK_RoleId AS FK_RoleId,
						   FRMCOMP.FK_FormId,
						   ISNULL(FRMCOMP.FK_ParentId,0)AS FK_ParentId,
						   ISNULL(FRMCOMP.FormName,'')AS FormName,
						   ISNULL(FRMCOMP.LevelId ,0)AS LevelId,
						   ISNULL(FRMCOMP.SortId  ,0)AS SortId,
						   ISNULL(FRMROLE.CanAdd,0) CanAdd,
						   ISNULL(FRMROLE.CanEdit,0) CanEdit,
						   ISNULL(FRMROLE.CanView,0) CanView,
						   ISNULL(FRMROLE.CanDelete,0) CanDelete, 

						   ISNULL(FRMROLE.PK_FormRoleId,0)AS PK_FormRoleId
						 FROM #TEMPFormCompany FRMCOMP
						   LEFT JOIN #TEMPFormRole FRMROLE
						   ON FRMROLE.FK_FormId=FRMCOMP.FK_FormId


						   DROP TABLE #TEMPFormCompany
						   DROP TABLE #TEMPFormRole
				END
			ELSE
				BEGIN

					;WITH FormList      
								  AS      
									          (      
									           SELECT  PK_FormId, FormName,FK_ParentId,LevelId,SortId   
									           FROM MST_Form(NOLOCK) where ISNULL(FK_ParentId,0) =0     
									           and PK_FormId=@iPK_FormId AND ISNULL(IsDeleted,0)=0  AND (UPPER(ISNULL(FormFor,'ALL'))='WEB'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' )      
									           UNION ALL      
									           SELECT  a.PK_FormId, a.FormName, a.FK_ParentId ,a.LevelId,a.SortId      
									           FROM MST_Form a      
									           WHERE a.FK_ParentId =@iPK_FormId AND ISNULL(IsDeleted,0)=0    AND (UPPER(ISNULL(FormFor,'ALL'))='WEB'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' ) 
									          )
								 SELECT
								 @iPK_RoleId AS FK_RoleId,
								 ISNULL(FRMCMP.PK_FormRoleId,0)PK_FormRoleId, 
								 FRMLIST.PK_FormId AS FK_FormId, 
								 ISNULL(FRMLIST.FormName,'')FormName,
								 ISNULL(FRMLIST.FK_ParentId,0)AS FK_ParentId,
								 ISNULL(FRMLIST.LevelId,0)AS LevelId,
								 ISNULL(FRMLIST.SortId,0) AS SortId,
								 ISNULL(FRMCMP.CanAdd   ,0)CanAdd,
								 ISNULL(FRMCMP.CanDelete,0)CanDelete,
								 ISNULL(FRMCMP.CanView  ,0)CanView,
								 ISNULL(FRMCMP.CanEdit	,0)CanEdit
								 FROM  FormList FRMLIST    
							     LEFT JOIN MAP_FormRole(NOLOCK) FRMCMP 
								 ON FRMLIST.PK_FormId=FRMCMP.FK_FormId
								 AND FK_RoleId=@iPK_RoleId
							     order by FK_ParentId, PK_FormId
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS(	SELECT 1 
							FROM MST_Account(NOLOCK) acc 
							INNER JOIN MST_Category(NOLOCK) cat 
							ON cat.PK_CategoryId=acc.FK_CategoryId 
							AND acc.PK_AccountId=@iAccountId
						
						)
				BEGIN
					;WITH FormList      
				AS      
				   (      
				           SELECT  PK_FormId, FormName,FK_ParentId,LevelId,SortId   
				 
				           FROM MST_Form(NOLOCK) where FK_ParentId =0     
				           and PK_FormId=@iPK_FormId AND isActive=1     AND (UPPER(ISNULL(FormFor,'ALL'))='MOBILE'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' )  
				           UNION ALL      
				           SELECT  a.PK_FormId, a.FormName, a.FK_ParentId ,a.LevelId,a.SortId      
				           FROM MST_Form a      
				           --JOIN FormList b on a.FK_ParentId=b.PK_FormId      
				          WHERE a.FK_ParentId =@iPK_FormId AND a.isActive=1    AND (UPPER(ISNULL(FormFor,'ALL'))='MOBILE'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' )  
				   )      
				   SELECT  
				   @iAccountId as CompanyId,  
				   --ISNULL(FRMCMP.FK_CompanyId,0),  
				   --0 AS PK_FormRoleId,   
				   FRMLIST.PK_FormId AS FK_FormId,   
				   ISNULL(FRMLIST.FormName,  '')AS FormName,
				   ISNULL(FRMLIST.FK_ParentId, 0)AS FK_ParentId,  
				   ISNULL(FRMLIST.LevelId,  0)AS LevelId,
				   ISNULL(FRMLIST.SortId,  	0)AS SortId,
				   ISNULL(FRMCMP.CanAdd   ,0)CanAdd,  
				   ISNULL(FRMCMP.CanDelete,0)CanDelete,  
				   ISNULL(FRMCMP.CanView  ,0)CanView,  
				   ISNULL(FRMCMP.CanEdit ,0)CanEdit--,
				   --ISNULL(FRMROLE.PK_FormRoleId,0)PK_FormRoleId
				   INTO #TEMPFormCompany1
				   FROM  FormList FRMLIST      
				  LEFT JOIN Map_FormAccount(NOLOCK) FRMCMP   
				   ON FRMLIST.PK_FormId=FRMCMP.FK_FormId
				   AND 
				   1=(
						CASE WHEN ISNULL(FRMCMP.FK_AccountId,0)=@iAccountId THEN 1
							 
					ELSE 0 END
					)
				   WHERE  
				   (
						FRMCMP.CanAdd=1 OR FRMCMP.CanDelete=1 OR FRMCMP.CanEdit=1 OR FRMCMP.CanView=1
				   )
				  
				   ORDER BY FK_ParentId ASC


					;WITH FormList1      
				AS      
				   (      
				           SELECT  PK_FormId, FormName,FK_ParentId,LevelId,SortId   
				 
				           FROM MST_Form(NOLOCK) where FK_ParentId =0     
				           and PK_FormId=@iPK_FormId AND isActive=1  AND (UPPER(ISNULL(FormFor,'ALL'))='MOBILE'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' )     
				           UNION ALL      
				           SELECT  a.PK_FormId, a.FormName, a.FK_ParentId ,a.LevelId,a.SortId      
				           FROM MST_Form a      
				           --JOIN FormList b on a.FK_ParentId=b.PK_FormId      
				          WHERE a.FK_ParentId =@iPK_FormId AND a.isActive=1     AND (UPPER(ISNULL(FormFor,'ALL'))='MOBILE'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' ) 
				   )
				   
				    SELECT  
				   @iAccountId as CompanyId,  
				   --ISNULL(FRMCMP.FK_CompanyId,0),  
				   --0 AS PK_FormRoleId,
				   FRMRLE.FK_RoleId,   
				   FRMLIST1.PK_FormId AS FK_FormId,   
				   FRMLIST1.FormName,  
				   FRMLIST1.FK_ParentId,  
				   FRMLIST1.LevelId,  
				   FRMLIST1.SortId,  
				   ISNULL(FRMRLE.CanAdd   ,0)CanAdd,  
				   ISNULL(FRMRLE.CanDelete,0)CanDelete,  
				   ISNULL(FRMRLE.CanView  ,0)CanView,  
				   ISNULL(FRMRLE.CanEdit ,0)CanEdit,
				   ISNULL(FRMRLE.PK_FormRoleId,0) PK_FormRoleId
				   INTO #TEMPFormRole1
				   FROM  FormList1 FRMLIST1      
				   LEFT JOIN MAP_FormRole_MobileApp (NOLOCK) FRMRLE   
				   ON FRMLIST1.PK_FormId=FRMRLE.FK_FormId
				   AND FRMRLE.FK_RoleId=@iPK_RoleId
				   WHERE  
				   (
						FRMRLE.CanAdd=1 OR FRMRLE.CanDelete=1 OR FRMRLE.CanEdit=1 OR FRMRLE.CanView=1
				   )
				  
				   ORDER BY FK_ParentId ASC 

						   --SELECT * FROM #TEMPFormCompany1
						   --SELECT * FROM #TEMPFormRole1


				   SELECT
						   --@iPK_RoleId FK_RoleId, -- as this value was not going from FRMROLE.FK_RoleId so this was applied --done by jyoti
				   ISNULL(FRMROLE.FK_RoleId,0) AS FK_RoleId,
				   --FRMCOMP.*,
				   FRMCOMP.CompanyId,
				   FRMCOMP.FK_FormId,
				   ISNULL(FRMCOMP.FK_ParentId,0)AS FK_ParentId,
				   ISNULL(FRMCOMP.FormName,'')AS FormName,
				   ISNULL(FRMCOMP.LevelId,0)AS LevelId,
				   ISNULL(FRMCOMP.SortId, 0)AS SortId,
				   ISNULL(FRMROLE.CanAdd,0) CanAdd,
				   ISNULL(FRMROLE.CanEdit,0) CanEdit,
				   ISNULL(FRMROLE.CanView,0) CanView,
				   ISNULL(FRMROLE.CanDelete,0) CanDelete,
				   ISNULL(FRMROLE.PK_FormRoleId,0)AS PK_FormRoleId
				   FROM #TEMPFormCompany1 FRMCOMP
				   LEFT JOIN #TEMPFormRole1 FRMROLE
				   ON FRMROLE.FK_FormId=FRMCOMP.FK_FormId


						   DROP TABLE #TEMPFormCompany1
						   DROP TABLE #TEMPFormRole1
				END
			ELSE
				BEGIN
				
					;WITH FormList      
					  AS      
						          (      
						           SELECT  PK_FormId, FormName,FK_ParentId,LevelId,SortId   
						           FROM MST_Form(NOLOCK) where ISNULL(FK_ParentId,0) =0     
						           and PK_FormId=@iPK_FormId AND ISNULL(IsDeleted,0)=0  AND (UPPER(ISNULL(FormFor,'ALL'))='MOBILE'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' )      
						      UNION ALL      
						           SELECT  a.PK_FormId, a.FormName, a.FK_ParentId ,a.LevelId,a.SortId      
						           FROM MST_Form a      
						           WHERE a.FK_ParentId =@iPK_FormId AND ISNULL(IsDeleted,0)=0    AND (UPPER(ISNULL(FormFor,'ALL'))='MOBILE'  OR  UPPER(ISNULL(FormFor,'ALL'))='ALL' ) 
						          )
					 SELECT
					 @iPK_RoleId AS FK_RoleId,
					 ISNULL(FRMCMP.PK_FormRoleId,0)PK_FormRoleId, 
					 FRMLIST.PK_FormId AS FK_FormId, 
					 ISNULL(FRMLIST.FormName,'')FormName,
					 ISNULL(FRMLIST.FK_ParentId,0)AS FK_ParentId,
					 ISNULL(FRMLIST.LevelId,0)AS LevelId,
					 ISNULL(FRMLIST.SortId,0) AS SortId,
					 ISNULL(FRMCMP.CanAdd   ,0)CanAdd,
					 ISNULL(FRMCMP.CanDelete,0)CanDelete,
					 ISNULL(FRMCMP.CanView  ,0)CanView,
					 ISNULL(FRMCMP.CanEdit	,0)CanEdit
					 FROM  FormList FRMLIST    
					 LEFT JOIN MAP_FormRole_MobileApp (NOLOCK) FRMCMP 
					 ON FRMLIST.PK_FormId=FRMCMP.FK_FormId
					 AND FK_RoleId=@iPK_RoleId
					 order by FK_ParentId, PK_FormId
				END
		END	
		   
END






GO
/****** Object:  StoredProcedure [dbo].[USP_GetStateDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:sandeep Kumar   
CreatedDate:11-12-2019  
purpos:Get State Details 

EXEC [dbo].[USP_GetStateDetails]
0,'','',10,1
      
EXEC [dbo].[USP_GetStateDetails]
4,'','',10,1

EXEC [dbo].[USP_GetStateDetails]
0,'','',10,1,1
****************************************************/    
CREATE PROCEDURE [dbo].[USP_GetStateDetails]  
(
	@iPK_StateId BIGINT,
	@cSearchBy NVARCHAR(50)='',
	@cSearchValue NVARCHAR(50)='',
	@iRowperPage  INT  ,  
	@iCurrentPage  INT,
	@iUserId       BIGINT  
)    

AS
BEGIN    
        SELECT 1 AS Message_Id, 'SUCCESS' AS Message
	    SELECT 
	    ISNULL(st.PK_StateId,0)PK_StateId,
	    ISNULL(st.StateName,'')StateName,
	    ISNULL(st.IsActive,0)IsActive,
	    ISNULL(st.FK_CountryId,0)FK_CountryId,
	    CASE WHEN st.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status], 
	    FORMAT(st.CreatedDateTime,'dd/MM/yyyy HH:mm') CreatedDateTime,
	    ISNULL(cntry.CountryName,'')CountryName
        FROM MST_State(NOLOCK) st 
	    INNER JOIN MST_Country(NOLOCK) cntry
	    ON st.FK_CountryId = cntry.PK_CountryId
	    WHERE 
	    ISNULL(st.IsDeleted,0)=0 AND
	    --st.IsActive = 1
	    --AND 
	    st.PK_StateId = CASE WHEN @iPK_StateId <> 0 THEN @iPK_StateId ELSE st.PK_StateId END
	    --AND st.CreatedBy=@iUserId
	    AND
	    ISNULL(cntry.CountryName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(cntry.CountryName,'')   
         END  
		 AND
	     ISNULL(st.StateName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(st.StateName,'')   
         END  

	     ORDER BY st.PK_StateId DESC 
	     OFFSET (@iCurrentPage-1)*@iRowperPage ROWS     
         FETCH NEXT @iRowperPage ROWS ONLY		
         SELECT 
         ISNULL(COUNT (1),0)  AS TotalItem
         

         FROM MST_State(NOLOCK) st 
	     INNER JOIN MST_Country(NOLOCK) cntry
	     ON st.FK_CountryId = cntry.PK_CountryId
	     WHERE 
	     ISNULL(st.IsDeleted,0)=0 AND
	     --st.IsActive = 1
	     --AND 
	     st.PK_StateId = CASE WHEN @iPK_StateId <> 0 THEN @iPK_StateId ELSE st.PK_StateId END
	     --AND st.CreatedBy=@iUserId
	     AND
	     ISNULL(cntry.CountryName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'CountryName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(cntry.CountryName,'')   
         END  
		 AND
	     ISNULL(st.StateName,'') LIKE    
         CASE     
           WHEN       
            (    
             @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''    
            )     
           THEN '%'+@cSearchValue+'%'     
           ELSE  ISNULL(st.StateName,'')   
         END  
END



GO
/****** Object:  StoredProcedure [dbo].[USP_GetStateDetailsByCountryId]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************          
CreatedBy:sandeep Kumar         
CreatedDate:11-12-2019        
purpos:Get State Details       
[dbo].[USP_GetAllStateDetails]             
EXEC [dbo].[USP_GetStateDetailsByCountryId]  2      
****************************************************/          
CREATE PROCEDURE [dbo].[USP_GetStateDetailsByCountryId]        
(      
 @iFK_CountryId BIGINT = 0      
)              
AS      
BEGIN     
SELECT 1 AS Message_Id,'Success' AS Message           
 SELECT       
       st.PK_StateId,      
       st.StateName   ,
	   c.TimeZone
       FROM MST_State(NOLOCK) st   
	    inner join MST_Country(NOLOCK) c  on  c.PK_CountryId = st.FK_CountryId
       WHERE st.FK_CountryId=@iFK_CountryId      
       AND isnull(st.IsActive,0) = 1      AND isnull(st.IsDeleted,0) = 0    
END




GO
/****** Object:  StoredProcedure [dbo].[Usp_GetUserCredentialsByUserId]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************        
CreatedBy:		MD. TARIQUE KHAN
CreatedDate:	11 FEB 20   
PURPOS:GetUserCredentialsByUserId     
EXEC [dbo].[Usp_GetUserCredentialsByUserId] 1
    
****************************************************/  
CREATE PROCEDURE [dbo].[Usp_GetUserCredentialsByUserId]
(
	@iUserID BIGINT
)
AS
BEGIN TRY
	
	IF EXISTS(SELECT 1 FROM MST_User(NOLOCK) WHERE PK_UserId = @iUserID AND IsActive = 1)
	BEGIN
		SELECT 1 AS Message_Id, 'SUCCESS' AS Message
		
		SELECT 
		ISNULL(UserName,'')		[Username],
		ISNULL(UserPassword,'') [Password],
		ISNULL(EmailId,'')		[UserEmail]
		FROM MST_User(NOLOCK) 
		WHERE PK_UserId = @iUserID
	END

	ELSE
	BEGIN
		SELECT 0 AS Message_Id, 'No Active User Found.' AS Message
	END
	
END TRY



BEGIN CATCH
	SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                            
CreatedBy:Vinish                          
CreatedDate:2020-05-01 16:21:12.527
purpos:Get User Master  Deatils                         
                         
EXEC [dbo].[USP_GetUserDetails]  1,1,1,0,'COMPANY',10,1,'',''                        
****************************************************/                          
CREATE PROCEDURE [dbo].[USP_GetUserDetails]                        
(                        
 @iPK_UserId            BIGINT,                          
 @iFK_AccountId         BIGINT,                         
 @iUserId               BIGINT,                
 @iFK_CustomerId        BIGINT = 0,              
 @cLoginType            nvarchar(200),              
 @iRowperPage           BIGINT,                        
 @iCurrentPage          BIGINT,                        
 @cSearchBy             NVARCHAR(50),                          
 @cSearchValue          NVARCHAR(50)                            
)                         
AS                            
BEGIN TRY                            
         SELECT 1 [Message_Id],'Success' [Message]                            
         SELECT                        
         ISNULL(usr.PK_UserId,0)PK_UserId,                        
         ISNULL(usr.UserName,'')UserName,                        
         ISNULL(usr.FirstName,'')+' '+ISNULL(usr.LastName,'') [Name],                        
         ISNULL(usr.FK_CategoryId,0)FK_CategoryId,                        
         ISNULL(cat.CategoryName,'') CategoryName,                        
         ISNULL(usr.FK_RoleId,0) FK_RoleId,                        
         ISNULL(rol.RoleName,'') RoleName,                         
         ISNULL(usr.FK_AccountId, 0)FK_AccountId,                           
         ISNULL(acc.AccountName,'') AccountName,                        
         ISNULL(usr.UserPassword,'')UserPassword,                        
         ISNULL(usr.MobileNo,'')MobileNo,                        
         ISNULL(usr.AlternateMobileNo,'')AlternateMobileNo,                        
         ISNULL(usr.EmailId,'')EmailId,                        
         ISNULL(usr.AlternateEmailId,'')AlternateEmailId,                        
         ISNULL(usr.Gender,'') Gender,                        
         ISNULL(usr.DateOfBirth,'') DateOfBirth,                        
         --ISNULL(CONVERT(VARCHAR,FORMAT(usr.DateOfBirth,'dd/MM/yyyy HH:mm')),'')DateOfBirth,                      
         ISNULL(usr.UserAddress,'')UserAddress,                        
         ISNULL(usr.ZipCode,0) ZipCode,                        
         ISNULL(usr.FK_CountryId,0)FK_CountryId,                        
         ISNULL(cntry.CountryName,'') CountryName,                        
         ISNULL(usr.FK_StateId,0)FK_StateId,                        
         ISNULL(st.StateName,'') StateName,                        
         ISNULL(usr.FK_CityId,0)FK_CityId,                        
         ISNULL(cty.CityName,'') CityName,                        
         ISNULL(usr.ShareBy,'')ShareBy,                        
         ISNULL(usr.IsActive,0)IsActive,                        
         ISNULL(usr.FullName,'')FullName,                   
         0 FK_CustomerId,                       
         CASE WHEN usr.IsActive = 1 THEN 'Active' ELSE 'In-Active' END [Status],                        
         ISNULL(FORMAT(usr.CreatedDateTime,'dd/MM/yyyy HH:mm'),'') CreatedDateTime,                        
         ISNULL(usrCreated.FirstName,'')+' '+ISNULL(usrCreated.LastName,'') CreatedBy                        
         ,acc.FK_CategoryId  as FK_CategoryIdForCust                 
         ,'' CustomerName,      
   ISNULL(usr.IsVehicleSpecific,0)IsVehicleSpecific--Added By Meenakshi Jha(10-Feb-2020)            
         FROM  [dbo].[MST_User](NOLOCK) usr                         
         LEFT JOIN MST_Category(NOLOCK) cat                        
         ON usr.FK_CategoryId = cat.PK_CategoryId                        
         INNER JOIN MST_Role(NOLOCK) rol                   
         ON usr.FK_RoleId = rol.PK_RoleId                        
         LEFT JOIN MST_Account(NOLOCK) acc                        
         ON usr.FK_AccountId = acc.PK_AccountId                        
         LEFT JOIN MST_Country(NOLOCK) cntry             
         ON usr.FK_CountryId = cntry.PK_CountryId                        
         LEFT JOIN MST_State(NOLOCK) st                        
         ON usr.FK_StateId = st.PK_StateId                     
         LEFT JOIN MST_City(NOLOCK) cty                        
         ON usr.FK_CityId = cty.PK_CityId                        
         LEFT JOIN MST_User(NOLOCK) usrCreated                        
         ON usr.CreatedBy = usrCreated.PK_UserId            
         
		   where                                                          
         ISNULL(usr.IsDeleted,0)=0                   
         AND                        
         usr.PK_UserId = CASE WHEN @iPK_UserId <> 0 THEN @iPK_UserId ELSE usr.PK_UserId END                
         AND         
     1=(        
                            CASE         
       WHEN (usr.FK_AccountId IN            
                                                                                (            
                                                                                    SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA             
                                                                                    INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId             
                                                                                    WHERE         
                     FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and        
                                                                                    FMUA.IsActive=1 and FMU.IsActive=1            
                                                                                    AND @iFK_AccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')                
                     --FK_UserId=@iUserId and        
                                                                                    --FMUA.IsActive=1 and FMU.IsActive=1            
                                                                                    --AND @iFK_AccountId=6          
         )            
                                                                                OR             
                                                                                ISNULL(usr.FK_AccountId,0) =@iFK_AccountId        
                                                                )  THEN 1        
                                  
                            ELSE 0        
                            END        
                      )        
                                
       AND                        
         ISNULL(usr.UserName,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'UserName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(usr.UserName,'')                           
            END                        
                                    
         AND                        
         ISNULL(usr.MobileNo,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'MobileNo' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(usr.MobileNo,'')                           
            END                        
                                   
         AND                        
         ISNULL(usr.EmailId,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'EmailId' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(usr.EmailId,'')                           
            END     
    AND                        
         ISNULL(cat.CategoryName,'') LIKE                            
     CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'AccountCategory' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(cat.CategoryName,'')                           
        END       
   AND                        
         ISNULL(rol.RoleName,'') LIKE                            
            CASE                             
              WHEN          
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'Role' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(rol.RoleName,'')                              
        END       
   AND                        
       
	   (
	     ISNULL(acc.AccountName,'')  LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(acc.AccountName,'')                           
        END     
		
		)                       
   --Nitin                     
    AND                        
 (                                  
    (case when CONVERT(CHAR(1),ISNULL(usr.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                                       
    CASE                                         
      WHEN                                           
       (                                        
        @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue)) <> ''                                        
       )                                         
      THEN @cSearchValue                        
      ELSE  (case when CONVERT(CHAR(1),ISNULL(usr.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                                      
    END                                  
    )                                  
                        
 AND                        
 (                                  
    convert(varchar(10),concat(isnull(month(usr.CreatedDateTime),'0'),isnull(year(usr.CreatedDateTime),'0'))) =                                       
    CASE                                           WHEN                                           
       (                                        
        @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                                        
    )                                         
      THEN convert(varchar(10),concat(month(getdate()),year(getdate())))                        
      ELSE convert(varchar(10),concat(isnull(month(usr.CreatedDateTime),'0'),isnull(year(usr.CreatedDateTime),'0')))                        
    END                                  
    )     
                       
                       
   --NitinEnd                      
                                
         ORDER BY usr.PK_UserId desc       OFFSET (@iCurrentPage-1)*@iRowperPage ROWS                                     
         FETCH NEXT @iRowperPage ROWS ONLY                         
         SELECT                       
         ISNULL(COUNT (1),0)  AS TotalItem,                      
         (                      
      SELECT                       
        ISNULL( SUM (                      
      CASE                       
      WHEN YEAR(usr.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(usr.CreatedDateTime)=MONTH(GETDATE())                       
    THEN 1                       
    ELSE 0 END),0                      
      )                      
         ) AS TotalCurrentMonth,                       
         ISNULL(SUM(CASE WHEN usr.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,                      
         ISNULL(SUM(CASE WHEN usr.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive             
       FROM  [dbo].[MST_User](NOLOCK) usr                         
         LEFT JOIN MST_Category(NOLOCK) cat                        
         ON usr.FK_CategoryId = cat.PK_CategoryId                        
         INNER JOIN MST_Role(NOLOCK) rol                        
         ON usr.FK_RoleId = rol.PK_RoleId                        
         LEFT JOIN MST_Account(NOLOCK) acc                        
         ON usr.FK_AccountId = acc.PK_AccountId                        
         LEFT JOIN MST_Country(NOLOCK) cntry                        
         ON usr.FK_CountryId = cntry.PK_CountryId                        
         LEFT JOIN MST_State(NOLOCK) st                        
         ON usr.FK_StateId = st.PK_StateId                        
         LEFT JOIN MST_City(NOLOCK) cty                        
         ON usr.FK_CityId = cty.PK_CityId                        
         LEFT JOIN MST_User(NOLOCK) usrCreated                        
         ON usr.CreatedBy = usrCreated.PK_UserId   
		                     
           where
         ISNULL(usr.IsDeleted,0)=0  
         AND                        
         usr.PK_UserId = CASE WHEN @iPK_UserId <> 0 THEN @iPK_UserId ELSE usr.PK_UserId END                   
     AND         
     1=(        
                            CASE         
       WHEN (usr.FK_AccountId IN            
                                                                                (            
                                                                                    SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA             
                                                                                    INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId             
                                                                                    WHERE         
                     FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and        
                                                                                    FMUA.IsActive=1 and FMU.IsActive=1            
                                                                                    AND @iFK_AccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')                
                     --FK_UserId=@iUserId and        
                                                                                    --FMUA.IsActive=1 and FMU.IsActive=1            
                                                                                    --AND @iFK_AccountId=6          
         )            
                                                                                OR             
                                                                                ISNULL(usr.FK_AccountId,0) =@iFK_AccountId        
                                                                )  THEN 1        
                                  
                            ELSE 0        
                            END        
                      )         
         AND                        
         ISNULL(usr.UserName,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'UserName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(usr.UserName,'')                           
            END                      
                         
                                    
         AND                        
         ISNULL(usr.MobileNo,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'MobileNo' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(usr.MobileNo,'')                           
 END                        
                                   
         AND                        
         ISNULL(usr.EmailId,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'EmailId' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(usr.EmailId,'')                           
        END         
   AND                        
         ISNULL(cat.CategoryName,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'AccountCategory' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(cat.CategoryName,'')                           
        END       
   AND               
         ISNULL(rol.RoleName,'') LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'Role' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(rol.RoleName,'')                              
        END       
    AND  
	(                      
         ISNULL(acc.AccountName ,'')  LIKE                            
            CASE                             
              WHEN                               
               (                            
                @cSearchBy <> '' AND @cSearchBy = 'AccountName' AND LTRIM(RTRIM(@cSearchValue)) <> ''                            
               )                             
              THEN '%'+LTRIM(RTRIM(@cSearchValue))+'%'                             
              ELSE  ISNULL(acc.AccountName,'')                           
        END  
		
		)                   
  AND                    
  (                    
    (case when CONVERT(CHAR(1),ISNULL(usr.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                                       
    CASE                                         
      WHEN                                           
       (                                        
        @cSearchBy <> '' AND @cSearchBy = 'Status' AND LTRIM(RTRIM(@cSearchValue)) <> ''                                        
       )                                         
      THEN @cSearchValue                        
      ELSE  (case when CONVERT(CHAR(1),ISNULL(usr.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                                      
    END                                  
    )                                  
                        
 AND                        
 (                  
    convert(varchar(10),concat(isnull(month(usr.CreatedDateTime),'0'),isnull(year(usr.CreatedDateTime),'0'))) =                                       
    CASE                                         
      WHEN                                           
       (                                        
        @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                                        
    )                                         
      THEN convert(varchar(10),concat(month(getdate()),year(getdate())))                        
      ELSE convert(varchar(10),concat(isnull(month(usr.CreatedDateTime),'0'),isnull(year(usr.CreatedDateTime),'0')))                        
    END                                  
    )                        
                      
                          
END TRY                        
BEGIN CATCH                        
    SELECT 0 [Message_Id], ERROR_MESSAGE() [Message]                         
END CATCH   
  




GO
/****** Object:  StoredProcedure [dbo].[USP_GetUserDetailsForExcel]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************  
CreatedBy:sandeep Kumar 
CreatedDate:16-12-2019
select * from mst_user
purpos:Get User Deatils For Excel
EXEC [dbo].[USP_GetUserDetailsForExcel] 0,'',2,1,'',''
****************************************************/ 
 CREATE Procedure [dbo].[USP_GetUserDetailsForExcel] 
   (
   @iPK_UserId                  BIGINT=0,  
   @cPK_UserIds                 NVARCHAR(300)='',
   @iFK_AccountId               BIGINT=0, 
   @iLoggedIn_UserId            BIGINT=0,
   @cSearchBy                   NVARCHAR(50)='',
   @cSearchValue                NVARCHAR(50)=''  
   )
  AS    
  BEGIN TRY 
    IF(ISNULL(@cPK_UserIds,'') ='')	    
    BEGIN       
	SELECT 1 [Message_Id],'Success' [Message]    
	SELECT
	usr.PK_UserId,
	usr.UserName,
	ISNULL(usr.FirstName,'')+' '+ISNULL(usr.LastName,'') [Name],
	usr.FK_CategoryId,
	ISNULL(cat.CategoryName,'') CategoryName,
	usr.FK_RoleId, 
	ISNULL(rol.RoleName,'') RoleName, 
	usr.FK_AccountId,    
	ISNULL(acc.AccountName,'') AccountName,
	'' AccountType,
	usr.UserPassword,
	usr.MobileNo,
	usr.AlternateMobileNo,
	usr.EmailId,
	usr.AlternateEmailId,
	ISNULL(usr.Gender,'') Gender,
	usr.DateOfBirth,
	ISNULL(usr.UserAddress,'')UserAddress,
	ISNULL(usr.ZipCode,0) ZipCode,
	usr.FK_CountryId,
	ISNULL(cntry.CountryName,'') CountryName,
	usr.FK_StateId,
	ISNULL(st.StateName,'') StateName,
	usr.FK_CityId,
	ISNULL(cty.CityName,'') CityName,
	usr.ShareBy,
	usr.IsActive,
	usr.FullName,
	CASE WHEN usr.IsActive = 1 THEN 'Active' ELSE 'In-Active' END [Status],
	FORMAT(usr.CreatedDateTime,'dd/MM/yyyy HH:mm') CreatedDateTime,
	ISNULL(usrCreated.FirstName,'')+' '+ISNULL(usrCreated.LastName,'') CreatedBy
	FROM  [dbo].[MST_User](NOLOCK) usr 
	LEFT JOIN MST_Category(NOLOCK) cat
	ON usr.FK_CategoryId = cat.PK_CategoryId
	INNER JOIN MST_Role(NOLOCK) rol
	ON usr.FK_RoleId = rol.PK_RoleId
	LEFT JOIN MST_Account(NOLOCK) acc
	ON usr.FK_AccountId = acc.PK_AccountId
	LEFT JOIN MST_Country(NOLOCK) cntry
	ON usr.FK_CountryId = cntry.PK_CountryId
	LEFT JOIN MST_State(NOLOCK) st
	ON usr.FK_StateId = st.PK_StateId
	LEFT JOIN MST_City(NOLOCK) cty
	ON usr.FK_CityId = cty.PK_CityId
	LEFT JOIN MST_User(NOLOCK) usrCreated
	ON usr.CreatedBy = usrCreated.PK_UserId	
	WHERE
	usr.IsActive = 1
	AND      
	(    
		usr.FK_AccountId IN    
		(    
			SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
			INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
			WHERE FK_UserId=@iLoggedIn_UserId and 
			FMUA.IsActive=1 and FMU.IsActive=1    
			AND @iFK_AccountId=1    
		)    
		OR     
		usr.FK_AccountId =@iFK_AccountId    
	)  

	AND
	ISNULL(usr.UserName,'') LIKE    
    CASE     
      WHEN       
       (    
        @cSearchBy <> '' AND @cSearchBy = 'UserName' AND @cSearchValue <> ''    
       )     
      THEN '%'+@cSearchValue+'%'     
      ELSE  ISNULL(usr.UserName,'')   
    END
	   
	AND
	ISNULL(usr.MobileNo,'') LIKE    
    CASE     
      WHEN       
       (    
        @cSearchBy <> '' AND @cSearchBy = 'MobileNo' AND @cSearchValue <> ''    
       )     
      THEN '%'+@cSearchValue+'%'     
      ELSE  ISNULL(usr.MobileNo,'')   
    END
	  
	AND
	ISNULL(usr.EmailId,'') LIKE    
    CASE     
      WHEN       
       (    
        @cSearchBy <> '' AND @cSearchBy = 'EmailId' AND @cSearchValue <> ''    
       )     
      THEN '%'+@cSearchValue+'%'     
      ELSE  ISNULL(usr.EmailId,'')   
    END   
	ORDER BY usr.PK_UserId asc 
	END


	ELSE
	BEGIN
	SELECT 1 [Message_Id],'Success' [Message]    
	SELECT
	usr.PK_UserId,
	usr.UserName,
	ISNULL(usr.FirstName,'')+' '+ISNULL(usr.LastName,'') [Name],
	usr.FK_CategoryId,
	ISNULL(cat.CategoryName,'') CategoryName,
	usr.FK_RoleId, 
	ISNULL(rol.RoleName,'') RoleName, 
	usr.FK_AccountId,    
	ISNULL(acc.AccountName,'') AccountName,
	'' AccountType,
	usr.UserPassword,
	usr.MobileNo,
	usr.AlternateMobileNo,
	usr.EmailId,
	usr.AlternateEmailId,
	ISNULL(usr.Gender,'') Gender,
	usr.DateOfBirth,
	ISNULL(usr.UserAddress,'')UserAddress,
	ISNULL(usr.ZipCode,0) ZipCode,
	usr.FK_CountryId,
	ISNULL(cntry.CountryName,'') CountryName,
	usr.FK_StateId,
	ISNULL(st.StateName,'') StateName,
	usr.FK_CityId,
	ISNULL(cty.CityName,'') CityName,
	usr.ShareBy,
	usr.IsActive,
	usr.FullName,
	CASE WHEN usr.IsActive = 1 THEN 'Active' ELSE 'In-Active' END [Status],
	FORMAT(usr.CreatedDateTime,'dd/MM/yyyy HH:mm') CreatedDateTime,
	ISNULL(usrCreated.FirstName,'')+' '+ISNULL(usrCreated.LastName,'') CreatedBy
	FROM  [dbo].[MST_User](NOLOCK) usr 
	LEFT JOIN MST_Category(NOLOCK) cat
	ON usr.FK_CategoryId = cat.PK_CategoryId
	INNER JOIN MST_Role(NOLOCK) rol
	ON usr.FK_RoleId = rol.PK_RoleId
	LEFT JOIN MST_Account(NOLOCK) acc
	ON usr.FK_AccountId = acc.PK_AccountId
	LEFT JOIN MST_Country(NOLOCK) cntry
	ON usr.FK_CountryId = cntry.PK_CountryId
	LEFT JOIN MST_State(NOLOCK) st
	ON usr.FK_StateId = st.PK_StateId
	LEFT JOIN MST_City(NOLOCK) cty
	ON usr.FK_CityId = cty.PK_CityId
	LEFT JOIN MST_User(NOLOCK) usrCreated
	ON usr.CreatedBy = usrCreated.PK_UserId	
	WHERE	usr.PK_UserId IN (SELECT Item FROM SplitString(@cPK_UserIds ,','))
	END
		
END TRY

BEGIN CATCH
	SELECT	0 AS Message_Id, ERROR_MESSAGE() AS Message 
END CATCH	



GO
/****** Object:  StoredProcedure [dbo].[Usp_GetVehicleDashboardData]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
Created By: Md. Tarique Khan
Created Date: 2020-01-07
Purpose: GET VEHICLE DASHBOARD DATA
EXEC [dbo].[Usp_GetVehicleDashboardData]
0,'group111','COMPANY',1,1,0,0,0,''
*******************************************************************/
CREATE PROCEDURE [dbo].[Usp_GetVehicleDashboardData]
(
	
	@cCommaSeparatedVehicle_IDs	NVARCHAR(MAX)	,
	@cVehicleGroupName			NVARCHAR(100),
	@cLoginType					NVARCHAR(100),
	@iAccountId					BIGINT,
	@iUserId					BIGINT,
	@iClientCustomerId			BIGINT,
	@iLoggedInCustomerId		BIGINT,
	@bIsMachineSpecificRole		BIT   ,
	@cType						VARCHAR(20)
	--DECLARE
	--@cCommaSeparatedVehicle_IDs	NVARCHAR(MAX)	='0',
	--@cVehicleGroupName			NVARCHAR(100)='',
	--@cLoginType					NVARCHAR(100)='COMPANY',
	--@iAccountId					BIGINT=1,
	--@iUserId					BIGINT=1,
	--@iClientCustomerId			BIGINT=0,
	--@iLoggedInCustomerId		BIGINT=0,
	--@bIsMachineSpecificRole		BIT   =0,
	--@cType						VARCHAR(20)=''
)
AS
BEGIN TRY
	SELECT 1 AS Message_Id, 'SUCCESS' AS Message

	IF OBJECT_ID('tempdb..#TempTransDashboardData') IS NOT NULL 
	DROP TABLE #TempTransDashboardData

	CREATE TABLE #TempTransDashboardData
	(
		FK_VehicleId	BIGINT NULL,
		PK_DashboardId	BIGINT NULL,
		FK_CustomerId	BIGINT NULL,
		FK_AccountId	BIGINT NULL,
		DeviceNo	NVARCHAR(500) NULL,
		SimNo NVARCHAR(500) NULL,
		IMEINo NVARCHAR(500) NULL,		
		RegistrationNo NVARCHAR(500) NULL,
		ModelName NVARCHAR(500) NULL,
		FK_DriverId	BIGINT NULL,
		DriverMobileNo NVARCHAR(500) NULL,
		DriverName NVARCHAR(500) NULL,
		DeviceDateTime NVARCHAR(500) NULL,
		Serverdatetime NVARCHAR(500) NULL,
		VehicleType NVARCHAR(500) NULL,
		Lat NVARCHAR(500) NULL,
		Long NVARCHAR(500) NULL,
		Location NVARCHAR(500) NULL,
		NoGPRS NVARCHAR(500) NULL,
		Ignition NVARCHAR(500) NULL,
		NoOfGeofense NVARCHAR(500) NULL,
		FMS NVARCHAR(500) NULL,
		OverSpeed NVARCHAR(500) NULL,
		OverSpeedDuration NVARCHAR(500) NULL,
		--OverSpeedLimit NVARCHAR(50) NULL,
		Moving NVARCHAR(500) NULL,
		Idling NVARCHAR(500) NULL,
		IdlingDuration NVARCHAR(500) NULL,
		PowerCutOff NVARCHAR(500) NULL,
		Panic NVARCHAR(500) NULL,
		LowBattery NVARCHAR(500) NULL,
		Fuel NVARCHAR(500) NULL,
		Mobilize_Immobilize NVARCHAR(500) NULL,
		[Status] NVARCHAR(500) NULL,
		VehicleCurrentStatus		NVARCHAR(1000) NULL	,		
		
		VehicleCurrentStatusDurationHours 	NVARCHAR(100) NULL	,
		VehicleCurrentStatusDurationMins 	NVARCHAR(100) NULL	,	


		VehicleStatus NVARCHAR(500) NULL,
		Icon  NVARCHAR(500) NULL,

		Speed NVARCHAR(500) NULL,
		PowerMode NVARCHAR(500) NULL,
		BatteryLevel  NVARCHAR(500) NULL,
		InsertedDateTime	NVARCHAR(500) NULL,
		VehicleSubscriptionStatus 	NVARCHAR(500) NULL,
		CustomerName NVARCHAR(1000) NULL,
		SignalStrength  NVARCHAR(100) NULL
	)


	IF OBJECT_ID('tempdb..#TempVehicleSubsciptionData') IS NOT NULL 
	DROP TABLE #TempVehicleSubsciptionData

	CREATE TABLE #TempVehicleSubsciptionData
	(
		FK_VehicleId			BIGINT NULL,		
		SubscriptionEndDatetime	NVARCHAR(50) NULL
	)

	INSERT INTO #TempVehicleSubsciptionData 
	SELECT DISTINCT FK_VehicleId, SubscriptionTo FROM MST_Subscription(NOLOCK) WHERE IsActive = 1

	IF(ISNULL(@cVehicleGroupName,'') ='' ) -- NOT A CUSTOMER LOGIN + VEHICLE GROUP NOT SELECTED
	BEGIN
		INSERT INTO #TempTransDashboardData
		
		SELECT 
		DISTINCT 
		ISNULL(dash.FK_VehicleId		,0)	FK_VehicleId	,
		ISNULL(dash.PK_DashboardId      ,0)	PK_DashboardId  ,
		ISNULL(dash.FK_CustomerId		,0)	FK_CustomerId	,
		ISNULL(dash.FK_AccountId		,0)	FK_AccountId	,
		ISNULL(dash.DeviceNo			,'NA')	DeviceNo		,
		ISNULL(dash.SimNo				,'NA')	SimNo			,
		ISNULL(dash.IMEINo				,'NA')	IMEINo			,
		
		ISNULL(dash.RegistrationNo		,'NA')	RegistrationNo	,
		ISNULL(dash.ModelName			,'NA')	ModelName		,
		ISNULL(dash.FK_DriverId			,0)	FK_DriverId		,
		ISNULL(dash.DriverMobileNo		,'NA')	DriverMobileNo	,
		ISNULL(dash.DriverName			,'NA')	DriverName		,
		ISNULL(dash.DeviceDateTime		,'NA')	DeviceDateTime	,
		ISNULL(FORMAT(dash.Serverdatetime,'dd/MM/yyyy HH:mm:ss'),'NA') Serverdatetime,
		ISNULL(dash.VehicleType			,'NA')VehicleType			,
		CASE WHEN dash.Lat IS NULL THEN 'NA' ELSE CONVERT(VARCHAR(50),dash.Lat) END  Lat,
		CASE WHEN dash.Long IS NULL THEN 'NA' ELSE CONVERT(VARCHAR(50),dash.Long) END  Long,
		ISNULL(dash.Location			,'NA')Location			,
		ISNULL(dash.NoGPRS				,'NA')NoGPRS				,
		ISNULL(dash.Ignition			,'NA')Ignition			,
		ISNULL(dash.NoOfGeofense		,'NA')NoOfGeofense		,
		ISNULL(dash.FMS					,'NA')FMS					,
		ISNULL(dash.OverSpeed			,'NA')OverSpeed			,
		ISNULL(dash.OverSpeedDuration	,'NA')OverSpeedDuration	,
		--ISNULL(dash.OverSpeedLimit		,'NA')OverSpeedLimit		,
		ISNULL(dash.Moving				,'NA')Moving				,
		ISNULL(dash.Idling				,'NA')Idling				,
		ISNULL(dash.IdlingDuration		,'NA')IdlingDuration		,
		ISNULL(dash.PowerCutOff			,'NA')PowerCutOff			,
		ISNULL(dash.Panic				,'NA')Panic				,
		ISNULL(dash.LowBattery			,'NA')LowBattery			,
		CASE WHEN ISNULL(dash.Fuel,'') = '' THEN 'NA' ELSE dash.Fuel END AS [Fuel],		
		ISNULL(dash.Mobilize_Immobilize	,'NA')Mobilize_Immobilize	,
		ISNULL(dash.[Status]			,'NA')[Status]			,
		
		ISNULL(dash.CurrentStatus			,'NA')			VehicleCurrentStatus			,		


		CONVERT(VARCHAR(10),
		CASE 
			WHEN CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT) <=59 THEN 0
			ELSE CONVERT(DECIMAL(18,0),CONVERT(DECIMAL(18,6),CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT))/60) 
		END) VehicleCurrentStatusDurationHours,

		CONVERT(VARCHAR(10),
		CASE 
			WHEN CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT) <=59 THEN ISNULL(dash.CurrentStatusDuration ,'0') 
			ELSE CONVERT(DECIMAL(18,0),CONVERT(DECIMAL(18,6),CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT))%60) 
		END) VehicleCurrentStatusDurationMins,

		ISNULL(
		CASE 
			WHEN ISNULL(bdVeh.FK_VehicleId,0) <> 0  THEN 'BREAKDOWN'
			WHEN ISNULL(Status,'') =  'NP' OR ISNULL(Status,'') =  ''  THEN 'OFFLINE'
			WHEN ISNULL(Status,'') =  'P'  AND ISNULL(Status,'') <> '' AND ISNULL(dash.Speed,'') <> '' AND CONVERT(DECIMAL(18,2),ISNULL(dash.Speed,'')) > 0.0 THEN 'MOVING'
			WHEN ISNULL(Status,'') =  'P'  AND ISNULL(Status,'') <> '' AND (ISNULL(dash.Speed,'') = '' OR CONVERT(DECIMAL(18,2),ISNULL(dash.Speed,'')) = 0.0) AND ISNULL(dash.Ignition,'') = 'ON' THEN 'IDILING'
			WHEN ISNULL(Status,'') =  'P'  AND ISNULL(Status,'') <> '' AND ISNULL(dash.Speed,'') <> '' AND CONVERT(DECIMAL(18,2),ISNULL(dash.Speed,'')) = 0.0 AND (ISNULL(dash.Ignition,'') = '' OR ISNULL(dash.Ignition,'') = 'OFF') THEN 'STOP'

		ELSE '' END,'NA')
		AS VehicleStatus,



		CASE WHEN ISNULL(Status,'') =  'NP' THEN ISNULL(vehType.OfflineIcon,'') ELSE ISNULL(dash.Icon,'NA') END,





		CASE WHEN ISNULL(Speed,'') = '' THEN 'NA' ELSE Speed END AS [Speed],
		ISNULL(PowerMode   ,'NA') PowerMode,
		ISNULL(BatteryLevel,'NA') BatteryLevel,
		CASE WHEN dash.InsertedDateTime IS NULL THEN 'NA' ELSE FORMAT(CONVERT(DATETIME,dash.InsertedDateTime,103),'dd/MM/yyyy HH:mm:ss') END InsertedDateTime,

		CASE 
			WHEN SubscriptionStatus.FK_VehicleId IS NOT  NULL AND  CONVERT(DATETIME,SubscriptionStatus.SubscriptionEndDatetime,103) <  GETDATE() THEN 'EXPIRED'
			WHEN SubscriptionStatus.FK_VehicleId IS NOT  NULL AND  CONVERT(DATETIME,SubscriptionStatus.SubscriptionEndDatetime,103) >= GETDATE() THEN 'SUBSCRIBED'
			WHEN SubscriptionStatus.FK_VehicleId IS NULL THEN 'NOT SUBSCRIBED'
			ELSE 'NA'
		END AS [VehicleSubscriptionStatus],

		ISNULL(CustVeh.CustomerName,'') CustomerName,

		CASE 
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >0 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 6 THEN '1.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >6 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 12 THEN '2.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >12 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 18 THEN '3.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >18 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 24 THEN '4.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >24 THEN '5.png'
		ELSE 'NA'
		END
		SignalStrength

		FROM TRANS_Dashboard(NOLOCK) dash
		LEFT JOIN MST_BreakDownVehicle(NOLOCK) bdVeh
		ON dash.FK_VehicleId = bdVeh.FK_VehicleId AND bdVeh.IsActive = 1

		LEFT JOIN #TempVehicleSubsciptionData SubscriptionStatus
		ON dash.FK_VehicleId = SubscriptionStatus.FK_VehicleId

		LEFT JOIN MST_Customer(NOLOCK) CustVeh
		ON dash.FK_CustomerId = CustVeh.PK_CustomerId

		LEFT JOIN  MST_Vehicle(NOLOCK) vehMst
		ON ISNULL(dash.FK_VehicleId,0) = ISNULL(vehMst.PK_VehicleId,0)
		LEFT JOIN  MST_VehicleType(NOLOCK) vehType
		ON ISNULL(vehMst.FK_VehicleTypeId,0) = ISNULL(vehType.PK_VehicleTypeId,0)

		WHERE			
		dash.FK_VehicleId IN
		(
			CASE 
			WHEN ISNULL(@cCommaSeparatedVehicle_IDs,'') <> '' AND ISNULL(@cCommaSeparatedVehicle_IDs,'') <> '0' THEN (SELECT DISTINCT Item FROM dbo.SplitString(@cCommaSeparatedVehicle_IDs,',') WHERE ISNULL(Item,'') <> '')
			ELSE (SELECT dash.FK_VehicleId) END
		)
		AND
		ISNULL(dash.FK_CustomerId,0) = CASE WHEN ISNULL(@iClientCustomerId,0) <> 0 THEN ISNULL(@iClientCustomerId,0) ELSE ISNULL(dash.FK_CustomerId,0) END
		AND

		1=
		(
			CASE 
				WHEN @cLoginType='COMPANY' AND (
													dash.FK_AccountId IN    
		                                            (    

														SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                        INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                        WHERE 
														FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and
                                                        FMUA.IsActive=1 and FMU.IsActive=1    
                                                        AND @iAccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')        
														--FK_UserId=@iUserId and
          --FMUA.IsActive=1 and FMU.IsActive=1    
                                                        --AND @iFK_AccountId=6  
		                                            )    
		                                            OR     
		                                            ISNULL(dash.FK_AccountId,0) =@iAccountId
		                                        )  THEN 1

				WHEN @cLoginType='CUSTOMER' AND	dash.FK_CustomerId IN 
																		(
																			SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
																			WHERE
																			IsActive=1
																			AND PK_CustomerId    = @iLoggedInCustomerId
																			OR ISNULL(FK_ParentCustomerId,0)    = @iLoggedInCustomerId
		                                                                )  THEN 1

				WHEN @cLoginType='RESELLER' AND dash.FK_AccountId IN
																		(
																			 SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
																			 WHERE
																			 IsActive=1
																			 AND PK_AccountId    = @iAccountId
																			 OR ISNULL(FK_ResellerId,0)    = @iAccountId    
																		)	THEN 1

				WHEN @cLoginType='AFFILIATE' AND dash.FK_AccountId IN	(
																			SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
																			WHERE
																			IsActive=1
																			AND PK_AccountId    = @iAccountId
																			OR ISNULL(FK_AffiliateId,0)    = @iAccountId    
																		) THEN 1
				ELSE 0
			END
		)
	END

	ELSE
	BEGIN
		INSERT INTO #TempTransDashboardData
		
		SELECT 
		DISTINCT
		ISNULL(dash.FK_VehicleId		,0)	FK_VehicleId	, 
		ISNULL(dash.PK_DashboardId      ,0)	PK_DashboardId  ,
		ISNULL(dash.FK_CustomerId		,0)	FK_CustomerId	,
		ISNULL(dash.FK_AccountId		,0)	FK_AccountId	,
		ISNULL(dash.DeviceNo			,'NA')	DeviceNo		,
		ISNULL(dash.SimNo				,'NA')	SimNo			,
		ISNULL(dash.IMEINo				,'NA')	IMEINo			,
		
		ISNULL(dash.RegistrationNo		,'NA')	RegistrationNo	,
		ISNULL(dash.ModelName			,'NA')	ModelName		,
		ISNULL(dash.FK_DriverId			,0)	FK_DriverId		,
		ISNULL(dash.DriverMobileNo		,'NA')	DriverMobileNo	,
		ISNULL(dash.DriverName			,'NA')	DriverName		,
		ISNULL(dash.DeviceDateTime		,'NA')	DeviceDateTime	,
		ISNULL(FORMAT(dash.Serverdatetime,'dd/MM/yyyy HH:mm:ss'),'NA') Serverdatetime,
		ISNULL(dash.VehicleType			,'NA')VehicleType			,
		CASE WHEN dash.Lat IS NULL THEN 'NA' ELSE CONVERT(VARCHAR(50),dash.Lat) END  Lat,
		CASE WHEN dash.Long IS NULL THEN 'NA' ELSE CONVERT(VARCHAR(50),dash.Long) END  Long,
		ISNULL(dash.Location			,'NA')Location			,
		ISNULL(dash.NoGPRS				,'NA')NoGPRS				,
		ISNULL(dash.Ignition			,'NA')Ignition			,
		ISNULL(dash.NoOfGeofense		,'NA')NoOfGeofense		,
		ISNULL(dash.FMS					,'NA')FMS					,
		ISNULL(dash.OverSpeed			,'NA')OverSpeed			,
		ISNULL(dash.OverSpeedDuration	,'NA')OverSpeedDuration	,
		--ISNULL(dash.OverSpeedLimit		,'NA')OverSpeedLimit		,
		ISNULL(dash.Moving				,'NA')Moving				,
		ISNULL(dash.Idling				,'NA')Idling				,
		ISNULL(dash.IdlingDuration		,'NA')IdlingDuration		,
		ISNULL(dash.PowerCutOff			,'NA')PowerCutOff			,
		ISNULL(dash.Panic				,'NA')Panic				,
		ISNULL(dash.LowBattery			,'NA')LowBattery			,
		CASE WHEN ISNULL(dash.Fuel,'') = '' THEN 'NA' ELSE dash.Fuel END AS [Fuel],
		ISNULL(dash.Mobilize_Immobilize	,'NA')Mobilize_Immobilize	,
		ISNULL(dash.[Status]			,'NA')[Status]			,		
		ISNULL(dash.CurrentStatus			,'NA')VehicleCurrentStatus			,		
		

		CONVERT(VARCHAR(10),
		CASE 
			WHEN CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT) <=59 THEN 0
			ELSE CONVERT(DECIMAL(18,0),CONVERT(DECIMAL(18,6),CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT))/60) 
		END) VehicleCurrentStatusDurationHours,

		CONVERT(VARCHAR(10),
		CASE 
			WHEN CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT) <=59 THEN ISNULL(dash.CurrentStatusDuration ,'0') 
			ELSE CONVERT(DECIMAL(18,0),CONVERT(DECIMAL(18,6),CAST(ISNULL(dash.CurrentStatusDuration ,'0') AS BIGINT))%60) 
		END) VehicleCurrentStatusDurationMins,

		ISNULL(
		CASE 
			WHEN ISNULL(bdVeh.FK_VehicleId,0) <> 0  THEN 'BREAKDOWN'
			WHEN ISNULL(Status,'') =  'NP' OR ISNULL(Status,'') =  ''  THEN 'OFFLINE'
			WHEN ISNULL(Status,'') =  'P'  AND ISNULL(Status,'') <> '' AND ISNULL(dash.Speed,'') <> '' AND CONVERT(DECIMAL(18,2),ISNULL(dash.Speed,'')) > 0.0 THEN 'MOVING'
			WHEN ISNULL(Status,'') =  'P'  AND ISNULL(Status,'') <> '' AND (ISNULL(dash.Speed,'') = '' OR CONVERT(DECIMAL(18,2),ISNULL(dash.Speed,'')) = 0.0) AND ISNULL(dash.Ignition,'') = 'ON' THEN 'IDILING'
			WHEN ISNULL(Status,'') =  'P'  AND ISNULL(Status,'') <> '' AND ISNULL(dash.Speed,'') <> '' AND CONVERT(DECIMAL(18,2),ISNULL(dash.Speed,'')) = 0.0 AND (ISNULL(dash.Ignition,'') = '' OR ISNULL(dash.Ignition,'') = 'OFF') THEN 'STOP'

		ELSE '' END,'NA')
		AS VehicleStatus,



		CASE WHEN ISNULL(Status,'') =  'NP' THEN ISNULL(vehType.OfflineIcon,'') ELSE ISNULL(dash.Icon,'NA') END,



		CASE WHEN ISNULL(Speed,'') = '' THEN 'NA' ELSE Speed END AS [Speed],
		ISNULL(PowerMode   ,'NA') PowerMode,
		ISNULL(BatteryLevel,'NA') BatteryLevel,
		
		CASE WHEN dash.InsertedDateTime IS NULL THEN 'NA' ELSE FORMAT(CONVERT(DATETIME,dash.InsertedDateTime,103),'dd/MM/yyyy HH:mm:ss') END InsertedDateTime,

		CASE 
			WHEN SubscriptionStatus.FK_VehicleId IS NOT  NULL AND  CONVERT(DATETIME,SubscriptionStatus.SubscriptionEndDatetime, 103) <  GETDATE() THEN 'EXPIRED'
			WHEN SubscriptionStatus.FK_VehicleId IS NOT  NULL AND  CONVERT(DATETIME,SubscriptionStatus.SubscriptionEndDatetime, 103) >= GETDATE() THEN 'SUBSCRIBED'
			WHEN SubscriptionStatus.FK_VehicleId IS NULL THEN 'NOT SUBSCRIBED'
			ELSE 'NA'
		END AS [VehicleSubscriptionStatus],

		ISNULL(CustVeh.CustomerName,'') CustomerName,


		CASE 
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >0 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 6 THEN '1.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >6 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 12 THEN '2.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >12 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 18 THEN '3.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >18 AND CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) <= 24 THEN '4.png'
			WHEN CONVERT(DECIMAL,ISNULL(dash.SatelliteCount,'0.0')) >24 THEN '5.png'
		ELSE 'NA'
		END
		SignalStrength
		

		FROM TRANS_Dashboard(NOLOCK) dash
		LEFT JOIN MST_BreakDownVehicle(NOLOCK) bdVeh
		ON dash.FK_VehicleId = bdVeh.FK_VehicleId

		LEFT JOIN #TempVehicleSubsciptionData SubscriptionStatus
		ON dash.FK_VehicleId = SubscriptionStatus.FK_VehicleId

		LEFT JOIN MST_Customer(NOLOCK) CustVeh
		ON dash.FK_CustomerId = CustVeh.PK_CustomerId

		LEFT JOIN  MST_Vehicle(NOLOCK) vehMst
		ON ISNULL(dash.FK_VehicleId,0) = ISNULL(vehMst.PK_VehicleId,0)
		LEFT JOIN  MST_VehicleType(NOLOCK) vehType
		ON ISNULL(vehMst.FK_VehicleTypeId,0) = ISNULL(vehType.PK_VehicleTypeId,0)

		WHERE		
		ISNULL(dash.FK_CustomerId,0) = CASE WHEN ISNULL(@iClientCustomerId,0) <> 0 THEN ISNULL(@iClientCustomerId,0) ELSE ISNULL(dash.FK_CustomerId,0) END
		AND
		1=
			(
				CASE 
					WHEN @cLoginType='COMPANY' AND (
														dash.FK_AccountId IN    
                                                        (    
                                                            SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
                                                            INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
                                                            WHERE 
															--FK_UserId=@iUserId and
      FMUA.IsActive=1 and FMU.IsActive=1    
                                                            --AND @iAccountId= 1
                                                        )    
                                                        OR     
                                                        ISNULL(dash.FK_AccountId,0) =@iAccountId
                                                    )  THEN 1

					WHEN @cLoginType='CUSTOMER' AND	dash.FK_CustomerId IN 
																			(
																				SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
																				WHERE
																				IsActive=1
																				AND PK_CustomerId    = @iLoggedInCustomerId
																				OR ISNULL(FK_ParentCustomerId,0)    = @iLoggedInCustomerId
                                                                            )  THEN 1

					WHEN @cLoginType='RESELLER' AND dash.FK_AccountId IN
																			(
																				 SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
																				 WHERE
																				 IsActive=1
																				 AND PK_AccountId    = @iAccountId
																				 OR ISNULL(FK_ResellerId,0)    = @iAccountId    
																			)	THEN 1

					WHEN @cLoginType='AFFILIATE' AND dash.FK_AccountId IN	(
																				SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
																				WHERE
																				IsActive=1
																				AND PK_AccountId    = @iAccountId
																				OR ISNULL(FK_AffiliateId,0)    = @iAccountId    
																			) THEN 1
                ELSE 0
				END
			)
		AND
		(
			dash.FK_VehicleId IN
			(
				SELECT 
				DISTINCT VG.FK_VehicleId
				FROM MST_VehicleGrouping(NOLOCK) VG 
				WHERE 
				ISNULL(VG.GroupName,'') LIKE '%'+ISNULL(@cVehicleGroupName,'')+'%'
				AND VG.IsActive = 1

				AND
				1=
				(
					CASE 
						WHEN @cLoginType='COMPANY' AND (
															VG.FK_CustomerId IN  
				                                            (    
																SELECT PK_CustomerId FROM MST_Customer(NOLOCK) custmr
																WHERE
																custmr.FK_AccountId IN
																(
																	SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA     
																	INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId     
																	WHERE 
																	FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and
																	FMUA.IsActive=1 and FMU.IsActive=1    
																	AND @iAccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')        
																	--FK_UserId=@iUserId and
																	--FMUA.IsActive=1 and FMU.IsActive=1    
																	--AND @iFK_AccountId=6  
																)
				                                            )                                            
				                                        )  THEN 1
				
						WHEN @cLoginType='CUSTOMER' AND	VG.FK_CustomerId IN 
																				(
																					SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)
																					WHERE
																					IsActive=1
																					AND PK_CustomerId    = @iLoggedInCustomerId
																					OR ISNULL(FK_ParentCustomerId,0)    = @iLoggedInCustomerId
				                                                                )  THEN 1
				
						WHEN @cLoginType='RESELLER' AND VG.FK_CustomerId IN
																				(
				
																					SELECT PK_CustomerId FROM MST_Customer(NOLOCK) custmr
																					WHERE
																					custmr.FK_AccountId IN
																					(
																						SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
																						WHERE
																						IsActive=1
																						AND PK_AccountId    = @iAccountId
																						OR ISNULL(FK_ResellerId,0)    = @iAccountId  
																					)  
																				)	THEN 1
				
						WHEN @cLoginType='AFFILIATE' AND VG.FK_CustomerId IN	(
				
																					SELECT PK_CustomerId FROM MST_Customer(NOLOCK) custmr
																					WHERE
																					custmr.FK_AccountId IN
																					(
																					
																						SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)
																						WHERE
																						IsActive=1
																						AND PK_AccountId    = @iAccountId
																						OR ISNULL(FK_AffiliateId,0)    = @iAccountId  
																					)  
																				) THEN 1
						ELSE 0
					END
				)			
			)
			
		)
		AND
		dash.FK_VehicleId IN
		(
			CASE 
			WHEN ISNULL(@cCommaSeparatedVehicle_IDs,'') <> '' AND ISNULL(@cCommaSeparatedVehicle_IDs,'') <> '0' THEN (SELECT DISTINCT Item FROM dbo.SplitString(@cCommaSeparatedVehicle_IDs,',') WHERE ISNULL(Item,'') <> '')
			ELSE (SELECT dash.FK_VehicleId) END
		)
	END

	SELECT  * FROM #TempTransDashboardData

	SELECT
	ISNULL(SUM(1)														  ,0)	AllVehiclesCount,
	ISNULL(SUM(CASE WHEN VehicleStatus = 'MOVING'		THEN 1 ELSE 0 END),0)	MovingVehiclesCount,
	ISNULL(SUM(CASE WHEN VehicleStatus = 'IDILING'		THEN 1 ELSE 0 END),0)	IdilingVehiclesCount,
	ISNULL(SUM(CASE WHEN VehicleStatus = 'STOP'		THEN 1 ELSE 0 END)    ,0)	StopVehiclesCount,
	ISNULL(SUM(CASE WHEN VehicleStatus = 'OFFLINE'		THEN 1 ELSE 0 END),0)	OfflineVehiclesCount,
	ISNULL(SUM(CASE WHEN VehicleStatus = 'BREAKDOWN'	THEN 1 ELSE 0 END),0)	BreakdownVehiclesCount

	FROM #TempTransDashboardData

	IF OBJECT_ID('tempdb..#TempTransDashboardData') IS NOT NULL 
	DROP TABLE #TempTransDashboardData

END TRY


BEGIN CATCH
	IF OBJECT_ID('tempdb..#TempTransDashboardData') IS NOT NULL 
	DROP TABLE #TempTransDashboardData

	IF OBJECT_ID('tempdb..#TempVehicleSubsciptionData') IS NOT NULL 
	DROP TABLE #TempVehicleSubsciptionData

	SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[usp_GyanmitrasGetSubMenuSvc]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************      
Created By: Nitin Gupta      
Created Date: 2020-02-01      
Purpose:Get Menu For DroupDownList      
EXEC [dbo].[usp_GyanmitrasGetSubMenuSvc]  10,27     
        
*******************************************************************/      
CREATE PROCEDURE [dbo].[usp_GyanmitrasGetSubMenuSvc]      
(                
             @iRoleId       INT,      
             @iFormId      INT        
)       
AS      
 BEGIN      
  BEGIN TRY      
        ;WITH FormList      
               as      
                      (      
                              SELECT  PK_FormId, FormName,FK_ParentId,LevelId,SortId      
                              FROM MST_Form where ISNULL(FK_ParentId,0) =0      
                              and PK_FormId=@iFormId AND isActive=1      
                              UNION ALL      
                              SELECT  a.PK_FormId, a.FormName, a.FK_ParentId ,a.LevelId,a.SortId      
                              FROM MST_Form a      
                                   
                              WHERE a.FK_ParentId =@iFormId AND a.isActive=1      
                      )      
              select * from  FormList a      
              LEFT JOIN      
     [dbo].[MAP_FormRole_MobileApp]  b on a.PK_FormId=b.FK_FormId      
              where b.FK_RoleId=@iRoleId    
			  ORDER BY a.PK_FormId ASC
            
  END TRY --2      
  BEGIN CATCH       
      
         
  END CATCH;       
 END;



GO
/****** Object:  StoredProcedure [dbo].[usp_LogApplicationError]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
Created By: TARIQUE KHAN
Created Date: 2020-01-06
Purpose: Log Application Lever Error Details.
SELECT * FROM  [dbo].[ErrorLog_App] 
*******************************************************************/
CREATE PROCEDURE [dbo].[usp_LogApplicationError]
(
	@cSource				VARCHAR(100),
	@cAssemblyName			VARCHAR(100),
	@cClassName				VARCHAR(100),
	@cMethodName			VARCHAR(100),
	@cErrorMessage			VARCHAR(300),
	@cErrorType 			VARCHAR(100),
	@cRemarks				VARCHAR(100)
)
AS
	BEGIN
		INSERT [dbo].[ErrorLog_App] (ErrorTime,Source,Assembly_Name,Class_Name,Method_Name,ErrorMessage,ErrorType,Remarks )
		VALUES ( GETDATE(),@cSource,@cAssemblyName,@cClassName,@cMethodName,@cErrorMessage,@cErrorType,@cRemarks )
	END;



GO
/****** Object:  StoredProcedure [dbo].[usp_LogServiceError]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
Created By: JYOTI SOLANKI
Created Date: 14 JAN 2020
Purpose: Log SERVICE Lever Error Details.
SELECT * FROM  [dbo].[ErrorLog_Service]
SELECT * FROM [dbo].[ErrorLog_App] 
*******************************************************************/
CREATE PROCEDURE [dbo].[usp_LogServiceError]
	(
		@cSource				varchar(100),
		@cAssemblyName			varchar(100),
		@cClassName				varchar(100),
		@cMethodName			varchar(100),
		@cErrorMessage			nvarchar(max),
		@cRemarks				nvarchar(max)
	)
AS
	BEGIN
		INSERT dbo.ErrorLog_Service (ErrorTime,Source,Assembly_Name,Class_Name,Method_Name,ErrorMessage,Remarks )
		VALUES ( GETDATE(),@cSource,@cAssemblyName,@cClassName,@cMethodName,@cErrorMessage,@cRemarks )
	END;



GO
/****** Object:  StoredProcedure [dbo].[USP_MapFormRoleAddEdit]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_MapFormRoleAddEdit]
@FK_FormId		 bigint
,@FK_RoleId		 bigint
,@CanAdd		 bit
,@CanEdit		 bit
,@CanDelete		 bit
,@CanView		 bit
,@IsActive		 bit
,@CreatedBy		 bigint
AS 
BEGIN
delete [dbo].[Map_FormRole]  where FK_FormId=  @FK_FormId and  FK_RoleId = @FK_RoleId
insert into [dbo].[Map_FormRole] (
FK_FormId
,FK_RoleId
,CanAdd
,CanEdit
,CanDelete
,CanView
,IsActive
--,IsDeleted
,CreatedBy
)
SELECT 
 @FK_FormId 
,@FK_RoleId
,@CanAdd
,@CanEdit
,@CanDelete
,@CanView
,@IsActive
--,@IsDeleted
,@CreatedBy

SELECT 1 Message_Id,'Mapping Inserted Successfuly!' Message;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_RoleById]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************
Created By: sandeep kumar
Created Date: 2019-12-02
Purpose: Select Role details based on Id
SELECT * FROM MST_ROLE
EXEC [dbo].[usp_RoleById]  1
*******************************************************************/
CREATE PROCEDURE [dbo].[USP_RoleById] 
	(
		@PK_RoleId				bigint		
 	)
AS
	BEGIN
		BEGIN TRY
		       SELECT [PK_RoleId],[RoleName],[Role].[IsActive],[FK_CategoryId],[FK_AccountId] FROM  [dbo].[MST_Role](NOLOCK) [Role]
					INNER JOIN [dbo].[MST_Category](NOLOCK) Category ON [Role].FK_CategoryId=Category.PK_CategoryId
					  WHERE  
					  [PK_RoleId]=@PK_RoleId
			  
		END TRY
		BEGIN CATCH 
		      SELECT 0 [Message_Id], ERROR_MESSAGE() [Message]
		END CATCH;
	END;




GO
/****** Object:  StoredProcedure [dbo].[USP_SaveAndGenerateTokenForWeb]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/***************************************************************    
CREATED BY : MD. TARIQUE

CREATED DATE : 12 FEB 2020

PURPOSE : TO SAVE DATA AND GENERATE AND TOKEN NUMBER

EXEC [dbo].[USP_SaveAndGenerateTokenForWeb]
1,1,'test','0','60'  
****************************************************************/    
CREATE PROCEDURE [dbo].[USP_SaveAndGenerateTokenForWeb]    
(    
	@iVehicleId BIGINT,  
	@iUserId BIGINT,   
	@cRegNo VARCHAR(100),    
	@iMinutes INT
)    
AS    
BEGIN TRY

	DECLARE @DB_NAME VARCHAR(20)       
	SELECT @DB_NAME=DB_NAME() ;     
	IF(ISNULL(@cRegNo,'')!='' AND ISNULL(@iMinutes,0)!=0 AND @iVehicleId!=0 )    
	BEGIN    
		INSERT INTO [dbo].[Trans_ShareOnMobile]    
		(    
			Fk_VehicleId,    
			RegistrationNo,    
			FromDate,    
			ToDate    
		)    
		VALUES    
		(   
			@iVehicleId,    
			@cRegNo,    
			CONVERT(DATETIME,GETDATE(),103),    
			CONVERT(DATETIME,DATEADD(MINUTE,@iMinutes,GETDATE()),103)    
		)    
	
		DECLARE @PK_ID INT    
		SET @PK_ID=SCOPE_IDENTITY()    
		UPDATE [dbo].[Trans_ShareOnMobile]    
		SET TokenNo=CONVERT(VARCHAR,CONVERT(NUMERIC(12,0),RAND() * 10000000000))    
		WHERE PK_ShareId=@PK_ID    
	
		UPDATE [dbo].[Trans_ShareOnMobile]    
		SET URL=
		CASE 
			WHEN @DB_NAME= 'Gyanmitras_Live' THEN 'http://Gyanmitras.vseen.my/ShareOnMobile/Index?TokenNo=' +TokenNo    
			WHEN @DB_NAME= 'Gyanmitras_Dev' THEN 'http://182.76.79.236:10003/ShareOnMobile/Index?TokenNo='+TokenNo			
			ELSE 'http://182.76.79.236:10001/ShareOnMobile/Index?TokenNo='+TokenNo  END      
		WHERE PK_ShareId=@PK_ID    
	
	
		SELECT 1 AS Message_Id,'Added Successfully' AS Message,1 as status    
		 
		SELECT TokenNo,    
		CASE 
		WHEN @DB_NAME= 'Gyanmitras_Live' THEN 'http://Gyanmitras.vseen.my/ShareOnMobile/Index?TokenNo='    
		WHEN @DB_NAME= 'Gyanmitras_Dev' THEN 'http://182.76.79.236:10003/ShareOnMobile/Index?TokenNo='     
		ELSE 'http://182.76.79.236:10001/ShareOnMobile/Index?TokenNo=' END 
		
		
		
		--'http://localhost:64930/ShareOnMobile/Index?TokenNo=' -- FOR TESTING : OPEN THIS AND COMMENT ABOVE VALUE
		AS [URL]     
		FROM [dbo].[Trans_ShareOnMobile] WHERE PK_ShareId=@PK_ID    
	
	END    
	ELSE    
	BEGIN    
		SELECT 0 AS Message_Id,'Details Cannot Be Empty' AS Message    
	END    
      
END TRY    
BEGIN CATCH    
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message    
END CATCH



GO
/****** Object:  StoredProcedure [dbo].[USP_SaveFormAccountMapping]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:sandeep Kumar     
CreatedDate:18-12-2019 
purpos:Save Form Account Mapping
[dbo].[USP_SaveFormAccountMapping]        
EXEC [dbo].[USP_SaveFormAccountMapping] 1,1,1,1,1,1,1,1
****************************************************/
CREATE PROCEDURE [dbo].[USP_SaveFormAccountMapping] 
    (
	 @iPK_FormAccountId       BIGINT,
	 @iFK_FormId              BIGINT,
	 @iFK_AccountId           BIGINT,
	 @iFK_CategoryId          BIGINT,
	 @bIsActive               BIT,
	 @bIsCustomerAccount      BIT,
	 @iUserId                 BIGINT,
	 @iFK_CustomerId          BIGINT=0,
     @cLoginType              VARCHAR(50)=''  
    )
AS
BEGIN
BEGIN TRY
		 BEGIN
		   IF (@iPK_FormAccountId =0)	 
			 BEGIN
			   IF NOT EXISTS(select 1 from  [dbo].[Map_FormAccount] where FK_FormId =  @iFK_FormId    AND FK_AccountId =@iFK_AccountId AND IsActive=1)	
			      BEGIN
				  INSERT INTO MAP_FormAccount
				  (   
				  FK_FormId,          
				  FK_AccountId,       
				  FK_CategoryId, 
				  IsCustomerAccount,        
				  IsActive,
				  CreatedBy,
				  CreatedDateTime
				   )
                 VALUES
				 ( 
				 @iFK_FormId,        
				 @iFK_AccountId,     
				 @iFK_CategoryId, 
				 @bIsCustomerAccount,             
				 @bIsActive,
				 @iUserId,         
				 GETDATE() 
				 ) 
				 SELECT 1 AS Message_Id,'Form Account  Mapping added successfully.' AS Message
			     END
			   ELSE
			   BEGIN
			      SELECT 0 AS Message_Id,'Form Account Mapping already Exists.' AS Message
			   END
	        END
		ELSE  
		  IF NOT EXISTS(select 1 from  [dbo].[Map_FormAccount] where FK_FormId =  @iFK_FormId AND FK_AccountId =@iFK_AccountId and PK_FormAccountId <> @iPK_FormAccountId)	
			     BEGIN
			     UPDATE Map_FormAccount SET 
			     FK_FormId         =  	  @iFK_FormId, 
			     FK_AccountId      =       @iFK_AccountId,     
			     FK_CategoryId     =       @iFK_CategoryId, 
			     IsCustomerAccount =       @bIsCustomerAccount,             
			     IsActive          =       @bIsActive,    
			     UpdatedBy         =       @iUserId,         
			     UpdatedDateTime   =        GETDATE() 
			     WHERE PK_FormAccountId =@iPK_FormAccountId 
			     SELECT 2 AS Message_Id,'Form Account Mapping updated successfully.' AS Message
			     END	
         ELSE 
		 BEGIN
		     SELECT 0 AS Message_Id,'Form Account Mapping already Exists.' AS Message
		 END
	 END
END TRY
BEGIN CATCH
	 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message
END CATCH
END;     
				
				 				 





GO
/****** Object:  StoredProcedure [dbo].[usp_SaveUserAccountMapping]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************          
Created By: Prince kumar srivastva      
Created Date:12-12-2019         
Purpose: Get Save  User Account Mapping        
EXEC [dbo].[usp_SaveUserAccountMapping]   0,10,2,'',''        
*******************************************************************/      
    
CREATE PROCEDURE [dbo].[usp_SaveUserAccountMapping]      
(      
--declare 
 @iPK_Map_UserAccountId BIGINT=0,   
 @iFK_UserID BIGINT,--=2,
 @iFK_CategoryId BIGINT,--=2, 
 @bIsCustomerAccount BIT,--='false',  
 @bIsActive BIT ,  --='false'  
 @iUserId    BIGINT,                --=1
 @cAccountIDs  VARCHAR(MAX),
 @iFK_CustomerId BIGINT=0,
 @cLoginType  VARCHAR(MAX)=''--='8'  --@iFk_AccountIds     
)      
AS      
BEGIN TRY      
DECLARE @list varchar(max)    
  DECLARE @pos INT    
  DECLARE @len INT    
  DECLARE @value varchar(20)    
    
  SET @list = @cAccountIDs+','    
  SET @pos = 0    
  SET @len = 0    
    
  WHILE CHARINDEX(',', @list, @pos+1)>0    
  BEGIN    
   SET @len = CHARINDEX(',', @list, @pos+1) - @pos    
   SET @value = SUBSTRING(@list, @pos, @len)    
   IF(ISNULL(@value,'')<>'')    
   BEGIN    
    IF EXISTS    
    (    
     SELECT 1 FROM MAP_UserAccount(NOLOCK)    
     WHERE FK_UserId  = @iFK_UserID    
     AND FK_AccountId  = CAST(@value AS BIGINT)    
    )    
    BEGIN    
     UPDATE MAP_UserAccount           
     SET          
     FK_UserId =@iFK_UserID  ,          
     FK_AccountId =CAST(@value AS BIGINT),                 
	 FK_CategoryId=@iFK_CategoryId,  
     IsCustomerAccount=@bIsCustomerAccount,
	 IsActive=@bIsActive ,
	 UpdatedBy = @iUserId ,          
     UpdatedDateTime = GETDATE()        
     WHERE FK_UserId  = @iFK_UserID    
     AND FK_AccountId  = CAST(@value AS BIGINT)          
     END    
     ELSE    
     BEGIN       
     INSERT INTO MAP_UserAccount            
     (          
      FK_UserId        
     ,FK_AccountId
	 ,FK_CategoryId  
	 ,IsCustomerAccount        
     ,IsActive        
     
     ,CreatedBy        
     ,CreatedDateTime   
            
      )   
            
     SELECT       
      @iFK_UserID       
     ,CAST(@value AS BIGINT)
	 ,@iFK_CategoryId 
	 ,@bIsCustomerAccount           
     ,@bIsActive        
     
     ,@iUserId         
     ,GETDATE()   
      
    END         
  END    
    
   SET @pos = CHARINDEX(',', @list, @pos+@len) +1    
    
  END    

  IF(@iPK_Map_UserAccountId=0)
     BEGIN
        SELECT 1 AS Message_Id, 'User Account Mapping Added Successfully.' AS Message 
     END
  ELSE
     BEGIN
        SELECT 2 AS Message_Id, 'User Account Mapping Updated Successfully.' AS Message 
     END

END TRY          
BEGIN CATCH      
 SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message      
END CATCH      
      
      

	
    
         
        
    
    
    
    
    
    
    
    
    






GO
/****** Object:  StoredProcedure [dbo].[Usp_SvcAuthenticateGyanmitrasUserWithRegID]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************************                  
Created By: Nitin Gupta                  
Created Date: 05/02/2020                  
Purpose: Validate User login and Return User Based Menu access and package SERVICE                      
 EXEC [dbo].[Usp_SvcAuthenticateGyanmitrasUserWithRegID] 'shivamsaluja', '1234','FR', 'ANDROID','3211321313213131313131313131312313131','78787878787822','test'                 
 EXEC [dbo].[Usp_SvcAuthenticateGyanmitrasUserWithRegID] 'dadmin', 'bsl@321','FR', 'ANDROID','3211321313213131313131313131312313131','78787878787822','test'       
  EXEC [dbo].[Usp_SvcAuthenticateGyanmitrasUserWithRegID] 'mobile', 'mobile','FR', 'ANDROID','3211321313213131313131313131312313131','78787878787822','test'           
EXEC [dbo].[Usp_SvcAuthenticateGyanmitrasUserWithRegID] 'lianlee', 'yZA/NeA3ZOv8tp8fk0dU2w==','FR', 'ANDROID','dMszZb535Fg:APA91bFNHWmq_QMiS9XBl-xnoy1RZuggiVVbwMoLhQwTxfpjmALWcXiFWBLM0AHo8U_bwBisXhm1l1b8OaT6n5bjzfO95gtzAos5aXmtLYsj4hhLg7IMCCAELRBKmQYuye953dsYJwP6','862183042070434','test'      
***************************************************************************/                  
CREATE PROCEDURE [dbo].[Usp_SvcAuthenticateGyanmitrasUserWithRegID]                  
(                
 @cUserName    varchar(50),                
 @cPassword    varchar(50),                
 @cAppName    VARCHAR(100),                
 @cOSType    VARCHAR(100),              
 @cRegId    VARCHAR(MAX),              
 @cIMEINo    VARCHAR(100),           
 @cUnquieID    NVARCHAR(100),           
 @cLanguage    nvarchar(100)=''              
)                
 AS                 
  BEGIN TRY                   
    IF  EXISTS(SELECT 1 FROM  [dbo].[MST_User](NOLOCK) WHERE LTRIM(RTRIM(UserName)) = LTRIM(RTRIM(@cUserName)) AND LTRIM(RTRIM(UserPassword)) = LTRIM(RTRIM(@cPassword)) AND IsActive= 1)                    
     BEGIN              
      UPDATE [dbo].[MST_User]              
      SET AppRegId=@cRegId,                
      IMEINo=@cIMEINo,                
      OSType=@cOSType,                
      LastLoginDt=GETDATE()                
      WHERE LTRIM(RTRIM(UserName)) = LTRIM(RTRIM(@cUserName)) AND LTRIM(RTRIM(UserPassword)) = LTRIM(RTRIM(@cPassword))                
      AND ISACTIVE=1
	            
   DECLARE                            
  @iRoleID   BIGINT ,                   
  @AccountId BIGINT,            
  @Userid   Bigint,  
  @cCategoryName NVARCHAR(30)                   
                        
  SELECT                             
  @iRoleID  = FK_RoleId,                
  @AccountId = FK_AccountId,          
  @Userid = PK_UserId,  
  @cCategoryName= RTRIM(LTRIM(ISNULL(CTGR.CategoryName,'')))       
          
  FROM MST_User(NOLOCK) USR                            
  INNER JOIN MST_Category (NOLOCK)  CTGR ON                            
  USR.FK_CategoryId=CTGR.PK_CategoryId                            
  WHERE                             
  UserName = @cUserName AND                             
  UserPassword = @cPassword                            
  AND ISNULL(USR.IsActive,'0') = 1 and ISNULL(CTGR.IsActive,'0') = 1  AND ISNULL(USR.IsDeleted,'0') = 0 and ISNULL(CTGR.IsDeleted,'0') = 0             
            
              
   IF  EXISTS(SELECT 1 FROM  [dbo].[Map_UserUnquieId](NOLOCK) WHERE Fk_UserId =@Userid)          
Begin          
 UPDATE [dbo].[Map_UserUnquieId]              
      SET Fk_UserId=@Userid,                
      UnquieId=@cUnquieID,                
       UpdatedDateTime=GETDATE()           
 WHERE Fk_UserId =@Userid                    
 END                
    ELSE                
     BEGIN                
     insert into  [dbo].[Map_UserUnquieId]              
   (  Fk_UserId,                
      UnquieId,CreatedDateTime)          
   values(@Userid,@cUnquieID,GETDATE() )          
     END                    
                      
                   
  SELECT 1 AS Message_Id,'Success' AS Message ,1 AS status                  
  begin--[GetData of UserInfo for session]                 
   SELECT                 
  Usr.[PK_UserId]  'UserId',                            
  ISNULL(Usr.UserName,'')UserName,                    
  ISNULL(Usr.UserPassword,'')UserPassword,                        
  ISNULL(Usr.[FullName],'') 'Name',                            
  Usr.[FK_RoleId]  'RoleId',                    
  Usr.EmailId ,                            
  Rol.RoleName 'RoleName',                     
  Usr.FK_AccountId   FK_AccountId,                               
  acc.AccountName AccountName,                            
  Usr.FK_CustomerId,                
  Usr.MobileNo,                            
  ISNULL(cust.CustomerName,'')CustomerName,                            
  Usr.FK_CategoryId FK_CategoryId,                             
  cat.CategoryName CategoryName,                               
  Usr.[FK_CityId]  'CityId',                            
  City.[CityName],                            
  City.[FK_StateId]    'StateId' ,                            
  State.[StateName],                            
  Country.[PK_CountryId] 'CountryId',                            
  Country.[CountryName],           
  FORM.FormName,                             
  ISNULL(acc.AccountLogo,'') logoClass,                            
   CASE            
   WHEN LOWER(ISNULL(cat.CategoryName,''))='company' THEN 'COMPANY'                          
   WHEN LOWER(ISNULL(cat.CategoryName,''))='customer' THEN 'CUSTOMER'                             
   WHEN LOWER(ISNULL(cat.CategoryName,''))='reseller' THEN 'RESELLER'                            
   WHEN LOWER(ISNULL(cat.CategoryName,'')) ='affiliate' THEN 'AFFILIATE'                                     
   ELSE '' END    AS LoginType,                          
  ISNULL(acc.FK_ResellerId ,0) FK_ResellerId,                            
  ISNULL(acc.FK_AffiliateId,0) FK_AffiliateId,          
  @cUnquieID uniqueId                            
  FROM  [dbo].[MST_User](NOLOCK) Usr                            
  INNER JOIN MST_Role(NOLOCK) Rol ON Rol.PK_RoleId=Usr.FK_RoleId                            
  LEFT JOIN [dbo].[MST_City](NOLOCK) City ON Usr.FK_CityId=[PK_CityId]            
  LEFT JOIN  MST_FORM(NOLOCK) FORM ON FORM.PK_FormId=Rol.HomePage                             
  LEFT JOIN [dbo].[MST_State](NOLOCK) State ON City.[FK_StateId]=State.[PK_StateId]                            
  LEFT JOIN [dbo].[MST_Country] Country ON Country.[PK_CountryId]=state.[FK_CountryId]                            
  INNER JOIN [MST_Account](NOLOCK) acc ON Rol.FK_AccountId=acc.PK_AccountId                            
  INNER JOIN [MST_Category](NOLOCK) cat ON Usr.FK_CategoryId = cat.PK_CategoryId                 
  LEFT JOIN [MST_Customer](NOLOCK) cust ON Usr.FK_CustomerId = cust.PK_CustomerId                                              
  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword                 
  AND Usr.ISACTIVE=1
                   
  end --[EndGetData of UserInfo for session]            
            
            
            
          
           
                 
                          
     	                
      SELECT Ucmp.PK_CustomerId 'CmpId',LTRIM(RTRIM(CustomerName)) 'CmpName'               
       FROM [dbo].[MST_Customer] Ucmp                  
       WHERE Ucmp.FK_AccountId=@AccountId  
	   and
			1=(  
                            CASE   
       WHEN UPPER(@cCategoryName)='CUSTOMER' AND   Ucmp.PK_CustomerId IN (  
                                                                                          SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)  
                                                                                          WHERE  
                                                                                          IsActive=1  
                                                                                          AND PK_CustomerId    = (SELECT FK_CustomerId FROM MST_User(NOLOCK) Usr  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword  AND ISACTIVE=1   )  
                                                                                          OR ISNULL(FK_ParentCustomerId,0) = (SELECT FK_CustomerId FROM MST_User(NOLOCK) Usr  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword  AND ISACTIVE=1   )  
                                                                                        )  THEN 1  
                             WHEN UPPER(@cCategoryName)='COMPANY' AND (Ucmp.FK_AccountId IN      
                                                                                (      
                   
                     SELECT PK_AccountId from MST_Account fma WHERE ISNULL(fma.IsActive,0)=1 AND ISNULL(fma.IsDeleted,0)=0   
                     or ISNULL(fma.FK_CompanyId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_CompanyId=(SELECT FK_AccountId FROM MST_User(NOLOCK) Usr  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword AND ISACTIVE=1    ))  
                     or ISNULL(fma.PK_AccountId,0) in( select PK_AccountId fROM  [dbo].[MST_Account]  where FK_CompanyId=(SELECT FK_AccountId FROM MST_User(NOLOCK) Usr  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword AND ISACTIVE=1    ))  
                                                                                   
                                                                                )      
                                                                                OR       
                                                                                ISNULL(Ucmp.FK_AccountId,0) =(SELECT FK_AccountId FROM MST_User(NOLOCK) Usr  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword  AND ISACTIVE=1   )  
                                                                )  THEN 1  
                          
  ELSE 0  
                            END  
                      )  
																					           
       ORDER BY PK_CustomerId asc        
          
      SELECT                
      form.PK_FormId, form.FormName,form.FK_ParentId,form.LevelId,form.SortId,                
      ISNULL(fr.CanAdd, 0) CanAdd, ISNULL(fr.CanDelete,0) CanDelete, ISNULL(fr.CanEdit,0) CanEdit , ISNULL(fr.CanView,0) CanView, @iRoleID RoleId                
      FROM MAP_FormRole_MobileApp(NOLOCK) fr                
      --FROM map_formrole fr                
      INNER JOIN                
       MST_Form(NOLOCK) form                
      ON                
      fr.FK_FormId = form.PK_FormId                
      WHERE  fr.FK_RoleId=@iRoleID                 
      AND ISNULL(fr.IsActive,0) = 1                
      AND ISNULL(fr.IsDeleted,0) = 0                
      AND ISNULL(form.FK_ParentId,0)=0                
      ORDER BY   
   --form.FK_ParentId,PK_FormRoleId       
   FormName ASC          
  
           
      IF(@cCategoryName='COMPANY')  
  BEGIN  
   SELECT   
   AlertValue TagName    
   FROM LKP_Alert(NOLOCK)  
  END    
  ELSE IF(@cCategoryName='CUSTOMER')  
  BEGIN  
   SELECT   
   AlertValue TagName    
   FROM LKP_Alert(NOLOCK)  
  END  
 ELSE  
  BEGIN  
   SELECT   
   AlertValue TagName    
   FROM LKP_Alert(NOLOCK)  
  END  
        
               
                 
      --SELECT       
      --TagName              
      --FROM LKP_Alarm(NOLOCK)               
      --UNION               
      --SELECT              
      --TagName              
      --FROM LKP_Events(NOLOCK)              
              
      --SELECT               
      --[TagName]              
      --FROM [dbo].[LKP_](NOLOCK)                  --WHERE FK_CompanyId=@Company_Id              
                    
      --IF EXISTS              
      --(              
      -- SELECT 1 FROM [MST_EmailSMSConfig](NOLOCK)              
      -- WHERE UserId = ISNULL(@User_Id,0) AND FK_CompanyId = ISNULL(@Company_Id,0) AND UPPER(Type) = 'APP NOTIFICATION'              
      --)          
              
           
             
              
     END                
    ELSE                
     BEGIN                
      SELECT 0 AS Message_Id,'Invalid User' AS Message ,1 As status             
             
     END              
  END TRY                
                
  BEGIN CATCH                 
   SELECT 0 AS Message_Id,'Operation failed' AS Message                
  END CATCH;   




GO
/****** Object:  StoredProcedure [dbo].[USP_SVCGetFormRoleMapping]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************  
Created By: Nitin Gupta
Created Date: 05/02/2020 
select * from Map_FormLanguage  
Purpose: Get user form role rights  
EXEC[dbo].[USP_SVCGetFormRoleMapping] 1,''  
*******************************************************************/   
CREATE PROCEDURE [dbo].[USP_SVCGetFormRoleMapping]  
(  
 @iRoleId   bigint,  
 @cLanguage nvarchar(100)  
)  
AS   
BEGIN   
  
 IF(ISNULL(@cLanguage,'')<> '' AND LTRIM(RTRIM(ISNULL(@cLanguage,'')))<>'' AND UPPER(LTRIM(RTRIM(ISNULL(@cLanguage,''))))<>'ENGLISH')  
 BEGIN  
  SELECT  
   ISNULL(PK_FormId,0)PK_FormId  
  ,ISNULL(form.FK_ParentId,0) ParentId  
  ,ISNULL(form.FK_SolutionId,0)FK_SolutionId  
  ,ISNULL(RoleName,'')RoleName  
  ,ISNULL(ControllerName,'')ControllerName   
  ,ISNULL(ActionName,'')ActionName    
  ,ISNULL(LevelId,0)LevelId  
  ,ISNULL(FK_MainId,0) MainId  
  ,ISNULL(SortId,0) SortId  
  ,IsNULL([Image],'') [Image]  
  ,IsNULL(CanAdd ,0)CanAdd  
  ,IsNULL(CanEdit,0)CanEdit   
  ,IsNULL(CanDelete,0)CanDelete   
  ,IsNULL(CanView,0)CanView  
  ,IsNULL(ClassName,'') ClassName  
  ,ISNULL(frole.HomePage,0) HomePage  
  ,ISNULL(form.Area,'') Area  
  ,ISNULL(lkplang.LanguageFullName,0) LanguageFullName  
   FROM MAP_FormRole  (NOLOCK) map  
   INNER JOIN MST_Form(NOLOCK) form  on form.PK_FormId=map.FK_FormId  
   INNER JOIN MST_Role(NOLOCK) frole on map.FK_RoleId=frole.PK_RoleId  
   LEFT JOIN [dbo].[Map_FormLanguage](NOLOCK) mapFormLang ON form.PK_FormId = mapFormLang.FK_FormId  
      LEFT JOIN LKP_Language(NOLOCK)  lkplang ON  mapFormLang.FK_LanguageId=lkplang.PK_LanguageId  
   WHERE map.CanView=1  and  map.FK_RoleId=@iRoleId and  ISNULL(form.IsDeleted,0)=0  
   AND ISNULL(lkplang.[LanguageFullName],'')  = @cLanguage   
   ORDER BY FormName  
 END  
 ELSE  
 BEGIN  
   SELECT  
   DISTINCT  
   form.FormName FormName  
  ,PK_FormId  
  ,ISNULL(form.FK_ParentId,0) ParentId  
     ,ISNULL(form.FK_SolutionId,0)FK_SolutionId  
  ,ISNULL(RoleName,'' )RoleName   
  ,ISNULL(ControllerName,'')ControllerName  
  ,ISNULL(ActionName,'')ActionName    
  ,ISNULL(LevelId,0)LevelId  
  ,ISNULL(FK_MainId,0) MainId  
  ,ISNULL(SortId,0)SortId    
  ,IsNULL([Image],'') [Image]  
     ,IsNULL(CanAdd ,0)CanAdd  
  ,IsNULL(CanEdit,0)CanEdit   
  ,IsNULL(CanDelete,0)CanDelete   
  ,IsNULL(CanView,0)CanView  
  ,IsNULL(ClassName,'') ClassName  
  ,ISNULL(frole.HomePage,0) HomePage  
  ,ISNULL(form.Area,'') Area  
  ,'English' LanguageFullName  
  FROM MAP_FormRole  (NOLOCK) map  
  INNER JOIN MST_Form(NOLOCK) form  on form.PK_FormId=map.FK_FormId  
  INNER JOIN MST_Role(NOLOCK) frole on map.FK_RoleId=frole.PK_RoleId    
  WHERE map.CanView=1  and  map.FK_RoleId=@iRoleId and ISNULL(form.IsDeleted,0)=0  
  ORDER BY FormName  
 END  
END  
  
  
  
  
  



GO
/****** Object:  StoredProcedure [dbo].[USP_SvcGetVehicleDashboardData]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************    
CREATED BY: SALONI BANSAL    
CREATED DATE: 5 Feb 2020    
PURPOSE: TO GET DASHBOARD DATA ACCORDING TO THE REQUEST    
EXEC [dbo].[USP_SvcGetVehicleDashboardData] 1,12,20170,'','COMPANY',1,'test'   
**********************************************************************/    
CREATE PROCEDURE [dbo].[USP_SvcGetVehicleDashboardData]    
(    
  @iAccountId    INT      
 ,@iCustomerId               INT    
 ,@iUserId     INT       
 ,@cDetailType    VARCHAR(50)    
 ,@cLoginType    VARCHAR(500)    
 ,@iRoleId INT,  
 @cuniqueId nvarchar(500)  
)    
AS    
BEGIN    
  
  IF  EXISTS(SELECT 1 FROM  [dbo].[Map_UserUnquieId](NOLOCK) WHERE LTRIM(RTRIM(Fk_UserId)) = @iUserId AND LTRIM(RTRIM(UnquieId)) = LTRIM(RTRIM(@cuniqueId)) )   
  
  BEGIN   
     SELECT 1 AS Message_Id,'Success' AS Message ,1 as status           
 SELECT    
    
  SUM(CASE WHEN ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS PollingCount,    
  SUM(CASE WHEN ISNULL(dash.Status,'')='NP' THEN 1 ELSE 0 END) AS NotPollingCount,     
  SUM(CASE WHEN CONVERT(decimal, Speed)>0 AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS MovingCount,    
  SUM(CASE WHEN CONVERT(decimal, Speed)=0 AND Ignition  = 'ON'  AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS IdlingCount,    
  SUM(CASE WHEN CONVERT(decimal, Speed)=0 AND Ignition<>   'ON'  AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS StationaryCount,    
  SUM(CASE WHEN ISNULL(dash.OverSpeed  ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountOverspeed,    
  SUM(CASE WHEN ISNULL(dash.OverSpeedDuration   ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountOverSpeedDuration,    
  SUM(CASE WHEN ISNULL(dash.PowerCutOff  ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountPowerCutOff,    
  SUM(CASE WHEN ISNULL(dash.PowerMode  ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountPowerMode,     
  SUM(CASE WHEN ISNULL(dash.LowBattery ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountLowBattery,    
  SUM(CASE WHEN ISNULL(dash.Mobilize_Immobilize  ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountMobilize_Immobilize,     
  SUM(CASE WHEN ISNULL(dash.ISGSM  ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountISGSM,    
  SUM(CASE WHEN ISNULL(dash.BatteryLevel  ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountBatteryLevel,      
     
  SUM(CASE WHEN ISNULL(dash.Panic   ,'')   = 'ON' AND ISNULL(dash.Status,'')='P' THEN 1 ELSE 0 END) AS CountPanic     
  FROM     
   dboGyanmitrasTRANS_Dashboard (NOLOCK) dash    
  INNER JOIN MST_Vehicle(NOLOCK) Vehicle ON dash.FK_VehicleId = Vehicle.PK_VehicleId    
  WHERE    
  ISNULL(dash.FK_CustomerId,0) = CASE WHEN ISNULL(@iCustomerId,0) <> 0 THEN ISNULL(@iCustomerId,0) ELSE ISNULL(dash.FK_CustomerId,0) END    
  AND    
    
  1=    
  (    
   CASE     
    WHEN @cLoginType='COMPANY' AND (    
             dash.FK_AccountId IN        
                                              (        
    
              SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA         
                                                        INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId         
                                                        WHERE     
              FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and    
                                                        FMUA.IsActive=1 and FMU.IsActive=1        
                                                        AND @iAccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')            
                  
                                              )        
                         OR         
                                              ISNULL(dash.FK_AccountId,0) =@iAccountId    
                                          )  THEN 1    
    
    WHEN @cLoginType='CUSTOMER' AND dash.FK_CustomerId IN     
                  (    
                   SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)    
                   WHERE    
                   IsActive=1    
                   AND PK_CustomerId    = @iCustomerId    
                   OR ISNULL(FK_ParentCustomerId,0)    = @iCustomerId    
                                                                  )  THEN 1    
    
    WHEN @cLoginType='RESELLER' AND dash.FK_AccountId IN    
                  (    
                    SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)    
                    WHERE    
                    IsActive=1    
                    AND PK_AccountId    = @iAccountId    
                    OR ISNULL(FK_ResellerId,0)    = @iAccountId        
                  ) THEN 1    
    
    WHEN @cLoginType='AFFILIATE' AND dash.FK_AccountId IN (    
                   SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)    
                   WHERE    
                   IsActive=1    
                   AND PK_AccountId    = @iAccountId    
                   OR ISNULL(FK_AffiliateId,0)    = @iAccountId        
                  ) THEN 1    
    ELSE 0    
   END    
  )    
      
  SELECT    
        
   dash.PK_DashboardId    
  ,dash.FK_AccountId    
  ,dash.FK_CustomerId    
  ,dash.FK_VehicleId    
  ,ISNULL(dash.DeviceNo,'') DeviceNo    
  ,ISNULL(dash.SimNo,'') SimNo    
  ,ISNULL(dash.IMEINo,'') IMEINo    
  ,dash.FK_VehicleId    
  ,ISNULL(dash.RegistrationNo,'') RegistrationNo    
  ,ISNULL(dash.ModelName,'') ModelName    
  ,ISNULL(dash.DeviceDateTime,'') DeviceDateTime    
  ,CONVERT(float, dash.Lat)Lat    
  ,CONVERT(float, dash.Long)Long    
  --,dash.Lat    
  --,dash.Long    
  ,ISNULL(dash.Location,'') Location    
  ,ISNULL(dash.OverSpeed,'') OverSpeed    
  ,ISNULL(dash.OverSpeedDuration,'') OverSpeedDuration    
  ,ISNULL(dash.PowerCutOff,'') PowerCutOff    
  ,ISNULL(dash.PowerMode,'') PowerMode    
  ,ISNULL(dash.LowBattery,'') LowBattery    
  ,ISNULL(dash.Mobilize_Immobilize,'') Mobilize_Immobilize    
  ,ISNULL(dash.BatteryLevel,'') BatteryLevel    
      ,ISNULL(dash.Panic,'') Panic    
    
    
  ,ISNULL(dash.Speed,'0') Speed    
  ,ISNULL(dash.Fuel,'') Fuel    
  ,ISNULL(dash.MovingTime,'') MovingTime    
  ,ISNULL(dash.StoppingTime,'') StoppingTime    
  ,ISNULL(dash.IdleTimes,'') IdleTimes    
  ,ISNULL(dash.ISGSM,'') ISGSM    
  ,ISNULL(dash.InsertedDateTime,'') InsertedDateTime    
  ,CASE WHEN dash.Icon IS NULL THEN (CASE WHEN dash.Status='P' THEN 'DefaultIconPoll.png' ELSE 'DefaultIconNotPoll.png' END) ELSE dash.Icon END AS Icon    
    
  ,ISNULL(dash.Status,'') [Status]    
  ,CASE WHEN dash.Serverdatetime IS NULL THEN 'NA' ELSE FORMAT(CONVERT(DATETIME, dash.Serverdatetime,103),'dd/MM/yyyy HH:mm') END Serverdatetime    
  ,ISNULL(dash.FirmwareVersion,'') FirmwareVersion    
  ,ISNULL(dash.HardwareVersion,'') HardwareVersion    
  ,ISNULL(dash.GSMRSSI,'') GSMRSSI    
  ,ISNULL(dash.SatelliteCount,'') SatelliteCount    
  ,ISNULL(dash.BatteryVoltage,'') BatteryVoltage    
  ,ISNULL(dash.LastGPSConnect,'') LastGPSConnect    
  ,ISNULL(dash.AlertRefNo,'') AlertRefNo    
  ,ISNULL(dash.Heading,'') Heading    
  ,ISNULL(dash.PowerMode,'') PowerMode    
  ,ISNULL(dash.BatteryLevel,'') BatteryLevel    
    
  FROM trans_dashboard(NOLOCK) dash    
  INNER JOIN MST_Vehicle(NOLOCK) Vehicle ON dash.FK_VehicleId = Vehicle.PK_VehicleId    
  WHERE    
  ISNULL(dash.FK_CustomerId,0) = CASE WHEN ISNULL(@iCustomerId,0) <> 0 THEN ISNULL(@iCustomerId,0) ELSE ISNULL(dash.FK_CustomerId,0) END    
  AND    
    
  1=    
  (    
   CASE     
    WHEN @cLoginType='COMPANY' AND (    
        dash.FK_AccountId IN        
                                              (        
    
              SELECT FMUA.FK_AccountId from MAP_UserAccount(NOLOCK) FMUA         
                                                        INNER JOIN MST_User(NOLOCK) FMU ON FMUA.FK_UserId=FMU.PK_UserId         
                                                      WHERE     
              FK_UserId=(case when @iUserId = (SELECT DISTINCT PK_UserId FROM MST_USER WHERE UserName = 'dadmin') then FK_UserId else @iUserId end) and    
                                                        FMUA.IsActive=1 and FMU.IsActive=1        
                                                        AND @iAccountId=(SELECT DISTINCT FK_AccountId FROM MST_USER WHERE UserName = 'dadmin')            
                  
                                              )        
                                           OR         
                                              ISNULL(dash.FK_AccountId,0) =@iAccountId    
                                          )  THEN 1    
    
    WHEN @cLoginType='CUSTOMER' AND dash.FK_CustomerId IN     
                  (    
                   SELECT PK_CustomerId FROM dboGyanmitrasMST_Customer (NOLOCK)    
                   WHERE    
                   IsActive=1    
                   AND PK_CustomerId    = @iCustomerId    
                   OR ISNULL(FK_ParentCustomerId,0)    = @iCustomerId    
                                                                  )  THEN 1    
    
    WHEN @cLoginType='RESELLER' AND dash.FK_AccountId IN    
                  (    
                    SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)    
                    WHERE    
                    IsActive=1    
                    AND PK_AccountId    = @iAccountId    
                    OR ISNULL(FK_ResellerId,0)    = @iAccountId        
                  ) THEN 1    
    
    WHEN @cLoginType='AFFILIATE' AND dash.FK_AccountId IN (    
                   SELECT PK_AccountId FROM dboGyanmitrasMST_Account (NOLOCK)    
                   WHERE    
                   IsActive=1    
                   AND PK_AccountId    = @iAccountId    
                   OR ISNULL(FK_AffiliateId,0)    = @iAccountId        
                  ) THEN 1    
    ELSE 0    
   END    
  )    
    
  AND    
  (     

  (CASE WHEN ISNULL(dash.Status,'')='P' THEN 'Polling' ELSE '' END)=@cDetailType
			  OR
			(CASE WHEN CONVERT(float, ISNULL(Speed,'0.0'))>0 AND ISNULL(dash.Status,'')='P' THEN 'Moving' ELSE '' END)= @cDetailType
			  OR  
			(CASE WHEN CONVERT(float, ISNULL(Speed,'0.0'))=0 AND ISNULL(dash.Status,'')='P' AND Ignition= 'ON'THEN 'Idling' ELSE '' END)= @cDetailType
			  OR  
			(CASE WHEN CONVERT(float, ISNULL(Speed,'0.0'))=0  AND ISNULL(dash.Status,'')='P' AND Ignition<> 'ON' THEN 'Stationary' ELSE '' END)= @cDetailType
			  OR
			(CASE WHEN ISNULL(dash.Status,'')='NP' THEN 'NotPolling' ELSE '' END)= @cDetailType
			  OR
			(CASE WHEN ISNULL(dash.Status,'') IN ('P','NP') THEN 'TotalVehicle' ELSE '' END)=@cDetailType	
			)
   
    
  --ORDER BY     
  --AcStatus    DESC,     
  --VibrationAlarm   DESC,     
  --CutOffAlarm    DESC,     
  --CollisionAlarm   DESC,     
  --GeofenceAlarm   DESC,     
  --LowPowerAlarm   DESC,     
  --LowVehiclePowerAlarm DESC,     
  --OverSpeedAlarm   DESC,     
  --HarnesRemoval   DESC,     
  --BatteryTempering  DESC,     
  --BuzzerStatus   DESC,     
  --CasingTempering   DESC,     
  --Immobilizer    DESC,     
  --PanicDriver    DESC,     
  --PanicPassr    DESC   
  end  
   ELSE        
     BEGIN        
      SELECT 0 AS Message_Id,'Invalid User' AS Message ,2 as status    
   end   
     
END 




GO
/****** Object:  StoredProcedure [dbo].[USP_SvcSaveAndGenerateToken]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************      
CREATED BY : SALONI BANSAL      
ModifiedBy : Nitin Gupta    
CREATED DATE : 6 FEB 2020      
PURPOSE : TO SAVE DATA AND GENERATE AND TOKEN NUMBER      
EXEC [dbo].[USP_SvcSaveAndGenerateToken] 1,6,'9c0232f580fe3693','A9TEST','0'    
*****************************************************/   
CREATE PROCEDURE [dbo].[USP_SvcSaveAndGenerateToken]      
(      
@iVehicleId INT,    
@iUserId bigint,     
@cuniqueId   NVARCHAR(100),      
@cRegNo VARCHAR(100),      
@iMinutes INT      
)      
AS      
BEGIN TRY      
  IF  EXISTS(SELECT 1 FROM  [dbo].[Map_UserUnquieId](NOLOCK) WHERE Fk_UserId = @iUserId AND LTRIM(RTRIM(UnquieId)) = LTRIM(RTRIM(@cuniqueId)) )    
   BEGIN    
      DECLARE @DB_NAME VARCHAR(20)         
      SELECT @DB_NAME=DB_NAME() ;       
      IF(ISNULL(@cRegNo,'')!='' AND ISNULL(@iMinutes,0)!=0 AND @iVehicleId!=0 )      
        BEGIN      
           INSERT INTO [dbo].[Trans_ShareOnMobile]      
           (      
            Fk_VehicleId,      
            RegistrationNo,      
            FromDate,      
            ToDate      
           )      
           VALUES      
           (   @iVehicleId,      
            @cRegNo,      
            CONVERT(DATETIME,GETDATE(),103),      
            CONVERT(DATETIME,DATEADD(MINUTE,@iMinutes,GETDATE()),103)      
           )     
           DECLARE @PK_ID INT      
           SET @PK_ID=SCOPE_IDENTITY()      
           UPDATE [dbo].[Trans_ShareOnMobile]      
           SET TokenNo=CONVERT(VARCHAR,CONVERT(NUMERIC(12,0),RAND() * 10000000000))      
           WHERE PK_ShareId=@PK_ID    
           UPDATE [dbo].[Trans_ShareOnMobile]      
           SET URL=CASE WHEN @DB_NAME= 'Gyanmitras_Live' THEN 'http://Gyanmitras.vseen.my/ShareOnMobile/Index?TokenNo=' +TokenNo      
           WHEN @DB_NAME= 'Gyanmitras_Dev' THEN 'http://182.76.79.236:10003/ShareOnMobile/Index?TokenNo='+TokenNo      
           ELSE 'http://182.76.79.236:10001/ShareOnMobile/Index?TokenNo='+TokenNo  END        
           WHERE PK_ShareId=@PK_ID    
           SELECT 1 AS Message_Id,'Added Successfully' AS Message,1 as status   
           SELECT TokenNo,      
           CASE WHEN @DB_NAME= 'Gyanmitras_Live' THEN 'http://Gyanmitras.vseen.my/ShareOnMobile/Index?TokenNo='      
           WHEN @DB_NAME= 'Gyanmitras_Dev' THEN 'http://182.76.79.236:10003/ShareOnMobile/Index?TokenNo='       
           ELSE 'http://182.76.79.236:10001/ShareOnMobile/Index?TokenNo=' END AS [URL]       
           FROM [dbo].[Trans_ShareOnMobile] WHERE PK_ShareId=@PK_ID      
        END      
      ELSE      
        BEGIN      
          SELECT 0 AS Message_Id,'Details Cannot Be Empty' AS Message ,0 as status      
        END      
   END    
  ELSE    
   BEGIN     
          SELECT 0 AS Message_Id,'Logout' AS Message,2 as status      
      END    
END TRY      
BEGIN CATCH      
  SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message      
END CATCH  





GO
/****** Object:  StoredProcedure [SiteUsers].[SiteUserActionManagementByAdmin]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Vinish  
CreatedDate:2020-05-14 00:25:13.513
purpos:
********** ******************************************/  
CREATE PROCEDURE [SiteUsers].[SiteUserActionManagementByAdmin] 
(
	@iPK_Id bigint,
	@iUserId bigint,
	@type varchar(100)
)
AS  
BEGIN TRY 
	IF(@type = 'approve_counselor')
	BEGIN
		UPDATE [SiteUsers].[MST_SiteUser] SET 
		IsApprovedCounselor	= 1,
		ApprovedCounselorDateTime = GETDATE(),
		ApprovedCounselorBy = @iUserId
		WHERE PK_UserId = @iPK_Id
		SELECT 1 Message_Id,'Counselor Approved!' Message;
		RETURN;
	END
	ELSE
	BEGIN
		SELECT 1 Message_Id,'Somthing Went Wrong!' Message;
	END
END TRY  
BEGIN CATCH  
      SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
END CATCH

GO
/****** Object:  StoredProcedure [SiteUsers].[SiteUserSignUp]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Vinish  
CreatedDate: 2020-05-20 20:58:42.910
purpos:
********** ******************************************/  
CREATE PROCEDURE [SiteUsers].[SiteUserSignUp] 
(
	@Name NVARCHAR(100),
	@EmailID NVARCHAR(400),
	@UserName NVARCHAR(200),
	@UserPassword NVARCHAR(100),
	@AdoptionWish BIT = null,
	@FK_CategoryId BIGINT,
	@FK_RoleId BIGINT,
	@type NVARCHAR(100)= '',
	@PK_UserId BIGINT
)
AS  
BEGIN TRY 
	IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] (NOLOCK) WHERE UserName =LTRIM(RTRIM(@UserName)) AND IsActive =1  and ISNULL(@PK_UserId,0) <> PK_UserId )            
	BEGIN            
    --IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] WHERE Mobile_Number=@Mobile_Number  AND IsActive=1   and ISNULL(@PK_UserId,0) <> PK_UserId)                    
    --BEGIN             
    IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] WHERE Email = @EmailID AND IsActive=1  and ISNULL(@PK_UserId,0) <> PK_UserId)                    
    BEGIN  
		IF(ISNULL(@type,'') = 'NewSignUp')
		BEGIN
			INSERT INTO [SiteUsers].[MST_SiteUser] 
		(Name,
		Email,
		UserName,
		UserPassword,
		AdoptionWish,
		FK_CategoryId,
		FK_RoleId,
		IsActive,
		CreatedDateTime,
		IsEmailVerified) 
		VALUES(@Name,
		@EmailID,
		@UserName,
		@UserPassword,
		@AdoptionWish,
		@FK_CategoryId,
		@FK_RoleId,
		1,
		GETDATE(),
		1);

			IF(ISNULL(@FK_CategoryId,0) <> 0)
			BEGIN
				IF(ISNULL(@FK_CategoryId,0) = 1)	
				BEGIN
					SELECT 1 Message_Id,'Dear Student, you have successfully registered now you can login on "Gyanmitras"' Message;
				END
				ELSE IF(ISNULL(@FK_CategoryId,0) = 2)	
				BEGIN
					SELECT 1 Message_Id,'Dear Counselor, you have successfully registered we will inform you shortly' Message;
				END
				ELSE IF(ISNULL(@FK_CategoryId,0) = 3)	
				BEGIN
					SELECT 1 Message_Id,'Dear Volunteer, you have successfully registered now you can login on "Gyanmitras"' Message;
				END
				ELSE
				BEGIN
					SELECT -1 Message_Id,'Somthing went wrong!' Message;
				END
			END
			ELSE
			BEGIN
				SELECT -1 Message_Id,'Somthing went wrong!' Message;
			END
		END
		ELSE IF(ISNULL(@type,'') = 'MailVerification')
		BEGIN
			UPDATE [SiteUsers].[MST_SiteUser] 
			SET IsEmailVerified = 1,
			EmailVerifiedDateTime = GETDATE()
			WHERE PK_UserId = @PK_UserId;
			SELECT 1 Message_Id,'Dear "'+@Name+'" your email verification success, now you can login on Gyanmitras.!' Message;
		END
		ELSE
		BEGIN
			SELECT -1 Message_Id,'Somthing went wrong!' Message;
		END
	END          
    ELSE                    
    BEGIN                    
       SELECT -1 AS Message_Id,'EmailId Already In Use.' AS Message                    
	END                  
	--END          
	--ELSE                    
	--BEGIN                   
	--    SELECT -2 AS Message_Id,'Mobile No. Already In Use.' AS Message                    
	--END             
  END            
  ELSE                  
  BEGIN                 
	SELECT -3 AS Message_Id,'Invalid User Name' As Message     
  END            
END TRY  
BEGIN CATCH  
      SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
END CATCH








GO
/****** Object:  StoredProcedure [SiteUsers].[sp_CheckUserID]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [SiteUsers].[sp_CheckUserID] --'d'
(@UserID varchar(50))
AS
Begin
--Declare @Message varchar(100)
Declare @Message int
Begin Try
Begin
IF ((SELECT  count(UserName) FROM SiteUsers.MST_SiteUser  WHERE UserName=@UserID)=0)
Begin
--Set @Message='Exists'
Set @Message=2000
End
Else
Begin
--Set @Message='Not Exists'
Set @Message=-2000
End
End
End try
Begin Catch
Begin
--Set @Message='Failled'
Set @Message=-2001
End
End Catch
Select @Message as Message;
End


alter table [SiteUsers].[MST_SiteUser] add  [Mobile_Number] [int] NULL
alter table [SiteUsers].[MST_SiteUser] add	[Alternate_Mobile_Number] [int] NULL
alter table [SiteUsers].[MST_SiteUser] add	[Address] [varchar](200) NULL
alter table [SiteUsers].[MST_SiteUser] add	[Zipcode] [int] NULL
alter table [SiteUsers].[MST_SiteUser] add	[FK_StateID] [bigint] NULL
alter table [SiteUsers].[MST_SiteUser] add	[FK_CityID] [bigint] NULL
alter table [SiteUsers].[MST_SiteUser] add	[FK_LanguageKnown] [int] NULL
alter table [SiteUsers].[MST_SiteUser] add	[FK_AreaOfInterest] [bigint] NULL
alter table [SiteUsers].[MST_SiteUser] add	[Image] [nvarchar](200) NULL
alter table [SiteUsers].[MST_SiteUser] add	[HaveSmartPhone] [char](5) NULL
alter table [SiteUsers].[MST_SiteUser] add	[HavePC] [char](5) NULL
alter table [SiteUsers].[MST_SiteUser] add	[AdoptionWish] [char](5) NULL
alter table [SiteUsers].[MST_SiteUser] add	[FK_Education_DetailsID] [int] NULL

ALTER TABLE [SiteUsers].[MST_SiteUser]  WITH CHECK ADD FOREIGN KEY([FK_AreaOfInterest])
REFERENCES [SiteUsers].[MST_AreaOfInterest] ([PK_AreaOfInterest])

GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AddEditContentResourcePage]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---ALTER PROCEDURE---------
/******************************************                
CREATED BY: Vnish             
CREATED DATE: 2020-05-28 23:18:19.360
PURPOSE:        
****************************************************/            
CREATE  PROCEDURE [SiteUsers].[USP_AddEditContentResourcePage]                  
(             
	 @PK_ContantResourceId		BIGINT = 0
	,@FK_RoleId					BIGINT
	,@FK_StateId					BIGINT
	,@FK_SearchCategoryId        BIGINT
	,@FK_SubSearchCategoryId		BIGINT
	,@Heading					NVARCHAR(100)
	,@Description				NVARCHAR(500)
	,@ResourceType				NVARCHAR(50)
	,@ResourceFileName			NVARCHAR(200)
	,@IsActive					BIT
	,@IsDeleted					BIT
	,@CreatedBy					BIT
)                  
AS           
BEGIN TRY                    
    IF(ISNULL(@PK_ContantResourceId,0) = 0)            
    BEGIN            
      INSERT INTO [SiteUsers].[MST_ContentResourcePage]            
      (          
		 FK_RoleId				
		,FK_StateId				
		,FK_SearchCategoryId    
		,FK_SubSearchCategoryId	
		,Heading				
		,Description			
		,ResourceType			
		,ResourceFileName		
		,IsActive				
		,IsDeleted				
		,CreatedBy				
		,CreatedDateTime			
      )                    
      VALUES                    
      (                   
		 @FK_RoleId				
		,@FK_StateId				
		,@FK_SearchCategoryId    
		,@FK_SubSearchCategoryId	
		,@Heading				
		,@Description			
		,@ResourceType			
		,@ResourceFileName		
		,@IsActive				
		,@IsDeleted				
		,@CreatedBy				
		,GETDATE()
      )                 
      SELECT 1 AS Message_Id,'Form Added Successfully.' As Message;                 
  END                   
  ELSE                     
      UPDATE [SiteUsers].[MST_ContentResourcePage]
      SET                  	   
       FK_RoleId			    = @FK_RoleId				
	  ,FK_StateId			    = @FK_StateId				
	  ,FK_SearchCategoryId      = @FK_SearchCategoryId    
	  ,FK_SubSearchCategoryId  	= @FK_SubSearchCategoryId 
	  ,Heading				    = @Heading				
	  ,Description			    = @Description			
	  ,ResourceType			    = @ResourceType			
	  ,ResourceFileName		    = @ResourceFileName		
	  ,IsActive				    = @IsActive				
	  ,IsDeleted			    = @IsDeleted				
	  ,UpdatedBy			    = @CreatedBy	
	  ,UpdatedDateTime          = GETDATE()
      WHERE PK_ContantResourceId = @PK_ContantResourceId
      SELECT 1 AS Message_Id,'Form Details Updated Successfully.' AS Message;      
END TRY                    
BEGIN CATCH                    
       SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message                    
END CATCH




GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AddEditFeed]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [SiteUsers].[USP_AddEditFeed]
(
	@PK_FeedID		Bigint = 0,
	@FK_UserID		Bigint,
	@FeedSubject		varchar(200),
	@FeedDescription varchar(500),
	@MediaType		varchar(100),
	@VideoUrl		varchar(100),
	@ResourceFile	varchar(200),
	@CreatedBy		bigint,
	@IsActive		bit,
	@IsDeleted		bit
)
AS 
BEGIN
 SET NOCOUNT ON;  
 
	IF(@PK_FeedID = 0)
	Begin
	Begin TRAN;
	Begin Try
	SELECT 1 AS Message_Id, 'Feed Created Successfull!' AS Message  
	Insert Into SiteUsers.Mst_Feeds(		
		FK_UserID		
		,FeedSubject	
		,FeedDescription
		,MediaType		
		,VideoUrl		
		,ResourceFile			
		,CreatedBy		
		,IsActive		
		,IsDeleted		
		,CreatedDateTime
	) 
	values
	(
		@FK_UserID		
		,@FeedSubject	
		,@FeedDescription
		,@MediaType		
		,@VideoUrl		
		,@ResourceFile			
		,@CreatedBy		
		,@IsActive		
		,@IsDeleted	
		,GETDATE()
	) 
	Commit;
	End Try
Begin Catch
ROLLBACK;
 --SET @Output = -2000;  
End Catch
End
Else IF(@PK_FeedID>0)
Begin 
	Begin TRAN;
	Begin Try
	SELECT 1 AS Message_Id, 'Feed Updated Successfull!' AS Message  
		Update SiteUsers.Mst_Feeds set
		 FK_UserID		  = @FK_UserID		
		,FeedSubject	  = @FeedSubject	
		,FeedDescription  = @FeedDescription
		,MediaType		  = @MediaType		
		,VideoUrl		  = @VideoUrl		
		,ResourceFile			  = @ResourceFile			
		,CreatedBy		  = @CreatedBy		
		,IsActive		  = @IsActive		
		,IsDeleted		  = @IsDeleted		
		,CreatedDateTime  = GETDATE()
		where PK_FeedID=@PK_FeedID
	Commit;
	End Try
	Begin Catch
	ROLLBACK;
	 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message 
	--SET @Output = -2000;  
	End Catch
	END
 ExitLine:
--Select @Outpu
END


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AddEditManageFeedBack]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:
purpos:Add Edit ManageFeedBackCriteria  
****************************************************/          
CREATE PROCEDURE [SiteUsers].[USP_AddEditManageFeedBack]
(         
	@PK_FeedBackId			BIGINT = 0,
	@FeedBackCriteria_Data [SiteUsers].[Type_FeedBackCriteria] READONLY
)            
 AS            
 BEGIN TRY            
 IF(@PK_FeedBackId=0)    
    BEGIN          
            INSERT INTO [SiteUsers].[MAP_SiteUserFeedBack]          
            (            
				 FK_CounselorID			
				,FK_StudentID			
				,FK_FeedBackCriteriaID	
				,FeedBackBy				
				,IsLikeThisClass		
				,FeedBackSuggesstion	
				,IsActive				
				,CreatedBy				
				,CreatedDateTime
				,RateFeedBack	
            )            
            SELECT   
				 FK_CounselorID			
				 ,FK_StudentID			
				 ,FK_FeedBackCriteriaID	
				 ,FeedBackBy				
				 ,IsLikeThisClass			
				 ,FeedBackSuggesstion		
				 ,IsActive				
				 ,CreatedBy	
				 ,GETDATE()			
				 ,RateFeedBack			
			FROM @FeedBackCriteria_Data;
            SELECT 1 AS Message_Id,'FeedBack Created Successfully!' As Message        
    END         
 ELSE   
    BEGIN           

		--UPDATE [SiteUsers].[MAP_SiteUserFeedBack]
		--SET 
		-- FK_CounselorID			 = FB_D.FK_CounselorID			
		--,FK_StudentID			 = FB_D.FK_StudentID			
		--,FK_FeedBackCriteriaID	 = FB_D.FK_FeedBackCriteriaID	
		--,FeedBackBy				 = FB_D.FeedBackBy				
		--,IsLikeThisClass		 = FB_D.IsLikeThisClass		
		--,FeedBackSuggesstion	 = FB_D.FeedBackSuggesstion	
		--,IsActive				 = FB_D.IsActive				
		--,UpdatedBy				 = FB_D.CreatedBy
		--,UpdatedDateTime         = GETDATE()
		--,RateFeedBack			 = FB_D.RateFeedBack

		--FROM @FeedBackCriteria_Data FB_D
		--JOIN [SiteUsers].[MAP_SiteUserFeedBack] FB
		--ON FB.CreatedDateTime = (SELECT CreatedDateTime FROM [SiteUsers].[MAP_SiteUserFeedBack] WHERE PK_FeedBackId = @PK_FeedBackId)
	

		UPDATE [SiteUsers].[MAP_SiteUserFeedBack]
		SET 
		RateFeedBack = (SELECT TOP 1 RateFeedBack FROM @FeedBackCriteria_Data),
		RatedBy = (SELECT TOP 1 CreatedBy FROM @FeedBackCriteria_Data),
		RateDateTme = GETDATE()

		WHERE CreatedDateTime = (SELECT CreatedDateTime FROM [SiteUsers].[MAP_SiteUserFeedBack] WHERE PK_FeedBackId = @PK_FeedBackId)

		SELECT 1 AS Message_Id,'FeedBack Updated Successfully!' AS Message      
END 
END TRY            
BEGIN CATCH            
SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message            
END CATCH    


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AddEditManageFeedBackCriteria]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:
purpos:Add Edit ManageFeedBackCriteria  
****************************************************/          
CREATE PROCEDURE [SiteUsers].[USP_AddEditManageFeedBackCriteria]            
(         
	@PK_FeedBackCriteriaID	BIGINT = 0,
	@FK_SiteUserCategoryID	BIGINT,
	@FeedbackCriteria		NVARCHAR(100),
	@MarkCriteria_Yes		int,
	@MarkCriteria_No		int,
	@IsActive				bit,
	@CreatedBy				BIGINT
)            
 AS            
 BEGIN TRY            
 IF(@PK_FeedBackCriteriaID=0)    
    BEGIN  
         IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_FeedBackCriteria](NOLOCK) WHERE FeedbackCriteria=LTRIM(RTRIM(@FeedbackCriteria)) AND IsActive =1 AND  ISNULL(IsDeleted,0)=0 )    
           BEGIN         
            INSERT INTO [SiteUsers].[MST_FeedBackCriteria]           
            (            
				FeedbackCriteria
				,FK_SiteUserCategoryID		
				,MarkCriteria_Yes		
				,MarkCriteria_No		
				,IsActive						     
				,CreatedBy
				,CreatedDateTime
            )            
            VALUES            
           (       
				@FeedbackCriteria		
				,@FK_SiteUserCategoryID
				,@MarkCriteria_Yes		
				,@MarkCriteria_No		
				,@IsActive							
				,@CreatedBy		
				,GETDATE()		      
           )            
            SELECT 1 AS Message_Id,'FeedBack Criteria Added Successfully!' As Message        
          END     
         ELSE          
         BEGIN         
           SELECT 0 AS Message_Id,'FeedBack Criteria Already Exists!' AS Message        
         END                  
       
    END         
 ELSE   
    BEGIN           
	IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_FeedBackCriteria](NOLOCK) WHERE FeedbackCriteria=LTRIM(RTRIM(@FeedbackCriteria)) AND IsActive =1 AND  ISNULL(IsDeleted,0)=0 And PK_FeedBackCriteriaID <> @PK_FeedBackCriteriaID)    
	BEGIN 
		UPDATE [SiteUsers].[MST_FeedBackCriteria] SET
			FeedbackCriteria		= @FeedbackCriteria		
			,FK_SiteUserCategoryID   = @FK_SiteUserCategoryID
			,MarkCriteria_Yes		= @MarkCriteria_Yes		
			,MarkCriteria_No		= @MarkCriteria_No		
			,IsActive				= @IsActive							
			,UpdatedBy				= @CreatedBy				         
			,UpdatedDateTime		= GETDATE()	
		WHERE PK_FeedBackCriteriaID=@PK_FeedBackCriteriaID
		SELECT 2 AS Message_Id,'FeedBack Criteria Updated Successfully!' AS Message      
    END
	ELSE
	BEGIN    
		SELECT 0 AS Message_Id,'FeedBack Criteria Already Exists!' AS Message     
    END          
END 
END TRY            
BEGIN CATCH            
SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message            
END CATCH    


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AddEditPlannedCommunication]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Vinish  
CreatedDate:2020-05-14 00:25:13.513
purpos:
********** ******************************************/  
CREATE PROCEDURE  [SiteUsers].[USP_AddEditPlannedCommunication]        
(
  @PlannedCommunicationData SiteUsers.PlannedCommunicationData READONLY,
  @IsAdoptStudent bit = 0
)
  AS  
  BEGIN TRY    
		IF(@IsAdoptStudent = '1' and (SELECT ISNULL(AdoptionWish,0) FROM [SiteUsers].[MST_SiteUser] where PK_UserId = (SELECT TOP 1 FK_StudentID FROM @PlannedCommunicationData)) = 0)  
		BEGIN
			SELECT 1 Message_Id,'Adoption Not Completed due to student wish!' Message;
			return;
		END
		IF EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] where PK_UserId = (SELECT TOP 1 FK_CounselorID FROM @PlannedCommunicationData) AND ISNULL(IsApprovedCounselor,0) = 0 )  
		BEGIN
			SELECT -1 Message_Id,'Your are not a approved counselor so, adoption not completed!' Message;
			return;
		END
		IF EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] where PK_UserId = (SELECT TOP 1 FK_CounselorID FROM @PlannedCommunicationData) AND ISNULL(AdoptionWish,0) = 0)  
		BEGIN
			SELECT -2 Message_Id,'Adoption Not Completed due to your adoption wish, please request for adoption!' Message;
			return;
		END

		--IF(@IsAdoptStudent = '1'
		----Area of interest
		--and 
		--(SELECT ISNULL(FK_AreaOfInterest,'') FROM [SiteUsers].[MST_SiteUser] where PK_UserId = (SELECT TOP 1 FK_StudentID FROM @PlannedCommunicationData))
		--NOT in
		--(SELECT ISNULL(FK_AreaOfInterest,'') FROM [SiteUsers].[MST_SiteUser] where PK_UserId = (SELECT TOP 1 FK_CounselorID FROM @PlannedCommunicationData))
		----Language
		--OR 
		--(SELECT ISNULL(FK_LanguageKnown,'') FROM [SiteUsers].[MST_SiteUser] where PK_UserId = (SELECT TOP 1 FK_StudentID FROM @PlannedCommunicationData))
		--NOT in
		--(SELECT ISNULL(FK_LanguageKnown,'') FROM [SiteUsers].[MST_SiteUser] where PK_UserId = (SELECT TOP 1 FK_CounselorID FROM @PlannedCommunicationData))
		--) 
		--BEGIN
		--	SELECT 1 Message_Id,'Adoption Not Completed due to mismatches adoption parameters!' Message;
		--	return;
		--END
		
         
		INSERT INTO [SiteUsers].[MST_MAP_PlannedCommunication] (
		        FK_CounselorID
		   		,FK_StudentID
				,DateTimeFrom
				,DateTimeTo
				,CommunicationPlan
				,IsActive
				,IsDeleted
				,CreatedDateTime
		)
		SELECT 
				 FK_CounselorID
				,FK_StudentID
				,DateTimeFrom
				,DateTimeTo
				,CommunicationPlan
				,IsActive
				,IsDeleted
				,GETDATE()
		 FROM @PlannedCommunicationData 

		 IF(@IsAdoptStudent = '1')
		 BEGIN
			UPDATE [SiteUsers].[MST_SiteUser] SET 
			IsAdoptedStudent = 1
			,FK_RoleId = 1
			,IsAdoptedStudentDateTime = GETDATE()
			,IsAdoptedStudentByCounselor = (SELECT TOP 1 FK_CounselorID FROM @PlannedCommunicationData )
			WHERE PK_UserId = (SELECT TOP 1 FK_StudentID FROM @PlannedCommunicationData)
			IF NOT EXISTS (SELECT TOP 1 IsAdoptedStudentCounselor FROM [SiteUsers].[MST_SiteUser] WHERE PK_UserId = (SELECT TOP 1 FK_CounselorID FROM @PlannedCommunicationData))
			BEGIN
				UPDATE [SiteUsers].[MST_SiteUser] SET 
				IsAdoptedStudentCounselor = 1
				,AdoptedStudentCounselorDateTime = GETDATE()
				WHERE PK_UserId = (SELECT TOP 1 FK_CounselorID FROM @PlannedCommunicationData)
			END

			SELECT 1 Message_Id,'Student Adopted, Planned Communication Inserted Successfully!' Message;
			return;
		 END
		 
		 SELECT 1 Message_Id,'Planned Communication Inserted Successfully!' Message;
		   
  END TRY  
  BEGIN CATCH  
        SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
  END CATCH













GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AddEditSiteUser]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************               
Created:Vinish          
CreatedDate:2019-12-16 18:31:40.523          
purpos:   
********************************************************************/                  
CREATE PROCEDURE [SiteUsers].[USP_AddEditSiteUser]                    
(                 
   @PK_UserId											bigint  = 0 
  ,@UserName											nvarchar(200) = null
  ,@FK_CategoryId										bigint  
  ,@FK_RoleId											bigint  
  ,@UserPassword										nvarchar(100) = null
  ,@IsActive											bit = 1
  ,@IsDeleted											bit = 0
  ,@CreatedBy											bigint  
  ,@UpdatedBy											bigint  = 0 
  ,@DeletedBy											bigint   = 0
  ,@Name												nvarchar(200)
  ,@Mobile_Number										nvarchar(100) 
  ,@Alternate_Mobile_Number								nvarchar(100) = null
  ,@Address												varchar(200)
  ,@Zipcode												varchar(10)
  ,@FK_StateID											bigint  
  ,@FK_CityID											bigint  
  ,@FK_LanguageKnown									varchar(100) = NULL
  ,@FK_AreaOfInterest									varchar(100) = NULL
  ,@Image												nvarchar(400) = null
  ,@HaveSmartPhone										bit
  ,@HavePC												bit = 0
  ,@AdoptionWish										bit
  ,@Email												nvarchar(400) = null
  ,@Fk_AreaOfInterest_State								bigint = null  
  ,@Fk_AreaOfInterest_District							bigint  = null
  ,@AreYou												nvarchar(100) = NULL
  ,@JoinUsDescription									nvarchar(400) = NULL
  ,@Declaration											bit
  ,@LikeAdoptStudentLater								bit = NULL  

  
  ,@Retired_expertise									varchar(50) = NULL
  ,@Employed_expertise									varchar(50) = NULL
 
  ,@type												varchar(50) = '',
  --@IsEmailVerified										bit = 0,
   @AcademicDetails [SiteUsers].[Type_AcademicDetails]  READONLY
  --,@PlannedCommunicationData SiteUsers.PlannedCommunicationData READONLY
)                    
AS                    
BEGIN TRY 
 IF(@PK_UserId=0)                     
 BEGIN                
  IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] (NOLOCK) WHERE UserName =LTRIM(RTRIM(@UserName)) AND IsActive =1)            
  BEGIN            
   IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] WHERE Mobile_Number=@Mobile_Number  AND IsActive=1)                    
    BEGIN             
    IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] WHERE Email=@Email AND IsActive=1)                    
    BEGIN     
     DECLARE @myCreatedDateTime DATETIME = GETDATE();
     INSERT INTO [SiteUsers].[MST_SiteUser]  
     (                    
	  UserName
	  ,FK_CategoryId
	  ,FK_RoleId
	  ,UserPassword
	  ,IsActive
	  ,IsDeleted
	  ,CreatedBy
	  ,UpdatedBy
	  ,DeletedBy
	  ,Name
	  ,Mobile_Number
	  ,Alternate_Mobile_Number
	  ,Address
	  ,Zipcode
	  ,FK_StateID
	  ,FK_CityID
	  ,FK_LanguageKnown
	  ,FK_AreaOfInterest
	  ,Image
	  ,HaveSmartPhone
	  ,HavePC
	  ,AdoptionWish
	  ,Email
	  ,Fk_AreaOfInterest_State
	  ,Fk_AreaOfInterest_District
	  ,AreYou
	  ,JoinUsDescription
	  ,Declaration
	  ,LikeAdoptStudentLater
	 
	  ,Retired_expertise
	  ,Employed_expertise
	  ,CreatedDateTime
	  --,IsEmailVerified
	
     )               
     VALUES                    
     (               
      @UserName
	  ,@FK_CategoryId
	  ,@FK_RoleId
	  ,@UserPassword
	  ,@IsActive
	  ,@IsDeleted
	  ,@CreatedBy
	  ,@UpdatedBy
	  ,@DeletedBy
	  ,@Name
	  ,@Mobile_Number
	  ,@Alternate_Mobile_Number
	  ,@Address
	  ,@Zipcode
	  ,@FK_StateID
	  ,@FK_CityID
	  ,@FK_LanguageKnown
	  ,@FK_AreaOfInterest
	  ,@Image
	  ,@HaveSmartPhone
	  ,@HavePC
	  ,@AdoptionWish
	  ,@Email
	  ,@Fk_AreaOfInterest_State
	  ,@Fk_AreaOfInterest_District
	  ,@AreYou
	  ,@JoinUsDescription
	  ,@Declaration
	  ,@LikeAdoptStudentLater
	
	  ,@Retired_expertise
	  ,@Employed_expertise
	  ,@myCreatedDateTime
	  --,@IsEmailVerified
	 
     )           
	 INSERT INTO [SiteUsers].[MST_AcademicDetails]
	(
		FK_UserID
		,Education_Type
		,Class
		,FK_BoardID
		,FK_StreamID
		,Currentsemester
		,UniversityName
		,NatureOFCompletion
		,Percentage
		,Previous_Class
		,FK_Previous_Class_Board
		,Previous_Class_Percentage
		,Year_of_Passing
		,CourseName
		,Specification
		,OtherWork
	)
	SELECT
		FK_UserID
		,Education_Type
		,Class
		,FK_BoardID
		,FK_StreamID
		,Currentsemester
		,UniversityName
		,NatureOFCompletion
		,Percentage
		,Previous_Class
		,FK_Previous_Class_Board
		,Previous_Class_Percentage
		,Year_of_Passing
		,CourseName
		,Specification
		,OtherWork
	FROM @AcademicDetails;   
     set @PK_UserId = (SELECT TOP 1 PK_UserId from siteusers.mst_siteuser WHERE CreatedDateTime = @myCreatedDateTime);          
	 SELECT 1 AS Message_Id,'Details Inserted Successfully.' As Message   
	 SELECT @PK_UserId AS NewlyAddedUserId            
    END          
    ELSE                    
    BEGIN                    
       SELECT -1 AS Message_Id,'EmailId Already In Use.' AS Message                    
	END                  
	END          
	ELSE                    
	BEGIN                   
	    SELECT -2 AS Message_Id,'Mobile No. Already In Use.' AS Message                    
	END             
  END            
  ELSE                  
  BEGIN                 
	SELECT -3 AS Message_Id,'Invalid User Name' As Message     
  END            
 END           
                
 ELSE                    
 BEGIN
 
 
	if(isnull(@Image,'') = '')        
	begin        
       if (isnull((SELECT Image FROM [SiteUsers].[MST_SiteUser] WHERE PK_UserId =@PK_UserId),'') <> '')        
       begin        
	     set @Image = (SELECT Image FROM [SiteUsers].[MST_SiteUser] WHERE PK_UserId =@PK_UserId)        
       end        
    end    
	
	IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] (NOLOCK) WHERE UserName=LTRIM(RTRIM(@UserName)) AND IsActive =1 and ISNULL(PK_UserId,0) <> @PK_UserId)                
		BEGIN                
			IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] (NOLOCK) WHERE Mobile_Number=@Mobile_Number  AND IsActive=1 and ISNULL(PK_UserId,0) <> @PK_UserId)                        
			BEGIN                 
				IF NOT EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser] (NOLOCK) WHERE Email=@Email  AND IsActive=1 and ISNULL(PK_UserId,0) <> @PK_UserId)                        
				BEGIN     
					UPDATE  [SiteUsers].[MST_SiteUser]     SET   
					UserName							  = @UserName,
					 FK_CategoryId						  = @FK_CategoryId
					,FK_RoleId							  = @FK_RoleId
					,UserPassword						  = @UserPassword
					,IsActive							  = @IsActive
					--,IsDeleted							  = @IsDeleted
					--,CreatedBy							  = @CreatedBy
					,UpdatedBy							  = @UpdatedBy
					--,DeletedBy							  = @DeletedBy
					,Name								  = @Name
					,Mobile_Number						  = @Mobile_Number
					,Alternate_Mobile_Number				  = @Alternate_Mobile_Number
					,Address								  = @Address
					,Zipcode								  = @Zipcode
					,FK_StateID							  = @FK_StateID
					,FK_CityID							  = @FK_CityID
					,FK_LanguageKnown					  = @FK_LanguageKnown
					,FK_AreaOfInterest					  = @FK_AreaOfInterest
					,Image								  = @Image
					,HaveSmartPhone						  = @HaveSmartPhone
					,HavePC								  = @HavePC
					,AdoptionWish						  = @AdoptionWish
					--,Email								  = @Email
					,Fk_AreaOfInterest_State				  = @Fk_AreaOfInterest_State
					,Fk_AreaOfInterest_District			  = @Fk_AreaOfInterest_District
					,AreYou								  = @AreYou
					,JoinUsDescription					  = @JoinUsDescription
					,Declaration							  = @Declaration
					,LikeAdoptStudentLater				  = @LikeAdoptStudentLater

					,Retired_expertise					  = @Retired_expertise
					,Employed_expertise					  = @Employed_expertise
					,UpdatedDateTime					  = GETDATE()
					 --IsEmailVerified					  = @IsEmailVerified

					WHERE PK_UserId=@PK_UserId            
					DELETE FROM [SiteUsers].[MST_AcademicDetails] WHERE FK_UserID = @PK_UserId;
					INSERT INTO [SiteUsers].[MST_AcademicDetails]
					(
						FK_UserID
						,Education_Type
						,Class
						,FK_BoardID
						,FK_StreamID
						,Currentsemester
						,UniversityName
						,NatureOFCompletion
						,Percentage
						,Previous_Class
						,FK_Previous_Class_Board
						,Previous_Class_Percentage
						,Year_of_Passing
						,CourseName
						,Specification
						,OtherWork
					)
					SELECT
						FK_UserID
						,Education_Type
						,Class
						,FK_BoardID
						,FK_StreamID
						,Currentsemester
						,UniversityName
						,NatureOFCompletion
						,Percentage
						,Previous_Class
						,FK_Previous_Class_Board
						,Previous_Class_Percentage
						,Year_of_Passing
						,CourseName
						,Specification
						,OtherWork
					FROM @AcademicDetails;
					SELECT 1 AS Message_Id,'Details Updated Successfully.' AS Message
				END              
				ELSE                        
				BEGIN                        
					SELECT -1 AS Message_Id,'EmailId Already Exists.' AS Message   
				END                
            END       
			ELSE                        
			BEGIN                        
			  SELECT -2 AS Message_Id,'Mobile No. Already Exists' AS Message   
			END                 
         END                
		ELSE                      
		BEGIN            
			SELECT -3 AS Message_Id,'Invalid User Name!' AS Message   
		END  
 END          
END TRY                    
BEGIN CATCH                    
    SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                    
END CATCH  




GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AddEditSiteUserChat]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************        
CREATED BY:Vinish
CREATED DATE: 2020-05-27 01:52:57.920
PURPOSE:To 
****************************************************/  
CREATE PROCEDURE [SiteUsers].[USP_AddEditSiteUserChat]        
   (     
	@PK_ChatID			bigint = 0,
	@Chat_From			bigint ,
	@Chat_To			bigint ,
	@Query_From			varchar(max) = '',
	@Query_To			varchar(max) = '',
	@IsDeleted			bit = 0,
	@DeletedBy			bigint = 0,
	@IsSeen_From		bit = 0,
	@IsSeen_To			bit = 0,
	@IsReplay           bit = 0
   )        
AS        
BEGIN TRY        
 IF(@PK_ChatID = 0)
 BEGIN       
	SELECT 1 Message_Id,'Insert Success' Message;
	INSERT INTO [SiteUsers].[MST_SiteUserChat]
	(
		 Chat_From			
		,Chat_To				
		,Query_From			
		,Query_To			
		,QueryDateTime_From  
		,QueryDateTime_To	
		,IsSeen_From			
		,IsSeen_To			
	)
	VALUES
	(
		@Chat_From			
		,@Chat_To				
		,@Query_From			
		,@Query_To			
		,GETDATE()
		,NULL
		,NULL			
		,NULL
	)
	         
 END 	      
 ELSE        
 BEGIN 				       
	IF(ISNULL(@IsReplay,0) <> 0)
	BEGIN
		SELECT 1 Message_Id,'Update Success' Message;
		UPDATE [SiteUsers].[MST_SiteUserChat] SET Query_To = @Query_To,QueryDateTime_To = GETDATE()
		WHERE PK_ChatID = @PK_ChatID;
	END
 END
END TRY        
BEGIN CATCH        
		  SELECT 0 AS Message_Id, ERROR_MESSAGE()  AS Message        
END CATCH








GO
/****** Object:  StoredProcedure [SiteUsers].[USP_AuthenticateSiteUsers]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************          
Created By: Vinish
Created Date:      2020-04-26 23:41:40.563    
Purpose: To Authenticate Site User And Fetch Its Rights  
EXEC [SiteUsers].[USP_AuthenticateSiteUsers] 'Vinish.student.a','jRP6gcIvz+H0selbm6BUMQ==', ''       
*******************************************************************/          
CREATE PROCEDURE [SiteUsers].[USP_AuthenticateSiteUsers]          
(  
@cUserName    nvarchar(100),          
@cPassword    nvarchar(50),
@cLanguage    nvarchar(100)=''   
)          
AS          
BEGIN TRY                    
 IF  EXISTS          
 (          
  SELECT 1           
  FROM  [SiteUsers].[MST_SiteUser](NOLOCK)           
  WHERE           
  UserName = @cUserName AND           
  UserPassword = @cPassword          
  AND Isnull(IsActive,0) = 1 and Isnull(IsDeleted,0) = 0 AND
  1 = (
	CASE 
	WHEN ISNULL(FK_CategoryId,0) = 1 
	--AND ISNULL(IsAdoptedStudent,0) = 1 
	THEN 1
	WHEN ISNULL(FK_CategoryId,0) = 2 
	--AND ISNULL(IsApprovedCounselor,0) = 1 
	THEN 1
	WHEN ISNULL(FK_CategoryId,0) = 3 THEN 1
	ELSE 0 END 
  )
  
 )          
 BEGIN          
	
  DECLARE          
  @iRoleID   BIGINT         ,
  @iUserID   BIGINT=0; 
          
  SELECT           
  @iRoleID  = FK_RoleId  ,
  @iUserID=USR.PK_UserId   
  FROM [SiteUsers].[MST_SiteUser](NOLOCK) USR                  
  WHERE           
  UserName = @cUserName AND           
  UserPassword = @cPassword          
  AND ISNULL(USR.IsActive,0) = 1 
  and ISNULL(USR.IsDeleted,0) = 0 

  IF EXISTS(SELECT 1 FROM [SiteUsers].[MST_SiteUser](NOLOCK) WHERE PK_UserId = @iUserID AND ISNULL(IsEmailVerified,0) = 0)
  BEGIN
	SELECT -1 AS Message_Id,'Dear User, your registration is not verified!' AS Message;        
	RETURN;
  END
  

  SELECT 1 AS Message_Id,'Success' AS Message;        
  
  /*********************************/
  UPDATE [SiteUsers].[MST_SiteUser] SET LastWebLogInDatetime=GETDATE() WHERE PK_UserId=ISNULL(@iUserID,0);
              
  SELECT            
  ISNULL(Usr.[PK_UserId],0)  'UserId',          
  ISNULL(Usr.UserName,'')UserName,  
  ISNULL(Usr.UserPassword,'')UserPassword,      
  ISNULL(Usr.[Name],'') 'Name',          
  ISNULL(Usr.[FK_RoleId],0)  'RoleId',  
  --Usr.EmailId ,          
   ISNULL(Rol.RoleName,'') 'RoleName',            
   ISNULL(Cat.CategoryName,'') AccountName,          
   ISNULL(Usr.FK_CategoryId,0) FK_CategoryId,        
   ISNULL(cat.CategoryName,'') CategoryName ,
   ISNULL(Usr.IsAdoptedStudentCounselor,0) IsAdoptedStudentCounselor,
   ISNULL(Usr.IsAdoptedStudentByCounselor,0) AdoptedCounselor,
   ISNULL(Usr.AdoptionWish,0) AdoptionWish,
   ISNULL(
		CASE WHEN Usr.FK_CategoryId = 1 
		THEN
		(
			Select [dbo].[udf-Str-JSON](0,1,(
			SELECT PK_UserId Pk_UserId,Name,Image ImageName from [SiteUsers].[MST_SiteUser](NOLOCK) A 
			WHERE A.PK_UserId = Usr.IsAdoptedStudentByCounselor 
			AND ISNULL(A.IsActive,0) =1 and ISNULL(A.IsDeleted,0) =0 for XML RAW
			))
		)
		WHEN Usr.FK_CategoryId = 2 
		THEN
		(
			Select [dbo].[udf-Str-JSON](0,1,(
			SELECT PK_UserId Pk_UserId,Name,Image ImageName from [SiteUsers].[MST_SiteUser](NOLOCK) A WHERE A.IsAdoptedStudentByCounselor = Usr.PK_UserId 
			AND ISNULL(A.IsActive,0) =1 and ISNULL(A.IsDeleted,0) =0 for XML RAW
			))
		)
		ELSE
		(
			''
		)
		END
   ,'') PartnerProfileDetails,
   CONVERT(BIT,(CASE WHEN ISNULL(Usr.UpdatedDateTime,'') <> '' THEN 0 ELSE 1 END)) IsUpdatedProfileAlert,
   ISNULL(Usr.Image,'') ProfileImage,
   ISNULL(Usr.IsEmailVerified,0) IsEmailVerified      
  --'COMPANY'  AS LoginType,        
  FROM  [SiteUsers].[MST_SiteUser](NOLOCK) Usr          
  INNER JOIN [SiteUsers].[MST_SiteUserRole](NOLOCK) Rol ON Rol.PK_RoleId=Usr.FK_RoleId          
  INNER JOIN [SiteUsers].[MST_SiteUserCategory](NOLOCK) Cat ON Rol.FK_CategoryId=Cat.PK_CategoryId 
  --LEFT JOIN [SiteUsers].[MST_SiteUser](NOLOCK) C on C.PK_UserId =  ISNULL(Usr.IsAdoptedStudentByCounselor,0) 
  WHERE Usr.UserName = @cUserName  AND Usr.UserPassword = @cPassword    
  AND ISNULL(Usr.IsActive,0) = 1 and ISNULL(Usr.IsDeleted,0) = 0
 
 END          
          
  ELSE          
   BEGIN          
    SELECT 0 AS Message_Id,'UserId & Password Did Not Match!' AS Message          
   END          
END TRY           
BEGIN CATCH           
 SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message          
END CATCH;







GO
/****** Object:  StoredProcedure [SiteUsers].[USP_DeleteContantResourcePage]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Vinish             
CreatedDate:  2020-05-28 23:40:42.287    
purpos:
********** ******************************************/  
CREATE Procedure [SiteUsers].[USP_DeleteContantResourcePage] 
  (
	@PK_ContantResourceId	  BIGINT,
	@iUserId      BIGINT  
   )
    AS  
BEGIN TRY             
      UPDATE [SiteUsers].[MST_ContentResourcePage]
      SET 
	  IsActive=0, 
      IsDeleted=1,  
      DeletedBy=@iUserId,  
      DeletedDateTime=GETDATE() 
      WHERE   
      PK_ContantResourceId=@PK_ContantResourceId
      SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
END TRY  
BEGIN CATCH  
      SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
END CATCH  
  
      






GO
/****** Object:  StoredProcedure [SiteUsers].[USP_DeleteFeedBackCriteria]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Vinish
CreatedDate: 2020-05-24 22:30:57.637
purpos:Get Delete FeedBack Criteria

********** ******************************************/  
CREATE PROCEDURE [SiteUsers].[USP_DeleteFeedBackCriteria] 
(
	@PK_FeedBackCriteriaID	  BIGINT,
	@iUserId      BIGINT  
)
AS  
BEGIN TRY             
      UPDATE [SiteUsers].[MST_FeedBackCriteria]
      SET 
	  IsActive=0, 
      IsDeleted=1,  
      DeletedBy=@iUserId,  
      DeletedDateTime=GETDATE() 
      WHERE   
      PK_FeedBackCriteriaID=@PK_FeedBackCriteriaID 
      SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message   
END TRY  
BEGIN CATCH  
      SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
END CATCH  
  
      






GO
/****** Object:  StoredProcedure [SiteUsers].[USP_DeleteManageFeed]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [SiteUsers].[USP_DeleteManageFeed]
(
@PK_FeedID bigint,
@iUserId bigint
)
AS 
BEGIN
 SET NOCOUNT ON;  
     --   DECLARE @Output INT = 2000;  
  SELECT 1 AS Message_Id, 'SUCCESS' AS Message  
IF(@PK_FeedID<>0 OR @PK_FeedID<> 
null)
Begin
Begin TRAN;
Begin Try
Update SiteUsers.Mst_Feeds
set 
IsDeleted=1,
DeletedDateTime=GETDATE() ,
DeletedBy = @iUserId
where PK_FeedID=@PK_FeedID
Commit;
End Try
Begin Catch
ROLLBACK;
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message 
--SET @Output = -2000;
  
End Catch
END
 ExitLine:
--Select @Output
END


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetAcademicGroupList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:  2020-05-06 23:06:48.457
purpos:Get Academic Group List 
********** ******************************************/   
CREATE proc [SiteUsers].[USP_GetAcademicGroupList]
as
begin
	SELECT PK_AcademicGroupId,AcademicGroupName FROM [SiteUsers].[MST_AcademicGroup] WHERE ISNULL(IsActive,0) = 1 
end


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetAdminDashboardDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:  2020-05-06 23:06:48.457
purpos: Admin Dashboard 
[SiteUsers].[USP_GetAdminDashboardDetails]  @year = 2020,@month = 5
********** ******************************************/   
CREATE proc [SiteUsers].[USP_GetAdminDashboardDetails] 
@FK_StateId bigint = 0,
@year INT,
@month INT
AS
BEGIN
	
	SELECT 1 Message_Id,'Success' Message;
	
	SELECT 
	ISNULL(Student,0) StudentCount,
	ISNULL(Counselor,0) CounselorCount,
	ISNULL(Volunteer,0) VolunteerCount
	FROM
	(
		SELECT 
		C.CategoryName,count(1) TotalCount
		--U.PK_UserId,U.Name,C.PK_CategoryId,C.CategoryName,S.PK_StateId,S.StateName,U.CreatedDateTime
		
		FROM [SiteUsers].[MST_SiteUser] U
		INNER JOIN [SiteUsers].[MST_SiteUserCategory] C ON C.PK_CategoryId = U.FK_CategoryId
		LEFT JOIN [dbo].[MST_State] S ON S.PK_StateId = U.FK_StateID
		AND ISNULL(C.IsActive,0) =1 AND ISNULL(U.IsActive,0) =1 AND ISNULL(S.IsActive,0) =1 
		AND ISNULL(C.IsDeleted,0) =0 AND ISNULL(U.IsDeleted,0) =0 AND ISNULL(S.IsDeleted,0) =0
		AND S.PK_StateId = CASE WHEN ISNULL(@FK_StateId,0) = 0 THEN S.PK_StateId ELSE @FK_StateId END
		AND YEAR(U.CreatedDateTime) = @year
		AND MONTH(U.CreatedDateTime) = @month
		GROUP BY C.CategoryName WITH ROLLUP
	) D
	PIVOT
	(
		MAX(TotalCount)
		FOR CategoryName in (Student,Counselor,Volunteer)
	) PIV;
	
	
	
END





GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetAllAreaOfInterest]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Vinish
-- Create date: 2020-04-24 17:40:48.810
-- Description:	Get All Area Of Interest 
-- =============================================
CREATE PROCEDURE [SiteUsers].[USP_GetAllAreaOfInterest]  
	@type varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SELECT [PK_AreaOfInterest]
	  ,[AreaOfInterest]
	  --,[IsActive]
	FROM [SiteUsers].[MST_AreaOfInterest] WHERE ISNULL([IsActive],0) = 1 AND [TYPE] = @type
END


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetAllEmployedExpertiseDetailsList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vinish
-- Create date: 2020-04-25 23:02:22.520
-- Description:	Get All Employed Expertise 
-- =============================================
CREATE PROCEDURE [SiteUsers].[USP_GetAllEmployedExpertiseDetailsList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SELECT [PK_EmployedExpertise]
	  ,[EmployedExpertise]
	FROM [SiteUsers].[MST_EmployedExpertise] WHERE ISNULL([IsActive],0) = 1 
END

GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetAllRetiredExpertiseDetailsList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vinish
-- Create date: 2020-04-25 23:02:22.520
-- Description:	Get All Retired Expertise 
-- =============================================
CREATE PROCEDURE [SiteUsers].[USP_GetAllRetiredExpertiseDetailsList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SELECT [PK_RetiredExpertise]
	  ,[RetiredExpertise]
	FROM [SiteUsers].[MST_RetiredExpertise] WHERE ISNULL([IsActive],0) = 1 
END



GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetAllStateWiseBoard]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Vinish
-- Create date: 2020-04-24 17:40:48.810
-- Description:	Get All State Wise Board
-- =============================================
CREATE PROCEDURE [SiteUsers].[USP_GetAllStateWiseBoard]  
	@FK_StateUT BIGINT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SELECT
	
	 SB.PK_StateUTBoard,
	 S.PK_StateUT,
	 S.StateUT,
	 SB.StateUTBoard
	  --,[IsActive]
	FROM [SiteUsers].[MST_StateUTBoard] SB
	INNER JOIN [SiteUsers].[MST_StateUT] S ON S.PK_StateUT = SB.FK_StateUT
	WHERE ISNULL(SB.[IsActive],0) = 1 AND ISNULL(S.[IsActive],0) = 1 
	AND SB.FK_StateUT = (CASE WHEN ISNULL(@FK_StateUT,0) = 0 THEN SB.FK_StateUT ELSE @FK_StateUT END)
END


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetAllStreams]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Vinish
-- Create date: 2020-04-24 17:40:48.810
-- Description:	Get All State Wise Board
-- =============================================
CREATE PROCEDURE [SiteUsers].[USP_GetAllStreams]  
	@FK_StreamType BIGINT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SELECT
	SD.PK_DET_Stream,
	SD.StreamCourses,
	S.PK_StreamType,
	S.StreamType
	
	FROM [SiteUsers].[MST_DET_StreamCourses] SD
	INNER JOIN [SiteUsers].[MST_StreamType] S ON S.PK_StreamType = SD.FK_StreamType
	WHERE ISNULL(SD.[IsActive],0) = 1 AND ISNULL(S.[IsActive],0) = 1 
	AND SD.FK_StreamType = (CASE WHEN ISNULL(@FK_StreamType,0) = 0 THEN SD.FK_StreamType ELSE @FK_StreamType END)
END


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetBenifitTypeList]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:  2020-05-06 23:06:48.457
purpos:Get Benifit Type List 
********** ******************************************/   
CREATE proc [SiteUsers].[USP_GetBenifitTypeList]
as
begin
	SELECT PK_BenifitTypeId,BenifitTypeName FROM [SiteUsers].[MST_BenifitType] WHERE ISNULL(IsActive,0) = 1 
end


GO
/****** Object:  StoredProcedure [SiteUsers].[usp_GetBoardType]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [SiteUsers].[usp_GetBoardType] 
AS
BEGIN

select ID,BoardName from [SiteUsers].[Board]
End

GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetContentResourcePageDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************              
CreatedBy:Vinish             
CreatedDate:12-12-2019        
purpos:
****************************************************/            
CREATE PROCEDURE [SiteUsers].[USP_GetContentResourcePageDetails]          
 (          
 @PK_ContantResourceId	  BIGINT = 0,           
 @iRowperPage             BIGINT,          
 @iCurrentPage            BIGINT,          
 @cSearchBy               NVARCHAR(50),            
 @cSearchValue            NVARCHAR(50) ,
 @FK_StateId			  BIGINT = 0,   
 @FK_AcademicGroupId	  BIGINT = 0,           
 @FK_BenifitTypeId		  BIGINT = 0                         
 )           
AS              
BEGIN TRY              
         SELECT 1 [Message_Id],'Success' [Message]              
         SELECT          
          ISNULL(CRP.PK_ContantResourceId,0) PK_ContantResourceId       
         ,ISNULL(CRP.FK_RoleId,0) FK_RoleId
		 ,ISNULL(R.RoleName,'For All Roles(Also Anonymous User)') RoleName
		 ,ISNULL(CRP.FK_StateId,0) FK_StateId
		 ,ISNULL(S.StateName,'') StateName
		 ,ISNULL(CRP.FK_SearchCategoryId,0) FK_SearchCategoryId
		 ,ISNULL(AD.AcademicGroupName,'') AcademicGroupName
		 ,ISNULL(CRP.FK_SubSearchCategoryId,0) FK_SubSearchCategoryId
		 ,ISNULL(BT.BenifitTypeName,'') BenifitTypeName
		 ,ISNULL(CRP.Heading,'') Heading
		 ,ISNULL(CRP.Description,'') Description
		 ,ISNULL(CRP.ResourceType,'') ResourceType
		 ,ISNULL(CRP.ResourceFileName,'') ResourceFileName
		 ,ISNULL(CRP.IsActive,0) IsActive
		 ,ISNULL(CRP.IsDeleted,0) IsDeleted
         ,CASE WHEN CRP.IsActive = 1 THEN 'Active' ELSE 'In-Active' END [Status]
         ,ISNULL(FORMAT(CRP.CreatedDateTime,'dd/MM/yyyy HH:mm'),'') CreatedDateTime
         FROM  [SiteUsers].[MST_ContentResourcePage](NOLOCK) CRP           
         INNER JOIN [dbo].[MST_State] (NOLOCK) S ON S.PK_StateId = CRP.FK_StateId
		 LEFT JOIN [SiteUsers].[MST_SiteUserRole] (NOLOCK) R ON R.PK_RoleId = CRP.FK_RoleId
		 INNER JOIN [SiteUsers].[MST_AcademicGroup] (NOLOCK) AD ON AD.PK_AcademicGroupId = CRP.FK_SearchCategoryId
		 INNER JOIN [SiteUsers].[MST_BenifitType] (NOLOCK) BT ON BT.PK_BenifitTypeId = CRP.FK_SubSearchCategoryId

         where  Isnull(CRP.IsDeleted,0)=0  AND         
         CRP.PK_ContantResourceId = CASE WHEN @PK_ContantResourceId=0 THEN CRP.PK_ContantResourceId  ELSE @PK_ContantResourceId END        
         AND ISNULL(CRP.FK_StateId,0) = CASE WHEN ISNULL(@cSearchBy,'') = 'SiteUserResource' THEN @FK_StateId ELSE ISNULL(CRP.FK_StateId,0) END 
		 AND ISNULL(CRP.FK_SearchCategoryId,0) = CASE WHEN ISNULL(@cSearchBy,'') = 'SiteUserResource' THEN @FK_AcademicGroupId ELSE ISNULL(CRP.FK_SearchCategoryId,0) END 
		 AND ISNULL(CRP.FK_SubSearchCategoryId,0) = CASE WHEN ISNULL(@cSearchBy,'') = 'SiteUserResource' THEN @FK_BenifitTypeId ELSE ISNULL(CRP.FK_SubSearchCategoryId,0) END 

		And  
		CRP.IsActive in    
		(    
		Case When @cSearchBy <>''AND @cSearchBy = 'IsActive' AND @cSearchValue <> ''      
		Then @cSearchValue  ELSE CRP.IsActive END      
		)    
		AND    
		convert(varchar(10),concat(isnull(month(CRP.CreatedDateTime),'0'),isnull(year(CRP.CreatedDateTime),'0'))) in     
		(    
		Case When @cSearchBy <>''AND @cSearchBy = 'ThisMonth' AND @cSearchValue = ''      
		Then  convert(varchar(10),concat(month(getdate()),year(getdate())))   ELSE  convert(varchar(10),concat(isnull(month(CRP.CreatedDateTime),'0'),isnull(year(CRP.CreatedDateTime),'0'))) END      
		)    
         
           
		AND          
		ISNULL(R.RoleName,'For All Roles(Also Aanonymous User)') LIKE              
		CASE               
		WHEN                 
		(              
		@cSearchBy <> '' AND @cSearchBy = 'RoleName' AND @cSearchValue <> ''              
		)               
		THEN '%'+@cSearchValue+'%'               
		ELSE  ISNULL(R.RoleName,'For All Roles(Also Aanonymous User)')             
		END     
		
		AND          
		ISNULL(CRP.FK_RoleId,0) =              
		CASE               
		WHEN                 
		(              
		@cSearchBy <> '' AND @cSearchBy = 'SiteUserResource' AND @cSearchValue <> ''
		
		)               
		THEN CONVERT(BIGINT,@cSearchValue)
		ELSE ISNULL(CRP.FK_RoleId,0)             
		END         
		  
		AND          
		ISNULL(CRP.FK_RoleId,0) =              
		CASE               
		WHEN                 
		(              
		@cSearchBy <> '' AND @cSearchBy = 'AnonymousUser' 
		
		)               
		THEN 0
		ELSE ISNULL(CRP.FK_RoleId,0)             
		END           
          
        ORDER BY CRP.CreatedDateTime DESC              
        OFFSET (@iCurrentPage-1)*@iRowperPage ROWS               
        FETCH NEXT @iRowperPage ROWS ONLY      
  
/***********************Start Pagination **********************************/             
             
		SELECT       
		ISNULL(COUNT (1),0)  AS TotalItem,      
		(      
		SELECT       
		ISNULL(SUM (      
		CASE       
		WHEN YEAR(CRP.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(CRP.CreatedDateTime)=MONTH(GETDATE())       
		THEN 1       
		ELSE 0 END),0      
		)      
		) AS TotalCurrentMonth,       
		ISNULL(SUM(CASE WHEN CRP.IsActive =1 THEN 1 ELSE 0 END),0)AS TotalActive,      
		ISNULL(SUM(CASE WHEN CRP.IsActive =0 THEN 1 ELSE 0 END),0)AS TotalInActive           
         FROM  [SiteUsers].[MST_ContentResourcePage](NOLOCK) CRP           
         INNER JOIN [dbo].[MST_State] (NOLOCK) S ON S.PK_StateId = CRP.FK_StateId
		 LEFT JOIN [SiteUsers].[MST_SiteUserRole] (NOLOCK) R ON R.PK_RoleId = CRP.FK_RoleId
		 INNER JOIN [SiteUsers].[MST_AcademicGroup] (NOLOCK) AD ON AD.PK_AcademicGroupId = CRP.FK_SearchCategoryId
		 INNER JOIN [SiteUsers].[MST_BenifitType] (NOLOCK) BT ON BT.PK_BenifitTypeId = CRP.FK_SubSearchCategoryId

         where  Isnull(CRP.IsDeleted,0)=0  AND         
         CRP.PK_ContantResourceId = CASE WHEN @PK_ContantResourceId=0 THEN CRP.PK_ContantResourceId  ELSE @PK_ContantResourceId END        
         AND ISNULL(CRP.FK_StateId,0) = CASE WHEN ISNULL(@cSearchBy,'') = 'SiteUserResource' THEN @FK_StateId ELSE ISNULL(CRP.FK_StateId,0) END 
		 AND ISNULL(CRP.FK_SearchCategoryId,0) = CASE WHEN ISNULL(@cSearchBy,'') = 'SiteUserResource' THEN @FK_AcademicGroupId ELSE ISNULL(CRP.FK_SearchCategoryId,0) END 
		 AND ISNULL(CRP.FK_SubSearchCategoryId,0) = CASE WHEN ISNULL(@cSearchBy,'') = 'SiteUserResource' THEN @FK_BenifitTypeId ELSE ISNULL(CRP.FK_SubSearchCategoryId,0) END 

		And  
		CRP.IsActive in    
		(    
		Case When @cSearchBy <>''AND @cSearchBy = 'IsActive' AND @cSearchValue <> ''      
		Then @cSearchValue  ELSE CRP.IsActive END      
		)    
		AND    
		convert(varchar(10),concat(isnull(month(CRP.CreatedDateTime),'0'),isnull(year(CRP.CreatedDateTime),'0'))) in     
		(    
		Case When @cSearchBy <>''AND @cSearchBy = 'ThisMonth' AND @cSearchValue = ''      
		Then  convert(varchar(10),concat(month(getdate()),year(getdate())))   ELSE  convert(varchar(10),concat(isnull(month(CRP.CreatedDateTime),'0'),isnull(year(CRP.CreatedDateTime),'0'))) END      
		)    
         
           
		AND          
		ISNULL(R.RoleName,'For All Roles(Also Aanonymous User)') LIKE              
		CASE               
		WHEN                 
		(              
		@cSearchBy <> '' AND @cSearchBy = 'RoleName' AND @cSearchValue <> ''              
		)               
		THEN '%'+@cSearchValue+'%'               
		ELSE  ISNULL(R.RoleName,'For All Roles(Also Aanonymous User)')             
		END   
		
		AND          
		ISNULL(CRP.FK_RoleId,0) =              
		CASE               
		WHEN                 
		(              
		@cSearchBy <> '' AND @cSearchBy = 'SiteUserResource' AND @cSearchValue <> ''              
		)               
		THEN CONVERT(BIGINT,@cSearchValue)
		ELSE ISNULL(CRP.FK_RoleId,0)             
		END           
             
		AND          
		ISNULL(CRP.FK_RoleId,0) =              
		CASE               
		WHEN                 
		(              
		@cSearchBy <> '' AND @cSearchBy = 'AnonymousUser' 
		
		)               
		THEN 0
		ELSE ISNULL(CRP.FK_RoleId,0)             
		END           
/***********************End Pagination **********************************/      
END TRY          
BEGIN CATCH          
 SELECT 0 [Message_Id], ERROR_MESSAGE() [Message]           
END CATCH





GO
/****** Object:  StoredProcedure [SiteUsers].[usp_GetLanguage]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                  
CreatedBy:Shubham
CreatedDate: 2020-05-07 14:46:50.177       
purpos:
****************************************************/                  
CREATE Procedure [SiteUsers].[usp_GetLanguage]
AS
BEGIN
select ID,LanguageName from [SiteUsers].[LKP_Languages]
End


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetManageFeedBackCriteriaDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinish
-- Create date: 2020-05-24 21:13:33.700
-- Description:	Get All Manage FeedBack
-- EXEC [SiteUsers].[USP_GetManageFeedBackCriteriaDetails] 
-- @PK_FeedBackCriteriaID   = 0
-- ,@cSearchBy				= 'SiteUserCategory'
-- ,@cSearchValue			= 'Counselor'
-- ,@iRowperPage			    = 1000
-- ,@iCurrentPage			= 1
-- ,@iUserId				    = 0

-- =============================================
CREATE PROCEDURE [SiteUsers].[USP_GetManageFeedBackCriteriaDetails]
(
	@PK_FeedBackCriteriaID  BIGINT,
	@cSearchBy				NVARCHAR(50)='',
	@cSearchValue			NVARCHAR(50)='',
	@iRowperPage			INT  ,  
	@iCurrentPage			INT  ,
	@iUserId				BIGINT  
)
AS
BEGIN  TRY  
	      SELECT 1 AS Message_Id, 'SUCCESS' AS Message
	      SELECT 
	      ISNULL(SC.PK_FeedBackCriteriaID,0) PK_FeedBackCriteriaID,
		  ISNULL(SC.FK_SiteUserCategoryID,0) FK_SiteUserCategoryID,
		  ISNULL(CAT.CategoryName,'') SiteUserCategory,
	      ISNULL(SC.FeedbackCriteria,'') FeedbackCriteria,
	      ISNULL(SC.IsActive,0) IsActive,
		  ISNULL(SC.IsDeleted,0) IsDeleted,
		  ISNULL(SC.MarkCriteria_Yes,0) MarkCriteria_Yes,
		  ISNULL(SC.MarkCriteria_No,0) MarkCriteria_No,
	      CASE WHEN SC.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status], 
	      ISNULL(FORMAT(SC.CreatedDateTime,'dd/MM/yyyy HH:mm'),'')CreatedDateTime
          FROM [SiteUsers].[MST_FeedBackCriteria](NOLOCK) SC
		  INNER JOIN [SiteUsers].[MST_SiteUserCategory] CAT on sc.FK_SiteUserCategoryID = CAT.PK_CategoryId
	      WHERE 
	      ISNULL(SC.IsDeleted,0)=0 AND
	      SC.PK_FeedBackCriteriaID = CASE WHEN @PK_FeedBackCriteriaID <> 0 THEN @PK_FeedBackCriteriaID ELSE SC.PK_FeedBackCriteriaID END
	      AND
	      ISNULL(SC.FeedbackCriteria,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'FeedbackCriteria' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(SC.FeedbackCriteria,'')   
          END 
		  AND
	      ISNULL(CAT.CategoryName,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'SiteUserCategory' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(CAT.CategoryName,'')   
          END 
		  and          
		  (                    
		     (case when CONVERT(CHAR(1),ISNULL(SC.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
		     CASE                           
		       WHEN                             
		        (                          
		         @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
		        )                           
		       THEN @cSearchValue          
		       ELSE  (case when CONVERT(CHAR(1),ISNULL(SC.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
		     END                    
		     )                    
		           
		  and          
		  (                    
		     convert(varchar(10),concat(isnull(month(SC.CreatedDateTime),'0'),isnull(year(SC.CreatedDateTime),'0'))) =                         
		     CASE                           
		       WHEN          
		        (                          
		         @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
		     )                           
		       THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
		       ELSE convert(varchar(10),concat(isnull(month(SC.CreatedDateTime),'0'),isnull(year(SC.CreatedDateTime),'0')))          
		     END                    
		   )              
	      
	      
	      ORDER BY   SC.PK_FeedBackCriteriaID DESC
	      
	      OFFSET (@iCurrentPage-1)*@iRowperPage ROWS     
          FETCH NEXT @iRowperPage ROWS ONLY		
          ---------SELECT COUNT
		  SELECT 
          ISNULL(COUNT (1),0)  AS TotalItem,          
           (          
			SELECT           
		 ISNULL(SUM(          
		    CASE           
		    WHEN YEAR(SC.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(SC.CreatedDateTime)=MONTH(GETDATE())           
		    THEN 1           
		    ELSE 0 END),0          
		   )          
          ) AS TotalCurrentMonth,         
		  ISNULL(SUM(CASE WHEN isnull(SC.IsActive,0) =1 THEN 1 ELSE 0 END),0)AS TotalActive,          
		  ISNULL(SUM(CASE WHEN isnull(SC.IsActive,0) =0 THEN 1 ELSE 0 END),0)AS TotalInActive             
   
          FROM [SiteUsers].[MST_FeedBackCriteria](NOLOCK) SC
		  INNER JOIN [SiteUsers].[MST_SiteUserCategory] CAT on sc.FK_SiteUserCategoryID = CAT.PK_CategoryId
	      WHERE 
	      ISNULL(SC.IsDeleted,0)=0 AND
	      SC.PK_FeedBackCriteriaID = CASE WHEN @PK_FeedBackCriteriaID <> 0 THEN @PK_FeedBackCriteriaID ELSE SC.PK_FeedBackCriteriaID END
	      AND
	      ISNULL(SC.FeedbackCriteria,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'FeedbackCriteria' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(SC.FeedbackCriteria,'')   
          END 
		   AND
	      ISNULL(CAT.CategoryName,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'SiteUserCategory' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(CAT.CategoryName,'')   
          END 
		  and          
		  (                    
		     (case when CONVERT(CHAR(1),ISNULL(SC.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
		     CASE                           
		       WHEN                             
		        (                          
		         @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
		        )                           
		       THEN @cSearchValue          
		       ELSE  (case when CONVERT(CHAR(1),ISNULL(SC.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
		     END                    
		     )                    
		           
		  and          
		  (                    
		     convert(varchar(10),concat(isnull(month(SC.CreatedDateTime),'0'),isnull(year(SC.CreatedDateTime),'0'))) =                         
		     CASE                           
		       WHEN          
		        (                          
		         @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
		     )                           
		       THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
		       ELSE convert(varchar(10),concat(isnull(month(SC.CreatedDateTime),'0'),isnull(year(SC.CreatedDateTime),'0')))          
		     END                    
		   )  
	      
	      
END TRY

BEGIN CATCH
	SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message

END CATCH

GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetManageFeedBackDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinish
-- Create date: 2020-05-24 21:13:33.700
-- Description:	Get All Manage FeedBack
 
--EXEC [SiteUsers].[USP_GetManageFeedBackDetails] 
--@PK_FeedBackID   = 0
--,@cSearchBy				= ''
--,@cSearchValue			= ''
--,@iRowperPage			    = 1000
--,@iCurrentPage			= 1
--,@iUserId				    = 0
--,@type = 'admin'

-- =============================================
CREATE PROCEDURE [SiteUsers].[USP_GetManageFeedBackDetails]
(
	@PK_FeedBackID  BIGINT,
	@cSearchBy				NVARCHAR(50)='',
	@cSearchValue			NVARCHAR(50)='',
	@iRowperPage			INT  ,  
	@iCurrentPage			INT  ,
	@iUserId				BIGINT ,
	@type					NVARCHAR(50)=''
)
AS
BEGIN  TRY  
	      SELECT 1 AS Message_Id, 'SUCCESS' AS Message;
		  ;WITH MYTABLE AS (
	      SELECT 
	      ISNULL(FBM.PK_FeedBackID,0) PK_FeedBackID,
		  ISNULL(FBM.FK_CounselorID,0) FK_CounselorID,
		  ISNULL(C.Name,'') CounselorName,
		  ISNULL(FBM.FK_FeedBackCriteriaID,0) FK_FeedBackCriteriaID,
		  (CASE     
              WHEN       
               (    
                 @type = 'admin'  and @PK_FeedBackID <> 0
               )     
              THEN (
					  SELECT  Convert(varchar(max),(SELECT CONVERT(varchar(100),MYFeedbackCriteria)+ '-||-'   from (
						SELECT CONVERT(VARCHAR(10),A.FK_FeedBackCriteriaID) MYFeedbackCriteria
						FROM [SiteUsers].[MAP_SiteUserFeedBack](NOLOCK) A WHERE
						--LEFT JOIN [SiteUsers].[MST_FeedBackCriteria](NOLOCK) B on B.PK_FeedBackCriteriaID = A.FK_FeedBackCriteriaID AND 
						A.CreatedDateTime = (SELECT CreatedDateTime FROM [SiteUsers].[MAP_SiteUserFeedBack](NOLOCK) where PK_FeedBackID = @PK_FeedBackID)    
					  ) as MyTable  FOR XML PATH('')))
				   )
              ELSE  ISNULL(SC.FeedbackCriteria,'')
          END) FeedbackCriteria,

		  ISNULL(FBM.FK_StudentID,0) FK_StudentID,
		  ISNULL(S.Name,'') StudentName,
		  ISNULL(CAT.CategoryName,'') FeedBackByCategory,
	      ISNULL(FBM_BY.Name,'') FeedBackBy,
		  ISNULL(FBM.IsLikeThisClass,0) IsLikeThisClass,
	      ISNULL(FBM.IsActive,0) IsActive,
		  ISNULL(FBM.IsDeleted,0) IsDeleted,
		  ISNULL(FBM.RateFeedBack,0) RateFeedBack,
		  ISNULL(FBM.RatedBy,0) RatedBy,
		  (ISNULL(SC.MarkCriteria_Yes,0)) AutoRateFeedBack,
		  ISNULL(FBM.FeedBackSuggesstion,'') FeedBackSuggesstion,
		  
	      CASE WHEN FBM.IsActive = 1 THEN 'Active' ELSE 'InActive' END [Status], 
	      ISNULL(FORMAT(FBM.CreatedDateTime,'dd/MM/yyyy HH:mm'),'') CreatedDateTime,
		  FBM.CreatedDateTime MYCreatedDateTime,
		  CONVERT(INT,(ROW_NUMBER() Over (partition by FBM.CreatedDateTime order by FBM.CreatedDateTime DESC))) FeedOneTimeNumber
          FROM [SiteUsers].[MAP_SiteUserFeedBack](NOLOCK) FBM
		  LEFT JOIN [SiteUsers].[MST_FeedBackCriteria](NOLOCK) SC on SC.PK_FeedBackCriteriaID = FBM.FK_FeedBackCriteriaID
		  LEFT JOIN [SiteUsers].[MST_SiteUser](NOLOCK) C on C.PK_UserId = FBM.FK_CounselorID
		  LEFT JOIN [SiteUsers].[MST_SiteUser](NOLOCK) S on S.PK_UserId = FBM.FK_StudentID
		  LEFT JOIN [SiteUsers].[MST_SiteUser](NOLOCK) FBM_BY on FBM_BY.PK_UserId = FBM.CreatedBy
		  LEFT JOIN [SiteUsers].[MST_SiteUserCategory](NOLOCK) CAT on CAT.PK_CategoryId = FBM_BY.FK_CategoryId

	      WHERE 
	      ISNULL(FBM.IsDeleted,0)=0 AND
		  FBM.CreatedDateTime = 
		  CASE     
              WHEN       
               (    
                 @type = 'admin'  and @PK_FeedBackID <> 0
               )     
              THEN (SELECT CreatedDateTime FROM [SiteUsers].[MAP_SiteUserFeedBack](NOLOCK) where PK_FeedBackID = @PK_FeedBackID )    
              ELSE  FBM.CreatedDateTime
          END 
		  AND 
	      FBM.PK_FeedBackID = CASE WHEN @PK_FeedBackID <> 0 AND @type <> 'admin' THEN @PK_FeedBackID ELSE FBM.PK_FeedBackID END
	      
		  AND
	      ISNULL(C.Name,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'CounselorName' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(C.Name,'')   
          END 
		   

		   AND
	      ISNULL(S.Name,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'StudentName' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(S.Name,'')   
          END 
		  AND
	      ISNULL(CAT.CategoryName,'') LIKE    
          CASE     
              WHEN       
               (    
                @cSearchBy <> '' AND @cSearchBy = 'SiteUserCategory' AND @cSearchValue <> ''    
               )     
              THEN '%'+@cSearchValue+'%'     
              ELSE  ISNULL(CAT.CategoryName,'')   
  END 
		  and          
		  (                    
		     (case when CONVERT(CHAR(1),ISNULL(FBM.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
		     CASE                           
		       WHEN                             
		        (                          
		         @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
		        )                        
		       THEN @cSearchValue          
		       ELSE  (case when CONVERT(CHAR(1),ISNULL(FBM.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
		     END                    
		     )                    
		           
		  and          
		  (                    
		     convert(varchar(10),concat(isnull(month(FBM.CreatedDateTime),'0'),isnull(year(FBM.CreatedDateTime),'0'))) =                         
		     CASE                           
		       WHEN          
		        (                          
		         @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
		     )                           
		       THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
		       ELSE convert(varchar(10),concat(isnull(month(FBM.CreatedDateTime),'0'),isnull(year(FBM.CreatedDateTime),'0')))          
		     END                    
		   )              
	      
	      )--End CTE
		  SELECT  * INTO #TEMP  FROM MYTABLE  WHERE 
	      1 =    
          CASE     
              WHEN       
               (    
                @type = 'admin' AND @PK_FeedBackID = 0
               )     
              THEN 
			  (
				CASE WHEN FeedOneTimeNumber = 1 THEN 1 
				ELSE 0 END
			  )
              ELSE 1
          END

	      ORDER BY PK_FeedBackID DESC
	      
	      OFFSET (@iCurrentPage-1)*@iRowperPage ROWS     
          FETCH NEXT @iRowperPage ROWS ONLY		

		  SELECT * FROM #TEMP;

		  SELECT 

		   ISNULL(COUNT (1),0)  AS TotalItem,          
           (          
			SELECT           
		 ISNULL(SUM(          
		    CASE           
		    WHEN YEAR(MYCreatedDateTime)=YEAR(GETDATE()) AND MONTH(MYCreatedDateTime)=MONTH(GETDATE())           
		    THEN 1           
		    ELSE 0 END),0          
		   )          
          ) AS TotalCurrentMonth,         
		  ISNULL(SUM(CASE WHEN isnull(IsActive,0) =1 THEN 1 ELSE 0 END),0)AS TotalActive,          
		  ISNULL(SUM(CASE WHEN isnull(IsActive,0) =0 THEN 1 ELSE 0 END),0)AS TotalInActive 

		  FROM #TEMP;
	       
END TRY

BEGIN CATCH
	SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message

END CATCH






GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetPlannedCommunication]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************    
CreatedBy:Vinish  
CreatedDate:2020-05-14 00:25:13.513
purpos:
********** ******************************************/  
CREATE PROCEDURE [SiteUsers].[USP_GetPlannedCommunication] 
(
  @FK_CounselorID bigint,
  @FK_StudentID bigint,
  @LoginType varchar(100) = ''
)
  AS  
  BEGIN TRY             
		
		SELECT * FROM [SiteUsers].[MST_MAP_PlannedCommunication] 
		WHERE FK_CounselorID = CASE WHEN ISNULL(@LoginType,'') = '' THEN @FK_CounselorID ELSE FK_CounselorID  END
		AND FK_StudentID = @FK_StudentID  
		AND ISNULL(IsActive,0) = 1
		AND ISNULL(IsDeleted,0) = 0
		ORDER BY CreatedDateTime DESC
		
  END TRY  
  BEGIN CATCH  
        SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
  END CATCH





GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetSiteUser]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:28-11-2019    
purpos:Get User Site User CATEGORY   

********** ******************************************/   
CREATE PROC [SiteUsers].[USP_GetSiteUser]
AS
BEGIN
	SELECT PK_UserId,UserName FROM [SiteUsers].[MST_SiteUser] WHERE ISNULL(IsActive,0) = 1 AND ISNULL(IsDeleted,0) = 0;
END


GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetSiteUserCategory]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:28-11-2019    
purpos:Get User Site User CATEGORY   

********** ******************************************/   
CREATE PROC [SiteUsers].[USP_GetSiteUserCategory]
AS
BEGIN
	SELECT PK_CategoryId,CategoryName FROM [SiteUsers].[MST_SiteUserCategory] WHERE ISNULL(IsActive,0) = 1 AND ISNULL(IsDeleted,0) = 0;
END

GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetSiteUserChatDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************
CREATED BY :Vinish
CREATED DATE :2020-05-27 02:03:00.667
Purpose:
********************************************************************************************/
CREATE PROCEDURE [SiteUsers].[USP_GetSiteUserChatDetails]-- 0, 3,2
@PK_ChatID			bigint,
@Chat_From			bigint,
@Chat_To			bigint
AS 
BEGIN 
	SELECT 1 Message_Id,'Success' Message;
	SELECT 
	 ISNULL(PK_ChatID,0) PK_ChatID
	,ISNULL(Chat_From,0) Chat_From         
	,ISNULL(Chat_To,0) Chat_To            
	,ISNULL(Query_From,'')  Query_From        
	,ISNULL(Query_To,'')  Query_To          
	,ISNULL(IsDeleted  ,0) IsDeleted        
	,ISNULL(DeletedBy,0)    DeletedBy       
	,ISNULL(IsSeen_From,0)  IsSeen_From       
	,ISNULL(IsSeen_To,0) IsSeen_To         
	,FORMAT(CONVERT(DATETIME, QueryDateTime_From, 103),'dd/MM/yyyy HH:mm') QueryDateTime_From  
	,FORMAT(CONVERT(DATETIME, QueryDateTime_To, 103),'dd/MM/yyyy HH:mm') QueryDateTime_To  
	FROM [SiteUsers].[MST_SiteUserChat](NOLOCK) WHERE 
	
	Chat_From = (CASE 
	WHEN Chat_From = @Chat_From THEN @Chat_From 
	WHEN Chat_From = @Chat_To THEN @Chat_To 
	ELSE 0 END)
	AND 
	Chat_To =(CASE 
	WHEN Chat_To = @Chat_From THEN @Chat_From 
	WHEN Chat_To = @Chat_To THEN @Chat_To 
	ELSE 0 END)
	AND ISNULL(IsDeleted,0) = 0;
END








GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetSiteUserDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                  
CreatedBy:Vinish               
CreatedDate: 2020-05-07 14:46:50.177       
purpos:Get Counselor Details                

EXEC [SiteUsers].[USP_GetSiteUserDetails]                   
 @iPK_Id			 = 3
,@iPK_UserId    	 = 0
,@iRowperPage   	 = 10
,@iCurrentPage  	 = 1
,@cSearchBy     	 = ''
,@cSearchValue  	 = ''
,@cLoginType		 = 'counselor'
,@iFK_CategoryId	 = '2'
,@iFK_RoleId	     = '0'

****************************************************/                  
CREATE PROCEDURE [SiteUsers].[USP_GetSiteUserDetails]                
(    
 @iPK_Id					BIGINT,                     
 @iPK_UserId                BIGINT,                
 @iRowperPage               BIGINT,                
 @iCurrentPage              BIGINT,                
 @cSearchBy                 NVARCHAR(50)='',                
 @cSearchValue              NVARCHAR(50)='',
 @cLoginType				nvarchar(100) = '' ,
 @iFK_CategoryId			BIGINT,                
 @iFK_RoleId				BIGINT            
)                
AS                
BEGIN TRY                
 SELECT 1 AS Message_Id, 'SUCCESS' AS Message                 
      SELECT        
	   --(CASE WHEN (SELECT  item from dbo.SplitString(ISNULL(U.FK_AreaOfInterest,''),','))  IN (1,2) THEN 1 ELSE 0 END ) as A1,
	   --(SELECT  item from dbo.SplitString(
				--								(SELECT ISNULL(FK_AreaOfInterest,'') FROM [SiteUsers].[MST_SiteUser] where PK_UserId = @iPK_UserId) ,',')) A2,

	   ISNULL(U.PK_UserId				   ,'') PK_Id				   
	  ,ISNULL(U.UserName				   ,'') UserName				   
	  ,ISNULL(U.FK_CategoryId			   ,'') FK_CategoryId			   
	  ,ISNULL(U.FK_RoleId				   ,'') FK_RoleId				   
	  ,ISNULL(U.UserPassword			   ,'') UserPassword			   
	  ,ISNULL(U.IsActive				   ,'') IsActive				   
	  ,ISNULL(U.IsDeleted				   ,'') IsDeleted				   
	  --,ISNULL(U.CreatedBy				   ,'') CreatedBy				   
	  --,ISNULL(U.CreatedDateTime			   ,'') CreatedDateTime		   
	  --,ISNULL(U.UpdatedBy				   ,'') UpdatedBy				   
	  --,ISNULL(U.UpdatedDateTime			   ,'') UpdatedDateTime		   
	  --,ISNULL(U.DeletedBy				   ,'') DeletedBy				   
	  --,ISNULL(U.DeletedDateTime			   ,'') DeletedDateTime		   
	  ,ISNULL(U.Name					   ,'') Name					   
	  ,ISNULL(U.LastWebLogInDatetime	   ,'') LastWebLogInDatetime	   
	  ,ISNULL(U.Mobile_Number			   ,'') Mobile_Number			   
	  ,ISNULL(U.Alternate_Mobile_Number	   ,'') Alternate_Mobile_Number   
	  ,ISNULL(U.Address					   ,'') Address				   
	  ,ISNULL(U.Zipcode				       ,'') Zipcode				   
	  ,ISNULL(U.FK_StateID				   ,'') FK_StateID				   
	  ,ISNULL(U.FK_CityID				   ,'') FK_CityID				   
	  ,ISNULL(U.Fk_AreaOfInterest_State				   ,'') FK_AreaOfInterestStateId				   
	  ,ISNULL(U.Fk_AreaOfInterest_District				   ,'') FK_AreaOfInterestDistrictId	
	  ,ISNULL(U.FK_LanguageKnown		   ,'') FK_LanguageKnown		   
	  ,ISNULL(Convert(varchar(10),U.FK_AreaOfInterest)		   ,'') FK_AreaOfInterest		   
	  ,ISNULL(U.Image					   ,'') Image					   
	  ,ISNULL(U.HaveSmartPhone			   ,0) HaveSmartPhone			   
	  ,ISNULL(U.HavePC					   ,0) HavePC					   
	 
	  ,ISNULL(U.AreYou					   ,'') AreYou					   
	  ,ISNULL(U.JoinUsDescription					   ,'') JoinUsDescription
	  ,ISNULL(U.Declaration					   ,'') Declaration		
	  ,ISNULL(U.LikeAdoptStudentLater					   ,0) LikeAdoptStudentLater		   
	  
	  ,ISNULL(U.AdoptionWish			   ,0) AdoptionWish			     
	  ,ISNULL(U.Email					   ,'') Email					   
	  ,ISNULL(U.Fk_AreaOfInterest_State    ,'') Fk_AreaOfInterest_State   
	  ,ISNULL(U.Fk_AreaOfInterest_District ,'') Fk_AreaOfInterest_District

	  ,ISNULL(C.CategoryName ,'') CategoryName
	  ,ISNULL(R.RoleName,'') RoleName
	  ,ISNULL(st.StateName,'') StateName
	  ,ISNULL(ct.CityName,'') CityName
	  ,FORMAT(CONVERT(DATETIME,  u.CreatedDateTime, 103),'dd/MM/yyyy HH:mm') CreatedDateTime  
	  ,ISNULL(U.IsPendingForReply,'') IsPendingReplyUsers
	  ,ISNULL(U.IsManageCreiticalSupport,'') IsManageCreiticalSupport
	 ,ISNULL(U.IsApprovedCounselor,'') IsApprovedCounselor
	  ,ISNULL(U.IsAdoptedStudent,'') IsAdoptedStudent
	  ,ISNULL(U.FK_LanguageKnown,0) FK_LanguageKnown
	  --,ISNULL(U.FK_Education_DetailsID,0) FK_LanguageKnown
	  ,CONVERT(BIT,(CASE WHEN ISNULL(@iPK_UserId,0) =  isnull(U.IsAdoptedStudentByCounselor,0) THEN 1 ELSE 0 END)) MyAdoption
	  ,CONVERT(BIT,
			(CASE WHEN
				--Area Of Interest
				--(SELECT  item from dbo.SplitString(ISNULL(U.FK_AreaOfInterest,''),',')) IN (SELECT  item from dbo.SplitString(
				--								(SELECT ISNULL(FK_AreaOfInterest,'') FROM [SiteUsers].[MST_SiteUser] where PK_UserId = @iPK_UserId) ,','))
				--Language
				--OR 
				--(SELECT  item from dbo.SplitString(ISNULL(U.FK_LanguageKnown,''),','))  IN (SELECT  item from dbo.SplitString(
				--(SELECT ISNULL(FK_LanguageKnown,'') FROM [SiteUsers].[MST_SiteUser] where PK_UserId = @iPK_UserId) ,','))
				
				--and
				 ISNULL(U.IsAdoptedStudent,'') = 0
				
				THEN 1 ELSE 0 END
				
	    	  ) )IsMachingStudentsForCounselor
	   ,
	  ISNULL((
		SELECT  Convert(varchar(max),(SELECT CONVERT(varchar(100),Item)+ ','   from (
		SELECT AI.AreaOfInterest Item FROM DBO.SplitString (ISNULL(U.FK_AreaOfInterest,''),',') SP
		INNER JOIN [SiteUsers].[MST_AreaOfInterest]  AI   (NOLOCK)
		ON AI.PK_AreaOfInterest = SP.Item AND ISNULL(AI.IsActive,0) = 1
		) as MyTable  FOR XML PATH('')))
	  ),'') AreaOfInterest
	   ,
		ISNULL((
		SELECT  Convert(varchar(max),(SELECT CONVERT(varchar(100),Item)+',' from (
		SELECT RTRIM (LTRIM(LK.LanguageName)) Item FROM DBO.SplitString (U.FK_LanguageKnown,',') Lang
		INNER JOIN [SiteUsers].[LKP_Languages]  LK   (NOLOCK)
		ON LK.ID = Lang.Item 
		) as MyTable  FOR XML PATH('')))
	  ),'') LanguageKnown

	  
                     
      FROM  [SiteUsers].[MST_SiteUser]  U (NOLOCK)  
	  
      INNER JOIN [SiteUsers].[MST_SiteUserCategory]  C   (NOLOCK)    ON C.PK_CategoryId=U.FK_CategoryId
	  INNER JOIN [SiteUsers].[MST_SiteUserRole]  R   (NOLOCK)    ON R.PK_RoleId=U.FK_RoleId
	  --LEFT JOIN [SiteUsers].[MST_AreaOfInterest]  AI   (NOLOCK)    ON AI.PK_AreaOfInterest=U.FK_AreaOfInterest
      LEFT JOIN [dbo].[MST_State]     st    (NOLOCK)    ON U.FK_StateId=st.PK_StateId                
     LEFT JOIN [dbo].[MST_City]      ct    (NOLOCK)    ON U.FK_CityId=ct.PK_CityId                
	  
      WHERE 
	  ISNULL(U.IsDeleted,0)=CASE WHEN ISNULL(@cLoginType,'') = 'siteusers' then ISNULL(U.IsDeleted,0) else 0 end
	  AND U.PK_UserId = CASE WHEN @iPK_Id <> 0 THEN @iPK_Id ELSE U.PK_UserId END                
      AND U.FK_CategoryId = CASE WHEN @iFK_CategoryId <> 0 THEN @iFK_CategoryId ELSE U.FK_CategoryId END                
	  --AND U.FK_RoleId = CASE WHEN @iFK_RoleId <> 0 THEN @iFK_RoleId ELSE U.FK_CategoryId END        
	  
	  
	          
      and          
      (                    
         (case when CONVERT(CHAR(1),ISNULL(U.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
            )                           
           THEN @cSearchValue          
           ELSE  (case when CONVERT(CHAR(1),ISNULL(U.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
         END               
         )  


		  and          
      (                    
         Isnull(U.IsDeleted,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'Removed'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsDeleted,0)        
         END                    
         )    


		  and          
  (                    
         Isnull(U.CreatedBy,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cLoginType = 'volunteer' AND @cSearchBy != 'suggestedvolunteer' 
         )                           
           THEN @iPK_UserId
        ELSE Isnull(U.CreatedBy,0)        
         END                    
         ) 
		 
		 and          
      (                    
         Isnull(U.FK_CategoryId,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'suggestedvolunteer' AND  @cLoginType = 'volunteer'                
         )           
           THEN 3
        ELSE Isnull(U.FK_CategoryId,0)        
         END                    
         )    
		

		 and          
      (                    
         Isnull(U.IsAdoptedStudent,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsNotAdoptedStudent' AND  @cLoginType = 'volunteer'                
         )           
           THEN 0
        ELSE Isnull(U.IsAdoptedStudent,0)        
         END                    
         )    
		

		   and          
	  (               
         isnull(U.AdoptionWish,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cLoginType = 'counselor' AND U.FK_CategoryId = 1
         )                           
           THEN 1
        ELSE isnull(U.AdoptionWish,0) 
         END                    
         ) 



		   and          
	  (               
         isnull(U.IsAdoptedStudentByCounselor,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cLoginType = 'counselor'  and @cSearchBy = 'myadoption' and @cSearchBy <> ''
         )                           
           THEN @iPK_UserId
        ELSE isnull(U.IsAdoptedStudentByCounselor,0) 
         END                    
         ) 


		 

		  and          
	  (               
         isnull(U.IsAdoptedStudentByCounselor,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cLoginType = 'counselor_myadoption' and isnull(U.IsAdoptedStudent,0) = 1
     )                           
           THEN ISNULL(@iPK_UserId,0)
        ELSE isnull(U.IsAdoptedStudentByCounselor,0)
         END                    
         ) 

		 

		 
		 
		 and          
      (                    
  Isnull(U.IsPendingForReply,0) =                         
         CASE                           
  WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsPendingReplyUsers'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsPendingForReply,0)        
         END                    
         )     
		 
	and          
      (                    
         Isnull(U.IsManageCreiticalSupport,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsManageCreiticalSupport'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsManageCreiticalSupport,0)        
         END                    
         )  
		 
		 and          
      (                    
  Isnull(U.IsApprovedCounselor,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsApprovedCounselor'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsApprovedCounselor,0)        
         END                    
         ) 
		  and          
      (                    
         Isnull(U.IsAdoptedStudent,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsAdoptedStudent'                          
   )                           
           THEN 1
        ELSE Isnull(U.IsAdoptedStudent,0)       
         END                    
         )     

	and          
      (                    
         Isnull(U.IsAdoptedStudent,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsNotAdoptedStudent'                          
         )                           
           THEN 0
        ELSE Isnull(U.IsAdoptedStudent,0)        
         END                    
         )     

               
      and          
      (                    
         convert(varchar(10),concat(isnull(month(U.CreatedDateTime),'0'),isnull(year(U.CreatedDateTime),'0'))) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
         )                           
           THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
        ELSE convert(varchar(10),concat(isnull(month(U.CreatedDateTime),'0'),isnull(year(U.CreatedDateTime),'0')))          
         END                    
         )                     
         AND                
           ISNULL(C.CategoryName,'') LIKE 
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserCategory' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'                     
            ELSE  ISNULL(C.CategoryName,'')                   
          END 
		  
		   AND                
           ISNULL(R.RoleName,'') LIKE                    
          CASE                     
        WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserRole' AND @cSearchValue <> ''                    
    )                     
            THEN '%'+@cSearchValue+'%'                     
            ELSE  ISNULL(R.RoleName,'')                   
          END 
		    
  	      --End               
           AND      
           ISNULL(U.Name,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'Name' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'         
            ELSE  ISNULL(U.Name,'')                   
          END                 
               
          AND                
         ISNULL(st.StateName,'') LIKE                    
                         CASE                     
                           WHEN                       
                            (                    
                             @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''                    
                       )                     
                           THEN '%'+@cSearchValue+'%'                     
                           ELSE  ISNULL(st.StateName,'')                   
                         END                
             AND                
         ISNULL(ct.CityName,'') LIKE                    
                         CASE                     
                           WHEN                       
                            (                    
       @cSearchBy <> '' AND @cSearchBy = 'CityName' AND @cSearchValue <> ''                    
                            )                     
                           THEN '%'+@cSearchValue+'%'      
                           ELSE  ISNULL(ct.CityName,'')                
                         END
      
  	   					AND                
    ISNULL(U.Email,'') LIKE                    
                    CASE                     
                        WHEN                       
                          (                    
                           @cSearchBy <> '' AND @cSearchBy = 'Email' AND @cSearchValue <> ''                    
                          )                     
                         THEN '%'+@cSearchValue+'%'                     
                         ELSE  ISNULL(U.Email,'')                   
                       END                 
           AND  
               ISNULL(U.Mobile_Number,'') LIKE                    
                       CASE                     
                         WHEN                       
                          (                    
                           @cSearchBy <> '' AND @cSearchBy = 'MobileNo' AND @cSearchValue <> ''                    
                          )                     
                         THEN '%'+@cSearchValue+'%'                     
                         ELSE  ISNULL(U.Mobile_Number,'')                   
                  END        
  	   				    
                 ORDER BY U.PK_UserId  desc                 
				 OFFSET (@iCurrentPage-1)*@iRowperPage ROWS                     
                 FETCH NEXT @iRowperPage ROWS ONLY                
    -------Counts for cards          
	  SELECT           
	  ISNULL(COUNT (1),0)  AS TotalItem,  
	          
	  (          
	  SELECT           
	  ISNULL(SUM(          
	  CASE           
	  WHEN YEAR(U.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(U.CreatedDateTime)=MONTH(GETDATE())           
	  THEN 1           
	  ELSE 0 END),0          
	  )          
	  ) AS TotalCurrentMonth,   
	        
	  ISNULL(SUM(CASE WHEN isnull(U.IsActive,0) =1 THEN 1 ELSE 0 END),0)AS TotalActive,          
	  ISNULL(SUM(CASE WHEN isnull(U.IsActive,0) =0 THEN 1 ELSE 0 END),0)AS TotalInActive             ,
	  ISNULL(SUM(CASE WHEN isnull(U.IsDeleted,0) =1 THEN 1 ELSE 0 END),0)AS RemovedUsers,          
	  ISNULL(SUM(CASE WHEN isnull(U.IsApprovedCounselor,0) =1 THEN 1 ELSE 0 END),0)AS ApprovedCounselor,
	  ISNULL(SUM(CASE WHEN isnull(U.IsAdoptedStudent,0) =1 and isnull(U.IsActive,0) =1 THEN 1 ELSE 0 END),0)AS AdoptedStudent,
	  ISNULL(SUM(CASE WHEN isnull(U.IsAdoptedStudent,0) =0 and isnull(U.IsActive,0) =1 THEN 1 ELSE 0 END),0)AS PendingAdoptedStudent,
	  ISNULL(SUM(CASE WHEN isnull(U.IsAdoptedStudentByCounselor,0) = @iPK_UserId and isnull(U.IsActive,0) =1 THEN 1 ELSE 0 END),0)AS TotalAdoptedStudentByCounselor,
	  
	  
	  0 LastMonth,
	  0 TotalExpiredMonth,
	
	  ISNULL(SUM(CASE WHEN isnull(U.IsApprovedCounselor,0) =1 THEN 1 ELSE 0 END),0)AS  ApprovedCounselor,

      ISNULL(SUM(CASE WHEN isnull(U.IsPendingForReply,0) =1 THEN 1 ELSE 0 END),0)AS PendingReplyUsers,
	  ISNULL(SUM(CASE WHEN isnull(U.IsManageCreiticalSupport,0) =1 THEN 1 ELSE 0 END),0)AS ManageCreiticalSupport,

	   --Student Display Cards
      CASE WHEN ISNULL(@iFK_CategoryId,0) = 1 THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END  IsManageCreiticalSupport ,

	  --Counselor Display Cards  
      CASE WHEN ISNULL(@iFK_CategoryId,0) = 2 THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END IsApprovedCounselor ,
      CASE WHEN ISNULL(@iFK_CategoryId,0) = 2 THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END IsLastMonth ,
      CASE WHEN ISNULL(@iFK_CategoryId,0) = 2 THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END IsTotalExpiredMonth ,

	  --Volunteer Display Cards
      

	 
	  CASE WHEN ISNULL(@iFK_CategoryId,0) not in (0,3) THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END IsManageFeedBack ,

	  CONVERT(BIT,1) IsTotalItem ,
	  CONVERT(BIT,1) IsTotalActive ,
	  CONVERT(BIT,1) IsThisMonth ,
	  CONVERT(BIT,1) IsTotalInactive ,

	  CASE WHEN ISNULL(@iFK_CategoryId,0) = 0 THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END IsPendingReplyUsers,
	  CASE WHEN ISNULL(@iFK_CategoryId,0) = 0 THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END IsRemovedUsers,

	  

	  CONVERT(BIT,(SELECT CASE WHEN @cLoginType = 'superadmin' THEN 0 ELSE 1 END)) IsNotSuperAdmin
	      
      FROM  [SiteUsers].[MST_SiteUser]  U (NOLOCK)                
      INNER JOIN [SiteUsers].[MST_SiteUserCategory]  C   (NOLOCK)    ON C.PK_CategoryId=U.FK_CategoryId
	  INNER JOIN [SiteUsers].[MST_SiteUserRole]  R   (NOLOCK)    ON R.PK_RoleId=U.FK_RoleId
	  --LEFT JOIN [SiteUsers].[MST_AreaOfInterest]  AI   (NOLOCK)    ON AI.PK_AreaOfInterest=U.FK_AreaOfInterest
      LEFT JOIN [dbo].[MST_State]     st    (NOLOCK)    ON U.FK_StateId=st.PK_StateId                
LEFT JOIN [dbo].[MST_City]      ct    (NOLOCK)    ON U.FK_CityId=ct.PK_CityId                
	  
      WHERE 
	  ISNULL(U.IsDeleted,0)=CASE WHEN ISNULL(@cLoginType,'') = 'siteusers' then ISNULL(U.IsDeleted,0) else 0 end
	  AND U.PK_UserId = CASE WHEN @iPK_Id <> 0 THEN @iPK_Id ELSE U.PK_UserId END                
      AND U.FK_CategoryId = CASE WHEN @iFK_CategoryId <> 0 THEN @iFK_CategoryId ELSE U.FK_CategoryId END                
	  --AND U.FK_RoleId = CASE WHEN @iFK_RoleId <> 0 THEN @iFK_RoleId ELSE U.FK_CategoryId END        
	  
	  
	          
      and          
      (                    
         (case when CONVERT(CHAR(1),ISNULL(U.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
         CASE            
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
            )                           
           THEN @cSearchValue          
           ELSE  (case when CONVERT(CHAR(1),ISNULL(U.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
         END               
         )  


		  and          
      (                    
         Isnull(U.IsDeleted,0) =                         
         CASE                           
           WHEN                             
            (                  
             @cSearchBy <> '' AND @cSearchBy = 'Removed'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsDeleted,0)        
         END                    
         )    


		  and          
      (                    
         Isnull(U.CreatedBy,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cLoginType = 'volunteer' AND @cSearchBy != 'suggestedvolunteer'
         )                           
           THEN @iPK_UserId
        ELSE Isnull(U.CreatedBy,0)        
         END                    
         ) 
		 

		  and          
      (                    
         Isnull(U.FK_CategoryId,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'suggestedvolunteer' AND  @cLoginType = 'volunteer'                         
         )                           
           THEN 3
        ELSE Isnull(U.FK_CategoryId,0)        
         END                    
         ) 
		 	 and          
      (                    
         Isnull(U.IsAdoptedStudent,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsNotAdoptedStudent' AND  @cLoginType = 'volunteer'                
         )           
           THEN 0
        ELSE Isnull(U.IsAdoptedStudent,0)        
         END                    
         )    
		
		
		   and          
	  (               
     isnull(U.AdoptionWish,0) =     
         CASE                           
           WHEN                             
            (                
             @cLoginType = 'counselor'  AND U.FK_CategoryId = 1
         )                           
           THEN 1
        ELSE isnull(U.AdoptionWish,0) 
         END                    
         ) 

		   and          
	  (               
         isnull(U.IsAdoptedStudentByCounselor,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cLoginType = 'counselor'  and @cSearchBy = 'myadoption' and @cSearchBy <> ''
         )                           
           THEN @iPK_UserId
        ELSE isnull(U.IsAdoptedStudentByCounselor,0) 
         END                    
         ) 
		   
		 
		 and          
      (                    
         Isnull(U.IsPendingForReply,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsPendingReplyUsers'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsPendingForReply,0)        
         END                    
         )     
		 
	and          
      (                    
         Isnull(U.IsManageCreiticalSupport,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsManageCreiticalSupport'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsManageCreiticalSupport,0)        
         END                    
         )  
		 
		 and          
      (                    
      Isnull(U.IsApprovedCounselor,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsApprovedCounselor'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsApprovedCounselor,0)        
         END                    
         ) 
		  and          
      (                    
         Isnull(U.IsAdoptedStudent,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsAdoptedStudent'                          
         )                           
           THEN 1
        ELSE Isnull(U.IsAdoptedStudent,0)        
         END                    
         )     

	and          
      (                    
         Isnull(U.IsAdoptedStudent,0) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'IsNotAdoptedStudent'                          
         )                           
           THEN 0
        ELSE Isnull(U.IsAdoptedStudent,0)        
         END                    
         )     

               
      and          
      (                    
         convert(varchar(10),concat(isnull(month(U.CreatedDateTime),'0'),isnull(year(U.CreatedDateTime),'0'))) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
         )                           
           THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
        ELSE convert(varchar(10),concat(isnull(month(U.CreatedDateTime),'0'),isnull(year(U.CreatedDateTime),'0')))          
         END                    
         )                     
         AND              
           ISNULL(C.CategoryName,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserCategory' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'                     
            ELSE  ISNULL(C.CategoryName,'')                   
          END 
		  
		   AND                
           ISNULL(R.RoleName,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserRole' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'                     
            ELSE  ISNULL(R.RoleName,'')                   
          END 
		    
  	      --End               
           AND      
           ISNULL(U.Name,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'Name' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'         
            ELSE  ISNULL(U.Name,'')                   
          END                 
               
          AND                
         ISNULL(st.StateName,'') LIKE                    
                         CASE                     
                           WHEN                       
                            (                    
                             @cSearchBy <> '' AND @cSearchBy = 'StateName' AND @cSearchValue <> ''                    
                            )                     
                           THEN '%'+@cSearchValue+'%'                     
                           ELSE  ISNULL(st.StateName,'')                   
                         END                
             AND                
         ISNULL(ct.CityName,'') LIKE                    
                         CASE                     
                           WHEN                       
                            (                    
       @cSearchBy <> '' AND @cSearchBy = 'CityName' AND @cSearchValue <> ''                    
                            )                     
                           THEN '%'+@cSearchValue+'%'                     
                           ELSE  ISNULL(ct.CityName,'')                   
                         END
      
  	   					AND                
               ISNULL(U.Email,'') LIKE                    
                    CASE                     
         WHEN                       
                          (                    
                           @cSearchBy <> '' AND @cSearchBy = 'Email' AND @cSearchValue <> ''                    
                          )                     
                         THEN '%'+@cSearchValue+'%'                     
                         ELSE  ISNULL(U.Email,'')                   
                       END                 
           AND  
               ISNULL(U.Mobile_Number,'') LIKE                    
                       CASE                     
                         WHEN                       
                          (                    
                           @cSearchBy <> '' AND @cSearchBy = 'MobileNo' AND @cSearchValue <> ''                    
                          )                     
                         THEN '%'+@cSearchValue+'%'                     
                         ELSE  ISNULL(U.Mobile_Number,'')                   
                  END         
					   --End Count

					   --Education Details List
	  SELECT 

	  ED.ID,
	  U.PK_UserId FK_UserId,
	   ISNULL(ED.Education_Type				  ,'') Education_Type
	  ,ISNULL(ED.Class						  ,'') Class
	  ,ISNULL(ED.FK_BoardID					  ,0) FK_BoardID
	  ,ISNULL(ED.FK_StreamID				  ,0) FK_StreamID
	  ,ISNULL(ED.Currentsemester			  ,'') Currentsemester
	  ,ISNULL(ED.UniversityName				  ,'') UniversityName
	  ,ISNULL(ED.NatureOFCompletion			  ,'') NatureOFCompletion
	  ,ISNULL(ED.Percentage					  ,0) Percentage
	  ,ISNULL(ED.Previous_Class				  ,'') Previous_Class
	  ,ISNULL(ED.FK_Previous_Class_Board	  ,0) FK_Previous_Class_Board
	  ,ISNULL(ED.Previous_Class_Percentage	  ,0) Previous_Class_Percentage
	  ,ISNULL(ED.Year_of_Passing			  ,'') Year_of_Passing
	  ,ISNULL(''				  ,'') Fk_UserName
	  ,ISNULL(ED.CourseName					  ,'') CourseName
	  ,ISNULL(ED.Specification				  ,'') Specification
	  ,ISNULL(ED.OtherWork                    ,'') OtherWork
	  ,ISNULL(BT.BoardName                    ,'') BoardType
	  ,ISNULL(BT1.BoardName                    ,'') PreviousClassBoard
	  ,ISNULL(ST.StreamName                    ,'') Stream

	  FROM  [SiteUsers].[MST_SiteUser](NOLOCK)  U   
	  INNER JOIN SiteUsers.MST_AcademicDetails(NOLOCK) ED on ED.FK_UserID = U.PK_UserId
	  LEFT JOIN [SiteUsers].[stream](NOLOCK) ST on ST.ID=ED.FK_StreamID
	  LEFT JOIN [SiteUsers].[Board](NOLOCK) BT on BT.ID=ED.FK_BoardID
	  LEFT JOIN [SiteUsers].[Board](NOLOCK) BT1 on BT1.ID=ED.FK_Previous_Class_Board

	  WHERE ED.FK_UserID = CASE WHEN ISNULL(@iPK_Id,0) <> 0 THEN ISNULL(@iPK_Id,0) ELSE ED.FK_UserID END;
						                            
END TRY                
BEGIN CATCH                 
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                 
END CATCH;




GO
/****** Object:  StoredProcedure [SiteUsers].[USP_GetSiteUserRoles]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************      
CreatedBy:Vinish
CreatedDate:28-11-2019    
purpos:Get User Site User Roles   

********** ******************************************/   
CREATE proc [SiteUsers].[USP_GetSiteUserRoles]
as
begin
SELECT PK_RoleId	,RoleName FROM [SiteUsers].[MST_SiteUserRole] WHERE ISNULL(IsActive,0) = 1 AND ISNULL(IsDeleted,0) = 0
end

GO
/****** Object:  StoredProcedure [SiteUsers].[usp_GetStream]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [SiteUsers].[usp_GetStream]
(
@EducationLevel Varchar(50))
AS
BEGIN

select ID,StreamName from [SiteUsers].[stream] where  EducationLevel=@EducationLevel
End

GO
/****** Object:  StoredProcedure [SiteUsers].[USP_SiteUserDeleteUser]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 /******************************************    
 CreatedBy:Vinish
 CreatedDate: 2020-05-08 23:15:45.780
 purpos:Delete 
 
 ********** ******************************************/  
 
 CREATE PROCEDURE [SiteUsers].[USP_SiteUserDeleteUser]
 (
 @iPK_Id	  BIGINT,
 @iUserId          BIGINT  ,
 @recover          bit = 0
 )
 AS  
 BEGIN TRY 
 
  --   DECLARE @iMappingExist INT
  --SET @iMappingExist = (SELECT COUNT(*) FROM [SiteUsers].[MST_SiteUser](NOLOCK) WHERE PK_UserId =@iPK_Id) 
  --IF(ISNULL(@iMappingExist,0)=0) 
  --  BEGIN            
            UPDATE [SiteUsers].[MST_SiteUser]
            SET 
			IsActive=case when Isnull(@recover,0) = 0 then 0 else 1 end, 
            IsDeleted=case when Isnull(@recover,0) = 0 then 1 else 0 end,  
            DeletedBy=case when Isnull(@recover,0) = 0 then @iUserId else DeletedBy end,  
            DeletedDateTime=case when Isnull(@recover,0) = 0 then GETDATE() else DeletedDateTime end,
			RecoverBy=case when Isnull(@recover,0) = 0 then @iUserId else RecoverBy end, 
            RecoverDateTime=case when Isnull(@recover,0) = 0 then GETDATE() else RecoverDateTime end
			WHERE
            PK_UserId  = @iPK_Id 
			if(ISNULL(@recover,0) = 0)
			BEGIN
				SELECT 1 AS Message_Id,'Deleted Successfully.' AS Message 
			END
			ELSE
			BEGIN
				SELECT 1 AS Message_Id,'Undo Deleted Record Successfully.' AS Message 
			END
  --  END
  --    ELSE
  --   BEGIN
	 -- SELECT 0 AS Message_Id,'You Cannot Delete Mapping As it Exists!' AS Message 

	 --END
 	    
             
 END TRY  
 BEGIN CATCH  
       SELECT 0 AS Message_Id, ERROR_MESSAGE() AS Message  
 END CATCH  
  








GO
/****** Object:  StoredProcedure [SiteUsers].[UST_GetFeedDetails]    Script Date: 5/29/2020 7:32:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************                  
CreatedBy:Vinish               
CreatedDate: 2020-05-07 14:46:50.177       
purpos:Get Counselor Details                

EXEC [SiteUsers].[Mst_GetFeedDetails]                
 @PK_FeedID			 = 3
,@iPK_UserId    	 = 0
,@iRowperPage   	 = 10
,@iCurrentPage  	 = 1
,@cSearchBy     	 = ''
,@cSearchValue  	 = ''
,@cLoginType		 = ''

****************************************************/                  
CREATE PROCEDURE [SiteUsers].[UST_GetFeedDetails]                
(    
 @PK_FeedID					BIGINT = 0,                     
 @UserId                BIGINT = 0,                
 @iRowperPage               BIGINT = 10,                
 @iCurrentPage              BIGINT = 1,                
 @cSearchBy                 NVARCHAR(50)='',                
 @cSearchValue              NVARCHAR(50)='',
 @cLoginType				nvarchar(100) = '' 
)                
AS                
BEGIN TRY                
 SELECT 1 AS Message_Id, 'SUCCESS' AS Message                 
      SELECT        
	  
		ISNULL(F.PK_FeedID            ,'') PK_FeedID       
		,ISNULL(F.FK_UserID			 ,'') FK_UserID		
		,ISNULL(U.FK_CategoryId			 ,'') FK_CategoryID	
		,ISNULL(U.UserName			 ,'') UserName	
		,ISNULL(C.CategoryName			 ,'') CategoryName	
		,ISNULL(U.FK_AreaOfInterest			 ,'') FK_AreaOfInterest	
		,ISNULL(F.FeedSubject			 ,'') FeedSubject		
		,ISNULL(F.FeedDescription		 ,'') FeedDescription	
		,ISNULL(F.MediaType			 ,'') MediaType		
		,ISNULL(F.VideoUrl			 ,'') VideoUrl		
		,ISNULL(F.ResourceFile					 ,'') ResourceFile				
		,ISNULL(F.CreatedBy			 ,'') CreatedBy		
		,ISNULL(F.IsActive			 ,'') IsActive		
		,ISNULL(F.IsDeleted			 ,'') IsDeleted		
		
	  ,FORMAT(CONVERT(DATETIME,  F.CreatedDateTime, 103),'dd/MM/yyyy HH:mm') CreatedDateTime  
	  
      FROM  SiteUsers.Mst_Feeds  F (NOLOCK)  
	  
      INNER JOIN [SiteUsers].[MST_SiteUser]  U (NOLOCK) ON F.FK_UserID=U.PK_UserId
	  INNER JOIN [SiteUsers].[MST_SiteUserCategory]  C(NOLOCK) ON U.FK_CategoryId=C.PK_CategoryId
	 
      WHERE 
	  ISNULL(F.IsDeleted,0) = 0 
	  AND F.PK_FeedID = CASE WHEN @PK_FeedID <> 0 THEN @PK_FeedID ELSE F.PK_FeedID END                
      and          
      (                    
         (case when CONVERT(CHAR(1),ISNULL(F.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
            )                           
           THEN @cSearchValue          
           ELSE  (case when CONVERT(CHAR(1),ISNULL(F.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
         END               
         )  
      and          
      (                    
         convert(varchar(10),concat(isnull(month(F.CreatedDateTime),'0'),isnull(year(F.CreatedDateTime),'0'))) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
         )                           
           THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
        ELSE convert(varchar(10),concat(isnull(month(F.CreatedDateTime),'0'),isnull(year(F.CreatedDateTime),'0')))          
         END                    
         ) 
		AND              
           ISNULL(C.CategoryName,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserCategory' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'                     
        ELSE  ISNULL(C.CategoryName,'')                   
          END 
		  AND              
           ISNULL(U.UserName,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserName' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'                     
            ELSE  ISNULL(U.UserName,'')                   
          END 

		   AND              
           ISNULL(F.FK_UserID,0) =                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserData' AND @cSearchValue <> ''                    
          )                     
            THEN Convert(BIGINT,@cSearchValue)
            ELSE  ISNULL(F.FK_UserID,0)
          END 
		  		    
      ORDER BY F.PK_FeedID  desc                 
	  OFFSET (@iCurrentPage-1)*@iRowperPage ROWS                     
      FETCH NEXT @iRowperPage ROWS ONLY                
    -------Counts for cards          
	  SELECT           
	  ISNULL(COUNT (1),0)  AS TotalItem,  
	          
	  (          
	  SELECT           
	  ISNULL(SUM(          
	  CASE           
	  WHEN YEAR(F.CreatedDateTime)=YEAR(GETDATE()) AND MONTH(F.CreatedDateTime)=MONTH(GETDATE())           
	  THEN 1           
	  ELSE 0 END),0          
	  )          
	  ) AS TotalCurrentMonth,   
	        
	  ISNULL(SUM(CASE WHEN isnull(F.IsActive,0) =1 THEN 1 ELSE 0 END),0)AS TotalActive,          
	  ISNULL(SUM(CASE WHEN isnull(F.IsActive,0) =0 THEN 1 ELSE 0 END),0)AS TotalInActive      
	      
      FROM  SiteUsers.Mst_Feeds  F (NOLOCK)  
	  

	  INNER JOIN [SiteUsers].[MST_SiteUser]  U (NOLOCK) ON F.FK_UserID=U.PK_UserId
	  INNER JOIN [SiteUsers].[MST_SiteUserCategory]  C(NOLOCK) ON U.FK_CategoryId=C.PK_CategoryId
      WHERE 
	  ISNULL(F.IsDeleted,0) = 0 
	  AND F.PK_FeedID = CASE WHEN @PK_FeedID <> 0 THEN @PK_FeedID ELSE F.PK_FeedID END                
      and          
      (                    
         (case when CONVERT(CHAR(1),ISNULL(F.IsActive,'')) = '1' then 'Active' else 'Inactive' end ) like                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'Status' AND @cSearchValue <> ''                          
            )                           
           THEN @cSearchValue          
           ELSE  (case when CONVERT(CHAR(1),ISNULL(F.IsActive,'')) = '1' then 'Active' else 'Inactive' end )                        
         END               
         )  
      and          
      (                    
         convert(varchar(10),concat(isnull(month(F.CreatedDateTime),'0'),isnull(year(F.CreatedDateTime),'0'))) =                         
         CASE                           
           WHEN                             
            (                          
             @cSearchBy <> '' AND @cSearchBy = 'ThisMonth'                          
         )                           
           THEN convert(varchar(10),concat(month(getdate()),year(getdate())))          
        ELSE convert(varchar(10),concat(isnull(month(F.CreatedDateTime),'0'),isnull(year(F.CreatedDateTime),'0')))          
         END                    
         )  
		 AND              
           ISNULL(C.CategoryName,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserCategory' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'                     
            ELSE  ISNULL(C.CategoryName,'')                   
          END 
		  AND              
           ISNULL(U.UserName,'') LIKE                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserName' AND @cSearchValue <> ''                    
          )                     
            THEN '%'+@cSearchValue+'%'                     
            ELSE  ISNULL(U.UserName,'')                   
          END 	
		  
		   AND              
           ISNULL(F.FK_UserID,0) =                    
          CASE                     
            WHEN                       
          (                    
           @cSearchBy <> '' AND @cSearchBy = 'SiteUserData' AND @cSearchValue <> ''                    
          )                     
            THEN Convert(BIGINT,@cSearchValue)
            ELSE  ISNULL(F.FK_UserID,0)
          END 	                                
END TRY                
BEGIN CATCH                 
 SELECT 0 AS Message_Id,ERROR_MESSAGE() AS Message                 
END CATCH;






GO
