From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 20:41:15 +0800
Subject: [PATCH 02/10] staging: erofs: fix race when the managed cache is
 enabled
In-Reply-To: <20181122122627.GC10212@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-3-gaoxiang25@huawei.com>
 <20181122101711.GA3189@kroah.com>
 <55aed87f-196e-9048-6aae-db09bc497664@huawei.com>
 <20181122110642.GE5287@kroah.com>
 <78f8bed5-5f7f-8ca6-5d7a-3a94a2062425@huawei.com>
 <20181122122627.GC10212@kroah.com>
Message-ID: <fa61d737-216e-c644-5d23-28d520182262@huawei.com>

Hi Greg,

On 2018/11/22 20:26, Greg Kroah-Hartman wrote:
> Ugh, every page?  Ok, nevermind, I take back my objections.  You all are
> crazy and need to do crazy things like this :)

...Do you have some idea about this? ... I think it is fairly normal... :(

We have a large number of managed workgroups, the current use case is the 4k compressed size,
each compressed page has a workgroup, but erofs also has reclaim paths to free them for low memory cases.

But since the structure (z_erofs_vle_workgroup, erofs_workgroup) is critical,
I need to make it as small as possible.

Thanks,
Gao Xiang
