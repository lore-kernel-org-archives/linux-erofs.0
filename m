From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 27 Aug 2018 15:14:40 +0800
Subject: EROFS filesystem testdata (part I)
In-Reply-To: <5765b7d8-b3f4-4448-baa6-c28fe61ac8a5@huawei.com>
References: <5765b7d8-b3f4-4448-baa6-c28fe61ac8a5@huawei.com>
Message-ID: <14d6f15c-c36f-4e43-1e6d-9cb035d18a31@huawei.com>



On 2018/8/27 14:57, Gao Xiang wrote:
> Test environment: HUAWEI R&D cloud (Intel(R) Xeon(R) CPU E5-2690 v2 @ 3.00GHz * 8, 16GB RAM, Magnetic storage)
>                   and tested in QEMU Virtual machine configured with -smp 4 -m 512M
> 
> Linux kernel version:
>  4.19 rc1

p.s. tested with CONFIG_EROFS_FS_ZIP_CACHE_BIPOLAR=y (which is the default option) and read_ahead_kb is 128.
It could be lower memory usage if erofs is configured with CONFIG_EROFS_FS_ZIP_NO_CACHE=y.

Thanks,
Gao Xiang
