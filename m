From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 12 Sep 2018 16:33:53 +0800
Subject: [PATCH] Revert "staging: erofs: disable compiling temporarile"
In-Reply-To: <20180912173404.288ea2e5@canb.auug.org.au>
References: <1535427588-69630-1-git-send-email-gaoxiang25@huawei.com>
 <20180828054444.GA4453@kroah.com>
 <0c701b3c-5553-cf4c-c0b3-ad151b84662c@huawei.com>
 <f12ae5df-3130-f293-5863-3d9ff0802e92@huawei.com>
 <20180828130559.GA5427@kroah.com>
 <16974cb6-2eed-7c12-9e27-c65a32b81673@huawei.com>
 <20180829094403.3a3bf19b@canb.auug.org.au>
 <20180906092504.282d5f62@canb.auug.org.au>
 <58dbf050-ac24-9d8a-bbf3-0e28e10149ff@huawei.com>
 <20180912173404.288ea2e5@canb.auug.org.au>
Message-ID: <bdb3e07b-b769-34a4-28c9-630131db2c55@huawei.com>

Hi Stephen,

On 2018/9/12 15:34, Stephen Rothwell wrote:
> Hi Chao,
> 
> On Wed, 12 Sep 2018 15:19:16 +0800 Chao Yu <yuchao0@huawei.com> wrote:
>>
>> To make sure, did -next tree enable erofs compiling now?
> 
> Yes, from yesterday.

Great, thanks for your help. :)

> 
>> Xiang has made two patches to fix integration issue with other vfs changes,
>> and Greg and David have already picked them in their tree.
>>
>> staging: erofs: rename superblock flags (MS_xyz -> SB_xyz)
>> staging: erofs: update .mount and .remount_sb
> 
> I noticed, thanks.
> 
