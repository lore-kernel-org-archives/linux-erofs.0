From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 1 Oct 2018 12:26:27 +0800
Subject: [PREVIEW] [PATCH chao/erofs-dev 1/3] staging: erofs: harden inode
 lookup for 32-bit platforms
In-Reply-To: <ffcc88b5-bb18-047a-6dcd-639bf8647890@kernel.org>
References: <1537501415-70936-1-git-send-email-gaoxiang25@huawei.com>
 <72499322-10d4-b9af-3eb1-1787f451b5c8@kernel.org>
 <a3f994a3-f38e-5e20-775e-63bbef343073@aol.com>
 <ffcc88b5-bb18-047a-6dcd-639bf8647890@kernel.org>
Message-ID: <9db17a38-8f62-2057-e040-5b0d5dd579bb@aol.com>

Hi Chao

On 2018/10/1 11:04, Chao Yu wrote:
>>  /* inode.c */
>> +static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
>> +{
>> +	u64 h = nid;
> unsigned long h;
> 
>> +
>> +#if BITS_PER_LONG == 32
>> +	h = (h >> 32) ^ (h & 0xffffffff);
> h = (nid >> 32) ^ (nid & 0xffffffff);
> 
>> +#endif
>> +	return (unsigned long)h;

inode hash could be wrong in 64-bit since h is not initialized.
I will fix it in another way.

Thanks,
Gao Xiang.
