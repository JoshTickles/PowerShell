<# 

Version 1.5.abcdefg

Developed by : Josh and Conan
 
Change Log

1.0.abcdefg - created inistal script to export CSV's
1.1.abcdefg - added filter for non teachers
1.2.abcdefg - clean up empty spaces and added/adjusted # comments
1.3 abcdefg - remove extra "-" in SIS ID's, Section ID's
1.4.abcdefg - pull ll json in folder and then remove json after run
1.5.abcdefg - created sds.ps1 to copy latest json to upload folder and changed output csv folder to upload

#>

## Load data Source

$json = Get-Content -Raw .\upload\*.json | ConvertFrom-Json

## Set SIS ID and School name

$sisid = 'MAGS'
$schoolname = 'Mount Albert Grammer'

## Set Year

$year = get-date -Format yyyy

## Student CSV
## Headers - SIS ID, School SIS ID, Username

## Create Empty Array

$studentarray =@()

## Pull Data and Insert into Object

foreach($id in $json.SMSDirectoryData.students.data) {
	        
            ## Create Student Object and Add to Array

            $studentobj = New-Object PSObject -Property @{
                      
                    Username = "$($id.username)"
                    'School SIS ID' = $sisid
                    'SIS ID' = "$($id.id)"
                    } | Select 'SIS ID','School SIS ID',Username
            
            $studentarray += $studentobj  
} 

## Export to CSV

$studentarray | Export-CSV .\upload\student.csv -NoTypeInformation

## Teacher CSV
## Headers - SIS ID, School SIS ID, Username

## Create Empty Array

$teacherarray =@()

## Pull Data and Insert into Object

foreach($tusername in $json.SMSDirectoryData.staff.data) {

            ## Pull MOE Number
            
            $moe = $tusername.moenumber
            
            ## Create Teacher Object and Add to Array
            
            $teacherobj = New-Object PSObject -Property @{
                      
                    Username = "$($tusername.username)"
                    'School SIS ID' = $sisid
                    'SIS ID' = "$($tusername.id)"
                    } | Select 'SIS ID','School SIS ID',Username
            
            ## Filter Non MOE Number
            
            if($moe -notlike ''){
                $teacherarray += $teacherobj
        }
}

## Export to CSV

$teacherarray | Export-CSV .\upload\teacher.csv -NoTypeInformation

## School CSV
## Headers - SIS ID, Name

## Create School Details Object

$schoolobj = New-Object PSObject -Property @{
                      
                    Name = $schoolname
                    'SIS ID' = $sisid
                    } | Select 'SIS ID',Name

## Export to CSV

$schoolobj | Export-CSV .\upload\school.csv -NoTypeInformation

## Section CSV
## Headers - SIS ID, School SIS ID, Section Name

## Create Empty Array

$sectionarray =@()

## Pull Data and Insert into Object

foreach($section in $json.SMSDirectoryData.students.data.groups) {
	
            ## Create Section Object and Add to Array

            $sectionobj = New-Object PSObject -Property @{
                      
                    'Section Name' = "$year-$($section.coreoption)-$($section.subject)"
                    'School SIS ID' = $sisid
                    'SIS ID' = "$year$($section.coreoption -replace '-','')$($section.subject)"
                    } | Select 'SIS ID','School SIS ID','Section Name'
            
            $sectionarray += $sectionobj
}

## Export to CSV

$sectionarray | where {$_."SIS ID" -ne "2019"} | Export-CSV .\upload\section.csv -NoTypeInformation

## Remove Duplicates

$input = '.\upload\section.csv'
$inputCsv = Import-Csv $input | Sort-Object * -Unique
$inputCsv | Export-Csv ".\upload\section.csv" -NoTypeInformation

## Student Enrollment CSV
## Headers - Section SIS ID, SIS ID

## Create Empty Array

$studentearray = @()

## Pull Data and Insert into Object

foreach($student in $json.SMSDirectoryData.students.data) {
    
            ## Create Student Object and Add to Array
            
            foreach($group in $student.groups) {
    
                $lineitem = New-Object PSObject -Property @{
                'Section SIS ID' = "$year$($group.coreoption -replace '-','')$($group.subject)"
                'SIS ID' = "$($student.id)"
                } | Select 'Section SIS ID','SIS ID'

                ## Add if have Class
            
                if($group.type -eq "class"){
                    $studentearray += $lineitem
        }                                    
    }                                  
}

## Export to CSV

$studentearray | Export-CSV .\upload\studentenrollment.csv -NoTypeInformation

## Teacher Roster CSV
## Headers - Section SIS ID, SIS ID

## Create Empty Array

$teacherrarray = @()

## Pull Data and Insert into Object

foreach($teacher in $json.SMSDirectoryData.staff.data) {
    
        ## Create Teacher Object and Add to Array
    
            foreach($group in $teacher.groups) {
    
                $lineitem = New-Object PSObject -Property @{
                'Section SIS ID' = "$year$($group.coreoption -replace '-','')$($group.subject)"
                'SIS ID' = "$($teacher.id)"
                } | Select 'Section SIS ID','SIS ID'

        ## Add if have Class
        
            if($group.type -eq "class"){
                $teacherrarray += $lineitem
        }                                      
    }                                      
}

## Export to CSV

$teacherrarray | Export-CSV .\upload\teacherroster.csv -NoTypeInformation

Remove-Item .\upload\*.json