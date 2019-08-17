From: richard@nod.at (Richard Weinberger)
Date: Sun, 18 Aug 2019 01:25:58 +0200 (CEST)
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>

----- Urspr?ngliche Mail -----
>> How does erofs compare to squashfs?
>> IIUC it is designed to be faster. Do you have numbers?
>> Feel free to point me older mails if you already showed numbers,
>> I have to admit I didn't follow the development very closely.
> 
> You can see the following related material which has microbenchmark
> tested on my laptop:
> https://static.sched.com/hosted_files/kccncosschn19eng/19/EROFS%20file%20system_OSS2019_Final.pdf
> 
> which was mentioned in the related topic as well:
> https://lore.kernel.org/r/20190815044155.88483-1-gaoxiang25 at huawei.com/

Thanks!
Will read into.

While digging a little into the code I noticed that you have very few
checks of the on-disk data.
For example ->u.i_blkaddr. I gave it a try and created a
malformed filesystem where u.i_blkaddr is 0xdeadbeef, it causes the kernel
to loop forever around erofs_read_raw_page().

Thanks,
//richard
