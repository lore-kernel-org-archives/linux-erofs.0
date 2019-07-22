From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 22 Jul 2019 11:29:30 +0800
Subject: [PATCH v3 01/24] erofs: add on-disk layout
In-Reply-To: <20190722132616.60edd141@canb.auug.org.au>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-2-gaoxiang25@huawei.com>
 <20190722132616.60edd141@canb.auug.org.au>
Message-ID: <b1ff773b-eb15-9fdc-77aa-f7446471a1d4@huawei.com>

Hi Stephen,

On 2019/7/22 11:26, Stephen Rothwell wrote:
> Hi Gao,
> 
> On Mon, 22 Jul 2019 10:50:20 +0800 Gao Xiang <gaoxiang25@huawei.com> wrote:
>>
>> diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
>> new file mode 100644
>> index 000000000000..e418725abfd6
>> --- /dev/null
>> +++ b/fs/erofs/erofs_fs.h
>> @@ -0,0 +1,316 @@
>> +/* SPDX-License-Identifier: GPL-2.0 OR Apache-2.0 */
> 
> I think the preferred tag is now GPL-2.0-only (assuming that is what is
> intended).

OK, GPL-2.0-only is much better.
I will change these tags in the next version :)

Thanks,
Gao Xiang

> 
