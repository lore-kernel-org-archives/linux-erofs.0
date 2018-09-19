From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 19 Sep 2018 23:22:24 +0800
Subject: [PATCH v4 0/3] staging: erofs: option validation for remount and
 some code cleanups
In-Reply-To: <20180919145346.9927-1-cgxu519@gmx.com>
References: <20180919145346.9927-1-cgxu519@gmx.com>
Message-ID: <97e148db-1ab9-a76f-414e-bbeaa1a24eda@aol.com>

Hi Chengguang,

On 2018/9/19 22:53, Chengguang Xu wrote:
> Hi Greg, Xiang
> 
> I rebased code on latest erofs-master branch and that branch
> has already merged the first patch in my previous patchset,
> so this time I only post rest 3 patches.

Great, at the most time Chao's erofs-master is the same as Greg's
staging tree (currently it is), but I personally think all patches
could be better directly based on the final staging tree if these
patches has no real/effective dependency with some submitted patches
but haven't been applied by Greg (p.s. it should be avoided as
much as possible because community guys could find something
important like the yesterday patches).

Once again, the detail information of branches is described in
  https://lists.ozlabs.org/listinfo/linux-erofs/

I have nothing more to say, good luck :)

Thanks,
Gao Xiang

> 
> Thanks,
> 
> --
> 
> This patch set mainly does option validation for remount and at
> the same time does related code cleanups. Currently when we call
> fault injection related code we have to surround it with macro
> CONFIG_EROFS_FAULT_INJECTION in every calling place, after this
> patch set we don't have to do that, so the code looks clean and
> more understandable.
> 
> v3->v4:
> - Rebase code on latest erofs-master branch in Chao's linux tree.
> - Fix checkpatch complains.
> 
> v2->v3:
> - Fold related patches to one patch.
> - Fix building issue.
> 
> v1->v2:
> Address Chao's comments:
> - Allow to set fault_injection=0.
> - Keep flag bit when setting fault_injection=0.
> - Show injection info in original place.
> - Rebase code on latest erofs branch in Chao's linux tree.
> - Fix building issue.
> 
> Chengguang Xu (3):
>   staging: erofs: code cleanup for option parsing of fault_injection
>   staging: erofs: code cleanup for erofs_show_options()
>   staging: erofs: option validation in remount
> 
>  drivers/staging/erofs/super.c | 73 +++++++++++++++++++++++++++--------
>  1 file changed, 57 insertions(+), 16 deletions(-)
> 
