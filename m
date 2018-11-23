From: gaoxiang25@huawei.com (Gao Xiang)
Date: Fri, 23 Nov 2018 18:00:25 +0800
Subject: [PATCH 05/10] staging: erofs: add a full barrier in
 erofs_workgroup_unfreeze
In-Reply-To: <20181123094739.GA3487@andrea>
References: <20181120143425.43637-1-gaoxiang25@huawei.com>
 <20181120143425.43637-6-gaoxiang25@huawei.com>
 <20181122102230.GF3189@kroah.com>
 <1d1fd688-0cb5-cbac-9213-f56f7e356bca@huawei.com>
 <20181122185058.GA3466@andrea>
 <b2f367c5-a54c-9edf-42ad-d256bc725cf7@huawei.com>
 <20181123094739.GA3487@andrea>
Message-ID: <5bf95ae0-cecb-c220-653b-704baee1cd8e@huawei.com>

Hi Andrea,

On 2018/11/23 17:51, Andrea Parri wrote:
> Correct.  This is informally documented in Documentation/atomic_t.txt
> and formalized within tools/memory-model/.
> 
> 
>> I don't know whether my understanding is correct, If I am wrong..please correct me, or
>> I need to add more detailed code comments to explain in the code?
> Yes, please; please review the above points (including 1. and 3.) and
> try to address them with inline comments.  Maybe (if that matches the
> *behavior*/guarantee you have in mind...) something like:
> 
> [in erofs_workgroup_unfreeze()]
> 
> 	/*
> 	 * Orders the store/load to/from [???] and the store to
> 	 * ->refcount performed by the atomic_set() below.
> 	 *
> 	 * Matches the atomic_cmpxchg() in erofs_workgroup_get().
> 	 *
> 	 * Guarantees that if a successful atomic_cmpxchg() reads
> 	 * the value stored by the atomic_set() then [???].
> 	 */
> 	smp_mb();
> 	atomic_set(&grp->refcount, v);
> 
> 
> [in erofs_workgroup_get()]
> 
> 	/*
> 	 * Orders the load from ->refcount performed by the
> 	 * atomic_cmpxchg() below and the store/load [???].
> 	 *
> 	 * See the comment for the smp_mb() in
> 	 * erofs_workgroup_unfreeze().
> 	 */
> 	if (unlikely(atomic_cmpxchg(&grp->refcount, o, o + 1) != o))
> 		goto repeat;
> 

OK, I will add these comments in the next version patchset, will be sent later.
Thanks for your suggestion. :)

Thanks,
Gao Xiang

> Thanks,
>   Andrea
> 
> 
