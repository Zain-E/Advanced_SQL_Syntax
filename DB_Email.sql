
----------------------------------------- SCRIPT TO SEND EMAIL----------------------------------------------------------
--So remember, the column header names will not appear, you must UNION them onto the output, and then for ease I have created a VIEW from
-- this makes the query itself below very easy to run.

EXEC msdb.dbo.sp_send_dbmail

@profile_name = 'Zain',
@recipients = 'zaineisa.work@gmail.com',
@subject = 'Jon Jones Fight Data',
@query = 'select * from [MISC].[dbo].[UFC_Fighter_Email]',
@attach_query_result_as_file = 1,
@query_attachment_filename = 'UFC_Jon_Jones.csv',
@query_result_separator = '|',
@query_result_header = 1,
@query_no_truncate =1,
@body = 'please see attached the fight data for the fighter specified at hand, for any issues - contact Zain Eisa by replying to this email. Thank you',
@query_result_width = 32767

----------------------------------------- OPTIONAL VARIABLES TO INCLUDE ----------------------------------------------------------

sp_send_dbmail [ [ @profile_name = ] 'profile_name' ]
[ , [ @recipients = ] 'recipients [ ; ...n ]' ]
[ , [ @copy_recipients = ] 'copy_recipient [ ; ...n ]' ]
[ , [ @blind_copy_recipients = ] 'blind_copy_recipient [ ; ...n ]' ]
[ , [ @subject = ] 'subject' ] 
[ , [ @body = ] 'body' ] 
[ , [ @body_format = ] 'body_format' ]
[ , [ @importance = ] 'importance' ]
[ , [ @sensitivity = ] 'sensitivity' ]
[ , [ @file_attachments = ] 'attachment [ ; ...n ]' ]
[ , [ @query = ] 'query' ]
[ , [ @execute_query_database = ] 'execute_query_database' ]
[ , [ @attach_query_result_as_file = ] attach_query_result_as_file ]
[ , [ @query_attachment_filename = ] query_attachment_filename ]
[ , [ @query_result_header = ] query_result_header ]
[ , [ @query_result_width = ] query_result_width ]
[ , [ @query_result_separator = ] 'query_result_separator' ]
[ , [ @exclude_query_output = ] exclude_query_output ]
[ , [ @append_query_error = ] append_query_error ]
[ , [ @query_no_truncate = ] query_no_truncate ]
[ , [ @query_result_no_padding = ] query_result_no_padding ]
[ , [ @mailitem_id = ] mailitem_id ] [ OUTPUT ]			


----------------------------------------- CONFIGURATION - NOT QUITE SURE WHAT THIS DOES ----------------------------------------------------------


--PLEASE ALSO LOOK AT THIS LINK TO SETUP A DATABASE PROFILE WITHIN (MANAGEMENT) ==> (DATABASE MAIL)---
--https://veeramaninatarajanmca.wordpress.com/2016/11/21/how-to-setup-database-mail-in-sql-server-using-gmail/--

sp_CONFIGURE 'show advanced', 1
GO
RECONFIGURE
GO
sp_configure 'Database Mail XPs',1
reconfigure
GO
ALTER DATABASE [MISC] SET ENABLE_BROKER WITH NO_WAIT
GO
