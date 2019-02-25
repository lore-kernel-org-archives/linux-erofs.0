From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 25 Feb 2019 23:04:33 +0800
Subject: [PATCH for-4.19 02/12] staging: erofs: complete error handing of
 z_erofs_do_read_page
In-Reply-To: <20190225145936.GC16015@kroah.com>
References: <20190220091854.19242-1-gaoxiang25@huawei.com>
 <20190220091854.19242-3-gaoxiang25@huawei.com>
 <20190225145936.GC16015@kroah.com>
Message-ID: <d57a2695-568c-1620-7298-241fd80427ee@huawei.com>



On 2019/2/25 22:59, Greg Kroah-Hartman wrote:
> On Wed, Feb 20, 2019@05:18:44PM +0800, Gao Xiang wrote:
>> commit 1e05ff36e6921ca61bdbf779f81a602863569ee3 upstream.
>>
>> This patch completes error handing code of z_erofs_do_read_page.
>> PG_error will be set when some read error happens, therefore
>> z_erofs_onlinepage_endio will unlock this page without setting
>> PG_uptodate.
>>
>> Reviewed-by: Chao Yu <yucxhao0 at huawei.com>
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh at linuxfoundation.org>
>>
>> Conflicts:
>> 	drivers/staging/erofs/unzip_vle.c
> 
> These types of lines are not needed in backports, they just are clutter.
> I'll go fix it up...

Thanks Greg... I also added some comments in some patch..
If it is not needed, I will notice in the future submission...

Thanks,
Gao Xiang

> 
> greg k-h
> 
