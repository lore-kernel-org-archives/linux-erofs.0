From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 28 Aug 2018 07:44:44 +0200
Subject: [PATCH] Revert "staging: erofs: disable compiling temporarile"
In-Reply-To: <1535427588-69630-1-git-send-email-gaoxiang25@huawei.com>
References: <1535427588-69630-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <20180828054444.GA4453@kroah.com>

On Tue, Aug 28, 2018@11:39:48AM +0800, Gao Xiang wrote:
> This reverts commit 156c3df8d4db4e693c062978186f44079413d74d.
> 
> Since XArray and the new mount apis aren't merged in 4.19-rc1
> merge window, the BROKEN mark can be reverted directly without
> any problems.
> 
> Fixes: 156c3df8d4db ("staging: erofs: disable compiling temporarile")
> Cc: Matthew Wilcox <willy at infradead.org>
> Cc: David Howells <dhowells at redhat.com>
> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
> ---
> 
> Hi Greg,
> 
>  Could you please apply this patch to enable EROFS from 4.19-rc2, thanks...
> 
>  p.s. We would like to provide a more stable EROFS when linux-4.19 is out,
>       and there are also two patchsets (the one is already sent out by Chao
>       and me, the other is previewing in linux-erofs mailing list and it will
>       be sent out after gathering enough testdata and feedback from community
>       and carefully reviewed), could you also please consider applying these
>       two patchsets in the later 4.19-rc (both >2, or the first patchset
>       could be in rc2 in advance) if it is convenient to do so, or the next
>       4.20 is also ok...
> 
>  LINK: https://lore.kernel.org/lkml/20180821144937.20555-1-chao at kernel.org/
>        https://lore.kernel.org/lkml/1535076160-99466-1-git-send-email-gaoxiang25 at huawei.com/

I applied those patch sets to my -next branch already, right?  So those
would be going into 4.20-rc1, it is time now for "bugfixes only" for
4.19-final.

So perhaps we should just leave it as "BROKEN" for now for 4.19 and add
this to my tree now and let people work on it for the next few months in
linux-next so that 4.20 has a solid base to start with?

thanks,

greg k-h
