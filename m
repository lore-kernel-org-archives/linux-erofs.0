From: hsiangkao@aol.com (Gao Xiang)
Date: Wed, 13 Feb 2019 23:28:12 +0800
Subject: [PATCH 2/2] staging: erofs: remove redundant unlikely annotation
 in unzip_vle.c
In-Reply-To: <b96e927a-2848-4c2c-f737-3710a4971d5a@gmx.com>
References: <20190212032423.14637-1-cgxu519@gmx.com>
 <20190212032423.14637-2-cgxu519@gmx.com>
 <333a15d7-3b8e-412b-34f6-a30010d36f4f@huawei.com>
 <b96e927a-2848-4c2c-f737-3710a4971d5a@gmx.com>
Message-ID: <0420a632-a88f-c03d-a787-fd5bbf25417e@aol.com>

Hi Chengguang,

On 2019/2/13 22:50, cgxu519 wrote:
>
> On 2/13/19 2:36 PM, Chao Yu wrote:
>> On 2019/2/12 11:24, Chengguang Xu wrote:
>>> unlikely has already included in IS_ERR(),
>>> so just remove it.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519 at gmx.com>
>> It looks like we don't need to send two patch to fix two similar
>> issues, if you can merge them, it will be better.
> I agree with you but I noticed the patches have already merged to Greg's staging tree,
> so I'm not sure if it cause inconvenience to his management.
>

I personally think it is not a big problem since that is indeed cleanup patches and

thanks for applying erofs patches and happy hacking :)


Thanks,

Gao Xiang


> Thanks,
> Chengguang
>
>
