From: pratikshinde320@gmail.com (Pratik Shinde)
Date: Wed, 7 Aug 2019 22:44:01 +0530
Subject: Test case suite for erofs.
In-Reply-To: <20190806160524.GA26612@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <CAGu0czRhmT7vSnFB-9pnJS=fhZp7RFL2ZwYfbc1RK-p5ddQ6tw@mail.gmail.com>
 <20190806160524.GA26612@hsiangkao-HP-ZHAN-66-Pro-G1>
Message-ID: <CAGu0czTjLixYux78ORnQEhx=VnMt_N_PaBAu1zbWAKXJTfo6Lw@mail.gmail.com>

Thanks for the comprehensive answer Gao !
So we can use this channel to post Test cases that we think are needed for
erofs.

--Pratik.

On Tue, Aug 6, 2019@9:35 PM Gao Xiang <hsiangkao@aol.com> wrote:

> Hi Pratik,
>
> On Tue, Aug 06, 2019@08:18:42PM +0530, Pratik Shinde wrote:
> > Hello Maintainers,
> >
> > I wanted to ask if there is any plan for writing a test case suite for
> > erofs. If not, how do you think is the idea of having a dedicated test
> case
> > suite, so as to maintain quality of fs?
> > Let me know your thoughts.
>
> Currently we have a modified ro-fsstress for EROFS to do fuzzer tests,
> and we have dedicated constructed images to do all regression tests.
>
> Yes, I personally think that is not enough (thus we have a large beta
> users as a supplement) and we asked squashfs maintainers for their tools
> last year but without any luck.
>
> new xfstest testcases for read-only filesystems developped by another
> HUAWEI
> team is also available at
> https://www.spinics.net/lists/fstests/msg11398.html
> but without further progress till now...
>
> It's better to develop more testcases for EROFS, and we can put forward
> xfstest as well. :)
>
> Thanks,
> Gao Xiang
>
> >
> > -Pratik
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20190807/3e2656fa/attachment.htm>
