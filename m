From: pratikshinde320@gmail.com (Pratik Shinde)
Date: Thu, 18 Jul 2019 01:17:35 +0530
Subject: erofs compilation failure.
Message-ID: <CAGu0czSPMpsmWxxmBYk96t3ixO=_vnNXXveZNzR-dhQSg_mtfg@mail.gmail.com>

Hi All,

I hope this is the correct channel to talk about this issue.
I am trying to compile erofs with latest kernel source as follows:

ps at ps:~/linux/drivers/staging/erofs$ pwd
/home/ps/linux/drivers/staging/erofs
ps at ps:~/linux/drivers/staging/erofs$  make -C ~/linux  M=`pwd`
make: Entering directory '/home/ps/linux'
make[1]: *** No rule to make target
'/home/ps/linux/drivers/staging/erofs/super.o', needed by
'/home/ps/linux/drivers/staging/erofs/erofs.o'.  Stop.
Makefile:1612: recipe for target
'_module_/home/ps/linux/drivers/staging/erofs' failed
make: *** [_module_/home/ps/linux/drivers/staging/erofs] Error 2
make: Leaving directory '/home/ps/linux'

I ran the above make command under strace, it looks like make is not able
to locate dependent '.o' files, e.g data.o, super.o etc. But, its should
compile those dependencies first ? In the strace I cannot see gcc invoked
on this '.c' files.

Is this the correct way of compiling the source ?
Help appreciated. !

Thank you.
--Pratik.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190718/3d96667c/attachment.htm>
