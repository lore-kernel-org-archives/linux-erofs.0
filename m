From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 7 Mar 2019 21:04:06 +0800
Subject: [PATCH for-4.19] staging: erofs: fix mis-acted TAIL merging
 behavior
In-Reply-To: <20190307122539.GD21325@kroah.com>
References: <20190301212203.5FE0C2084F@mail.kernel.org>
 <20190307053404.29108-1-gaoxiang25@huawei.com>
 <20190307122539.GD21325@kroah.com>
Message-ID: <5b7e1914-f8e5-da3d-4492-17d6afc00fb1@huawei.com>

Hi Greg,

On 2019/3/7 20:25, Greg KH wrote:
> On Thu, Mar 07, 2019@01:34:04PM +0800, Gao Xiang wrote:
>> commit a112152f6f3a2a88caa6f414d540bd49e406af60 upstream.
>>
>> EROFS has an optimized path called TAIL merging, which is designed
>> to merge multiple reads and the corresponding decompressions into
>> one if these requests read continuous pages almost at the same time.
>>
>> In general, it behaves as follows:
>>  ________________________________________________________________
>>   ... |  TAIL  .  HEAD  |  PAGE  |  PAGE  |  TAIL    . HEAD | ...
>>  _____|_combined page A_|________|________|_combined page B_|____
>>         1  ]  ->  [  2                          ]  ->  [ 3
>> If the above three reads are requested in the order 1-2-3, it will
>> generate a large work chain rather than 3 individual work chains
>> to reduce scheduling overhead and boost up sequential read.
>>
>> However, if Read 2 is processed slightly earlier than Read 1,
>> currently it still generates 2 individual work chains (chain 1, 2)
>> but it does in-place decompression for combined page A, moreover,
>> if chain 2 decompresses ahead of chain 1, it will be a race and
>> lead to corrupted decompressed page. This patch fixes it.
>>
>> Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
>> Cc: <stable at vger.kernel.org> # 4.19+
>> Signed-off-by: Gao Xiang <gaoxiang25 at huawei.com>
>> Reviewed-by: Chao Yu <yuchao0 at huawei.com>
>> ---
>>  drivers/staging/erofs/unzip_vle.c | 69 +++++++++++++++++++++++++--------------
>>  1 file changed, 44 insertions(+), 25 deletions(-)
>>
> 
> thanks for the backport, now applied.

Yes, it seems that Sasha's bot cannot cherry-pick it directly,
therefore I made this patch for 4.19 by hand...

BTW, there is another patch called "staging: erofs: compressed_pages should not be accessed again after freed"
in the same condition... And I also send 4.19 and 4.20 version to stable mailing list,
could you also kindly check them out?

Thanks,
Gao Xiang

> 
> greg k-h
> 
