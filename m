From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 18 Aug 2019 16:45:25 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
Message-ID: <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>

On Sun, Aug 18, 2019@10:16:50AM +0200, Richard Weinberger wrote:
> ----- Urspr?ngliche Mail -----
> >> While digging a little into the code I noticed that you have very few
> >> checks of the on-disk data.
> >> For example ->u.i_blkaddr. I gave it a try and created a
> >> malformed filesystem where u.i_blkaddr is 0xdeadbeef, it causes the kernel
> >> to loop forever around erofs_read_raw_page().
> > 
> > I don't fuzz all the on-disk fields for EROFS, I will do later..
> > You can see many in-kernel filesystems are still hardening the related
> > stuff. Anyway, I will dig into this field you mentioned recently, but
> > I think it can be fixed easily later.
> 
> This is no excuse to redo all these bugs. :-)

I agree with you, but what can we do now is trying our best to fuzz
all the fields.

So, what is your opinion about EROFS?

> 
> I know that many in-kernel filesystems trust the disk ultimately, this is a
> problem and huge attack vector.

I EROFS already has many error handing paths to recover corrupted images,
and your discovery is a bug out of one error handing path miswritten by me.
I cannot make a guarantee that all the new things (every new kernel version
will introduce new feature / new code) are bug-free since I am not a machine
or code parser.

My answer about this EROFS will be more stable with our development, we have
a dedicated team with paid job, and since we currently use EROFS on the top of
dm-verity for current Android, which will keep us from corrupted images.
But yes, we will focus on fuzzing all the images for generic usages,
and we will backport all these patches to old stable versions.

Thanks,
Gao Xiang

> 
> Thanks,
> //richard
