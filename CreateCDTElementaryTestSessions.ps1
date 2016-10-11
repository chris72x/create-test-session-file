[uint64[]]$PASecureIDArray = @();  # Strongly typed, only integers
while($s = (Read-Host "Enter a PA SecureID").Trim()){$PASecureIDArray+=$s} # Trim takes out spaces before or after

$schoolArray = "FIR", "SEC", "THI"

foreach ($element in $schoolArray) {

    $sourceFile = ("P:\ExportsReports\" + $element + "-ClassRosterL")
    $beginFile = ("C:\Users\user\Documents\CDT\" + $element)
    $endFile = "-CDT-ElementaryTestSessions"

    $importedFile1 = ($sourceFile + ".CSV");
     $exportedFile2 = ($beginFile + $endFile + ".CSV");
    $importedFile3 = ($beginFile + $endFile + ".CSV");
     $exportedFile4 = ($beginFile + $endFile + "2.CSV");
    $importedFile5 = ($beginFile + $endFile + "2.CSV");
     $exportedFile6 = ($beginFile + $endFile + "3.CSV");
    $importedFile7 = ($beginFile + $endFile + "3.CSV");
     $exportedFile8 = ($beginFile + $endFile + "4.CSV");
    $importedFile9 = ($beginFile + $endFile + "4.CSV");
     $exportedFile10 = ($beginFile + $endFile + "5.CSV");
    $importedFile11 = ($beginFile + $endFile + "5.CSV");
     $exportedFile12 = ($beginFile + $endFile + "6.CSV");
    $importedFile13 = ($beginFile + $endFile + "6.CSV");
     $exportedFile14 = ($beginFile + $endFile + "7.CSV");
    $importedFile15 = ($beginFile + $endFile + "7.CSV");
     $exportedFile16 = ($beginFile + $endFile + "8.CSV");
    $importedFile17 = ($beginFile + $endFile + "8.CSV");
     $exportedFile18 = ($beginFile + $endFile + "9.CSV");
    $importedFile19 = ($beginFile + $endFile + "9.CSV");
     $exportedFile20 = ($beginFile + $endFile + "10.CSV");
    $importedFile21 = ($beginFile + $endFile + "10.CSV");
     $exportedFile22 = ($beginFile + $endfile + "-Upload.csv");


    $schoolCodesArray = @{
          "002"  = "1234";  # First Elementary
          "003"  = "2345";  # Second Elementary
          "001"  = "3456";  # Third Elementary
          "010"  = "4567";  # Middle School
          "020"  = "5678"   # Senior High School
        }

    function MoveFilesFromSISToCDT {

        Copy-Item $importedFile1 $exportedFile2;

    }

    function KeepAndAddParticularColumns {

    #  This function imports the csv file, keeps certain columns, and saves it as another csv file.
         Import-Csv $importedFile3 |`
     
         Select-Object -Property @{ expression = {$_.cenrlhmdist}; label = 'District Code' }, `
            @{ expression = {$_. schlrefno}; label = 'School Code' }, `
            @{ expression = {$_.cpasid}; label = 'PAsecureID' }, `
            @{ expression = {$_.clastname}; label = 'Student Last Name' }, `
            @{ expression = {$_.cfirstname}; label = 'Student First Name' }, `
            @{ expression = {$_.d_dob}; label = 'Date of Birth' }, `
            'Educator ID (email)', `
            'Test Session Name', `
            'Content Area', `
            'Assessment', `
            'Mode', `
            'Begin Date', `
            'End Date', `
            'Local Student ID', `
            'ccoursenam', `
            'chome_rm', `
            'teachlast', `
            'teachfirst', `
            'ngrade' |
         select -Property @{n='chome_rm';e={$_.chome_rm -replace '^0+'}},* -Exclude 'chome_rm' |
    
         Export-Csv $exportedFile4 -NoTypeInformation;

    }

    function KeepGrades3-5 {
        $c = @("0", "1", "2")

        $csv = (Import-Csv $importedFile5) |

        where {$_.ngrade -notin $c -and $_.PASecureID -in $PASecureIDArray} |

        convertto-csv -NoTypeInformation | %{$_-replace '"', ""} | out-file $exportedFile6 -fo -en ascii

}
        function ReplaceSchoolCodesBasedOnArray {
    # declare hash table with School Code mapping

        $csv = Import-Csv $importedFile7

    #  Replace data based on array

            foreach($row in $csv)
                {

                $row.'School Code' = $schoolCodesArray[$row.'School Code'];
                }

            $csv | Export-Csv $exportedFile8 -NoTypeInformation;
    }

    function CreateEmailAddress {

      $csv = Import-Csv $importedFile9

              foreach($row in $csv)
            
                {

                    $row.'Educator ID (email)' = $row.teachfirst.substring(0,1).tolower()`
                    +$row.teachlast.tolower()`
                    +"@email.org";

                    if($row.'teachfirst' -eq 'JOHN' -and $row.teachlast -eq 'SMITH') {
         
                         $row.'Educator ID (email)' = "josmith@email.org";
        
                    }

                    if($row.'teachfirst' -eq 'JANE' -and $row.teachlast -eq 'DOE') {
         
                        $row.'Educator ID (email)' = "jadoe@email.org";
        
                    }
            
                }

           $csv | Export-Csv $exportedFile10 -NoTypeInformation;
    }
    
    function CreateTestSessionName {

       $csv = Import-Csv $importedFile11

              foreach($row in $csv)
          
              {

                $row.'Test Session Name' = $row.teachlast + " " + $row.ccoursenam + " "`
                + $row.chome_rm;

              }

           $csv | Export-Csv $exportedFile12 -NoTypeInformation;
    }
            
    function CreateContentAreaAndAssessment {

        #look at column 'Test Session Name'
        #  if find strings 'eng.'
        #    then make column 'Conent Area' = "Literacy"

        $csv = (Import-Csv $importedFile13);

        foreach($row in $csv) {

            if($row.ccoursenam -match ".eng") {
         
             $row.'Content Area' = "Literacy";
             $row.Assessment = "Reading Grades 3-5"
        
            }
        }

            foreach($row in $csv) {

            if($row.ccoursenam -match ".math") {
         
             $row.'Content Area' = "Mathematics";
             $row.Assessment = "Math Grades 3-5"
        
            }
        }

        $csv | convertto-csv -NoTypeInformation | out-file $exportedFile14  -fo -en ascii
    }

    function PopulateModeBeginAndEndDate {

       $csv = Import-Csv $importedFile15

              foreach($row in $csv)
          
              {

                $row.Mode = "Online";
                $row.'Begin Date' = "8/22/2016";
                $row.'End Date' = "7/28/2017";

              }

           $csv | Export-Csv $exportedFile16 -NoTypeInformation;

    }

    function RemovePeriodsFromTestSessionName {

       $csv = Import-Csv $importedFile17
   
        foreach($row in $csv)

              {

                 $replacePeriod = $row.'Test Session Name';
                 $replacePeriod = $replacePeriod.replace(".", "");
                 $row.'Test Session Name' = $replacePeriod

              }

            $csv | Export-Csv $exportedFile18 -NoTypeInformation;

    }

    function KeepParticularColumns {

    #  This function imports the csv file, keeps certain columns, and saves it as another csv file.

         Import-Csv $importedFile19 |`
     
         Select-Object -Property 'District Code', `
            'School Code', `
            'PAsecureID', `
            'Student Last Name', `
            'Student First Name', `
            'Date of Birth', `
            'Educator ID (email)', `
            'Test Session Name', `
            'Content Area', `
            'Assessment', `
            'Mode', `
            'Begin Date', `
            'End Date', `
            'Local Student ID' |

         Export-Csv $exportedFile20 -NoTypeInformation;

    }

    function RemoveNonMathOrEnglishClasses {

        $c = @("Literacy","Mathematics")
        $csv = Import-Csv $importedFile21 |
        where {$_.'Content Area' -in $c} |
        convertto-csv -NoTypeInformation | %{$_-replace '"', ""} | out-file $exportedFile22  -fo -en ascii
        

    }

    function DeleteFiles {

        Remove-Item $importedFile3, $importedFile5, $importedFile7, $importedFile9, $importedFile11, $importedFile13, $importedFile15, $importedFile17, $importedFile19, $importedFile21;

    }


    if ( Test-Path $importedFile1 ) {

        (MoveFilesFromProsoftToCDT)
        (KeepAndAddParticularColumns)
        (KeepGrades3-5)
        (ReplaceSchoolCodesBasedOnArray)
        (CreateEmailAddress)
        (CreateTestSessionName)
        (CreateContentAreaAndAssessment)
        (PopulateModeBeginAndEndDate)
        (RemovePeriodsFromTestSessionName)
        (KeepParticularColumns)
        (RemoveNonMathOrEnglishClasses)
        (DeleteFiles)

        }

    else {

        Write-Host ("File " + $importedFile1 + " does not exist, exiting script now.");
        Start-Sleep 5

        }

}

    function CombineAllElementaryFiles {
    
        ($a = Get-Content DON-CDT-ElementaryTestSessions-Upload.csv)
        ($b = Get-Content MCK-CDT-ElementaryTestSessions-Upload.csv)
        ($c = Get-Content WIL-CDT-ElementaryTestSessions-Upload.csv)
 
        (Set-Content ALL-CDT-ElementaryTestSessions-Upload.csv –value $a, $b, $c)

        Remove-Item DON-CDT-ElementaryTestSessions-Upload.csv, MCK-CDT-ElementaryTestSessions-Upload.csv, WIL-CDT-ElementaryTestSessions-Upload.csv;

    }

    (CombineAllElementaryFiles)
