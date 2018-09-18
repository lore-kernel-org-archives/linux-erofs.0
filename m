From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Tue, 18 Sep 2018 16:36:05 +0200
Subject: [PATCH v2 0/8] staging: erofs: error handing and more tracepoints
In-Reply-To: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>
References: <1537280740-122019-1-git-send-email-gaoxiang25@huawei.com>
Message-ID: <20180918143605.GA19347@kroah.com>

On Tue, Sep 18, 2018@10:25:32PM +0800, Gao Xiang wrote:
> change log v2:
>   - fix a gcc warning reported by Greg for the patch
>         staging: erofs: clean up z_erofs_map_blocks_iter
> 
> 
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

Thanks for the resend, looks good.

greg k-h
