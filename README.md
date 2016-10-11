
# create-test-session-file
This PowerShell script accepts a csv as an input file, manipulates the data and format, and saves it as another file, ready to upload to a testing service.

The first csv file was exported from an information system and the resulting file will be uploaded to a testing website.  Headers will be renamed and reordered, cell contents will be created based on the values of other cells, and static information will be added as necessary.

There are three files that need to be manually exported from the SIS for each of the elementary schools.  The files should be saved as ".\ExportsReports\XXX-ClassRosterL.CSV" where XXX = school code.  The grade levels should remain 0-12 so the files can be used for other processes.  The checkbox should be checked next to UPPERCASE.

This script first copies these files to this server in the CDT folder and they are processed with this script to keep certain data, change some data to meet the requirements to upload to DRC, and exclude unnecessary data.  When they are done being manipulated, they are combined into one file that is ready to uplod to DRC for elementary school CDT Test Sessions.
