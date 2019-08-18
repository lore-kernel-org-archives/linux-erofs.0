From: richard@nod.at (Richard Weinberger)
Date: Sun, 18 Aug 2019 10:16:50 +0200 (CEST)
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>

----- Urspr?ngliche Mail -----
>> While digging a little into the code I noticed that you have very few
>> checks of the on-disk data.
>> For example ->u.i_blkaddr. I gave it a try and created a
>> malformed filesystem where u.i_blkaddr is 0xdeadbeef, it causes the kernel
>> to loop forever around erofs_read_raw_page().
> 
> I don't fuzz all the on-disk fields for EROFS, I will do later..
> You can see many in-kernel filesystems are still hardening the related
> stuff. Anyway, I will dig into this field you mentioned recently, but
> I think it can be fixed easily later.

This is no excuse to redo all these bugs. :-)

I know that many in-kernel filesystems trust the disk ultimately, this is a
problem and huge attack vector.

Thanks,
//richard
