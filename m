From: hsiangkao@aol.com (Gao Xiang)
Date: Thu, 8 Aug 2019 02:34:05 +0800
Subject: Test case suite for erofs.
In-Reply-To: <CAGu0czTjLixYux78ORnQEhx=VnMt_N_PaBAu1zbWAKXJTfo6Lw@mail.gmail.com>
References: <CAGu0czRhmT7vSnFB-9pnJS=fhZp7RFL2ZwYfbc1RK-p5ddQ6tw@mail.gmail.com>
 <20190806160524.GA26612@hsiangkao-HP-ZHAN-66-Pro-G1>
 <CAGu0czTjLixYux78ORnQEhx=VnMt_N_PaBAu1zbWAKXJTfo6Lw@mail.gmail.com>
Message-ID: <20190807183403.GB13848@hsiangkao-HP-ZHAN-66-Pro-G1>

On Wed, Aug 07, 2019@10:44:01PM +0530, Pratik Shinde wrote:
> Thanks for the comprehensive answer Gao !
> So we can use this channel to post Test cases that we think are needed for
> erofs.

Yeah, it's a pretty good thing to see some new EROFS specfic
test cases are developped later. come on! :)

Thanks,
Gao Xiang

> 
> --Pratik.
> 
> On Tue, Aug 6, 2019@9:35 PM Gao Xiang <hsiangkao@aol.com> wrote:
> 
> > Hi Pratik,
> >
> > On Tue, Aug 06, 2019@08:18:42PM +0530, Pratik Shinde wrote:
> > > Hello Maintainers,
> > >
> > > I wanted to ask if there is any plan for writing a test case suite for
> > > erofs. If not, how do you think is the idea of having a dedicated test
> > case
> > > suite, so as to maintain quality of fs?
> > > Let me know your thoughts.
> >
> > Currently we have a modified ro-fsstress for EROFS to do fuzzer tests,
> > and we have dedicated constructed images to do all regression tests.
> >
> > Yes, I personally think that is not enough (thus we have a large beta
> > users as a supplement) and we asked squashfs maintainers for their tools
> > last year but without any luck.
> >
> > new xfstest testcases for read-only filesystems developped by another
> > HUAWEI
> > team is also available at
> > https://www.spinics.net/lists/fstests/msg11398.html
> > but without further progress till now...
> >
> > It's better to develop more testcases for EROFS, and we can put forward
> > xfstest as well. :)
> >
> > Thanks,
> > Gao Xiang
> >
> > >
> > > -Pratik
> >
