From: nitin.gupta981@gmail.com (Nitin Gupta)
Date: Fri, 31 Aug 2018 16:53:53 +0530
Subject: SKylake Edac support in linux 2.6.32.696 kernel build
In-Reply-To: <CAB3_1NuNyrBYx2M1iKOYb+rTRXW+p1gB-1VTaBymVBvRHvDSMA@mail.gmail.com>
References: <CAB3_1NuNyrBYx2M1iKOYb+rTRXW+p1gB-1VTaBymVBvRHvDSMA@mail.gmail.com>
Message-ID: <CAB3_1Nv8=KvbAnMsOwxpqfrNU7+Xf8napS12b3yt_fCP4JuyBA@mail.gmail.com>

There are below link also found


./sys/devices/mc/mc0
./sys/bus/mc0
./sys/bus/mc0/devices/mc0

On Fri, Aug 31, 2018 at 4:46 PM, Nitin Gupta <nitin.gupta981 at gmail.com>
wrote:

> Hi All
>
> I  started back porting  Skylake Edac driver from 4.8 kernel to 2.6.696
> kernel
> i am not getting the memory controller entries inside
> /sys/devices/system/edac/
>
> i am able to get the entries inside
>
> /sys/bus/edac/devices/mc/
> /sys/devices/mc/
>
> Any help will be appreciated .
>
> Regards
> Nitin
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://lists.ozlabs.org/pipermail/linux-erofs/attachments/20180831/ac981841/attachment.html>
