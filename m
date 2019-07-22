From: sfr@canb.auug.org.au (Stephen Rothwell)
Date: Mon, 22 Jul 2019 13:26:16 +1000
Subject: [PATCH v3 01/24] erofs: add on-disk layout
In-Reply-To: <20190722025043.166344-2-gaoxiang25@huawei.com>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-2-gaoxiang25@huawei.com>
Message-ID: <20190722132616.60edd141@canb.auug.org.au>

Hi Gao,

On Mon, 22 Jul 2019 10:50:20 +0800 Gao Xiang <gaoxiang25@huawei.com> wrote:
>
> diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
> new file mode 100644
> index 000000000000..e418725abfd6
> --- /dev/null
> +++ b/fs/erofs/erofs_fs.h
> @@ -0,0 +1,316 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Apache-2.0 */

I think the preferred tag is now GPL-2.0-only (assuming that is what is
intended).

-- 
Cheers,
Stephen Rothwell
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 488 bytes
Desc: OpenPGP digital signature
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190722/1bb82ba3/attachment.sig>
