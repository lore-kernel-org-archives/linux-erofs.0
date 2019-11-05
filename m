Return-Path: <SRS0=UCCL=Y5=lists.ozlabs.org=linux-erofs-bounces+linux-erofs=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF8BC5DF60
	for <linux-erofs@archiver.kernel.org>; Tue,  5 Nov 2019 15:47:08 +0000 (UTC)
Received: from lists.ozlabs.org (lists.ozlabs.org [203.11.71.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 097B521882
	for <linux-erofs@archiver.kernel.org>; Tue,  5 Nov 2019 15:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lists.ozlabs.org header.i=@lists.ozlabs.org header.b="B86xxeK0";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=android.com header.i=@android.com header.b="R8lPpHZa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 097B521882
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.ozlabs.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Received: from bilbo.ozlabs.org (lists.ozlabs.org [IPv6:2401:3900:2:1::3])
	by lists.ozlabs.org (Postfix) with ESMTP id 476vDV0wD9zF581
	for <linux-erofs@archiver.kernel.org>; Wed,  6 Nov 2019 02:47:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lists.ozlabs.org;
	s=201707; t=1572968826;
	bh=nTlZ4bvuiZC3UZLmcNtt6grhl9XFvxhvTEusTR40j08=;
	h=Subject:To:References:Date:In-Reply-To:List-Id:List-Unsubscribe:
	 List-Archive:List-Post:List-Help:List-Subscribe:From:Reply-To:Cc:
	 From;
	b=B86xxeK0vPfCjS9M217f8+gNSXaksoNazlxlK6/EKoHaQqfuqWcGCM63YK986jF2e
	 Up6lysK8KhMpw8xTbEXhUQf2jPfbD7HSq4I300zqOPNV1U2h0Zo8dDNZRzRCD76eVB
	 HsesNu8D2AIdInPZdIbKS9z5mR1tGdC5oD8Oaa3hvRDH8AesMLuAaLU0+givoSdzxk
	 15EK//fAkv6ItQ7SWCOVcM3osFkGEmDT2dXWBaa0iOsoca/bBsPm5Y91l9v+YC95Y2
	 NJT/y97QU4gn2SQ1hM27ED/kJA3yWQJ9fs+NH7Z1V+20TSOpOTSrLzK8/0yY6gqAAG
	 rJO8/OtXMh7eg==
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized)
 smtp.mailfrom=android.com (client-ip=2607:f8b0:4864:20::542;
 helo=mail-pg1-x542.google.com; envelope-from=salyzyn@android.com;
 receiver=<UNKNOWN>)
Authentication-Results: lists.ozlabs.org;
 dmarc=pass (p=reject dis=none) header.from=android.com
Authentication-Results: lists.ozlabs.org; dkim=pass (2048-bit key;
 unprotected) header.d=android.com header.i=@android.com header.b="R8lPpHZa"; 
 dkim-atps=neutral
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by lists.ozlabs.org (Postfix) with ESMTPS id 476v144BlSzF53t
 for <linux-erofs@lists.ozlabs.org>; Wed,  6 Nov 2019 02:37:11 +1100 (AEDT)
Received: by mail-pg1-x542.google.com with SMTP id 29so3161023pgm.6
 for <linux-erofs@lists.ozlabs.org>; Tue, 05 Nov 2019 07:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=android.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-transfer-encoding:content-language;
 bh=2/8/BwrhtmEXI7dj68SMTpCzdsjoLETsRSfZ5j8yePw=;
 b=R8lPpHZaNTKC1//4X3YRy/co01wfSuPnFkkkoDrdRRcs8xZqXtNYPLgm9OjzsXnJfg
 w/sgCdd9n+99HdKAd13HjrpckBRQK4F+I41/fuJw7ICMDJgQ0tKfn8kAw++u9jIK9Pl7
 wc3lGWI+tLAg5Fo7mlf+u1oz4ZCnt5dRpAwNiKM1EwVqGR4FwH3zMLPET/FX6DvXl/Cq
 XMn8MNwm1G21DoBMHo9twX6ox9SH+JhzmjDChdy5f2tzhmNnEaRv4FiGKkmYlD/OTP+l
 39M21mPDgGHAV1JVejM/uCulS4TGW/MwgQAeZfS0L3/q73lP5U74GqdSjn6t5WS3czii
 QV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=2/8/BwrhtmEXI7dj68SMTpCzdsjoLETsRSfZ5j8yePw=;
 b=OO5XD1ffjdC1HaaEk5tbhiwTQLb/d9MsdETP2SHvXY3nCMeDj87+o5swiOKltoyaGw
 QW89+0KYSfO5bQB6iOV2Xjm2s1OUagX5IhcU7yCvCKTkIe70aB1P4hVzJ9RmODMtkMxO
 I/YoCHKFEirKure5e8LpJ5X6ZR61bVL7uGvVoHj7B1aGHV6I4wb0R6r6u/uWVir+ygTk
 qxbw9KxLQbLO0JI7It9CzKFqOPdABBJzVplmSIbMwW70wdKW7Il1xHDzESlsnJ7M08qy
 mfb1euA2Rqmfy9LPcuEPeGKMFbrQ/xzIVypq8CqmJ2iPCH5+rTJ9tlkJRYNa59DRNgUZ
 g8kg==
X-Gm-Message-State: APjAAAXZSyQ2ZU0q07YMoGAKDwQTHH9dN70jwnG5xilXBY/mXnL0h1gP
 Xr27W5IWS0HztCWUPjBfc6Euew==
X-Google-Smtp-Source: APXvYqy6Q+jW7Nx8yhUJvITL/ENlgb+bvGP0zh9whSnmepYB/pthS+WgqdQwDBfJOEs5VO1iezn2Pw==
X-Received: by 2002:a62:e519:: with SMTP id n25mr38428065pff.144.1572968227784; 
 Tue, 05 Nov 2019 07:37:07 -0800 (PST)
Received: from nebulus.mtv.corp.google.com
 ([2620:15c:211:200:5404:91ba:59dc:9400])
 by smtp.googlemail.com with ESMTPSA id m13sm18037460pga.70.2019.11.05.07.37.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Nov 2019 07:37:07 -0800 (PST)
Subject: Re: [PATCH v15 1/4] Add flags option to get xattr method paired to
 __vfs_getxattr
To: Jan Kara <jack@suse.cz>
References: <20191104215253.141818-1-salyzyn@android.com>
 <20191104215253.141818-2-salyzyn@android.com>
 <20191105094830.GL22379@quack2.suse.cz>
Message-ID: <1de43656-e751-53a2-c0da-ff44ecbabbc4@android.com>
Date: Tue, 5 Nov 2019 07:37:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105094830.GL22379@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
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
From: Mark Salyzyn via Linux-erofs <linux-erofs@lists.ozlabs.org>
Reply-To: Mark Salyzyn <salyzyn@android.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>,
 jfs-discussion@lists.sourceforge.net, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Martin Brandenburg <martin@omnibond.com>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Artem Bityutskiy <dedekind1@gmail.com>,
 Adrian Hunter <adrian.hunter@intel.com>, David Howells <dhowells@redhat.com>,
 Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Eric Paris <eparis@parisplace.org>,
 Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, netdev@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org,
 Mike Marshall <hubcap@omnibond.com>, linux-xfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 Sage Weil <sage@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>,
 Richard Weinberger <richard@nod.at>, Mark Fasheh <mark@fasheh.com>,
 Eric Biggers <ebiggers@google.com>, Hugh Dickins <hughd@google.com>,
 James Morris <jmorris@namei.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>, cluster-devel@redhat.com,
 selinux@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
 Casey Schaufler <casey@schaufler-ca.com>, v9fs-developer@lists.sourceforge.net,
 Ilya Dryomov <idryomov@gmail.com>, linux-ext4@vger.kernel.org,
 Stephen Smalley <sds@tycho.nsa.gov>, linux-mm@kvack.org,
 Mark Salyzyn <salyzyn@google.com>, Serge Hallyn <serge@hallyn.com>,
 ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 Eric Van Hensbergen <ericvh@gmail.com>, linux-erofs@lists.ozlabs.org,
 Josef Bacik <josef@toxicpanda.com>, reiserfs-devel@vger.kernel.org,
 Miklos Szeredi <miklos@szeredi.hu>, Joel Becker <jlbec@evilplan.org>,
 linux-mtd@lists.infradead.org, Phillip Lougher <phillip@squashfs.org.uk>,
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 ceph-devel@vger.kernel.org, devel@lists.orangefs.org,
 Gao Xiang <xiang@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
 Paul Moore <paul@paul-moore.com>, linux-nfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mathieu Malaterre <malat@debian.org>,
 kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>,
 Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
 Tyler Hicks <tyhicks@canonical.com>, Steve French <sfrench@samba.org>,
 linux-security-module@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 Jan Kara <jack@suse.com>, Bob Peterson <rpeterso@redhat.com>,
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Woodhouse <dwmw2@infradead.org>,
 Anna Schumaker <anna.schumaker@netapp.com>, linux-btrfs@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org
Sender: "Linux-erofs"
 <linux-erofs-bounces+linux-erofs=archiver.kernel.org@lists.ozlabs.org>

On 11/5/19 1:48 AM, Jan Kara wrote:
>> @@ -228,11 +228,11 @@ static int afs_xattr_get_yfs(const struct xattr_handler *handler,
>>   		break;
>>   	case 1:
>>   		data = buf;
>> -		dsize = snprintf(buf, sizeof(buf), "%u", yacl->inherit_flag);
>> +		dsize = scnprintf(buf, sizeof(buf), "%u", yacl->inherit_flag);
>>   		break;
>>   	case 2:
>>   		data = buf;
>> -		dsize = snprintf(buf, sizeof(buf), "%u", yacl->num_cleaned);
>> +		dsize = scnprintf(buf, sizeof(buf), "%u", yacl->num_cleaned);
>>   		break;
>>   	case 3:
> These scnprintf() changes (and there are more in the patch) probably
> shouldn't be here... Otherwise the patch still looks good to me :).
>
> 								Honza
>
Good catch, they were done in locality, I forgot about them, this patch 
series has been living for almost a year now and time has become its 
enemy ... will spin this as a separate patch. They strike as a security 
issue with the possibility of fragile UAF when the code is maintained by 
future selves.

-- Mark

