From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 18 Sep 2018 20:31:22 +0800
Subject: [PATCH 0/8] staging: erofs: error handing and more tracepoints
In-Reply-To: <20180918121413.GA499@kroah.com>
References: <1536936030-62362-1-git-send-email-gaoxiang25@huawei.com>
 <20180918111953.GA3585@kroah.com>
 <aab26d0e-f8dc-cc83-46eb-7a93a833eaae@huawei.com>
 <20180918121413.GA499@kroah.com>
Message-ID: <e940cdaf-faeb-7f60-b5ca-5f4d6af450be@huawei.com>

Hi Greg,

On 2018/9/18 20:14, Greg Kroah-Hartman wrote:
> On Tue, Sep 18, 2018@08:02:30PM +0800, Gao Xiang wrote:
>> Hi Greg,
>>
>> On 2018/9/18 19:19, Greg Kroah-Hartman wrote:
>>> On Fri, Sep 14, 2018@10:40:22PM +0800, Gao Xiang wrote:
>>>> In order to avoid conflicts with cleanup patches, Chao and I think
>>>> it is better to send reviewed preview patches in the erofs mailing list
>>>> to the community in time.
>>>>
>>>> So here is reviewed & tested patches right now, which clean up and
>>>> enhance the error handing and add some tracepoints for decompression.
>>>>
>>>> Note that in this patchset, bare use of 'unsigned' and NULL comparison are
>>>> also fixed compared with the preview patches according to the previous
>>>> discussion in the staging mailing list.
>>>
>>> I applied this, but I need to go delete it as this patch series adds a
>>> build warning to the system:
>>>
>>> In file included from drivers/staging/erofs/unzip_vle.h:16:0,
>>>                  from drivers/staging/erofs/unzip_vle.c:13:
>>> drivers/staging/erofs/unzip_vle.c: In function ?z_erofs_map_blocks_iter?:
>>> drivers/staging/erofs/internal.h:303:34: warning: ?pblk? may be used uninitialized in this function [-Wmaybe-uninitialized]
>>>  #define blknr_to_addr(nr)       ((erofs_off_t)(nr) * EROFS_BLKSIZ)
>>>                                   ^
>>> drivers/staging/erofs/unzip_vle.c:1574:20: note: ?pblk? was declared here
>>>   erofs_blk_t mblk, pblk;
>>>                     ^~~~
>>>
>>> Please fix that up and resend.
>>
>> strange... my compiler (4.8.4) and huawei internal CI don't report that,
>> and this patchset has been in Chao's tree for a while, I don't get any report so far...
>>
>> I just looked into that code again and it seems a false warning since
>> 1) this code is heavily running on the products and working fine till now.
>> 2) pblk gets a proper value before unzip_vle.c:1690 map->m_pa = blknr_to_addr(pblk);
>>
>> so I think I need to silence this warning for now and check if there is a really issue....
> 
> Don't just silent the warning.  Usually gcc now properly detects where
> there really is a problem, it should not be a false-positive.  And in
> looking at the code, it does seem that pblk could not be set if one of
> the different case statements is taken and then exact_hitted: is jumped
> to, right?

pblk is assigned before each "goto exact_hitted" and "break;" here.

1641         switch (cluster_type) {
1642         case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
1643                 if (ofs_rem >= logical_cluster_ofs)
1644                         map->m_flags ^= EROFS_MAP_ZIPPED;
1645                 /* fallthrough */
1646         case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
1647                 if (ofs_rem == logical_cluster_ofs) {
1648                         pblk = le32_to_cpu(di->di_u.blkaddr);
1649                         goto exact_hitted; <--- assigned
1650                 }
1651
1652                 if (ofs_rem > logical_cluster_ofs) {
1653                         ofs = (u64)lcn * clustersize | logical_cluster_ofs;
1654                         pblk = le32_to_cpu(di->di_u.blkaddr);
1655                         break; <--- assigned
1656                 }
1657
1658                 /* logical cluster number should be >= 1 */
1659                 if (unlikely(!lcn)) {
1660                         errln("invalid logical cluster 0 at nid %llu",
1661                                 EROFS_V(inode)->nid);
1662                         err = -EIO;
1663                         goto unmap_out;  <--- bypass no need it
1664                 }
1665                 end = ((u64)lcn-- * clustersize) | logical_cluster_ofs;
1666                 /* fallthrough */
1667         case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
1668                 /* get the correspoinding first chunk */
1669                 err = vle_get_logical_extent_head(&ctx, lcn, &ofs,
1670                                                   &pblk, &map->m_flags);
1671                 mpage = *mpage_ret;
1672
1673                 if (unlikely(err)) {
1674                         if (mpage)
1675                                 goto unmap_out; <--- bypass no need it
1676                         goto out;   <--- bypass no need it
1677                 }
1678                 break;           <-- pblk should be assigned in vle_get_logical_extent_head
                                          if no error occurred in vle_get_logical_extent_head
1679         default:
1680                 errln("unknown cluster type %u at offset %llu of nid %llu",
1681                         cluster_type, ofs, EROFS_V(inode)->nid);
1682                 err = -EIO;
1683                 goto unmap_out;   <-- bypass no need it
1684         }
1685
1686         map->m_la = ofs;
1687 exact_hitted:
1688         map->m_llen = end - ofs;
1689         map->m_plen = clustersize;
1690         map->m_pa = blknr_to_addr(pblk);   <--- pblk is used here
1691         map->m_flags |= EROFS_MAP_MAPPED;
1692 unmap_out:
1693         kunmap_atomic(kaddr);
1694         unlock_page(mpage);
1695 out:

and in vle_get_logical_extent_head
1493 static int
1494 vle_get_logical_extent_head(const struct vle_map_blocks_iter_ctx *ctx,
1495                             unsigned int lcn,   /* logical cluster number */
1496                             unsigned long long *ofs,
1497                             erofs_blk_t *pblk,
1498                             unsigned int *flags)
1499 {
1500         const unsigned int clustersize = 1 << ctx->clusterbits;
1501         const erofs_blk_t mblk = vle_extent_blkaddr(ctx->inode, lcn);
1502         struct page *mpage = *ctx->mpage_ret;   /* extent metapage */
1503
1504         struct z_erofs_vle_decompressed_index *di;
1505         unsigned int cluster_type, delta0;
1506
1507         if (mpage->index != mblk) {
1508                 kunmap_atomic(*ctx->kaddr_ret);
1509                 unlock_page(mpage);
1510                 put_page(mpage);
1511
1512                 mpage = erofs_get_meta_page(ctx->sb, mblk, false);
1513                 if (IS_ERR(mpage)) {
1514                         *ctx->mpage_ret = NULL;
1515                         return PTR_ERR(mpage);   <--- bypass pblk since err != 0
1516                 }
1517                 *ctx->mpage_ret = mpage;
1518                 *ctx->kaddr_ret = kmap_atomic(mpage);
1519         }
1520
1521         di = *ctx->kaddr_ret + vle_extent_blkoff(ctx->inode, lcn);
1522
1523         cluster_type = vle_cluster_type(di);
1524         switch (cluster_type) {
1525         case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
1526                 delta0 = le16_to_cpu(di->di_u.delta[0]);
1527                 if (unlikely(!delta0 || delta0 > lcn)) {
1528                         errln("invalid NONHEAD dl0 %u at lcn %u of nid %llu",
1529                               delta0, lcn, EROFS_V(ctx->inode)->nid);
1530                         DBG_BUGON(1);
1531                         return -EIO;   <--- bypass pblk since err != 0
1532                 }
1533                 return vle_get_logical_extent_head(ctx,
1534                         lcn - delta0, ofs, pblk, flags);  <---- recursive call (vle_get_logical_extent_head at most 2 times)
1535         case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
1536                 *flags ^= EROFS_MAP_ZIPPED;
1537                 /* fallthrough */
1538         case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
1539                 /* clustersize should be a power of two */
1540                 *ofs = ((u64)lcn << ctx->clusterbits) +
1541                         (le16_to_cpu(di->di_clusterofs) & (clustersize - 1));
1542                 *pblk = le32_to_cpu(di->di_u.blkaddr);
1543                 break;      <--- assigned
1544         default:
1545                 errln("unknown cluster type %u at lcn %u of nid %llu",
1546                       cluster_type, lcn, EROFS_V(ctx->inode)->nid);
1547                 DBG_BUGON(1);
1548                 return -EIO;   <--- bypass pblk since err != 0
1549         }
1550         return 0;
1551 }

(I have no clang environment to build kernel yet... :( I will try later, but I have no idea why it happens,
and it seems a false warning).

Thanks,
Gao Xiang

> 
> Or is gcc just being "dumb" here?  What about clang, have you tried
> building it with that compiler as well?
> 
> thanks,
> 
> greg k-h
> 
