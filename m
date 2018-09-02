From: gregkh@linuxfoundation.org (Greg Kroah-Hartman)
Date: Sun, 2 Sep 2018 17:02:09 +0200
Subject: SKylake Edac support in linux 2.6.32.696 kernel build
In-Reply-To: <CAB3_1Nv2P7uh6ypy4RXQXejeJ9PpF2KWdFK3V5OPHq_+4rANAw@mail.gmail.com>
References: <CAB3_1NuNyrBYx2M1iKOYb+rTRXW+p1gB-1VTaBymVBvRHvDSMA@mail.gmail.com>
 <20180831161450.GB26043@kroah.com>
 <CAB3_1Ns_Zg0FLn4Yo2kOMtZVQvh-mNeGUqGOe2Hi5HEXJqXQBw@mail.gmail.com>
 <20180831194727.GA8631@kroah.com>
 <CAB3_1Nv2P7uh6ypy4RXQXejeJ9PpF2KWdFK3V5OPHq_+4rANAw@mail.gmail.com>
Message-ID: <20180902150209.GA25883@kroah.com>

On Sun, Sep 02, 2018@03:45:01PM +0530, Nitin Gupta wrote:
> Hi Greg
> 
> i am working on some project which is having huge changes and working
> on kernel-2.6.32-131.696
>  it will be very difficult to back port them into 4.8 .

Why 4.8?  That too is a totally unsupported kernel version.

Anyway, randomly pulling in a driver from a newer by many years, if not
almost a decade old (2.6.32 was released in 2009), is a very difficult
task, and usually almost impossible to go that far back.  That is not
how Linux is developed or meant to be worked with at all.

You are _really_ on your own here, only do this if you _really_ know
what you are doing.  Even then, I would not recommend you do this, as
you are guaranteeing to create a monstrosity that only you can support,
for forever, on your own.

good luck!

greg k-h
