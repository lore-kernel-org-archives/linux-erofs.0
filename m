From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 26 Jun 2019 15:13:52 +0800
Subject: [PATCH RESEND] staging: erofs: return the error value if
 fill_inline_data() fails
In-Reply-To: <20190626033038.9456-1-zbestahu@gmail.com>
References: <20190626033038.9456-1-zbestahu@gmail.com>
Message-ID: <96f12ad4-e9dc-a688-2c26-2dd285b7b795@huawei.com>

On 2019/6/26 11:30, Yue Hu wrote:
> From: Yue Hu <huyue2 at yulong.com>
> 
> We should consider the error returned by fill_inline_data() when filling
> last page in fill_inode(). If not getting inode will be successful even
> though last page is bad. That is illogical. Also change -EAGAIN to 0 in
> fill_inline_data() to stand for successful filling.
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
