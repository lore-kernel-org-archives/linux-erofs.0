From: yuchao0@huawei.com (Chao Yu)
Date: Tue, 16 Oct 2018 19:11:55 +0800
Subject: [PATCH] clean erofs_lookup()
In-Reply-To: <20181010190116.GG32577@ZenIV.linux.org.uk>
References: <20181010190116.GG32577@ZenIV.linux.org.uk>
Message-ID: <4b564529-a64e-eaee-aa9a-7324657c2eff@huawei.com>

On 2018/10/11 3:01, Al Viro wrote:
> 	d_splice_alias() does the right thing when given
> ERR_PTR(-E...) for inode.  No need for gotos, multiple
> returns, etc. in there.
> 
> Signed-off-by: Al Viro <viro at zeniv.linux.org.uk>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
