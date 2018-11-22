From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 18:49:53 +0800
Subject: [PATCH 01/10] staging: erofs: fix `trace_erofs_readpage' position
In-Reply-To: <20181122101941.GC3189@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-2-gaoxiang25@huawei.com>
 <20181122101941.GC3189@kroah.com>
Message-ID: <fcf5c088-6025-171f-bc24-0e698c68bbb7@huawei.com>

Hi Greg,

On 2018/11/22 18:19, Greg Kroah-Hartman wrote:
> On Tue, Nov 20, 2018@10:34:16PM +0800, Gao Xiang wrote:
>> `trace_erofs_readpage' should be placed in .readpage()
>> rather than in the internal `z_erofs_do_read_page'.
> Why?  What happens with the code today?
trace_erofs_readpage is used to trace .readpage() interface (it represents sync read)
hook rather than its internal implementation z_erofs_do_read_page (which both .readpage()
and .readpages() uses it). Chen Gong places the tracepoint to a wrong place by mistake.
And we found it by our internal test using this tracepoint.

> 
>> Fixes: 284db12cfda3 ("staging: erofs: add trace points for reading zipped data")
> Should this get into 4.20-final?
I think so, which is not very important but I think it should be fixed...

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
