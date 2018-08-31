From: nitin.gupta981@gmail.com (Nitin Gupta)
Date: Fri, 31 Aug 2018 23:22:06 +0530
Subject: SKylake Edac support in linux 2.6.32.696 kernel build
In-Reply-To: <20180831161450.GB26043@kroah.com>
References: <CAB3_1NuNyrBYx2M1iKOYb+rTRXW+p1gB-1VTaBymVBvRHvDSMA@mail.gmail.com>
 <20180831161450.GB26043@kroah.com>
Message-ID: <CAB3_1Ns_Zg0FLn4Yo2kOMtZVQvh-mNeGUqGOe2Hi5HEXJqXQBw@mail.gmail.com>

Hi Greg

Thanks for your comments  but somehow i cant use the latest kernel .
i am able to compile skx_edac.c to the kernel .but if some body can tell
how controller directory will be getting added will be good.

Some more output from the kernel

 cd /sys/devices/system/edac/

 ls -la
total 0
drwxr-xr-x 3 admin root 0 Aug 30 19:53 .
drwxr-xr-x 14 admin root 0 Aug 30 19:53 ..
drwxr-xr-x 2 admin root 0 Aug 30 19:53 power
rw-rr- 1 admin root 4096 Aug 30 20:00 uevent

cd /sys/bus/edac
 ls -la
total 0
drwxr-xr-x 4 admin root 0 Aug 30 19:53 .
drwxr-xr-x 21 admin root 0 Aug 30 19:57 ..
drwxr-xr-x 2 admin root 0 Aug 30 19:53 devices
drwxr-xr-x 2 admin root 0 Aug 30 19:53 drivers
rw-rr- 1 admin root 4096 Aug 30 19:59 drivers_autoprobe
-w------ 1 admin root 4096 Aug 30 19:59 drivers_probe
-w------ 1 admin root 4096 Aug 30 19:53 uevent



cd /sys/bus/edac/devices/mc/
 ls -la
total 0
drwxr-xr-x 7 admin root 0 Aug 30 19:53 .
drwxr-xr-x 21 admin root 0 Aug 30 19:53 ..
drwxr-xr-x 3 admin root 0 Aug 30 19:53 mc0
drwxr-xr-x 3 admin root 0 Aug 30 19:53 mc1
drwxr-xr-x 3 admin root 0 Aug 30 19:53 mc2
drwxr-xr-x 3 admin root 0 Aug 30 19:53 mc3
drwxr-xr-x 2 admin root 0 Aug 30 19:53 power
lrwxrwxrwx 1 admin root 0 Aug 30 19:59 subsystem -> ../../bus/edac
rw-rr- 1 admin root 4096 Aug 30 19:53 uevent

   - <https://jira.rvbdtechlabs.net/secure/AddComment!default.jspa?id=95528>




Regards
Nitin

On Fri, Aug 31, 2018 at 9:44 PM, Greg Kroah-Hartman <
gregkh@linuxfoundation.org> wrote:

> On Fri, Aug 31, 2018@04:46:41PM +0530, Nitin Gupta wrote:
> > Hi All
> >
> > I  started back porting  Skylake Edac driver from 4.8 kernel to 2.6.696
> > kernel
>
> Ick, why would you ever want to do that?  Just use a newer kernel
> please.  If you really want to do this, you are on your own.
>
> good luck!
>
> greg k-h
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20180831/d969f216/attachment.html>
