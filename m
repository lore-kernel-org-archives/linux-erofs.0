From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 22 Nov 2018 18:56:32 +0800
Subject: [PATCH 05/10] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <20181122102230.GF3189@kroah.com>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-6-gaoxiang25@huawei.com>
 <20181122102230.GF3189@kroah.com>
Message-ID: <1d1fd688-0cb5-cbac-9213-f56f7e356bca@huawei.com>

Hi Greg,

On 2018/11/22 18:22, Greg Kroah-Hartman wrote:
> Please document this memory barrier.  It does not make much sense to
> me...

Because we need to make the other observers noticing the latest values modified
in this locking period before unfreezing the whole workgroup, one way is to use
a memory barrier and the other way is to use ACQUIRE and RELEASE. we selected
the first one.

Hmmm...ok, I will add a simple message to explain this, but I think that is
plain enough for a lock...

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
