From: hsiangkao@aol.com (Gao Xiang)
Date: Fri, 31 Aug 2018 00:32:34 +0800
Subject: [PATCH 2/6] staging: erofs: formatting fix to NULL comparison
In-Reply-To: <747d9c74-02cd-fa39-9870-ae17dbddf366@aol.com>
References: <1535642042-5336-1-git-send-email-zemlyanoy@ispras.ru>
 <1535642042-5336-2-git-send-email-zemlyanoy@ispras.ru>
 <747d9c74-02cd-fa39-9870-ae17dbddf366@aol.com>
Message-ID: <44d6e603-fe1d-6853-c474-760c0a2ed4ec@aol.com>



On 2018/8/31 0:09, Gao Xiang via Linux-erofs wrote:
> Hi Pavel,
> 
> On 2018/8/30 23:13, Pavel Zemlyanoy wrote:
>> This patch does not change the logic, it only
>> corrects the formatting and checkpatch checks by
>> to NULL comparison.
>>
>> The patch fixes 5 checks of type:
>> "Comparison to NULL could be written".
>>
>> Signed-off-by: Pavel Zemlyanoy <zemlyanoy at ispras.ru>
> 
> Sorry about the late reply. I am on vacation now.
> 
> Personally, I use "== NULL" or "!= NULL" on purpose, since it is more 
> emphasized than the checkpatch.pl suggested way, and I tend to use the nullptr explicitly.
> 
> BTW, It seems other filesystems still use "== NULL" or "!= NULL" explicitly, too, eg:
> xfs, ext4, ext2, ocfs2, etc... You could 'grep' in the fs directory... 
> 
> Other commits look good for me at glance.
> 

p.s. I personally tend to drop this patch. :(

Here are bunch of 'NULL comparison' usages in xfs, eg.

...
./xfs_qm_syscalls.c:218:        if (ino == NULLFSINO)                                                                                                        ./xfs_qm_syscalls.c:747:                ASSERT(ip->i_udquot == NULL);                                                                                        ./xfs_qm_syscalls.c:748:                ASSERT(ip->i_gdquot == NULL);                                                                                        ./xfs_qm_syscalls.c:749:                ASSERT(ip->i_pdquot == NULL);                                                                                        ./xfs_quota.h:27:       ((XFS_IS_UQUOTA_ON(mp) && (ip)->i_udquot == NULL) || \                                                                               ./xfs_quota.h:28:        (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \                                                                               ./xfs_quota.h:29:        (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))                                                                                   ./xfs_quotaops.c:31:    if (!ip && ino == NULLFSINO)                                                                                                         ./xfs_reflink.c:213:    if (fbno == NULLAGBLOCK) {                                                                                                           ./xfs_reflink.c:652:    if (count == NULLFILEOFF)                                                                                                            ./xfs_reflink.c:1462:                   if (rbno == NULLAGBLOCK)                                                                                             ./xfs_rtalloc.c:836:                    if (bp == NULL) {                                                                                                    ./xfs_rtalloc.c:899:    if (mp->m_rtdev_targp == NULL || mp->m_rbmip == NULL ||                                                                              ./xfs_rtalloc.c:1165:   if (mp->m_rtdev_targp == NULL) {                                                                                                     ./xfs_rtalloc.c:1209:   if (sbp->sb_rbmino == NULLFSINO)                                                                                                     ./xfs_trans.c:185:                      ASSERT(tp->t_ticket == NULL);                                                                                        ./xfs_trans_ail.c:59:       (prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0) &&                                                                ./xfs_trans_ail.c:60:       (next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0))                                                                  ./xfs_trans_ail.c:65:   ASSERT(prev_lsn == NULLCOMMITLSN || XFS_LSN_CMP(prev_lsn, lsn) <= 0);                                                                ./xfs_trans_ail.c:66:   ASSERT(next_lsn == NULLCOMMITLSN || XFS_LSN_CMP(next_lsn, lsn) >= 0);                                                                ./xfs_trans_ail.c:475:          if (lip == NULL)                                                                                                             ./xfs_trans_buf.c:70:   ASSERT(bp->b_transp == NULL);                                                                                                        ./xfs_trans_buf.c:155:  if (bp == NULL) {                                                                                                                    ./xfs_trans_buf.c:187:  if (tp == NULL)                                                                                                                      ./xfs_trans_buf.c:207:  if (bp == NULL)                                                                                                                      ./xfs_trans_buf.c:350:  if (tp == NULL) {                                                                                                                    ./xfs_trans_buf.c:351:          ASSERT(bp->b_transp == NULL);                                                                                                ./xfs_trans_buf.c:495:  ASSERT(bp->b_iodone == NULL ||                                                                                                       ./xfs_trans_dquot.c:103:                        if (oqa[i].qt_dquot == NULL)                                                                                 ./xfs_trans_dquot.c:149:        if (tp->t_dqinfo == NULL)                                                                                                    ./xfs_trans_dquot.c:178:                if (qa[i].qt_dquot == NULL ||                                                                                        ./xfs_trans_dquot.c:205:        if (tp->t_dqinfo == NULL)                                                                                                    ./xfs_trans_dquot.c:213:        if (qtrx->qt_dquot == NULL)                                                                                                  ./xfs_trans_dquot.c:295:        if (q[1].qt_dquot == NULL) {                                                                                                 ./xfs_trans_dquot.c:332:                if (qa[0].qt_dquot == NULL)                                                                                          ./xfs_trans_dquot.c:346:                        if ((dqp = qtrx->qt_dquot) == NULL)                                                                          ./xfs_trans_dquot.c:519:                        if ((dqp = qtrx->qt_dquot) == NULL)                                                                          ./xfs_trans_dquot.c:757:        if (tp && tp->t_dqinfo == NULL)                                                                                              ./xfs_trans_inode.c:36: if (ip->i_itemp == NULL)                                                                                                             
...

And in ext4, eg.
...
./mballoc.c:2892:       if (ext4_free_data_cachep == NULL) {
./mballoc.c:3046:       BUG_ON(lg == NULL);
./mballoc.c:3286:       if (pa == NULL) {
./mballoc.c:3377:       if (cpa == NULL) {
./mballoc.c:3447:       if (lg == NULL)
./mballoc.c:3635:       if (pa == NULL)
./mballoc.c:3727:       BUG_ON(ext4_pspace_cachep == NULL);
./mballoc.c:3729:       if (pa == NULL)
./mballoc.c:3756:       BUG_ON(lg == NULL);
./mballoc.c:4637:       BUG_ON(e4b->bd_bitmap_page == NULL);
./mballoc.c:4638:       BUG_ON(e4b->bd_buddy_page == NULL);
./move_extent.c:34:     if (path[ext_depth(inode)].p_ext == NULL) {
./namei.c:874:  if (frames[0].bh == NULL)
./namei.c:879:          if (frames[i].bh == NULL)
./namei.c:1432:         if ((bh = bh_use[ra_ptr++]) == NULL)
./page-io.c:38: if (io_end_cachep == NULL)
./page-io.c:398:        if (io->io_bio == NULL) {
./readpage.c:242:               if (bio == NULL) {
./resize.c:200: if (flex_gd == NULL)
./resize.c:210: if (flex_gd->groups == NULL)
./resize.c:215: if (flex_gd->bg_flags == NULL)
./resize.c:265: BUG_ON(flex_gd->count == 0 || group_data == NULL);
./resize.c:1345:        BUG_ON(flex_gd->count == 0 || group_data == NULL);
./resize.c:2012:        if (flex_gd == NULL) {
./super.c:365:  return bdi->dev == NULL;
./super.c:596:  if (errno == -EROFS && journal_current_handle() == NULL && sb_rdonly(sb))
./super.c:1086: if (ext4_inode_cachep == NULL)
./super.c:4050: if (sbi->s_group_desc == NULL) {
./super.c:4617: if (bdev == NULL)
./super.c:5288: if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
./xattr.c:286:  if (name == NULL)
./xattr.c:1905:                 if (s->base == NULL)
./xattr.c:1948:         if (s->base == NULL)
./xattr.c:2665:         if (entry == NULL) {
./xattr.c:2666:                 if (small_entry == NULL)
./xattr.c:2804: if (*ea_inode_array == NULL) {
./xattr.c:2813:         if (*ea_inode_array == NULL)
./xattr.c:2826:         if (new_array == NULL)
./xattr.c:2947: if (ea_inode_array == NULL)
...

Anyway, I'd like to listen the Greg's and Chao's ideas.

Thanks,

> Thanks,
> Gao Xiang
> 
