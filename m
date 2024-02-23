Return-Path: <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 366F3C5478C
	for <linux-erofs@archiver.kernel.org>; Fri, 23 Feb 2024 20:02:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [IPv6:::1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4ThLWX69pFz3vY2
	for <linux-erofs@archiver.kernel.org>; Sat, 24 Feb 2024 07:02:00 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=145.40.73.55; helo=sin.source.kernel.org; envelope-from=srs0=wkxo=ka=goodmis.org=rostedt@kernel.org; receiver=lists.ozlabs.org)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4ThLWR3WzQz3dlY;
	Sat, 24 Feb 2024 07:01:55 +1100 (AEDT)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 8B5A9CE2E7B;
	Fri, 23 Feb 2024 20:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C71C433F1;
	Fri, 23 Feb 2024 20:01:46 +0000 (UTC)
Date: Fri, 23 Feb 2024 15:03:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [FYI][PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <20240223150339.2249bc95@gandalf.local.home>
In-Reply-To: <qsksxrdinia3cxr52tfe4p3pafsy4biktnodlfn4vyzud73p2j@6ycnhrhzwsv6>
References: <20240223125634.2888c973@gandalf.local.home>
	<0aed6cf2-17ae-45aa-b7ff-03da932ea4e0@quicinc.com>
	<20240223134653.524a5c9e@gandalf.local.home>
	<qsksxrdinia3cxr52tfe4p3pafsy4biktnodlfn4vyzud73p2j@6ycnhrhzwsv6>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-BeenThere: linux-erofs@lists.ozlabs.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: Development of Linux EROFS file system <linux-erofs.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linux-erofs/>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Help: <mailto:linux-erofs-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linux-erofs>,
 <mailto:linux-erofs-request@lists.ozlabs.org?subject=subscribe>
Cc: linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, brcm80211@lists.linux.dev, ath10k@lists.infradead.org, Julia Lawall <Julia.Lawall@inria.fr>, linux-s390@vger.kernel.org, dev@openvswitch.org, linux-cifs@vger.kernel.org, linux-bcachefs@vger.kernel.org, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, io-uring@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, ath11k@lists.infradead.org, linux-media@vger.kernel.org, linux-wpan@vger.kernel.org, linux-pm@vger.kernel.org, selinux@vger.kernel.org, linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-erofs@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org, linux-sound@vger.kernel.org, virtualization@lists.linux.dev, linux-block@vger.kernel.org, ocfs2-devel@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-cxl@vger.kernel.org, linux-tegra@vger.kernel.org, intel-xe@lists.freedesktop.org, linux-edac@vger.kernel.org, linu
 x-hwmon@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com, Jeff Johnson <quic_jjohnson@quicinc.com>, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, ath12k@lists.infradead.org, tipc-discussion@lists.sourceforge.net, Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>, freedreno@lists.freedesktop.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs" <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On Fri, 23 Feb 2024 14:50:49 -0500
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> Tangentially related though, what would make me really happy is if we
> could create the string with in the TP__fast_assign() section. I have to
> have a bunch of annoying wrappers right now because the string length
> has to be known when we invoke the tracepoint.

You can use __string_len() to determine the string length in the tracepoint
(which is executed in the TP_fast_assign() section).

My clean up patches will make __assign_str_len() obsolete too (I'm working
on them now), and you can just use __assign_str().

I noticed that I don't have a string_len example in the sample code and I'm
actually writing it now.

// cutting out everything else:

TRACE_EVENT(foo_bar,

	TP_PROTO(const char *foo, int bar),

	TP_ARGS(foo, bar),

	TP_STRUCT__entry(
		__string_len(	lstr,	foo,	bar < strlen(foo) ? bar : strlen(foo) )
	),

	TP_fast_assign(
		__assign_str(lstr, foo);

// Note, the above is with my updates, without them, you need to duplicate the logic

//		__assign_str_len(lstr, foo, bar < strlen(foo) ? bar : strlen(foo));
	),

	TP_printk("%s", __get_str(lstr))
);


The above will allocate "bar < strlen(foo) ? bar : strlen(foo)" size on the
ring buffer. As the size is already stored, my clean up code uses that
instead of requiring duplicating the logic again.

-- Steve
