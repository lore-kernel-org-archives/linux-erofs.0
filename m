From: gaoxiang25@huawei.com (Gao Xiang)
Date: Mon, 22 Jul 2019 13:24:45 +0800
Subject: [PATCH v3 01/24] erofs: add on-disk layout
In-Reply-To: <20190722050522.GA11993@kroah.com>
References: <20190722025043.166344-1-gaoxiang25@huawei.com>
 <20190722025043.166344-2-gaoxiang25@huawei.com>
 <20190722132616.60edd141@canb.auug.org.au> <20190722050522.GA11993@kroah.com>
Message-ID: <98b70190-a7d8-6251-84d9-599ca115f42b@huawei.com>

Hi Greg,

On 2019/7/22 13:05, Greg Kroah-Hartman wrote:
> On Mon, Jul 22, 2019@01:26:16PM +1000, Stephen Rothwell wrote:
>> Hi Gao,
>>
>> On Mon, 22 Jul 2019 10:50:20 +0800 Gao Xiang <gaoxiang25@huawei.com> wrote:
>>>
>>> diff --git a/fs/erofs/erofs_fs.h b/fs/erofs/erofs_fs.h
>>> new file mode 100644
>>> index 000000000000..e418725abfd6
>>> --- /dev/null
>>> +++ b/fs/erofs/erofs_fs.h
>>> @@ -0,0 +1,316 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 OR Apache-2.0 */
>>
>> I think the preferred tag is now GPL-2.0-only (assuming that is what is
>> intended).
> 
> Either is fine, see the LICENSE/preferred/GPL-2.0 file for the list of
> valid ones.

Yes, I noticed the LICENSE text before and I can do in the either way (use
GPL-2.0 or GPL-2.0-only). This modification won't take too much time...
If it is needed, I am happy to do that... That is fine :)

Thanks,
Gao Xiang
