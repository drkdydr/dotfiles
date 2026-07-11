# Defined via `source`
function lsblk --description 'alias lsblk lsblk -o NAME,FSTYPE,FSSIZE,FSUSED,FSUSE%,FSAVAIL,MOUNTPOINTS'
    command lsblk -o NAME,FSTYPE,FSSIZE,FSUSED,FSUSE%,FSAVAIL,MOUNTPOINTS $argv
end
