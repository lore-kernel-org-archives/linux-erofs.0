From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 8 Oct 2018 22:36:39 +0800
Subject: [PATCH v2] staging: erofs: add SPDX identifer
In-Reply-To: <20181008142228.GB13359@kroah.com>
References: <20181008141409.2624-1-loic.tourlonias.lkml@gmail.com>
 <20181008142228.GB13359@kroah.com>
Message-ID: <e9620bf6-5f3f-108d-b9f1-91af1ad603d6@huawei.com>

Hi Greg,

On 2018/10/8 22:22, Greg Kroah-Hartman wrote:
> Why delete that line?
> 
> But wait, why do we even have this file at all?  What's wrong with the
> lib/lz4/ code that we have in the kernel today?  Shouldn't the code
> using these files be moved over to use the lib/ code instead and this
> file be deleted?

EROFS uses customized LZ4 decompression code for now (which has been offically
supported in lz4 1.8.3, I have updated it in
https://ozlabs.org/~akpm/mmots/broken-out/lib-lz4-update-lz4-decompressor-module.patch
if it is shown up in Linux 4.20, I will remove all the customized LZ4 decompression code),
but lib/ code lz4def.h isn't export to include/.

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
