From: arshad.super@gmail.com (Arshad Hussain)
Date: Mon, 4 Mar 2019 15:36:49 +0530
Subject: [patch 1/1]erofs-utils:0001-Improve-README.patch
In-Reply-To: <71d5b48f-e445-d406-6c02-b148646d9aa6@aol.com>
References: <CAKsu7qwCnCTCESea+z6jZAKKSSZ5VFA7iWf10pwQ1=PY0VJEUA@mail.gmail.com>
 <979c9d18-952e-668d-e97d-4114d4ac2636@gmx.com>
 <53398e07-7816-f5b3-9228-36ce18067c44@aol.com>
 <EE08DA62-E709-466E-96EA-514CE7980A05@gmail.com>
 <71d5b48f-e445-d406-6c02-b148646d9aa6@aol.com>
Message-ID: <5D1B0990-3E4B-40E2-B5E6-B35A021FC20B@gmail.com>

Hi Gao Xiang,

On 03-Mar-2019,@9:18 pm, Gao Xiang <hsiangkao@aol.com> wrote:

> Hi Arshad,
> 
> On 2019/3/3 20:39, Arshad Hussain wrote:
>> Hi Gao Xiang,
>> 
>> I prepared the patch using format-patch. Wonder why that should be broken. Thanks anyway for accepting and applying!.
> 
> I have no idea as well, I tried in different way (eg, with 3-way merging...) but with no luck :(
> 
>> 
>> Presently, from the TODO list. I am trying to figure out the on disk layout of erofs in an attempt to prepare a document out of it.
>> Currently, I am just reverse engineering the structs to figure out. (This is for the no compress version). Do you have any
>> other docs you can upload to help out. ?
> 
> I have already prepared a Document and it will be in the linux-5.1. I think it can be checked out in the linux-next branch :)
> See: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/staging/erofs/Documentation/filesystems/erofs.txt
> 

I see. I will have a look at this. Secondly, I would take a look at xattr exit/fail path with is also in TODO.

>> 
>> Please do put out extensive TODO (I know you have it for erofs) for both erofs-utils(mkfs) and erofs so I can start contributing
> 
> OK, I will do that recently, for erofs-utils, I will submit a new framework in the near future.
> And I planned to start todevelop erofs-fuse to support old kernel / windows and other use... ;)

Excellent.  I would like to contribute. Do let me know.

Thanks
Arshad


> 
> Thanks,
> Gao Xiang
> 
>> 
>> Thanks,
>> Arshad
>> 
>> On 03-Mar-2019,@12:34 pm, Gao Xiang <hsiangkao@aol.com> wrote:
>> 
>>> Original patch seems broken. I apply it by hand with some minor changes...
>>> 
>>> From b6d8c8c6fa91a8ffa7c138578d6315b768372476 Mon Sep 17 00:00:00 2001
>>> From: Arshad Hussain <arshad.super at gmail.com>
>>> Date: Sun, 3 Mar 2019 14:46:44 +0800
>>> Subject: [PATCH] erofs-utils: improve README
>>> 
>>> This patch improves the build section and
>>> adds the example/specimen usage section in
>>> the README file.
>>> 
>>> Signed-off-by: Arshad Hussain <arshad.super at gmail.com>
>>> ---
>>> README | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>>> 1 file changed, 63 insertions(+), 3 deletions(-)
>>> 
>>> diff --git a/README b/README
>>> index 4e34159..9014268 100644
>>> --- a/README
>>> +++ b/README
>>> @@ -21,8 +21,14 @@ How to build with lz4 static library
>>> 	./configure --with-lz4=<lz4 install path>
>>> eg. if lz4 lib has been installed into fold of /usr/local/lib
>>> 	./configure --with-lz4=/usr/local/lib && make
>>> -Maybe you should run this first:
>>> -	./autogen.sh
>>> +On Fedora, static lz4 can be installed using:
>>> +	yum install lz4-static.x86_64
>>> +To build you should run this first:
>>> +	$ ./autogen.sh
>>> +	$ ./configure
>>> +	$ make
>>> +
>>> +mkfs.erofs binary will be generated under mkfs folder.
>>> 
>>> Usage:
>>> $ ./mkfs.erofs
>>> @@ -35,7 +41,61 @@ Usage:
>>> -d -- set debugging level <dbglvl>
>>> -z -- enable <compr_algri> compression (only lz4hc is supported)
>>> 
>>> - target path, source directory are both needed.
>>> + Target path, source directory are both needed.
>>> +
>>> +Specimen Usage:
>>> +1) Create a temporary Disk
>>> +$ dd if=/dev/zero of=erofs_disk bs=512 count=23000
>>> +
>>> +2) Create and populate source directory
>>> +$ mkdir -p srcd
>>> +
>>> +Our sample source directory contents
>>> +$ ls -ali srcd/
>>> +total 44
>>> +425555 drwxr-xr-x 2 root root  4096 Feb 23 06:55 .
>>> +425533 drwxr-xr-x 9 root root  4096 Feb 26 06:54 ..
>>> +422789 -rw-r--r-- 1 root root     0 Feb 22 14:52 ChangeLog
>>> ++422793 -rw-r--r-- 1 root root  3195 Feb 23 06:55 configure.ac
>>> ++422794 -rw-r--r-- 1 root root 25763 Feb 23 06:55 Makefile
>>> ++422796 -rw-r--r-- 1 root root  1879 Feb 23 06:55 README
>>> +
>>> +3) Run mkfs.erofs
>>> + ./mkfs/mkfs.erofs ./erofs_disk ./srcd/
>>> +        c_version:           [0.1   Feb 22 2019 14:13:38]
>>> +        c_img_path:          [./erofs_disk]
>>> +        c_src_path:          [/root/arshad/erofs-utils/srcd]
>>> +        c_dbg_lvl:           [       0]
>>> +        c_dry_run:           [       0]
>>> +        c_alg_name:          [    none]
>>> +        c_compr_maxsz:       [  921600]
>>> +        c_compr_lvl:         [       0]
>>> +        c_compr_boundary:    [     128]
>>> +        c_compr_ratio_limit: [     100]
>>> +
>>> +4) Load erofs.ko module
>>> +$ insmod drivers/staging/erofs/erofs.ko
>>> +
>>> +5) Mount erofs_disk image
>>> +$ mount -t erofs erofs_disk /mnt/vg1 -o loop
>>> +
>>> +6) Check FS type mount reports
>>> +$ mount | grep erofs
>>> +/root/arshad/erofs-utils/erofs_disk on /mnt/vg1 type erofs ro,relatime,user_xattr,acl)
>>> +
>>> +7) Check the contents of the mounted FS
>>> +$ ls -ali /mnt/vg1/
>>> +total 31
>>> +  4 -rw-r--r-- 1 root root     0 Feb 23 06:55 ChangeLog
>>> +896 -rw-r--r-- 1 root root  3195 Feb 23 06:55 configure.ac
>>> +  5 -rw-r--r-- 1 root root 25763 Feb 23 06:55 Makefile
>>> + 44 -rw-r--r-- 1 root root  1879 Feb 23 06:55 README
>>> +
>>> +8) Umount /mnt/vg1
>>> +$ umount /mnt/vg1
>>> +
>>> +9) Unload erofs module
>>> +$ rmmod erofs
>>> 
>>> To:
>>>  linux-erofs mailing list   <linux-erofs at lists.ozlabs.org>
>>> -- 
>>> 2.11.0
>>> 
>>> 
>>> On 2019/3/3 14:02, Gao Xiang wrote:
>>>> Hi Arshad,
>>>> 
>>>> On 2019/3/2 21:04, arshad hussain wrote:
>>>>> Hi,
>>>>> 
>>>>> This patch improves the build section and
>>>>> adds the example/specimen usage section in
>>>>> the README file.
>>>>> 
>>>>> Signed-off-by: Arshad Hussain <arshad.super at gmail.com>
>>>> 
>>>> 
>>>> Thanks for improving the mkfs README.
>>>> mkfs is now under refactoring in order to make it more clean and straight-forward,
>>>> yet its progress is somewhat slow.
>>>> 
>>>> Anyway, I will take this patch and thanks for your contributing :)
>>>> 
>>>> 
>>>> Thanks,
>>>> Gao Xiang
>>>> 
>>>> 
>>>>> ----
>>>>> # cat 0001-Improve-README.patch
>>>>> From a2aa7e7b8938f1190d1618a5dda9f5c32cf3215e Mon Sep 17 00:00:00 2001
>>>>> From: Arshad Hussain <arshad.super at gmail.com>
>>>>> Date: Tue, 26 Feb 2019 10:30:04 +0530
>>>>> Subject: [PATCH] Improve README
>>>>> 
>>>>> This patch improves the build section and
>>>>> adds the example/specimen usage section in
>>>>> the README file.
>>>>> ---
>>>>> README | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>>>>> 1 file changed, 63 insertions(+), 3 deletions(-)
>>>>> 
>>>>> diff --git a/README b/README
>>>>> index 4e34159..b5b605a 100644
>>>>> --- a/README
>>>>> +++ b/README
>>>>> @@ -21,8 +21,14 @@ How to build with lz4 static library
>>>>>       ./configure --with-lz4=<lz4 install path>
>>>>> eg. if lz4 lib has been installed into fold of /usr/local/lib
>>>>>       ./configure --with-lz4=/usr/local/lib && make
>>>>> -Maybe you should run this first:
>>>>> -       ./autogen.sh
>>>>> +On Fedora, static lz4 can be installed using:
>>>>> +       yum install lz4-static.x86_64
>>>>> +To build you should run this first:
>>>>> +       $ ./autogen.sh
>>>>> +       $ ./configure
>>>>> +       $ make
>>>>> +
>>>>> +mkfs.erofs binary will be generated under mkfs folder.
>>>>> 
>>>>> Usage:
>>>>> $ ./mkfs.erofs
>>>>> @@ -35,7 +41,61 @@ Usage:
>>>>> -d -- set debugging level <dbglvl>
>>>>> -z -- enable <compr_algri> compression (only lz4hc is supported)
>>>>> 
>>>>> - target path, source directory are both needed.
>>>>> + Target path, source directory are both needed.
>>>>> +
>>>>> +Specimen Usage:
>>>>> +Create a temporary Disk
>>>>> +$ dd if=/dev/zero of=erofs_disk bs=512 count=23000
>>>>> +
>>>>> +Create and populate source directory
>>>>> +$ mkdir -p srcd
>>>>> +
>>>>> +Our sample source directory contents
>>>>> +$ ls -ali srcd/
>>>>> +total 44
>>>>> +425555 drwxr-xr-x 2 root root  4096 Feb 23 06:55 .
>>>>> +425533 drwxr-xr-x 9 root root  4096 Feb 26 06:54 ..
>>>>> +422789 -rw-r--r-- 1 root root     0 Feb 22 14:52 ChangeLog
>>>>> +422793 -rw-r--r-- 1 root root  3195 Feb 23 06:55 configure.ac
>>>>> +422794 -rw-r--r-- 1 root root 25763 Feb 23 06:55 Makefile
>>>>> +422796 -rw-r--r-- 1 root root  1879 Feb 23 06:55 README
>>>>> +
>>>>> +Run mkfs.erofs
>>>>> +$ ./mkfs/mkfs.erofs ./erofs_disk ./srcd/
>>>>> +        c_version:           [0.1   Feb 22 2019 14:13:38]
>>>>> +        c_img_path:          [./erofs_disk]
>>>>> +        c_src_path:          [/root/arshad/erofs-utils/srcd]
>>>>> +        c_dbg_lvl:           [       0]
>>>>> +        c_dry_run:           [       0]
>>>>> +        c_alg_name:          [    none]
>>>>> +        c_compr_maxsz:       [  921600]
>>>>> +        c_compr_lvl:         [       0]
>>>>> +        c_compr_boundary:    [     128]
>>>>> +        c_compr_ratio_limit: [     100]
>>>>> +
>>>>> +Load erofs.ko module
>>>>> +$ insmod drivers/staging/erofs/erofs.ko
>>>>> +
>>>>> +Mount erofs_disk image
>>>>> +$ mount -t erofs erofs_disk /mnt/vg1 -o loop
>>>>> +
>>>>> +Check FS type mount reports
>>>>> +$ mount | grep erofs
>>>>> +/root/arshad/erofs-utils/erofs_disk on /mnt/vg1 type erofs
>>>>> (ro,relatime,user_xattr,acl)
>>>>> +
>>>>> +Check the contents of the mounted FS
>>>>> +$ ls -ali /mnt/vg1/
>>>>> +total 31
>>>>> +  4 -rw-r--r-- 1 root root     0 Feb 23 06:55 ChangeLog
>>>>> +896 -rw-r--r-- 1 root root  3195 Feb 23 06:55 configure.ac
>>>>> +  5 -rw-r--r-- 1 root root 25763 Feb 23 06:55 Makefile
>>>>> + 44 -rw-r--r-- 1 root root  1879 Feb 23 06:55 README
>>>>> +
>>>>> +Umount /mnt/vg1
>>>>> +$ umount /mnt/vg1
>>>>> +
>>>>> +Unload erofs module
>>>>> +$ rmmod erofs
>>>>> 
>>>>> To:
>>>>>  linux-erofs mailing list   <linux-erofs at lists.ozlabs.org>
>>>>> --
>>>>> 2.14.3
>> 
