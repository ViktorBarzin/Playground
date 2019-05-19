function Convert-BinaryToString {
 
   [CmdletBinding()] param (
 
      [string] $FilePath
 
   )
    $ByteArray = [System.IO.File]::ReadAllBytes($FilePath);
 
 
   if ($ByteArray) {
 
      $Base64String = [System.Convert]::ToBase64String($ByteArray);
 
   }
 
   else {
 
      throw '$ByteArray is $null.';
 
   }
 
   Write-Output -InputObject $Base64String;
 
}