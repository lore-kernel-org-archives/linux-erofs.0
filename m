From: bluce.liguifu@huawei.com (liguifu (C))
Date: Wed, 1 Aug 2018 08:40:05 +0000
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggMDgvMTFdIGVyb2ZzOiBzdXBwb3J0IHNwZWNpYWwg?=
 =?utf-8?Q?inode?=
In-Reply-To: <c78b4103-e536-396e-dfa9-da307fd78058@huawei.com>
References: <20180622020131.65525-1-yuchao0@huawei.com>
 <20180622020131.65525-8-yuchao0@huawei.com>
 <10330ccf-3f96-b5dd-0de9-1aa986af47e6@huawei.com>
 <c2d24dcc-3dbf-7c9d-ffda-dc9b3dbe7a1e@kernel.org>
 <c78b4103-e536-396e-dfa9-da307fd78058@huawei.com>
Message-ID: <9156E5F840CEC74FB517F66C6FB59A33015789DA@dggemi525-mbx.china.huawei.com>

Hi 
# Test special device of erofs
we have test four special device, like char device, block device, pipe device and sock decive
using new_encode_dev to create device number in the image created by mkfs.erofs
specail devices node were created in the  Ubuntu 16.04 LTS 4.4.0-104-generic, 
the source codes is based on LDD3 source which coming from https://github.com/duxing2007/ldd3-examples-3.x/tree/origin/linux-4.4.y

Test char devices, block device, pipe device file
step 1, build ldd3 codes 
step 2, install scull.ko sbull.ko and make device node with mknod cmd 

$ cat  /proc/devices|grep scull
246 scull
246 scullp
246 sculla

$ cat  /proc/devices|grep sbull
251 sbull

create device file:
mknod scull0 c 246 0
mknod pipe0  c 246 4
mknod sbulla b 251 0

step 3, create sock device with custom tcp server and client test program which invoke socket.
        it will create a socket file.

step 4, create erofs image using mkfs.erofs
step 5, mount erofs image and test the device file

1) scull 
echo test > scull0, you will get it by input 
cat scull0
test

2) sbull is the same to scull

3) pipe0

(1) input cat pipe0 at a shell
(2) input echo test > pip0 at another shell
So you will recive test string displayed at the fisrt shell terminal screen

4) socket
because erofs is a read only file system , socket file will not be created at fisrt running 
socket file need unlink fisrtly and recreate by program 
otherwise we got lots of string output at terminal when running socket server program.

Tks
Li GuiFu

-----????-----
???: Gaoxiang (OS) 
????: 2018?8?1? 16:18
???: liguifu (C) <bluce.liguifu at huawei.com>
??: Yuchao (T) <yuchao0 at huawei.com>; linux-erofs at lists.ozlabs.org; Wangzhigang (Brooke) <brooke.wangzhigang at hisilicon.com>
??: Re: [PATCH 08/11] erofs: support special inode

Hi Guifu,

On 2018/7/3 21:48, Chao Yu wrote:
>> The other code looks fine for me,
>> I think a basic test is needed for the function of this patch tho.
> 
> Yeah, I hope Guifu will leave the time for testing the patch.

Could you please reply this email with some test results of this patch?

Thanks,
Gao Xiang
