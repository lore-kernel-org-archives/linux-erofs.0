Return-Path: <linux-erofs+bounces-3223-linux-erofs=archiver.kernel.org@lists.ozlabs.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A92FD5F6E
	for <linux-erofs@archiver.kernel.org>; Wed,  8 Apr 2026 04:41:38 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4fr9Pr4r0fz2yZN;
	Wed, 08 Apr 2026 14:41:36 +1000 (AEST)
Authentication-Results: lists.ozlabs.org; arc=pass smtp.remote-ip=103.117.158.51 arc.chain=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1775623296;
	cv=pass; b=KK7MTItQNMMgsC29G/i6n8UzUc1ZzDk1n9HbKLCMi4Ds2AfAUcJYQ3qiy2EIGYdvpIIqKVFp+Cyq6nv6v1qpPjY/K4sEKjFV5hhKb2GN0mA+sHxh0nueyq7rRo9VvkSkDRwusKqTgrtaYQtqQt+QA25Oc9l088Ij0VbLHXko0zwv52dHoLQPql1nSYTk+nDpwtXQlmx0DiEU4QTGxIYqixbumj553dVH7JCB3OVguQOZ2NTQIg8hpkPjF5AtyBMRmOxddmRmBu29MQjj+tAsB85mOIUkfiHzaTiX9+M6RhRHv3Ui0BO1Jwl2cC6Hcf27D+An/JVIn/N18HKI2n6HrQ==
ARC-Message-Signature: i=2; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1775623296; c=relaxed/relaxed;
	bh=nB95EDcBDe2OPhDqzplZ3Ir4R6jvGuogOxJx44vtdzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IueW/YWW2DpE0rA3q3FQXsn4P66zp5hmGZZPqv8qVbIVG0PAiItdkGjJ2cBYEn5Tdp4ToX2uCMtdHHSDCwqJbZvIeiH2d6LVFXEVfm9+LAVY8P8TwGVcn2acgBgTywdt91yqY+/ZxRyT/bEVdbVdk9ARyD70n+ssgnI4zPDgHJ0Lx2OjOYYtDSG3wfktb1HnDAJSV3TEgq13AZrPMubod+chWD51T4UySNHpEnnNYIL+UpjreLMNa2ux3kUOJZhfm6+KxgtWuvUPWy8/hVtDTOo52cVdcHfexZfaxxCLHtct9rHlee9P7+LUiK4iUvgKFQCq5ew6s3aYx5hRObSBHA==
ARC-Authentication-Results: i=2; lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in; dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=SPQCWEbJ; dkim-atps=neutral; spf=pass (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org) smtp.mailfrom=vnsh.in
Authentication-Results: lists.ozlabs.org; dmarc=none (p=none dis=none) header.from=vnsh.in
Authentication-Results: lists.ozlabs.org;
	dkim=pass (1024-bit key; unprotected) header.d=vnsh.in header.i=ch@vnsh.in header.a=rsa-sha256 header.s=zoho header.b=SPQCWEbJ;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=vnsh.in (client-ip=103.117.158.51; helo=sender-of-o51.zoho.in; envelope-from=ch@vnsh.in; receiver=lists.ozlabs.org)
Received: from sender-of-o51.zoho.in (sender-of-o51.zoho.in [103.117.158.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4fr9Pq1zYnz2xm5
	for <linux-erofs@lists.ozlabs.org>; Wed, 08 Apr 2026 14:41:34 +1000 (AEST)
ARC-Seal: i=1; a=rsa-sha256; t=1775623288; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=MfezIXdemR4EeRx6Fpjj4klFIX8WD9QabTgm6Cj6PAjZZlsLDk3EdKyh8mbIWm2GOFnp7xM3lMKBLi3rX2+Uw7s6Gjc36kq1INv5m5nMSsqD7JKCFtaM9zvArpUhLFufE7HjKWqeoUFHdmiR8vTv8GgxzEowLgaAZsBmzl3Wf+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775623288; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nB95EDcBDe2OPhDqzplZ3Ir4R6jvGuogOxJx44vtdzk=; 
	b=c08jdDLlth0BfuTCB5xQde4QA1z7Kt6sQB3dqrgVM8nGyx9IKZ7D2KRZR/C288j8ZaBXKk3lDtFJiG7eOsKEgro8IIePP1kaxjTosWY9J4G2T4zRH30WjPu6WOkBUdG34nd2aNZCg8BW4CWtbCbM3SCiyAMpYu6rRMgObNfURgo=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=vnsh.in;
	spf=pass  smtp.mailfrom=ch@vnsh.in;
	dmarc=pass header.from=<ch@vnsh.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775623288;
	s=zoho; d=vnsh.in; i=ch@vnsh.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=nB95EDcBDe2OPhDqzplZ3Ir4R6jvGuogOxJx44vtdzk=;
	b=SPQCWEbJQg2ZRr1c0DVMVYZN3AV/qZnoaGJgmykKvrUStd1xh20nPF0hRq+ogD4d
	UgV4YipLOEkWx2SvPbbSIWA4uCW4H6TXl/a6NCJDrC5TJR9vGOnRMo2mNjrCsoeyBDe
	e1o7OAz1dr8Ww48MgfZng83Qus9DkLY2NwREZp60=
Received: by mx.zoho.in with SMTPS id 1775623284702288.0287313939507;
	Wed, 8 Apr 2026 10:11:24 +0530 (IST)
From: Vansh Choudhary <ch@vnsh.in>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Vansh Choudhary <ch@vnsh.in>,
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH] erofs-utils: tar: fix negative GNU base-256 number parsing
Date: Wed,  8 Apr 2026 04:41:23 +0000
Message-ID: <20260408044123.2553-1-ch@vnsh.in>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ecdd65aa-0dc1-41fc-afb1-d949ca8f5fa9@linux.alibaba.com>
References: <ecdd65aa-0dc1-41fc-afb1-d949ca8f5fa9@linux.alibaba.com>
X-Mailing-List: linux-erofs@lists.ozlabs.org
List-Id: <linux-erofs.lists.ozlabs.org>
List-Help: <mailto:linux-erofs+help@lists.ozlabs.org>
List-Owner: <mailto:linux-erofs+owner@lists.ozlabs.org>
List-Post: <mailto:linux-erofs@lists.ozlabs.org>
List-Subscribe: <mailto:linux-erofs+subscribe@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-digest@lists.ozlabs.org>,
  <mailto:linux-erofs+subscribe-nomail@lists.ozlabs.org>
List-Unsubscribe: <mailto:linux-erofs+unsubscribe@lists.ozlabs.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Yes, this definitely fixes the signed-overflow UB in tarerofs_parsenum(),
and also makes the negative GNU base-256 decoding logic correct.  But
from the current testcase alone, I cannot firmly show a visible end-user
failure on the old code path.

So I think this is safest to describe as a correctness + UB fix.

Thanks,
Vansh

