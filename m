From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 6 Sep 2018 18:37:37 +0800
Subject: [PATCH 1/2 dhowells/mount-api] staging: erofs: rename superblock
 flags (MS_xyz -> SB_xyz)
In-Reply-To: <17402.1536228489@warthog.procyon.org.uk>
References: <1536224508-66168-1-git-send-email-gaoxiang25@huawei.com>
 <17402.1536228489@warthog.procyon.org.uk>
Message-ID: <1643231b-7538-0f43-1670-7fddadd7ca87@huawei.com>



On 2018/9/6 18:08, David Howells wrote:
> Gao Xiang <gaoxiang25@huawei.com> wrote:
> 
>> This patch follows commit 1751e8a6cb93 ("Rename superblock
>> flags (MS_xyz -> SB_xyz)") and after commit ("vfs: Suppress
>> MS_* flag defs within the kernel unless explicitly enabled"),
>> there is no MS_RDONLY and MS_NOATIME at all.
>>
>> Reported-by: Stephen Rothwell <sfr at canb.auug.org.au>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> I recommend pushing this one to Linus now.  It's trivial enough.

Hi David,
I personally think that is fine, but I'd like to get Greg's idea and agreement, too...

> 
> Reviewed-by: David Howells <dhowells at redhat.com>

Hi Greg,

As David suggested above, could you please help merge this patch to Linus?
It's trivial enough (since the commit 1751e8a6cb93) and MS_xyz will be removed
in the new mount apis patchset...

Thanks in advance...

Thanks,
Gao Xiang
