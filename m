From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 29 Jan 2019 16:53:06 +0800
Subject: [PATCH v4 2/2] staging: erofs: complete POSIX ACL support
In-Reply-To: <20190129084320.GN1795@kadam>
References: <20190129083520.28607-1-gaoxiang25@huawei.com>
 <20190129083520.28607-2-gaoxiang25@huawei.com> <20190129084320.GN1795@kadam>
Message-ID: <acf57850-cf3f-76e3-5d61-6720dd1af5c4@huawei.com>



On 2019/1/29 16:43, Dan Carpenter wrote:
> On Tue, Jan 29, 2019@04:35:20PM +0800, Gao Xiang wrote:
>> Let's add .get_acl() to read the file's acl from its xattrs
>> to make POSIX ACL usable.
>>
>> Here is the on-disk detail,
>> fullname: system.posix_acl_access
>> struct erofs_xattr_entry:
>>         .e_name_len = 0
>>         .e_name_index = EROFS_XATTR_INDEX_POSIX_ACL_ACCESS (2)
>>
>> fullname: system.posix_acl_default
>> struct erofs_xattr_entry:
>> 	.e_name_len = 0
>> 	.e_name_index = EROFS_XATTR_INDEX_POSIX_ACL_DEFAULT (3)
>>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> ---
>> change log v4:
>>  - leave kmalloc and wait the conclusion of fault injection
>>    pointed out by Dan Carpenter;
> 
> I do think this is the right thing, but I also wasn't going to ask you
> do redo v3.  Anyway, thanks!
> 
> regards,
> dan carpenter

OK, let's wait the Chao's idea then...

Thanks,
Gao Xiang

> 
