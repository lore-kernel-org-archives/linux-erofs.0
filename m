From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 18 Sep 2018 13:19:53 +0200
Subject: [PATCH 0/8] staging: erofs: error handing and more tracepoints
In-Reply-To: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
References: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <20180918111953.GA3585@kroah.com>

On Fri, Sep 14, 2018@10:40:22PM +0800, Gao Xiang wrote:
> In order to avoid conflicts with cleanup patches, Chao and I think
> it is better to send reviewed preview patches in the erofs mailing list
> to the community in time.
> 
> So here is reviewed & tested patches right now, which clean up and
> enhance the error handing and add some tracepoints for decompression.
> 
> Note that in this patchset, bare use of 'unsigned' and NULL comparison are
> also fixed compared with the preview patches according to the previous
> discussion in the staging mailing list.

I applied this, but I need to go delete it as this patch series adds a
build warning to the system:

In file included from drivers/staging/erofs/unzip_vle.h:16:0,
                 from drivers/staging/erofs/unzip_vle.c:13:
drivers/staging/erofs/unzip_vle.c: In function ?z_erofs_map_blocks_iter?:
drivers/staging/erofs/internal.h:303:34: warning: ?pblk? may be used uninitialized in this function [-Wmaybe-uninitialized]
 #define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
                                  ^
drivers/staging/erofs/unzip_vle.c:1574:20: note: ?pblk? was declared here
  erofs_blk_t mblk, pblk;
                    ^~~~

Please fix that up and resend.

thanks,

greg k-h
