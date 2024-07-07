foreach ($volumeMapping in $volumeMappings) {
    $deviceName = $volumeMapping.split(":")[0]
    $mountpoint = $volumeMapping.split(":")[1]

    $volumeInfo = aws ec2 describe-instances --query "Reservations[].Instances[].BlockDeviceMappings[?DeviceName == '$deviceName'].{DeviceName: DeviceName, VolumeID: Ebs.VolumeId}" | ConvertFrom-Json

    $volumeId = $volumeInfo[0].VolumeID
    $volumeId = $volumeId.replace("-", "")
    $serialNumber = $volumeid +"_00000001."
    $disk = (Get-Disk -SerialNumber $serialNumber).Number
    $diskpartitionstyle = (get-disk -SerialNumber $serialNumber).partitionstyle
    if ($diskpartitionstyle.equals("MBR")) {
        # Disk exists
        Write-Host "Disk $disk already initialized. Skipping initialization."
        Get-Partition -DiskNumber $disk | Where-Object { $_.DriveLetter -eq $mountpoint } | Set-Partition -NewDriveLetter $mountpoint
    }
    else {
        # Disk does not exist
        Initialize-Disk -PartitionStyle MBR -PassThru -Number $disk
        New-Partition -UseMaximumSize -DriveLetter "$mountpoint" -DiskNumber $disk
        Format-Volume -FileSystem NTFS -Confirm:$false -DriveLetter $mountpoint
    }
}