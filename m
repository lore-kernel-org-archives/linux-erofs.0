From: pavel@denx.de (Pavel Machek)
Date: Tue, 13 Aug 2019 13:48:21 +0200
Subject: [PATCH v7 08/24] erofs: add namei functions
In-Reply-To: <20190813091326.84652-9-gaoxiang25@huawei.com>
References: <20190813091326.84652-1-gaoxiang25@huawei.com>
 <20190813091326.84652-9-gaoxiang25@huawei.com>
Message-ID: <20190813114821.GB11559@amd>

Hi!

> +	/*
> +	 * on-disk error, let's only BUG_ON in the debugging mode.
> +	 * otherwise, it will return 1 to just skip the invalid name
> +	 * and go on (in consideration of the lookup performance).
> +	 */
> +	DBG_BUGON(qd->name > qd->end);

I believe you should check for errors in non-debug mode, too.


> +			if (unlikely(!ndirents)) {
> +				DBG_BUGON(1);
> +				kunmap_atomic(de);
> +				put_page(page);
> +				page = ERR_PTR(-EIO);
> +				goto out;
> +			}

-EUCLEAN is right error code for corrupted filesystem. (And you
 probably want to print something to the syslog, too).

								Pavel
-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 181 bytes
Desc: Digital signature
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190813/b0bb8ba8/attachment.sig>
