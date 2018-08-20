<#
Preprocessor for Digispot II "Import from text file" module
v1.00 2018-08-18 Initial release
v1.01 2018-08-20 Some fixes. Requre PowerShell >2.0

Command line in import module settings:
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy bypass -command "\\your-root-server\ROOT\IMP_FORMATS\preproc.ps1"

Roman Ermakov r.ermakov@emg.fm
#>


param (
# Comment first two lines and uncomment las two lines for command-line test
    [Parameter(Position=0,Mandatory=$true)][string]$inputFile,
    [Parameter(Position=1,Mandatory=$true)][string]$outputFile
    #[Parameter(Position=0)][string]$inputFile = "DF180817.TXT",
    #[Parameter(Position=1)][string]$outputFile = "DF180817.out.TXT"
)

[string]$currentdir = Get-Location
$inputFile = Get-ChildItem -Path $inputFile
#$outputFile = $currentdir + "\" + $outputFile

if ($PSVersionTable.PSVersion.Major -le 3) {
    Write-Host "`n`nThis script requires PowerShell newer than 2.0`nPlease upgrade.`n"
    Break
}

$csvFile = $inputFile + ".csv.txt"
$utfFile = $inputFile + ".utf8.txt"

# HEADERS - Set columns headers here, we'll use it later for skip empty and select
# WIDTHS  - Set columns width here
$headers = 'Time','s1','s2','IDnumber','s','s4','s5','Dur','s6','Dur2','s8','s9','s10','s11','s12','s13','Date','Name'
$widths = @(5,     3,   1,   4,          8,   5,   4,   3,    1,   3,     5,   1,   2,    5,    1,    12,   8,     30)
<#
07:45.00N1330        77594    030 030NNFSP EP     0            20180817P_08_02/2018_#                
#>

# Converting source file from Windows-1251 to UTF8
[IO.File]::WriteAllText($utfFile,[IO.File]::ReadAllText($inputFile,[Text.Encoding]::GetEncoding('windows-1251')),[Text.Encoding]::GetEncoding('UTF-8'))

Get-Content $utfFile -Encoding UTF8 | ForEach-Object {
    $columns = @()                                                   # Each source line...
    $line = $_
    $pos = 0
    ForEach ($width in $widths) {
        $columns += $line.Substring($pos, $width).Trim()             # ...becomes an array.
        $pos += $width
    }
    [string]::Join(";",$columns)                                     # Joining array to string using ; as separator
} | Set-Content $csvFile -Encoding UTF8                            # Saving to temp file because
                                                                     # we need to reopen it again as CSV with headers
$array = Import-Csv $csvFile -Delim ';' -Header $headers -Encoding UTF8

# SKIP - Set condition for skip
$array = $array | Where-Object { $_.IDnumber -notlike "" }          # Skiping lines with empty IDNo

# SELECT - Select fields for output
$array | Select-Object Time,IDnumber,Dur,Date,Name |                     # Selecting meaningful fields
    Export-Csv -Path $csvFile -NoType -Delim ';' -Encoding UTF8           # Saving back to CSV as UTF8 -NoType
                                                                     # What else? Now we need little more PS magic
$array = Get-Content $csvFile -Encoding UTF8 | Select-Object -Skip 1 # 1. Removing first line with headers
$array.Replace('";"',";").TrimStart('"').TrimEnd('"') |              # 2. Stripping "" in CSV:
    Out-File $outputFile -Force -Confirm:$false -Encoding "UTF8"     # Saving output file

Remove-Item -Path $csvFile -Force                                          # and removing temp file
Remove-Item -Path $utfFile -Force