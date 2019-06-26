From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 26 Jun 2019 15:13:35 +0800
Subject: [PATCH RESEND] staging: erofs: remove unsupported ->datamode
 check in fill_inline_data()
In-Reply-To: <20190626032831.7252-1-zbestahu@gmail.com>
References: <20190626032831.7252-1-zbestahu@gmail.com>
Message-ID: <654721e9-fdca-f21f-c244-9e9c8c421f4b@huawei.com>

On 2019/6/26 11:28, Yue Hu wrote:
> From: Yue Hu <huyue2 at yulong.com>
> 
> Already check if ->datamode is supported in read_inode(), no need to check
> again in the next fill_inline_data() only called by fill_inode().
> 
> Signed-off-by: Yue Hu <huyue2 at yulong.com>

Reviewed-by: Chao Yu <yuchao0 at huawei.com>

Thanks,
