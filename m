From: yuchao0@huawei.com (Chao Yu)
Date: Wed, 14 Aug 2019 14:36:17 +0800
Subject: [PATCH] staging: erofs: removing an extra call to iloc() in
 fill_inode()
In-Reply-To: <CAGu0czT2z3Rx_PFot1mgZJ=X75N3pZoDeNDk5DNkyTcfZ7PBcg@mail.gmail.com>
References: <20190813203840.13782-1-pratikshinde320@gmail.com>
 <20190814015944.GA11254@138>
 <418907b6-0b6b-3b08-c6fd-939a206f061f@huawei.com>
 <20190814022442.GA28602@138>
 <CAGu0czT2z3Rx_PFot1mgZJ=X75N3pZoDeNDk5DNkyTcfZ7PBcg@mail.gmail.com>
Message-ID: <554b5085-7e73-bb56-4128-e9eaed827505@huawei.com>

On 2019/8/14 11:52, Pratik Shinde wrote:
> Yes.since we already have a function with same name (and we are using it in same
> context).
> 'inode_loc' was the most meaningful name I could come up with :)

[snip]

On Wed, Aug 14, 2019@7:37 AM Gao Xiang <gaoxiang25@huawei.com> wrote:
> iloc is the name of static inline helper function in internal.h
> used for shorter lines...

Correct, so let's keep as it is.

Thanks,
