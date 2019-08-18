From: hsiangkao@aol.com (Gao Xiang)
Date: Sun, 18 Aug 2019 17:28:43 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
References: <20190817082313.21040-1-hsiangkao@aol.com>
 <1746679415.68815.1566076790942.JavaMail.zimbra@nod.at>
 <20190817220706.GA11443@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1163995781.68824.1566084358245.JavaMail.zimbra@nod.at>
 <20190817233843.GA16991@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1405781266.69008.1566116210649.JavaMail.zimbra@nod.at>
 <20190818084521.GA17909@hsiangkao-HP-ZHAN-66-Pro-G1>
 <1133002215.69049.1566119033047.JavaMail.zimbra@nod.at>
Message-ID: <20190818092839.GA18975@hsiangkao-HP-ZHAN-66-Pro-G1>

On Sun, Aug 18, 2019@11:03:53AM +0200, Richard Weinberger wrote:
> ----- Urspr??ngliche Mail -----
> > I agree with you, but what can we do now is trying our best to fuzz
> > all the fields.
> > 
> > So, what is your opinion about EROFS?
> 
> All I'm saying is that you should not blindly trust the disk.

I completely agree with you, and I'm teaching EROFS to
make the little naughty boy more strong... (we already
have many error handling code, but I think I will teach him
more, yes.)

> 
> Another thing that raises my attention is in superblock_read():
>         memcpy(sbi->volume_name, layout->volume_name,
>                sizeof(layout->volume_name));
> 
> Where do you check whether ->volume_name has a NUL terminator?
> Currently this field has no user, maybe will add a check upon usage.
> But this kind of things makes me wonder.

Yes, I think this is a good point. :)
Since volume_name is not used currently, I will fix it when
it use late.

I will make a note here (or more straightforward, I will fix it
to avoid potential bug now.)

Thanks,
Gao Xiang

> 
> Thanks,
> //richard
