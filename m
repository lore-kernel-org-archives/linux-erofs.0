Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B00606A31D
	for <linux-erofs@archiver.kernel.org>; Fri, 30 Oct 2026 13:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fpb+Z+Ix
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jGM1L6qssz30Vm;
	Sat, 31 Oct 2026 00:11:18 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2600:3c04:e001:324:0:1991:8:25"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1793365878;
	cv=none; b=CPQcUpph1ClALacf30AX3DXBQqe3DLLx6ivqOqPNy2b42qy42xjz6qfl33c++34LWtB0fzpQRoMJZEMKELnVX96jXDTInQfq7oD4RjrwbduPR7/Gf1rOazWaLm5iH9+W+TDwr+D3c4fTjt8I7K3RMCJb6d/8RDJ81KahJVib+BMZ92HV6YTrAme1sDGnndClN56RnN66kEc7AkdEgoZxB+bz5U7oDTwWJZzsAWk/Wk3gdv9FR4bU9wYPXv2LgvN5Hwprts1AplIpdswyhl1/C/E/waM4uOdcjccOnOwYaA+VSveLetOoHXkhxrJHj5jlDrNOTqM87sUE9duotIkVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1793365878; c=relaxed/relaxed;
	bh=uFwc7OGwgV6qEbtcl4yUPDjOXOBRcbZ3GesOPunvbTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/BqA2uHLWC76uMAJbXWd3IwQObAh3I14czRVa9IGffR1xGk41TInr4gixmqJlzIN7mg1nCLXRuoWYG2JLc78BGiW1alpKNLn7a9BtoWrd5BdfBpgtghK/dj3N0cDzzmuCo6qBuxNLfr2Foakf5WgGWgd6DT9WzVdX4FdCftLKhMJA/KE+mxM2RLjbb7ipmJ4yx0f3Vzjl+ByZFwBIs529xq52O4kr3LPCreCeDS/PM6eF2UGW+OzamCFzzvTX/wdJxXFdCgZ5NQu8gYMFJ//hToR4bs6WB9JP0rMoT/LGvBe/wv4aPGwy0aS9wPKpiRp5rtOP3zkBMb7yXYYZzD9A==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org; dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fpb+Z+Ix; dkim-atps=neutral; spf=pass (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org) smtp.mailfrom=kernel.org
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fpb+Z+Ix;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=kernel.org (client-ip=2600:3c04:e001:324:0:1991:8:25; helo=tor.source.kernel.org; envelope-from=xiang@kernel.org; receiver=lists.ozlabs.org)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jGM1K5kwQz2yFQ
	for <linux-erofs@lists.ozlabs.org>; Sat, 31 Oct 2026 00:11:17 +1100 (AEDT)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82F25601EE;
	Fri, 30 Oct 2026 13:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E741F000C1;
	Fri, 30 Oct 2026 13:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793365875;
	bh=uFwc7OGwgV6qEbtcl4yUPDjOXOBRcbZ3GesOPunvbTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fpb+Z+IxnPtTlpJtDcaUON4F0oERwIQum8BlognF85k6iAjaAPLAiffsDsG+Huxgf
	 FBwGA0u+F5NNpasmd0gGS4z/uPP/mMmG3RQSbEeWXoSYuu2w/0dLyBHIrm7PsDCm26
	 xEqb6my0BQ+B53HRKZxyaU7qmcz73NlAwz3143e5Z0LkMg0Sf4xic/UOF/UsF3R/8X
	 2qrDRHe//J/Hq8kBoPzOzz0ztMyonLPwX4ZLAi3a6ZCjSEmR1WBQVNr8bDuSGPyxKU
	 8T4zz8PLjN2oHEn8GN4lBHTzwJhZ0kXOBivSUoLjYKsVi2ndaVHHM0RdD3Ao8/8jQv
	 ZJEHCNzy77TkQ==
Date: Fri, 30 Oct 2026 14:11:08 +0100
From: Gao Xiang <xiang@kernel.org>
To: lanbingying <lanbingying.lby@linux.alibaba.com>
Cc: linux-erofs <linux-erofs@lists.ozlabs.org>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
Subject: Re: [RFC] erofs-utils: addressing the 16 GiB xattr prefix offset
 limit in incremental builds
Message-ID: <auSXbEqArY8gbYKy@MacBookPro>
Mail-Followup-To: lanbingying <lanbingying.lby@linux.alibaba.com>,
	linux-erofs <linux-erofs@lists.ozlabs.org>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>
References: <ede0d70f-a0f4-41f6-b2ee-5ec238b2fd01.lanbingying.lby@linux.alibaba.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ede0d70f-a0f4-41f6-b2ee-5ec238b2fd01.lanbingying.lby@linux.alibaba.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Fri, Oct 30, 2026 at 04:32:48PM +0800, lanbingying wrote:
> Hi,
> xattr_prefix_start is a 32-bit field storing an offset in four-byte units. When an incremental build places a new long xattr name prefix table at or beyond 16 GiB, the offset cannot be represented and mkfs.erofs rejects the build.
> Before working on patches, I would like to discuss several possible solutions:

Thanks for discussing this.

I wonder in which case the long xattr name prefix table needs to be
extended?

> 
>  * 
> Store the prefix table in the packed inode.
> Use the existing format support so that the table is addressed by a logical offset within the packed inode rather than a physical offset in the image. This avoids a format extension, although the table’s logical offset remains subject to the same limit, and existing references to fragment data must be preserved.

I think we can this one.  Currently, it seems that mkfs.erofs should
support keeping long xattr name prefix table in the packed inode,
but I'm not sure if it supports incremental builds.

> 
>  * 
> Reserve space for the prefix table near the beginning of the image.
> Reserve sufficient space at a low offset when creating the image, with a feature flag identifying this layout. Subsequent incremental builds would use the reserved region, while images without the flag would retain the existing behavior. Existing images without reserved space would require migration or rebuilding to adopt this layout.

I think this one is okay too, and it's doable, maybe even without a new
feature flag. 

> 
>  * 
> Extend the offset using reserved superblock space.
> Add an upper field for xattr_prefix_start in the superblock’s reserved space and combine it with the existing field. A new incompat feature would enable the extended interpretation; without it, readers would retain the current interpretation. This would allow the table to remain appended to the image, but require reader updates.

I don't think it needs to be done, because long xattr name prefix
table has 128 entries at most. we could just reserve at the beginning.

and long xattr name prefix table table should not be vulnerable to
change a lot when doing incremental builds.

> 
>  * 
> Reserve space for the prefix table within the packed inode.

This one is doable too.

Thanks,
Gao Xiang

> Building on option 1, reserve a dedicated region at a low logical offset within the packed inode when creating the image. Subsequent incremental builds could use this region instead of appending a new table after the growing fragment data. A feature flag could identify the reservation; existing images without such a region would need a migration or rebuild path.
> All options should preserve the interpretation of existing images. Where a new interpretation is introduced, readers that do not support it should reject the feature rather than read the table from an incorrect location.
> Separately, we could reuse the existing prefix table when the required prefix entries and their indices match those in the base image, provided the original table remains valid and accessible. For example, newly added files may use existing long prefixes even if their xattr values differ, so no table update is needed. This would avoid writing another identical table at the end of the image. However, it is an optimization rather than a complete solution: the addressing limit still needs to be handled when new prefixes are added or the table must be relocated.
> Which approach would best fit EROFS’s long-term format and maintenance goals? Are there other options or constraints that should be considered?
> Thanks,
> Bingying

