# Use the following Commands to extend EC2 instance EBS Storage

1. Check your storage
```
root@ip-172-31-25-53:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
udev             15G     0   15G   0% /dev
tmpfs           3.0G  305M  2.7G  11% /run
/dev/xvda1       95G   57G   39G  60% /
tmpfs            15G     0   15G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs            15G     0   15G   0% /sys/fs/cgroup
/dev/loop0       33M   33M     0 100% /snap/amazon-ssm-agent/2996
/dev/loop2       56M   56M     0 100% /snap/core18/1944
/dev/loop1       56M   56M     0 100% /snap/core18/1988
/dev/loop6       34M   34M     0 100% /snap/amazon-ssm-agent/3552
/dev/loop5      100M  100M     0 100% /snap/core/10859
/dev/loop4      100M  100M     0 100% /snap/core/10908
tmpfs           3.0G     0  3.0G   0% /run/user/1000

```

2. Check your Storage Mount
```
root@ip-172-31-25-53:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   98G  0 disk
└─xvda1 202:1    0   98G  0 part /
loop0     7:0    0 32.3M  1 loop /snap/amazon-ssm-agent/2996
loop1     7:1    0 55.5M  1 loop /snap/core18/1988
loop2     7:2    0 55.4M  1 loop /snap/core18/1944
loop4     7:4    0 99.2M  1 loop /snap/core/10908
loop5     7:5    0 99.2M  1 loop /snap/core/10859
loop6     7:6    0 33.3M  1 loop /snap/amazon-ssm-agent/3552
```

3. If you notice from the commands above,

```
/dev/xvda1       95G   57G   39G  60%
```
/dev/svda1 is 60% utilized with total size 95GB and Free Space with 39GB.

We would now like to increase the storage from 95GB(Actuall 100GB) to 150GB. 

### Once you have all the details above. As step1. Goto your EC2 instance on AWS Management Console and select the volume and Modify the storage size. 

1. Select the Volume and Modify the storage size. 

![StorageVolume1](/Images/StorageVolume1.png)

![StorageVolume2](/Images/StorageVolume2.png)

![StorageVolume3](/Images/StorageVolume3.png)

![StorageVolume4](/Images/StorageVolume4.png)

![StorageVolume5](/Images/StorageVolume5.png)

![StorageVolume6](/Images/StorageVolume6.png)

2. Check lsblk commmand to check if step1 has worked fine from the server.

```
root@ip-172-31-25-53:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  150G  0 disk
**└─xvda1 202:1    0   98G**  0 part /
loop0     7:0    0 32.3M  1 loop /snap/amazon-ssm-agent/2996
loop1     7:1    0 55.5M  1 loop /snap/core18/1988
loop2     7:2    0 55.4M  1 loop /snap/core18/1944
loop4     7:4    0 99.2M  1 loop /snap/core/10908
loop5     7:5    0 99.2M  1 loop /snap/core/10859
loop6     7:6    0 33.3M  1 loop /snap/amazon-ssm-agent/3552
```

3. Now execute the command below to extend the volume and then check lsblk to make sure that it has extended the volume.

```
root@ip-172-31-25-53:~# growpart /dev/xvda 1
CHANGED: partition=1 start=2048 old: size=205518815 end=205520863 new: size=314570719,end=314572767
root@ip-172-31-25-53:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  150G  0 disk
**└─xvda1 202:1    0  150G**  0 part /
loop0     7:0    0 32.3M  1 loop /snap/amazon-ssm-agent/2996
loop1     7:1    0 55.5M  1 loop /snap/core18/1988
loop2     7:2    0 55.4M  1 loop /snap/core18/1944
loop4     7:4    0 99.2M  1 loop /snap/core/10908
loop5     7:5    0 99.2M  1 loop /snap/core/10859
loop6     7:6    0 33.3M  1 loop /snap/amazon-ssm-agent/3552
```
4. Check if the changes are now available at disk level. Changes are still not available at disk level.

```
root@ip-172-31-25-53:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
udev             15G     0   15G   0% /dev
tmpfs           3.0G  305M  2.7G  11% /run
**/dev/xvda1       95G   57G   39G  60% /**
tmpfs            15G     0   15G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs            15G     0   15G   0% /sys/fs/cgroup
/dev/loop0       33M   33M     0 100% /snap/amazon-ssm-agent/2996
/dev/loop2       56M   56M     0 100% /snap/core18/1944
/dev/loop1       56M   56M     0 100% /snap/core18/1988
/dev/loop6       34M   34M     0 100% /snap/amazon-ssm-agent/3552
/dev/loop5      100M  100M     0 100% /snap/core/10859
/dev/loop4      100M  100M     0 100% /snap/core/10908
tmpfs           3.0G     0  3.0G   0% /run/user/1000
```
5. To migrate the changes to disk, check the type of disk and execute the command specific to disk type

Check the type of Disk. 
```
root@ip-172-31-25-53:~# lsblk -f
NAME    FSTYPE   LABEL           UUID                                 MOUNTPOINT
xvda
└─xvda1 --ext4--     cloudimg-rootfs 9539c956-fc21-4e4f-973e-9d2ec8f3846c /
loop0   squashfs                                                      /snap/amazon-ssm-agent/2996
loop1   squashfs                                                      /snap/core18/1988
loop2   squashfs                                                      /snap/core18/1944
loop4   squashfs                                                      /snap/core/10908
loop5   squashfs                                                      /snap/core/10859
loop6   squashfs                                                      /snap/amazon-ssm-agent/3552
```

Resize mount point. 
```
root@ip-172-31-25-53:~# **resize2fs /dev/xvda1**
resize2fs 1.42.13 (17-May-2015)
Filesystem at /dev/xvda1 is mounted on /; on-line resizing required
old_desc_blocks = 7, new_desc_blocks = 10
The filesystem on /dev/xvda1 is now 39321339 (4k) blocks long.

```

Check the mount points size increase.
```
root@ip-172-31-25-53:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
udev             15G     0   15G   0% /dev
tmpfs           3.0G  305M  2.7G  11% /run
/dev/xvda1      **146G**   57G   89G  40% /
tmpfs            15G     0   15G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs            15G     0   15G   0% /sys/fs/cgroup
/dev/loop0       33M   33M     0 100% /snap/amazon-ssm-agent/2996
/dev/loop2       56M   56M     0 100% /snap/core18/1944
/dev/loop1       56M   56M     0 100% /snap/core18/1988
/dev/loop6       34M   34M     0 100% /snap/amazon-ssm-agent/3552
/dev/loop5      100M  100M     0 100% /snap/core/10859
/dev/loop4      100M  100M     0 100% /snap/core/10908
tmpfs           3.0G     0  3.0G   0% /run/user/1000
```
