From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Thu, 22 Nov 2018 12:00:44 +0100
Subject: [PATCH 01/10] staging: erofs: fix `trace_erofs_readpage' position
In-Reply-To: <fcf5c088-6025-171f-bc24-0e698c68bbb7@huawei.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-2-gaoxiang25@huawei.com>
 <20181122101941.GC3189@kroah.com>
 <fcf5c088-6025-171f-bc24-0e698c68bbb7@huawei.com>
Message-ID: <20181122110044.GA5287@kroah.com>

On Thu, Nov 22, 2018@06:49:53PM +0800, Gao Xiang wrote:
> Hi Greg,
> 
> On 2018/11/22 18:19, Greg Kroah-Hartman wrote:
> > On Tue, Nov 20, 2018@10:34:16PM +0800, Gao Xiang wrote:
> >> `trace_erofs_readpage' should be placed in .readpage()
> >> rather than in the internal `z_erofs_do_read_page'.
> > Why?  What happens with the code today?
> trace_erofs_readpage is used to trace .readpage() interface (it represents sync read)
> hook rather than its internal implementation z_erofs_do_read_page (which both .readpage()
> and .readpages() uses it). Chen Gong places the tracepoint to a wrong place by mistake.
> And we found it by our internal test using this tracepoint.

Ok, you should put this in the changelog text when you redo this series.

thanks,

greg k-h
