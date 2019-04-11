From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 11 Apr 2019 13:47:49 +0800
Subject: Some new bio merging behaviors in __bio_try_merge_page
Message-ID: <85c5fa1a-a506-e26f-c354-1554d47d8b2b@huawei.com>

Hi Ming,

I found a erofs issue after commit 07173c3ec276
("block: enable multipage bvecs") is merged. It seems that
it tries to merge more physical continuous pages in one iovec.

However it breaks the current erofs_read_raw_page logic since it uses
nr_iovecs of bio_alloc to limit the maximum number of physical
continuous blocks as well. It was practicable since the old
__bio_try_merge_page only tries to merge in the same page.
it is a kAPI behavior change which also affects bio_alloc...

...
231                 err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
232                 if (unlikely(err))
233                         goto err_out;
...
284                 /* max # of continuous pages */
285                 if (nblocks > DIV_ROUND_UP(map.m_plen, PAGE_SIZE))
286                         nblocks = DIV_ROUND_UP(map.m_plen, PAGE_SIZE);
287                 if (nblocks > BIO_MAX_PAGES)
288                         nblocks = BIO_MAX_PAGES;
289
290                 bio = erofs_grab_bio(sb, blknr, nblocks, sb,
291                                      read_endio, false);
292                 if (IS_ERR(bio)) {
293                         err = PTR_ERR(bio);
294                         bio = NULL;
295                         goto err_out;
296                 }
297         }
298
299         err = bio_add_page(bio, page, PAGE_SIZE, 0);
300         /* out of the extent or bio is full */
301         if (err < PAGE_SIZE)
302                 goto submit_bio_retry;
...

After commit 07173c3ec276 ("block: enable multipage bvecs"), erofs could
read more beyond what erofs_map_blocks assigns, and out-of-bound data could
be read and it breaks tail-end inline determination.

I can change the logic in erofs. However, out of curiosity, I have no idea
if some other places also are designed like this.

IMO, it's better to provide a total count which indicates how many real
pages have been added in this bio. some thoughts?

Thanks,
Gao Xiang
