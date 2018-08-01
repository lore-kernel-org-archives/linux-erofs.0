From: gaoxiang25@huawei.com (Gao Xiang)
Date: Wed, 1 Aug 2018 17:19:55 +0800
Subject: [PATCH 1/2] staging: erofs: add the missing break in
 z_erofs_map_blocks_iter
In-Reply-To: <20180801090243.ah7lhj2h6hjtvn4a@mwanda>
References: <1532915461-2512-1-git-send-email-gaoxiang25@huawei.com>
 <1533105511-26197-1-git-send-email-gaoxiang25@huawei.com>
 <20180801090243.ah7lhj2h6hjtvn4a@mwanda>
Message-ID: <ea978a27-efd4-9d58-e4c0-f9d00420304f@huawei.com>

Hi Dan,

On 2018/8/1 17:02, Dan Carpenter wrote:
> On Wed, Aug 01, 2018@02:38:30PM +0800, Gao Xiang wrote:
>> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
>> index bd2d7a8..6d3ab31 100644
>> --- a/drivers/staging/erofs/unzip_vle.c
>> +++ b/drivers/staging/erofs/unzip_vle.c
>> @@ -1596,10 +1596,10 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>>  	cluster_type = vle_cluster_type(di);
>>  
>>  	switch (cluster_type) {
>> -	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
>> +	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:	/* fallthrough */
> This fallthrough comment is in the wrong place.  It should be at the end
> where the break would have been.  Like this:
> 
> 	switch (cluster_type) {
> 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
> 		frob();
> 		frob();
> 		frob();
> 		/* fallthrough */
> 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
> 		frob();
> 

I am sorry.. I will send a new patch.
Thanks for your reply...

Thanks,
Gao Xiang

> regards,
> dan carpenter
> 
