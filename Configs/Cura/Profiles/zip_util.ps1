param([string]$source_dir="none",[string]$target_archive="target.zip")
$script_dir = split-path -parent $MyInvocation.MyCommand.Definition
add-type -assemblyname "System.IO.Compression.FileSystem"
[IO.Compression.ZipFile]::CreateFromDirectory($source_dir, $target_archive, [IO.Compression.CompressionLevel]::NoCompression, $false, [Text.Encoding]::UTF8)
if(!($?))
{
 write-host "faield to create archive $target_archive from $source_dir directory"
 exit 1
}
