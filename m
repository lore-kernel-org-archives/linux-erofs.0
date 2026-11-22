Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F77E606A332
	for <linux-erofs@archiver.kernel.org>; Sun, 22 Nov 2026 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2Hc6xFR
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jXjjZ4RGwz2ySH;
	Mon, 23 Nov 2026 09:02:26 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=172.105.4.254
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795384946;
	cv=none; b=ReEZdh1jjLjh0nE0OgXsrxe+BN9e3D2iLSeGMa5X7MOkLZwjaHFlohZkPh8teUeL6fa/lT2jdf+nWSVIJldWFrGRxFJk6MQW7xIgUoR6RTTkoGRizhoKZCJPMjqB89mpa9e6Pt/Zxfvpd2E37L0M/6goBGGBL160HV210FuVYQUiX5ILLlQscHB2e2uwsF+RnJoPf5JD4QHIM/+fp4ivTcClr513uuq1Xf9qDxveHo5wLV9mUd7waD5PoieSfVivk0kV8RgIujhrffpLeXvfdnxmSPbWLIkPXJ5eli3Rkw9uGcJxIe5CSSiUgDmF2EpR65CnJFk1Pac628NGFV3aCg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795384946; c=relaxed/relaxed;
	bh=sTtlSSaGTpDBtcMHiOircAIvmiTH+Ctop/XsFzGC1x4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Mae6KfZEQEKRhpXk+mOt150ASBC6TLLM9gU6TkfI/fBikHFsp/ctM6eYKM+kfDDiABTt9wGzvbxAaSBH1OOQwxCVuiPwh6KUUTb5ib7aBhgqn7cPgjeV/qYfjRhg1hbpYQ79yjWHkhMJT750NtrYzlJVTlCGnCBHfYbnUrK5ku7+noww2YxALLCcq+XG5m/YWVLsMaaAGY9wlBJPPlQwLNdGfF2bEh8sytHD6DYb5QVvE8XXQtFetb/EXEgi4eV9QYWkrXSuXMcqm9QMmO4OPQYUvSNtUnvgk5JVejOCLmYn3yGTkyidDjLBtml6Fob0O36+496mjQgP1qX/9G17dA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2Hc6xFR; dkim-atps=neutral; spf=pass (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=dakr@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k2Hc6xFR;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=172.105.4.254; helo=tor.source.kernel.org; envelope-from=dakr@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jXjjY4p2zz2yS6;
	Mon, 23 Nov 2026 09:02:25 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A73B7602C2;
	Sun, 22 Nov 2026 22:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DB11F000C6;
	Sun, 22 Nov 2026 22:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795384942;
	bh=sTtlSSaGTpDBtcMHiOircAIvmiTH+Ctop/XsFzGC1x4=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=k2Hc6xFRtkicPKFvuKT7zGdEMFSb//oYzAC6yGi4WET4vMctzGLV95ptNtrt42XPr
	 WQXnncoUOn8vCWB5V+5BOCSO1YRgvEGvWFlC6kSpFwx64JgBjdDeDjN8t0GAWjAHIl
	 OTUhOZXnH51x9+wu6dE5+5xRqac3uNPyE7pzVVKvZEWUvPhn37jeV+RfXXnvGy2n+o
	 5fpjybhz8GWsaKNEldr/b1vfp4LchA2oilYAZk48pyxh0hZg4h3t2J1QwAu6uVH9h7
	 a22sYJ2GBWGWAOsKWbURM4twq7Z2FvgS7RP2m5XNLf/srWoFugU+HT+1vi7WOYs8uY
	 PaUfPtPCWI/6w==
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
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 22 Nov 2026 23:02:06 +0100
Message-Id: <DN22U90WCTGB.1REAOP1PQUMIQ@kernel.org>
Subject: Re: [PATCH v4 0/9] Add __must_init and require explicit
 kobj_type::release
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Kees Cook"
 <kees@kernel.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Rafael J . Wysocki"
 <rafael@kernel.org>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Srish
 Srinivasan" <ssrish@linux.ibm.com>, "Michael Ellerman"
 <mpe@ellerman.id.au>, "Nicholas Piggin" <npiggin@gmail.com>, "Christophe
 Leroy" <chleroy@kernel.org>, "Nayna Jain" <nayna@linux.ibm.com>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Yoshinori Sato"
 <ysato@users.sourceforge.jp>, "Rich Felker" <dalias@libc.org>, "John Paul
 Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>, "Juergen Gross"
 <jgross@suse.com>, "Stefano Stabellini" <sstabellini@kernel.org>,
 "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>, "Nathan Chancellor"
 <nathan@kernel.org>, "Nick Desaulniers" <ndesaulniers@google.com>, "Viresh
 Kumar" <viresh.kumar@linaro.org>, "Zhongqiu Han"
 <zhongqiu.han@oss.qualcomm.com>, "Alexander Aring" <aahringo@redhat.com>,
 "Felix Kuehling" <felix.kuehling@amd.com>, =?utf-8?q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, "Zhihao Cheng" <chengzhihao1@huawei.com>,
 "Sumanth Korikkar" <sumanthk@linux.ibm.com>, "Bill Wendling"
 <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 <driver-core@lists.linux.dev>, <llvm@lists.linux.dev>,
 <linux-hardening@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-sh@vger.kernel.org>, <linux-s390@vger.kernel.org>,
 <gfs2@lists.linux.dev>, <xen-devel@lists.xenproject.org>,
 <linux-mtd@lists.infradead.org>, <amd-gfx@lists.freedesktop.org>,
 <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
 <agordeev@linux.ibm.com>, <airlied@gmail.com>, <alexander.deucher@amd.com>,
 <catalin.marinas@arm.com>, <chao@kernel.org>, <deller@gmx.de>,
 <dennis.dalessandro@cornelisnetworks.com>, <dmaengine@vger.kernel.org>,
 <gor@linux.ibm.com>, <hca@linux.ibm.com>, <jaegeuk@kernel.org>,
 <James.Bottomley@HansenPartnership.com>, <jgg@ziepe.ca>,
 <jlbec@evilplan.org>, <johan@kernel.org>, <joseph.qi@linux.alibaba.com>,
 <leon@kernel.org>, <lihuisong@huawei.com>, <linusw@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-erofs@lists.ozlabs.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-fbdev@vger.kernel.org>,
 <linux-omap@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <mark@fasheh.com>, <neescoba@cisco.com>,
 <ocfs2-devel@lists.linux.dev>, <satishkh@cisco.com>, <simona@ffwll.ch>,
 <sre@kernel.org>, <vkoul@kernel.org>, <will@kernel.org>, <xiang@kernel.org>
To: "Ian Rogers" <irogers@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20261119192520.1983406-1-irogers@google.com>
 <20261122215639.1178566-1-dakr@kernel.org>
In-Reply-To: <20261122215639.1178566-1-dakr@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(Cc: more people previously Cc'd on v2)

On Sun Nov 22, 2026 at 10:56 PM CET, Danilo Krummrich wrote:
> On Thu, 19 Nov 2026 11:25:11 -0800, Ian Rogers wrote:
>> [PATCH v4 0/9] Add __must_init and require explicit kobj_type::release
>
> Applied, thanks!
>
>   Branch: driver-core-testing
>   Tree:   git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/drive=
r-core.git
>
> [1/9] Compiler Attributes: Add __must_init macro
>       commit: b8a53320a885
> [2/9] powerpc/secvar: Add missing kobject release callback to secvar_ktyp=
e
>       commit: 4d5d4dd2a2e2
> [3/9] sh: sq: Add missing kobject release callback to ktype_percpu_entry
>       commit: d19384f2f3c7
> [4/9] cpufreq: governor: Initialize kobj_type release callback statically
>       commit: 009365942c15
> [5/9] dlm: Wait for kobject release before freeing dlm_ls
>       commit: 48ae948f4285
> [6/9] xen/sys-hypervisor: Add release callback to hyp_sysfs_kobj_type
>       commit: ecaf88d385c1
> [7/9] ubifs: sysfs: Use kset_create_and_add() for ubifs_kset
>       commit: 25d952902dee
> [8/9] drm/amdkfd: Free queue in procfs_queue_type kobject release callbac=
k
>       commit: 6d4ff4a020cf
> [9/9] kobject: Require explicit initialization of struct kobj_type::relea=
se
>       commit: 45eeed1f8094
>
> The patches will appear in the next linux-next integration (typically wit=
hin 24
> hours on weekdays).
>
> The patches are in the driver-core-testing branch and will be promoted to
> driver-core-next after validation.

I've now picked this up; I will keep this series in driver-core-testing for=
 a
few more days before moving it to driver-core-next. Please let me know if t=
here
are any concerns with the series, particularly the comments in patch 9.

Thanks,
Danilo

