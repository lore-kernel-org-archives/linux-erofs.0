From: yuchao0@huawei.com (Chao Yu)
Date: Mon, 3 Sep 2018 09:53:01 +0800
Subject: [PATCH] staging: erofs: use explicit unsigned int type
In-Reply-To: <20180830205605.19492-1-linux@weissschuh.net>
References: <20180830205605.19492-1-linux@weissschuh.net>
Message-ID: <a3a13e77-bd81-1dbd-de5f-8e796c21921d@huawei.com>

Hi,

It looks like there is another patch from Pavel Zemlyanoy changing the same
place, I think it needs to rebase this patch on that one.

[PATCH 1/6] staging: erofs: formatting fix in unzip_vle_lz4.c

On 2018/8/31 4:56, Thomas Wei?schuh wrote:
> Signed-off-by: Thomas Wei?schuh <linux at weissschuh.net>
> ---
>  drivers/staging/erofs/data.c          |  4 +--
>  drivers/staging/erofs/dir.c           | 14 ++++----
>  drivers/staging/erofs/inode.c         |  6 ++--
>  drivers/staging/erofs/namei.c         | 28 ++++++++--------
>  drivers/staging/erofs/super.c         |  2 +-
>  drivers/staging/erofs/unzip_vle.c     | 48 +++++++++++++--------------
>  drivers/staging/erofs/unzip_vle_lz4.c | 22 ++++++------
>  drivers/staging/erofs/utils.c         |  2 +-
>  drivers/staging/erofs/xattr.c         | 40 +++++++++++-----------
>  9 files changed, 83 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/staging/erofs/data.c b/drivers/staging/erofs/data.c
> index 3c0d9159514e..e1916101ad75 100644
> --- a/drivers/staging/erofs/data.c
> +++ b/drivers/staging/erofs/data.c
> @@ -202,7 +202,7 @@ static inline struct bio *erofs_read_raw_page(
>  	struct address_space *mapping,
>  	struct page *page,
>  	erofs_off_t *last_block,
> -	unsigned nblocks,
> +	unsigned int nblocks,
>  	bool ra)
>  {
>  	struct inode *inode = mapping->host;
> @@ -236,7 +236,7 @@ static inline struct bio *erofs_read_raw_page(
>  			.m_la = blknr_to_addr(current_block),
>  		};
>  		erofs_blk_t blknr;
> -		unsigned blkoff;
> +		unsigned int blkoff;
>  
>  		err = erofs_map_blocks(inode, &map, EROFS_GET_BLOCKS_RAW);
>  		if (unlikely(err))
> diff --git a/drivers/staging/erofs/dir.c b/drivers/staging/erofs/dir.c
> index be6ae3b1bdbe..87f12b0f983f 100644
> --- a/drivers/staging/erofs/dir.c
> +++ b/drivers/staging/erofs/dir.c
> @@ -24,8 +24,8 @@ static const unsigned char erofs_filetype_table[EROFS_FT_MAX] = {
>  };
>  
>  static int erofs_fill_dentries(struct dir_context *ctx,
> -	void *dentry_blk, unsigned *ofs,
> -	unsigned nameoff, unsigned maxsize)
> +	void *dentry_blk, unsigned int *ofs,
> +	unsigned int nameoff, unsigned int maxsize)
>  {
>  	struct erofs_dirent *de = dentry_blk;
>  	const struct erofs_dirent *end = dentry_blk + nameoff;
> @@ -36,7 +36,7 @@ static int erofs_fill_dentries(struct dir_context *ctx,
>  		int de_namelen;
>  		unsigned char d_type;
>  #ifdef CONFIG_EROFS_FS_DEBUG
> -		unsigned dbg_namelen;
> +		unsigned int dbg_namelen;
>  		unsigned char dbg_namebuf[EROFS_NAME_LEN];
>  #endif
>  
> @@ -81,15 +81,15 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>  	struct inode *dir = file_inode(f);
>  	struct address_space *mapping = dir->i_mapping;
>  	const size_t dirsize = i_size_read(dir);
> -	unsigned i = ctx->pos / EROFS_BLKSIZ;
> -	unsigned ofs = ctx->pos % EROFS_BLKSIZ;
> +	unsigned int i = ctx->pos / EROFS_BLKSIZ;
> +	unsigned int ofs = ctx->pos % EROFS_BLKSIZ;
>  	int err = 0;
>  	bool initial = true;
>  
>  	while (ctx->pos < dirsize) {
>  		struct page *dentry_page;
>  		struct erofs_dirent *de;
> -		unsigned nameoff, maxsize;
> +		unsigned int nameoff, maxsize;
>  
>  		dentry_page = read_mapping_page(mapping, i, NULL);
>  		if (IS_ERR(dentry_page))
> @@ -109,7 +109,7 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>  			goto skip_this;
>  		}
>  
> -		maxsize = min_t(unsigned, dirsize - ctx->pos + ofs, PAGE_SIZE);
> +		maxsize = min_t(unsigned int, dirsize - ctx->pos + ofs, PAGE_SIZE);
>  
>  		/* search dirents at the arbitrary position */
>  		if (unlikely(initial)) {
> diff --git a/drivers/staging/erofs/inode.c b/drivers/staging/erofs/inode.c
> index fbf6ff25cd1b..70d34b0a97fe 100644
> --- a/drivers/staging/erofs/inode.c
> +++ b/drivers/staging/erofs/inode.c
> @@ -19,7 +19,7 @@ static int read_inode(struct inode *inode, void *data)
>  {
>  	struct erofs_vnode *vi = EROFS_V(inode);
>  	struct erofs_inode_v1 *v1 = data;
> -	const unsigned advise = le16_to_cpu(v1->i_advise);
> +	const unsigned int advise = le16_to_cpu(v1->i_advise);
>  
>  	vi->data_mapping_mode = __inode_data_mapping(advise);
>  
> @@ -112,7 +112,7 @@ static int read_inode(struct inode *inode, void *data)
>   * try_lock since it takes no much overhead and
>   * will success immediately.
>   */
> -static int fill_inline_data(struct inode *inode, void *data, unsigned m_pofs)
> +static int fill_inline_data(struct inode *inode, void *data, unsigned int m_pofs)
>  {
>  	struct erofs_vnode *vi = EROFS_V(inode);
>  	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
> @@ -152,7 +152,7 @@ static int fill_inode(struct inode *inode, int isdir)
>  	void *data;
>  	int err;
>  	erofs_blk_t blkaddr;
> -	unsigned ofs;
> +	unsigned int ofs;
>  
>  	trace_erofs_fill_inode(inode, isdir);
>  
> diff --git a/drivers/staging/erofs/namei.c b/drivers/staging/erofs/namei.c
> index 546a47156101..0039b767afb3 100644
> --- a/drivers/staging/erofs/namei.c
> +++ b/drivers/staging/erofs/namei.c
> @@ -17,9 +17,9 @@
>  
>  /* based on the value of qn->len is accurate */
>  static inline int dirnamecmp(struct qstr *qn,
> -	struct qstr *qd, unsigned *matched)
> +	struct qstr *qd, unsigned int *matched)
>  {
> -	unsigned i = *matched, len = min(qn->len, qd->len);
> +	unsigned int i = *matched, len = min(qn->len, qd->len);
>  loop:
>  	if (unlikely(i >= len)) {
>  		*matched = i;
> @@ -46,8 +46,8 @@ static struct erofs_dirent *find_target_dirent(
>  	struct qstr *name,
>  	u8 *data, int maxsize)
>  {
> -	unsigned ndirents, head, back;
> -	unsigned startprfx, endprfx;
> +	unsigned int ndirents, head, back;
> +	unsigned int startprfx, endprfx;
>  	struct erofs_dirent *const de = (struct erofs_dirent *)data;
>  
>  	/* make sure that maxsize is valid */
> @@ -63,9 +63,9 @@ static struct erofs_dirent *find_target_dirent(
>  	startprfx = endprfx = 0;
>  
>  	while (head <= back) {
> -		unsigned mid = head + (back - head) / 2;
> -		unsigned nameoff = le16_to_cpu(de[mid].nameoff);
> -		unsigned matched = min(startprfx, endprfx);
> +		unsigned int mid = head + (back - head) / 2;
> +		unsigned int nameoff = le16_to_cpu(de[mid].nameoff);
> +		unsigned int matched = min(startprfx, endprfx);
>  
>  		struct qstr dname = QSTR_INIT(data + nameoff,
>  			unlikely(mid >= ndirents - 1) ?
> @@ -95,8 +95,8 @@ static struct page *find_target_block_classic(
>  	struct inode *dir,
>  	struct qstr *name, int *_diff)
>  {
> -	unsigned startprfx, endprfx;
> -	unsigned head, back;
> +	unsigned int startprfx, endprfx;
> +	unsigned int head, back;
>  	struct address_space *const mapping = dir->i_mapping;
>  	struct page *candidate = ERR_PTR(-ENOENT);
>  
> @@ -105,7 +105,7 @@ static struct page *find_target_block_classic(
>  	back = inode_datablocks(dir) - 1;
>  
>  	while (head <= back) {
> -		unsigned mid = head + (back - head) / 2;
> +		unsigned int mid = head + (back - head) / 2;
>  		struct page *page = read_mapping_page(mapping, mid, NULL);
>  
>  		if (IS_ERR(page)) {
> @@ -115,10 +115,10 @@ static struct page *find_target_block_classic(
>  			return page;
>  		} else {
>  			int diff;
> -			unsigned ndirents, matched;
> +			unsigned int ndirents, matched;
>  			struct qstr dname;
>  			struct erofs_dirent *de = kmap_atomic(page);
> -			unsigned nameoff = le16_to_cpu(de->nameoff);
> +			unsigned int nameoff = le16_to_cpu(de->nameoff);
>  
>  			ndirents = nameoff / sizeof(*de);
>  
> @@ -164,7 +164,7 @@ static struct page *find_target_block_classic(
>  
>  int erofs_namei(struct inode *dir,
>  	struct qstr *name,
> -	erofs_nid_t *nid, unsigned *d_type)
> +	erofs_nid_t *nid, unsigned int *d_type)
>  {
>  	int diff;
>  	struct page *page;
> @@ -204,7 +204,7 @@ static struct dentry *erofs_lookup(struct inode *dir,
>  {
>  	int err;
>  	erofs_nid_t nid;
> -	unsigned d_type;
> +	unsigned int d_type;
>  	struct inode *inode;
>  
>  	DBG_BUGON(!d_really_is_negative(dentry));
> diff --git a/drivers/staging/erofs/super.c b/drivers/staging/erofs/super.c
> index 1aec509c805f..5654cc7a5015 100644
> --- a/drivers/staging/erofs/super.c
> +++ b/drivers/staging/erofs/super.c
> @@ -81,7 +81,7 @@ static int superblock_read(struct super_block *sb)
>  	struct erofs_sb_info *sbi;
>  	struct buffer_head *bh;
>  	struct erofs_super_block *layout;
> -	unsigned blkszbits;
> +	unsigned int blkszbits;
>  	int ret;
>  
>  	bh = sb_bread(sb, 0);
> diff --git a/drivers/staging/erofs/unzip_vle.c b/drivers/staging/erofs/unzip_vle.c
> index 22f9a02a75f9..21874b79c434 100644
> --- a/drivers/staging/erofs/unzip_vle.c
> +++ b/drivers/staging/erofs/unzip_vle.c
> @@ -27,7 +27,7 @@ void z_erofs_exit_zip_subsystem(void)
>  
>  static inline int init_unzip_workqueue(void)
>  {
> -	const unsigned onlinecpus = num_possible_cpus();
> +	const unsigned int onlinecpus = num_possible_cpus();
>  
>  	/*
>  	 * we don't need too many threads, limiting threads
> @@ -89,7 +89,7 @@ struct z_erofs_vle_work_builder {
>  
>  	/* pages used for reading the compressed data */
>  	struct page **compressed_pages;
> -	unsigned compressed_deficit;
> +	unsigned int compressed_deficit;
>  };
>  
>  #define VLE_WORK_BUILDER_INIT()	\
> @@ -232,7 +232,7 @@ static int z_erofs_vle_work_add_page(
>  
>  	ret = z_erofs_pagevec_ctor_enqueue(&builder->vector,
>  		page, type, &occupied);
> -	builder->work->vcnt += (unsigned)ret;
> +	builder->work->vcnt += (unsigned int)ret;
>  
>  	return ret ? 0 : -EAGAIN;
>  }
> @@ -274,7 +274,7 @@ static inline bool try_to_claim_workgroup(
>  struct z_erofs_vle_work_finder {
>  	struct super_block *sb;
>  	pgoff_t idx;
> -	unsigned pageofs;
> +	unsigned int pageofs;
>  
>  	struct z_erofs_vle_workgroup **grp_ret;
>  	enum z_erofs_vle_work_role *role;
> @@ -440,7 +440,7 @@ static int z_erofs_vle_work_iter_begin(struct z_erofs_vle_work_builder *builder,
>  				       struct erofs_map_blocks *map,
>  				       z_erofs_vle_owned_workgrp_t *owned_head)
>  {
> -	const unsigned clusterpages = erofs_clusterpages(EROFS_SB(sb));
> +	const unsigned int clusterpages = erofs_clusterpages(EROFS_SB(sb));
>  	struct z_erofs_vle_workgroup *grp;
>  	const struct z_erofs_vle_work_finder finder = {
>  		.sb = sb,
> @@ -610,7 +610,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
>  #endif
>  
>  	enum z_erofs_page_type page_type;
> -	unsigned cur, end, spiltted, index;
> +	unsigned int cur, end, spiltted, index;
>  	int err;
>  
>  	/* register locked file pages as online pages in pack */
> @@ -667,7 +667,7 @@ static int z_erofs_do_read_page(struct z_erofs_vle_frontend *fe,
>  	tight &= builder_is_followed(builder);
>  	work = builder->work;
>  hitted:
> -	cur = end - min_t(unsigned, offset + end - map->m_la, end);
> +	cur = end - min_t(unsigned int, offset + end - map->m_la, end);
>  	if (unlikely(!(map->m_flags & EROFS_MAP_MAPPED))) {
>  		zero_user_segment(page, cur, end);
>  		goto next_part;
> @@ -741,7 +741,7 @@ static void z_erofs_vle_unzip_kickoff(void *ptr, int bios)
>  static inline void z_erofs_vle_read_endio(struct bio *bio)
>  {
>  	const blk_status_t err = bio->bi_status;
> -	unsigned i;
> +	unsigned int i;
>  	struct bio_vec *bvec;
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
>  	struct address_space *mngda = NULL;
> @@ -793,16 +793,16 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
>  	struct address_space *const mngda = sbi->managed_cache->i_mapping;
>  #endif
> -	const unsigned clusterpages = erofs_clusterpages(sbi);
> +	const unsigned int clusterpages = erofs_clusterpages(sbi);
>  
>  	struct z_erofs_pagevec_ctor ctor;
> -	unsigned nr_pages;
> +	unsigned int nr_pages;
>  #ifndef CONFIG_EROFS_FS_ZIP_MULTIREF
> -	unsigned sparsemem_pages = 0;
> +	unsigned int sparsemem_pages = 0;
>  #endif
>  	struct page *pages_onstack[Z_EROFS_VLE_VMAP_ONSTACK_PAGES];
>  	struct page **pages, **compressed_pages, *page;
> -	unsigned i, llen;
> +	unsigned int i, llen;
>  
>  	enum z_erofs_page_type page_type;
>  	bool overlapped;
> @@ -849,7 +849,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>  		Z_EROFS_VLE_INLINE_PAGEVECS, work->pagevec, 0);
>  
>  	for (i = 0; i < work->vcnt; ++i) {
> -		unsigned pagenr;
> +		unsigned int pagenr;
>  
>  		page = z_erofs_pagevec_ctor_dequeue(&ctor, &page_type);
>  
> @@ -880,7 +880,7 @@ static int z_erofs_vle_unzip(struct super_block *sb,
>  	compressed_pages = grp->compressed_pages;
>  
>  	for (i = 0; i < clusterpages; ++i) {
> -		unsigned pagenr;
> +		unsigned int pagenr;
>  
>  		page = compressed_pages[i];
>  
> @@ -1105,7 +1105,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
>  				   bool force_fg)
>  {
>  	struct erofs_sb_info *const sbi = EROFS_SB(sb);
> -	const unsigned clusterpages = erofs_clusterpages(sbi);
> +	const unsigned int clusterpages = erofs_clusterpages(sbi);
>  	const gfp_t gfp = GFP_NOFS;
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
>  	struct address_space *const mngda = sbi->managed_cache->i_mapping;
> @@ -1117,7 +1117,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
>  	/* since bio will be NULL, no need to initialize last_index */
>  	pgoff_t uninitialized_var(last_index);
>  	bool force_submit = false;
> -	unsigned nr_bios;
> +	unsigned int nr_bios;
>  
>  	if (unlikely(owned_head == Z_EROFS_VLE_WORKGRP_TAIL))
>  		return false;
> @@ -1149,7 +1149,7 @@ static bool z_erofs_vle_submit_all(struct super_block *sb,
>  		struct z_erofs_vle_workgroup *grp;
>  		struct page **compressed_pages, *oldpage, *page;
>  		pgoff_t first_index;
> -		unsigned i = 0;
> +		unsigned int i = 0;
>  #ifdef EROFS_FS_HAS_MANAGED_CACHE
>  		unsigned int noio = 0;
>  		bool cachemngd;
> @@ -1337,7 +1337,7 @@ static int z_erofs_vle_normalaccess_readpage(struct file *file,
>  static inline int __z_erofs_vle_normalaccess_readpages(
>  	struct file *filp,
>  	struct address_space *mapping,
> -	struct list_head *pages, unsigned nr_pages, bool sync)
> +	struct list_head *pages, unsigned int nr_pages, bool sync)
>  {
>  	struct inode *const inode = mapping->host;
>  
> @@ -1398,7 +1398,7 @@ static inline int __z_erofs_vle_normalaccess_readpages(
>  static int z_erofs_vle_normalaccess_readpages(
>  	struct file *filp,
>  	struct address_space *mapping,
> -	struct list_head *pages, unsigned nr_pages)
> +	struct list_head *pages, unsigned int nr_pages)
>  {
>  	return __z_erofs_vle_normalaccess_readpages(filp,
>  		mapping, pages, nr_pages,
> @@ -1445,7 +1445,7 @@ vle_extent_blkaddr(struct inode *inode, pgoff_t index)
>  	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
>  	struct erofs_vnode *vi = EROFS_V(inode);
>  
> -	unsigned ofs = Z_EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
> +	unsigned int ofs = Z_EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
>  		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
>  		index * sizeof(struct z_erofs_vle_decompressed_index);
>  
> @@ -1458,7 +1458,7 @@ vle_extent_blkoff(struct inode *inode, pgoff_t index)
>  	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
>  	struct erofs_vnode *vi = EROFS_V(inode);
>  
> -	unsigned ofs = Z_EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
> +	unsigned int ofs = Z_EROFS_VLE_EXTENT_ALIGN(vi->inode_isize +
>  		vi->xattr_isize) + sizeof(struct erofs_extent_header) +
>  		index * sizeof(struct z_erofs_vle_decompressed_index);
>  
> @@ -1476,9 +1476,9 @@ static erofs_off_t vle_get_logical_extent_head(
>  	struct inode *inode,
>  	struct page **page_iter,
>  	void **kaddr_iter,
> -	unsigned lcn,	/* logical cluster number */
> +	unsigned int lcn,	/* logical cluster number */
>  	erofs_blk_t *pcn,
> -	unsigned *flags)
> +	unsigned int *flags)
>  {
>  	/* for extent meta */
>  	struct page *page = *page_iter;
> @@ -1531,7 +1531,7 @@ int z_erofs_map_blocks_iter(struct inode *inode,
>  	unsigned long long ofs, end;
>  	struct z_erofs_vle_decompressed_index *di;
>  	erofs_blk_t e_blkaddr, pcn;
> -	unsigned lcn, logical_cluster_ofs, cluster_type;
> +	unsigned int lcn, logical_cluster_ofs, cluster_type;
>  	u32 ofs_rem;
>  	struct page *mpage = *mpage_ret;
>  	void *kaddr;
> diff --git a/drivers/staging/erofs/unzip_vle_lz4.c b/drivers/staging/erofs/unzip_vle_lz4.c
> index f5b665f15be5..a05a80580099 100644
> --- a/drivers/staging/erofs/unzip_vle_lz4.c
> +++ b/drivers/staging/erofs/unzip_vle_lz4.c
> @@ -23,14 +23,14 @@ static struct {
>  } erofs_pcpubuf[NR_CPUS];
>  
>  int z_erofs_vle_plain_copy(struct page **compressed_pages,
> -			   unsigned clusterpages,
> +			   unsigned int clusterpages,
>  			   struct page **pages,
> -			   unsigned nr_pages,
> +			   unsigned int nr_pages,
>  			   unsigned short pageofs)
>  {
> -	unsigned i, j;
> +	unsigned int i, j;
>  	void *src = NULL;
> -	const unsigned righthalf = PAGE_SIZE - pageofs;
> +	const unsigned int righthalf = PAGE_SIZE - pageofs;
>  	char *percpu_data;
>  	bool mirrored[Z_EROFS_CLUSTER_MAX_PAGES] = { 0 };
>  
> @@ -102,14 +102,14 @@ int z_erofs_vle_plain_copy(struct page **compressed_pages,
>  extern int z_erofs_unzip_lz4(void *in, void *out, size_t inlen, size_t outlen);
>  
>  int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
> -				  unsigned clusterpages,
> +				  unsigned int clusterpages,
>  				  struct page **pages,
> -				  unsigned outlen,
> +				  unsigned int outlen,
>  				  unsigned short pageofs,
>  				  void (*endio)(struct page *))
>  {
>  	void *vin, *vout;
> -	unsigned nr_pages, i, j;
> +	unsigned int nr_pages, i, j;
>  	int ret;
>  
>  	if (outlen + pageofs > EROFS_PERCPU_NR_PAGES * PAGE_SIZE)
> @@ -134,7 +134,7 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
>  	}
>  
>  	for (i = 0; i < nr_pages; ++i) {
> -		j = min((unsigned)PAGE_SIZE - pageofs, outlen);
> +		j = min((unsigned int)PAGE_SIZE - pageofs, outlen);
>  
>  		if (pages[i] != NULL) {
>  			if (ret < 0)
> @@ -164,14 +164,14 @@ int z_erofs_vle_unzip_fast_percpu(struct page **compressed_pages,
>  }
>  
>  int z_erofs_vle_unzip_vmap(struct page **compressed_pages,
> -			   unsigned clusterpages,
> +			   unsigned int clusterpages,
>  			   void *vout,
> -			   unsigned llen,
> +			   unsigned int llen,
>  			   unsigned short pageofs,
>  			   bool overlapped)
>  {
>  	void *vin;
> -	unsigned i;
> +	unsigned int i;
>  	int ret;
>  
>  	if (overlapped) {
> diff --git a/drivers/staging/erofs/utils.c b/drivers/staging/erofs/utils.c
> index 595cf90af9bb..ddd220ac33fd 100644
> --- a/drivers/staging/erofs/utils.c
> +++ b/drivers/staging/erofs/utils.c
> @@ -120,7 +120,7 @@ unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
>  {
>  	pgoff_t first_index = 0;
>  	void *batch[PAGEVEC_SIZE];
> -	unsigned freed = 0;
> +	unsigned int freed = 0;
>  
>  	int i, found;
>  repeat:
> diff --git a/drivers/staging/erofs/xattr.c b/drivers/staging/erofs/xattr.c
> index 79d7fc8b7cc5..f38300a8bc8e 100644
> --- a/drivers/staging/erofs/xattr.c
> +++ b/drivers/staging/erofs/xattr.c
> @@ -19,7 +19,7 @@ struct xattr_iter {
>  	void *kaddr;
>  
>  	erofs_blk_t blkaddr;
> -	unsigned ofs;
> +	unsigned int ofs;
>  };
>  
>  static inline void xattr_iter_end(struct xattr_iter *it, bool atomic)
> @@ -45,7 +45,7 @@ static inline void xattr_iter_end_final(struct xattr_iter *it)
>  static int init_inode_xattrs(struct inode *inode)
>  {
>  	struct xattr_iter it;
> -	unsigned i;
> +	unsigned int i;
>  	struct erofs_xattr_ibody_header *ih;
>  	struct super_block *sb;
>  	struct erofs_sb_info *sbi;
> @@ -111,9 +111,9 @@ static int init_inode_xattrs(struct inode *inode)
>  
>  struct xattr_iter_handlers {
>  	int (*entry)(struct xattr_iter *, struct erofs_xattr_entry *);
> -	int (*name)(struct xattr_iter *, unsigned, char *, unsigned);
> -	int (*alloc_buffer)(struct xattr_iter *, unsigned);
> -	void (*value)(struct xattr_iter *, unsigned, char *, unsigned);
> +	int (*name)(struct xattr_iter *, unsigned int, char *, unsigned int);
> +	int (*alloc_buffer)(struct xattr_iter *, unsigned int);
> +	void (*value)(struct xattr_iter *, unsigned int, char *, unsigned int);
>  };
>  
>  static inline int xattr_iter_fixup(struct xattr_iter *it)
> @@ -143,7 +143,7 @@ static int inline_xattr_iter_begin(struct xattr_iter *it,
>  {
>  	struct erofs_vnode *const vi = EROFS_V(inode);
>  	struct erofs_sb_info *const sbi = EROFS_SB(inode->i_sb);
> -	unsigned xattr_header_sz, inline_xattr_ofs;
> +	unsigned int xattr_header_sz, inline_xattr_ofs;
>  
>  	xattr_header_sz = inlinexattr_header_size(inode);
>  	if (unlikely(xattr_header_sz >= vi->xattr_isize)) {
> @@ -168,7 +168,7 @@ static int xattr_foreach(struct xattr_iter *it,
>  	const struct xattr_iter_handlers *op, unsigned int *tlimit)
>  {
>  	struct erofs_xattr_entry entry;
> -	unsigned value_sz, processed, slice;
> +	unsigned int value_sz, processed, slice;
>  	int err;
>  
>  	/* 0. fixup blkaddr, ofs, ipage */
> @@ -183,7 +183,7 @@ static int xattr_foreach(struct xattr_iter *it,
>  	 */
>  	entry = *(struct erofs_xattr_entry *)(it->kaddr + it->ofs);
>  	if (tlimit != NULL) {
> -		unsigned entry_sz = EROFS_XATTR_ENTRY_SIZE(&entry);
> +		unsigned int entry_sz = EROFS_XATTR_ENTRY_SIZE(&entry);
>  
>  		BUG_ON(*tlimit < entry_sz);
>  		*tlimit -= entry_sz;
> @@ -212,7 +212,7 @@ static int xattr_foreach(struct xattr_iter *it,
>  			it->ofs = 0;
>  		}
>  
> -		slice = min_t(unsigned, PAGE_SIZE - it->ofs,
> +		slice = min_t(unsigned int, PAGE_SIZE - it->ofs,
>  			entry.e_name_len - processed);
>  
>  		/* handle name */
> @@ -247,7 +247,7 @@ static int xattr_foreach(struct xattr_iter *it,
>  			it->ofs = 0;
>  		}
>  
> -		slice = min_t(unsigned, PAGE_SIZE - it->ofs,
> +		slice = min_t(unsigned int, PAGE_SIZE - it->ofs,
>  			value_sz - processed);
>  		op->value(it, processed, it->kaddr + it->ofs, slice);
>  		it->ofs += slice;
> @@ -278,7 +278,7 @@ static int xattr_entrymatch(struct xattr_iter *_it,
>  }
>  
>  static int xattr_namematch(struct xattr_iter *_it,
> -	unsigned processed, char *buf, unsigned len)
> +	unsigned int processed, char *buf, unsigned int len)
>  {
>  	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
>  
> @@ -286,7 +286,7 @@ static int xattr_namematch(struct xattr_iter *_it,
>  }
>  
>  static int xattr_checkbuffer(struct xattr_iter *_it,
> -	unsigned value_sz)
> +	unsigned int value_sz)
>  {
>  	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
>  	int err = it->buffer_size < value_sz ? -ERANGE : 0;
> @@ -296,7 +296,7 @@ static int xattr_checkbuffer(struct xattr_iter *_it,
>  }
>  
>  static void xattr_copyvalue(struct xattr_iter *_it,
> -	unsigned processed, char *buf, unsigned len)
> +	unsigned int processed, char *buf, unsigned int len)
>  {
>  	struct getxattr_iter *it = container_of(_it, struct getxattr_iter, it);
>  
> @@ -313,7 +313,7 @@ static const struct xattr_iter_handlers find_xattr_handlers = {
>  static int inline_getxattr(struct inode *inode, struct getxattr_iter *it)
>  {
>  	int ret;
> -	unsigned remaining;
> +	unsigned int remaining;
>  
>  	ret = inline_xattr_iter_begin(&it->it, inode);
>  	if (ret < 0)
> @@ -338,7 +338,7 @@ static int shared_getxattr(struct inode *inode, struct getxattr_iter *it)
>  	struct erofs_vnode *const vi = EROFS_V(inode);
>  	struct super_block *const sb = inode->i_sb;
>  	struct erofs_sb_info *const sbi = EROFS_SB(sb);
> -	unsigned i;
> +	unsigned int i;
>  	int ret = -ENOATTR;
>  
>  	for (i = 0; i < vi->xattr_shared_count; ++i) {
> @@ -489,7 +489,7 @@ static int xattr_entrylist(struct xattr_iter *_it,
>  {
>  	struct listxattr_iter *it =
>  		container_of(_it, struct listxattr_iter, it);
> -	unsigned prefix_len;
> +	unsigned int prefix_len;
>  	const char *prefix;
>  
>  	const struct xattr_handler *h =
> @@ -517,7 +517,7 @@ static int xattr_entrylist(struct xattr_iter *_it,
>  }
>  
>  static int xattr_namelist(struct xattr_iter *_it,
> -	unsigned processed, char *buf, unsigned len)
> +	unsigned int processed, char *buf, unsigned int len)
>  {
>  	struct listxattr_iter *it =
>  		container_of(_it, struct listxattr_iter, it);
> @@ -528,7 +528,7 @@ static int xattr_namelist(struct xattr_iter *_it,
>  }
>  
>  static int xattr_skipvalue(struct xattr_iter *_it,
> -	unsigned value_sz)
> +	unsigned int value_sz)
>  {
>  	struct listxattr_iter *it =
>  		container_of(_it, struct listxattr_iter, it);
> @@ -547,7 +547,7 @@ static const struct xattr_iter_handlers list_xattr_handlers = {
>  static int inline_listxattr(struct listxattr_iter *it)
>  {
>  	int ret;
> -	unsigned remaining;
> +	unsigned int remaining;
>  
>  	ret = inline_xattr_iter_begin(&it->it, d_inode(it->dentry));
>  	if (ret < 0)
> @@ -569,7 +569,7 @@ static int shared_listxattr(struct listxattr_iter *it)
>  	struct erofs_vnode *const vi = EROFS_V(inode);
>  	struct super_block *const sb = inode->i_sb;
>  	struct erofs_sb_info *const sbi = EROFS_SB(sb);
> -	unsigned i;
> +	unsigned int i;
>  	int ret = 0;
>  
>  	for (i = 0; i < vi->xattr_shared_count; ++i) {
> 
