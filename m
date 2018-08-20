From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 20 Aug 2018 14:13:53 +0800
Subject: =?UTF-8?Q?Re:_=e7=ad=94=e5=a4=8d:_[PREVIEW]_[PATCH]_staging:_erofs:?=
 =?UTF-8?Q?_add_trace_points_for_reading_zipped_data?=
In-Reply-To: <780FCA0995E39E408348187D2462E36A014F9315@DGGEML529-MBS.china.huawei.com>
References: <1534419216-47694-1-git-send-email-gongchen4@huawei.com>
 <f38a07f2-5441-1679-d847-1c7edf544f7b@huawei.com>
 <780FCA0995E39E408348187D2462E36A014F9315@DGGEML529-MBS.china.huawei.com>
Message-ID: <adaba4b3-db46-ce0a-fe55-36e88aa390e7@huawei.com>

Hi Chen,

On 2018/8/20 10:52, gongchen (E) wrote:
> Hi Xiang,
> 
> Thanks, I  will change the "Z" flag to "NULL". 
> 
> Hi Chao,
> 
> Do you have any other suggestions?  Thanks.

It needs to do cleanup as Xiang's suggestion, otherwise it looks good to me. ;)

You can add my Reviewed-by tag in v2.

Thanks,

> 
> 
> -----????-----
> ??: Re: [PREVIEW] [PATCH] staging: erofs: add trace points for reading zipped data
> 
> Hi Chen,
> 
> On 2018/8/16 19:33, Chen Gong wrote:
>> This patch adds trace points for reading zipped data.
>>
>> Signed-off-by: Chen Gong <gongchen4 at huawei.com>
>> ---
>>  drivers/staging/erofs/include/trace/events/erofs.h | 20 ++++++++++++++++++--
>>  drivers/staging/erofs/unzip_vle.c                  | 10 ++++++++++
>>  2 files changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/erofs/include/trace/events/erofs.h 
>> b/drivers/staging/erofs/include/trace/events/erofs.h
>> index 5aead93..53045de 100644
>> --- a/drivers/staging/erofs/include/trace/events/erofs.h
>> +++ b/drivers/staging/erofs/include/trace/events/erofs.h
>> @@ -162,7 +162,8 @@
>>  
>>  	TP_printk("dev = (%d,%d), nid = %llu, la %llu llen %llu flags %s",
>>  		  show_dev_nid(__entry),
>> -		  __entry->la, __entry->llen, show_map_flags(__entry->flags))
>> +		  __entry->la, __entry->llen,
>> +		  __entry->flags ? show_map_flags(__entry->flags) : "Z")
> 
> I personally tend to use
> __entry->flags ? show_map_flags(__entry->flags) : "(default)"
> or
> __entry->flags ? show_map_flags(__entry->flags) : "(null)"
> here, since no flag doesn't only mean ZIPPED or something else.
> 
>>  );
>>  
>>  DEFINE_EVENT(erofs__map_blocks_enter, 
>> erofs_map_blocks_flatmode_enter, @@ -172,6 +173,13 @@
>>  	TP_ARGS(inode, map, flags)
>>  );
>>  
>> +DEFINE_EVENT(erofs__map_blocks_enter, z_erofs_map_blocks_iter_enter,
>> +	TP_PROTO(struct inode *inode, struct erofs_map_blocks *map,
>> +		 unsigned flags),
>> +
>> +	TP_ARGS(inode, map, flags)
>> +);
>> +
>>  DECLARE_EVENT_CLASS(erofs__map_blocks_exit,
>>  	TP_PROTO(struct inode *inode, struct erofs_map_blocks *map,
>>  		 unsigned int flags, int ret),
>> @@ -204,7 +212,8 @@
>>  
>>  	TP_printk("dev = (%d,%d), nid = %llu, flags %s "
>>  		  "la %llu pa %llu llen %llu plen %llu mflags %s ret %d",
>> -		  show_dev_nid(__entry), show_map_flags(__entry->flags),
>> +		  show_dev_nid(__entry),
>> +		  __entry->flags ? show_map_flags(__entry->flags) : "Z",
> 
> ditto.
> 
> Thanks,
> Gao Xiang
> 
>>  		  __entry->la, __entry->pa, __entry->llen, __entry->plen,
>>  		  show_mflags(__entry->mflags), __entry->ret)  ); @@ -216,6 +225,13 
>> @@
>>  	TP_ARGS(inode, map, flags, ret)
>>  );
>>  
>> +DEFINE_EVENT(erofs__map_blocks_exit, z_erofs_map_blocks_iter_exit,
>> +	TP_PROTO(struct inode *inode, struct erofs_map_blocks *map,
>> +		 unsigned flags, int ret),
>> +
>> +	TP_ARGS(inode, map, flags, ret)
>> +);
>> +
>>  TRACE_EVENT(erofs_destroy_inode,
>>  	TP_PROTO(struct inode *inode),
>>  
>> diff --git a/drivers/staging/erofs/unzip_vle.c 
>> b/drivers/staging/erofs/unzip_vle.c
>> index 6e5c24d..3a87eee 100644
>> --- a/drivers/staging/erofs/unzip_vle.c
>> +++ b/drivers/staging/erofs/unzip_vle.c
>> @@ -13,6 +13,8 @@
>>  #include "unzip_vle.h"
>>  #include <linux/prefetch.h>
>>  
>> +#include <trace/events/erofs.h>
>> +
>>  static struct workqueue_struct *z_erofs_workqueue __read_mostly;  
>> static struct kmem_cache *z_erofs_workgroup_cachep __read_mostly;
>>  
>> @@ -613,6 +615,8 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
>>  	unsigned cur, end, spiltted, index;
>>  	int err = 0;
>>  
>> +	trace_erofs_readpage(page, false);
>> +
>>  	/* register locked file pages as online pages in pack */
>>  	z_erofs_onlinepage_init(page);
>>  
>> @@ -1347,6 +1351,8 @@ static inline int __z_erofs_vle_normalaccess_readpages(
>>  	struct page *head = NULL;
>>  	LIST_HEAD(pagepool);
>>  
>> +	trace_erofs_readpages(mapping->host, lru_to_page(pages), nr_pages, 
>> +false);
>> +
>>  #if (EROFS_FS_ZIP_CACHE_LVL >= 2)
>>  	f.cachedzone_la = lru_to_page(pages)->index << PAGE_SHIFT;  #endif 
>> @@ -1569,6 +1575,8 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>>  	unsigned int cluster_type, logical_cluster_ofs;
>>  	int err = 0;
>>  
>> +	trace_z_erofs_map_blocks_iter_enter(inode, map, flags);
>> +
>>  	/* when trying to read beyond EOF, leave it unmapped */
>>  	if (unlikely(map->m_la >= inode->i_size)) {
>>  		DBG_BUGON(!initial);
>> @@ -1687,6 +1695,8 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>>  		__func__, map->m_la, map->m_pa,
>>  		map->m_llen, map->m_plen, map->m_flags);
>>  
>> +	trace_z_erofs_map_blocks_iter_exit(inode, map, flags, err);
>> +
>>  	/* aggressively BUG_ON iff CONFIG_EROFS_FS_DEBUG is on */
>>  	DBG_BUGON(err < 0 && err != -ENOMEM);
>>  	return err;
>>
