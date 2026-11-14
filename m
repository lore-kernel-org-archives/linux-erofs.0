Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FAA606A330
	for <linux-erofs@archiver.kernel.org>; Sat, 14 Nov 2026 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ogihjrtX
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jRXdD6sl3z30VT;
	Sat, 14 Nov 2026 22:55:44 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::530"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794657344;
	cv=none; b=iPgUs5iB0PGns4WxDaTRtEpWjelyqA8Hh0xkYQGiFxx5JyuQGI+F9WKuvxsSu1ebcS5B9629i+8PUIu6qGplFgfA73KsG+kN3lYAspLQ1dxSXwW7XWidiP9F+P8XTNd7J/FbDztV4233cPhJcAAtYNDW5Ub0t9gr6h2bc3fjJvtjTlFKREduA5DvxYdW6oFo+GlIb8+/U/V52Mqei5XUemer1hHn7tMAcJWp33kz3dWpHM0pm4dbTZU1oJFmHbdp6C4Im9UvHea5ME5bdu0WwPQ9og26tHLnwP2t99X1bVYKxDKd6MGZllMtFqxoOiDa2ndpT0jRWnk3U1elhvyiYA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794657344; c=relaxed/relaxed;
	bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpDvsLBnbG3TOGJ+f92aPI+/6VHhmjOcsLP1T1IeyvLpRXU1hZLhH7yjLWUF/ch+yvismeb4PfKQRPYOXLCh3/eHXfQL2PJSRldPGlmMU6wMpV6If64+xzpZTX7r1M81s+dW26JmiwF5Rj7sRqll7N/vew3IsGjgecmgyUs9bOAtC+nMbpDhKW287jK9xJckPOmC3wDgjvIzBnxWLt6TD/LOjMO8cJd//MKhYOR61oH3WE3p/5KtS9IqufGGp2lYTFIs5xco0O/blv5k8y74Lpt8lNXyHTIGOPIknvdwRCPoKs/vsI6qQ2qBNvquZdRyiQtaWIu46OoxA0H+H38hAg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com; dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ogihjrtX; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::530; helo=mail-ed1-x530.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org) smtp.mailfrom=gmail.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ogihjrtX;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=gmail.com (client-ip=2a00:1450:4864:20::530; helo=mail-ed1-x530.google.com; envelope-from=amir73il@gmail.com; receiver=lists.ozlabs.org)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jRXdB5y5xz30Lw
	for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 22:55:41 +1100 (AEDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-6b633ddfad6so3261700a12.3
        for <linux-erofs@lists.ozlabs.org>; Sat, 14 Nov 2026 03:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794657337; x=1795262137; darn=lists.ozlabs.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=ogihjrtXfGm9JQvbk00KbXfqXPO7Yp1GaAaiKdNmCstKlmYxX2zzLimrSZEy4tsFlp
         A6t8rE6ybVO4gZS3urgDXp/nBoqaR/jkCFH4xwzkc5pXUwAEU7qdstkI5LI97jcik6Xa
         O1T10hg/PmuNwywTjPMBLi+1fPZCWTnEqAvwRpJCqaydU9m9vpZNQtV9s2cKasc3gN5m
         QQQdY2qqQmZL2dEkFRsQ/NxqLubpy5P+mbqkP9iHBjxmxQdnaGPLhFQ0uO03+Bk1eCWK
         zk0fyRzvlxyomR6swcg5K+mI1nTef9Rn2k+YiFv/NeFNFZASKS29Ik5vwByEFIJmVwHo
         YXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794657337; x=1795262137;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=TxcmBADMDaV02skCosX1dAfYVHqKaHjRg1R2CgMmmUGvJdaCN3HeV1de+G9zuzYv5l
         EyDM9e8OChxD0Ff2vnzWK52Labbb9pYQLcMRmPcIQEQx3BZb1i/Ui2jsc1T0psedHbTP
         AfjbW6Kbz9wd/166Ozl0xTht6NKf+LYcb4AjaSu0Wa8YNzjhy9hfTOicYMEiWrZp7eQp
         FQLlZNmyadntpicyz8wGHPPzZnuQRoZWlgOmZ0JHUl56QRJsZFC8LDORX2S86ZgkhsKc
         nI3Rnz41/WQu+jPO0aLz3HTRM+RogmPvKbBnw+q3fI420Mqvj3vycb1wRmMv2qf0DYnC
         AaHg==
X-Forwarded-Encrypted: i=1; AL+hErF5v9xnhkCe/JjdQ0+IdPUddI8LE60yfhQAS0PDUZ245vVsiwBxuOe6VAb2dRvnW343Ox+4I8lrZfl+9g==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z/95J2Nsckakc2vS1TXJQV2YdbkRsVb5Sh56vsiy7/6Z50G7S6Y
	aiahVPVykCnBUDl5FFVmCt6X3WpO9tSOZScW9AEXek/8fDIqnBddFqhW
X-Gm-Gg: AYBFou0114lLaz5SksC8OyMotP629qUOfkycc8PgjjO5k20iATH2pYtQ7kqiVEcw29o
	4nZvOMkOqkOZwkUzP69BtmL4LM6VeOnnXNjSE2upb6NZP4BgLK5YHA+WhfE7HcsiopXrnjBstS6
	jAMras1WTY7PWHnt8bfWrHKnijmBUA0VmQSHz/DqnQUNPjR0RdNcJ9YxgcFb8+oZPdMDl7KKW1S
	OVtG9qgfWAw7S4JzAESubyafLzgbZVvz/mePl03Q6f7hIy4yIl81SJyg+Ns8Tpeleat2s9qY3AJ
	ze0Yy+EaACkMCs25I+ZgAsr2KiVfruLQUlU5WS475YRlh0wwU61RuCjqV/oWbglEKBXyLOQ9220
	FDZyevDdtem8NeWzpudGNr/WAKKLk2a6OqNqMpSAZdc39vuVSLn0XxI4fWEK0bJ2x0csGBj5GH3
	x+3jvCK7F0Vjz9zo5KUp2gEafCQ60n53fB10qrFlJ9zPMn4HAMDuwm9AzhyBgbDJ3G3er2aL11Y
	H1LkAHsNphniTZD2xjrAO5iBj0UUjjujr36sC7j+SYMgm1TI2pUx4tihe20dN+7GUbeppR3YjLy
	1lbEeWBDmEByuXgIrHt653Z5BQ4ydzi89nPqbSiSVHLhJ4yBUGOf4NwY6B3gBTqEgG+JQ2/oshj
	BgSejvEDBRr4=
X-Received: by 2002:a17:907:3e10:b0:c40:231:6eab with SMTP id a640c23a62f3a-c5096370c31mr441592966b.16.1794657336589;
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b41f44sm206223866b.31.2026.11.14.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Date: Sat, 14 Nov 2026 12:55:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avhMN39TECaur0sS@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
 <20261111151202.GA11391@lst.de>
 <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
Precedence: list
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 11:25:57AM +0100, Alexander Mikhalitsyn wrote:
> Hi Christoph,
> 
> On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> > I've seen setups where people use fuse to mediate access to sysfs
> > sysfs in odd ways.  No idea if that's still around, but if so, this
> > patch will break it.
> 
> 
> Oh, that's painful. Do they use backing files for that?
> It's a relatively new feature in FUSE...
> 

Very unlikely that they use FUSE passthrough and if they did
very unlikely that it would break their filesystem.

The API for fuse passthrough is that the server requests to setup a
backing file before open via ioctl and if ioctl fails (as this patch
does) then server falls back to non-passthrough open.

The ioctl can already fail for many reasons such as MAX_STACK_DEPTH on
procfs as the commit message says, so server needs to cope with the
fall back.

Thanks,
Amir.

