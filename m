From: gaoxiang25@huawei.com (Gao Xiang)
Date: Thu, 18 Jul 2019 09:32:11 +0800
Subject: erofs compilation failure.
In-Reply-To: <CAGu0czSPMpsmWxxmBYk96t3ixO=_vnNXXveZNzR-dhQSg_mtfg@mail.gmail.com>
References: <CAGu0czSPMpsmWxxmBYk96t3ixO=_vnNXXveZNzR-dhQSg_mtfg@mail.gmail.com>
Message-ID: <56c96bca-fc01-fa3d-67e2-920a9c4afc61@huawei.com>



On 2019/7/18 3:47, Pratik Shinde wrote:
> Hi All,
> 
> I hope this is the correct channel to talk about this issue.
> I am trying to compile erofs with latest kernel source as follows:
> 
> ps at ps:~/linux/drivers/staging/erofs$ pwd
> /home/ps/linux/drivers/staging/erofs
> ps at ps:~/linux/drivers/staging/erofs$ ?make -C ~/linux? M=`pwd`
> make: Entering directory '/home/ps/linux'
> make[1]: *** No rule to make target '/home/ps/linux/drivers/staging/erofs/super.o', needed by '/home/ps/linux/drivers/staging/erofs/erofs.o'.? Stop.
> Makefile:1612: recipe for target '_module_/home/ps/linux/drivers/staging/erofs' failed
> make: *** [_module_/home/ps/linux/drivers/staging/erofs] Error 2
> make: Leaving directory '/home/ps/linux'
> 
> I ran the above make command under strace, it looks like make is not able to locate dependent '.o' files, e.g data.o, super.o etc. But, its should compile those dependencies first ? In the strace I cannot see gcc invoked on this '.c' files.
> 
> Is this the correct way of compiling the source ?

seems not.. Actually the question is not for erofs development.
I didn't observe any compile error on erofs.

Could you please refer guides on the internet?

Thanks,
Gao Xiang

> Help appreciated. !
> 
> Thank you.
> --Pratik.
> 
