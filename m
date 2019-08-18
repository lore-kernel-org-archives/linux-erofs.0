From: hsiangkao@aol.com (Gao Xiang)
Date: Mon, 19 Aug 2019 00:03:11 +0800
Subject: [PATCH] erofs: move erofs out of staging
In-Reply-To: <20190818151154.GA32157@mit.edu>
Message-ID: <20190818160305.GA31588@hsiangkao-HP-ZHAN-66-Pro-G1>

Hi Ted,

On Sun, Aug 18, 2019@11:11:54AM -0400, Theodore Y. Ts'o wrote:
> On Sun, Aug 18, 2019@11:21:13AM +0200, Richard Weinberger wrote:
> > > Not to say that erofs shouldn't be worked on to fix these kinds of
> > > issues, just that it's not an unheard of thing to trust the disk image.
> > > Especially for the normal usage model of erofs, where the whole disk
> > > image is verfied before it is allowed to be mounted as part of the boot
> > > process.
> > 
> > For normal use I see no problem at all.
> > I fear distros that try to mount anything you plug into your USB.
> > 
> > At least SUSE already blacklists erofs:
> > https://github.com/openSUSE/suse-module-tools/blob/master/suse-module-tools.spec#L24
> 
> Note that of the mainstream file systems, ext4 and xfs don't guarantee
> that it's safe to blindly take maliciously provided file systems, such
> as those provided by a untrusted container, and mount it on a file
> system without problems.  As I recall, one of the XFS developers
> described file system fuzzing reports as a denial of service attack on
> the developers.  And on the ext4 side, while I try to address them, it
> is by no means considered a high priority work item, and I don't
> consider fixes of fuzzing reports to be worthy of coordinated
> disclosure or a high priority bug to fix.  (I have closed more bugs in
> this area than XFS has, although that may be that ext4 started with
> more file system format bugs than XFS; however given the time to first
> bug in 2017 using American Fuzzy Lop[1] being 5 seconds for btrfs, 10
> seconds for f2fs, 25 seconds for reiserfs, 4 minutes for ntfs, 1h45m
> for xfs, and 2h for ext4, that seems unlikely.)
> 
> [1] https://events.static.linuxfound.org/sites/events/files/slides/AFL%20filesystem%20fuzzing%2C%20Vault%202016_0.pdf
> 
> So holding a file system like EROFS to a higher standard than say,
> ext4, xfs, or btrfs hardly seems fair.  There seems to be a very
> unfortunate tendancy for us to hold new file systems to impossibly
> high standards, when in fact, adding a file system to Linux should
> not, in my opinion, be a remarkable event.  We have a huge number of
> them already, many of which are barely maintained and probably have
> far worse issues than file systems trying to get into the clubhouse.
> 
> If a file system is requesting core changes to the VM or block layers,
> sure, we should care about the interfaces.  But this nitpicking about
> whether or not a file system can be trusted in what I consider to be
> COMPLETELY INSANE CONTAINER USE CASES is really not fair.

Thanks for your kind reply and understanding...

Yes, EROFS is now still like a little baby, and what I can do is to write
more code to make it grown up... but I personally cannot write bug-free
code all the time (because sometimes I could be in a low mood...)

In the past year, we already adds many error handling path for corrupted
images and handles all BUG_ONs in a more proper way... we are doing our best...

Our team will continue focusing on all bug reports from external /
internal sources and fix them all in time. and for more wider scenerios,
I'd like to build an autofuzzer tools based on erofs-utils to make EROFS
more strong as one of the next step.

Thanks,
Gao Xiang


> 
> Cheers,
> 
> 						- Ted
