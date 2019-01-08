From: gaoxiang25@huawei.com (Gao Xiang)
Date: Tue, 8 Jan 2019 17:23:58 +0800
Subject: [PATCH 0/2] staging: erofs: fixed -Wmissing-prototype warnings.
In-Reply-To: <20190108090850.GB20615@azazel.net>
References: <20190107182516.21511-1-jeremy@azazel.net>
 <5b305a6a-b50d-fd27-4675-88cdeffa577b@huawei.com>
 <20190108090850.GB20615@azazel.net>
Message-ID: <f1b26735-600b-e2dc-5b85-db824e4bd977@huawei.com>



On 2019/1/8 17:08, Jeremy Sowden wrote:
> On 2019-01-08,@09:46:18 +0800, Gao Xiang wrote:
>> On 2019/1/8 2:25, Jeremy Sowden wrote:
>>> Fixes for -Wmissing-prototype warnings in the erofs driver.  One
>>> group of functions have been made static; for the second, prototypes
>>> have been moved to a head
>> Is -Wmissing-prototypes required for the current linux kernel?
>> I cannot see this warning in my personal kernel compilation...
>>
>> Functions your fix have already been added proper erofs prefix,
>> therefore it wouldn't pollute the global namespace:
>> z_erofs_vle_work_release
>> z_erofs_unzip_lz4
>> erofs_try_to_release_workgroup
>>
>> erofs_workgroup_free_rcu
>> z_erofs_map_blocks_iter
> There was a request for help to fix these warnings on the
> driverdev-devel mailing list last Novemeber (I've also attached the
> message):
> 
>   http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-November/128432.html
> 
> Currently, the flag is only enabled by passing W=1 to make, but since it
> is useful, the idea is to fix all the current warnings and enable it in
> the main build.

OK, it is fine with me personally too since it has no logic change.
I will also take care of W=1 from now on, and thanks for your explanation ;)

Thanks,
Gao Xiang

> 
> J.
