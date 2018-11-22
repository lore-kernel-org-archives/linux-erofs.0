From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 11:19:41 +0100
Subject: [PATCH 01/10] staging: erofs: fix `trace_erofs_readpage' position
In-Reply-To: <20181120143425.43637-2-gaoxiang25@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-2-gaoxiang25@huawei.com>
Message-ID: <20181122101941.GC3189@kroah.com>

On Tue, Nov 20, 2018@10:34:16PM +0800, Gao Xiang wrote:
> `trace_erofs_readpage' should be placed in .readpage()
> rather than in the internal `z_erofs_do_read_page'.

Why?  What happens with the code today?

> 
> Fixes: 284db12cfda3 ("staging: erofs: add trace points for reading zipped data")

Should this get into 4.20-final?

thanks,

greg k-h
