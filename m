Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BF3606A331
	for <linux-erofs@archiver.kernel.org>; Mon, 16 Nov 2026 12:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UHpVSS9c
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jSmfP5m6zz3cGY;
	Mon, 16 Nov 2026 23:01:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip="2a00:1450:4864:20::448"
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1794830461;
	cv=none; b=UE5fRXFA7wbruQ4c5yCT1GDfiH3vT+MnW1/0QM4kkj2o4CP96TelfqYm3V8qqZ1q0h3HFtC/glGi1WC/A9/7FBY3LtvO5z5DHOHpeyBlernzfqAI8XNwD5NoCIeMQ4g90azBhuvXp0TGSE97vhJhXAnsZSx0HgKwIqPZ7RdZLAxF7GqnOR6bds7rpwiIk0mLCro3fDNor2BCmpsXqyPC7vjkaPW2xNH2kpQxm62jtO6w+98grhU1luZN7u/yaBLUA0PlrYoKWYytOlBSzcYXouVuFvcS8nUIW3/CFp940hCx9UilyrNUzY2rvQ/tCXzCszYXKAZ5e4ZYPdeHf/5aBA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1794830461; c=relaxed/relaxed;
	bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I1g1h0c7ek3bGEHpfEU25uBpcNCOuRyHZI4aN6TGrhAIRCg/sYXSkmz9Ujqg0vG0JSkfLQIZEf1VMydfAVJMgdzU+2OHqu18IJ5O9kK5Ior8EB46F8eWMsTbr+k4cstTR4ismSKhYtQF/MZcieE7qwxsWhcIqNOyRuDAgUpob93ceQEnNbDgDy6dDIAXVQjjkg3m+IrtfzR6yBGJwQZQXJhnS8Soz3fZzqk6U5gyiz+3Qwy7HzZJaYk2MxS2idnM+DeGr9Ew/L0TFI1w7qqcmY3B8E7RPgb6VSg4tSMKldHmuVKNgCpD/zoWp1yn094/2+M3yhNR0CbwhvH+5JXMXA==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com; dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UHpVSS9c; dkim-atps=neutral; spf=pass (client-ip=2a00:1450:4864:20::448; helo=mail-wr1-x448.google.com; envelope-from=3d_d6agkkc6icnkegtajniqqing.eqonkpwz-gtqhunkuvu.qbncdu.qti@flex--aliceryhl.bounces.google.com; receiver=lists.ozlabs.org) smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: lists.ozlabs.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: lists.ozlabs.org;
	dkim=pass (2048-bit key; unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UHpVSS9c;
	dkim-atps=neutral
Authentication-Results: lists.ozlabs.org; spf=pass (sender SPF authorized) smtp.mailfrom=flex--aliceryhl.bounces.google.com (client-ip=2a00:1450:4864:20::448; helo=mail-wr1-x448.google.com; envelope-from=3d_d6agkkc6icnkegtajniqqing.eqonkpwz-gtqhunkuvu.qbncdu.qti@flex--aliceryhl.bounces.google.com; receiver=lists.ozlabs.org)
Received: from mail-wr1-x448.google.com (mail-wr1-x448.google.com [IPv6:2a00:1450:4864:20::448])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jSmfN2DMTz3cDr
	for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 23:00:59 +1100 (AEDT)
Received: by mail-wr1-x448.google.com with SMTP id ffacd0b85a97d-49d70f45b22so1149903f8f.2
        for <linux-erofs@lists.ozlabs.org>; Mon, 16 Nov 2026 04:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794830456; x=1795435256; darn=lists.ozlabs.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=UHpVSS9cnlJh5s4tmJYgQA/CRXayM5CzW2tJvM1HfJnLjCE1UyRvu2tlMJPeEuPTg5
         pLeonrS1tx9uF9k6VXMgp6fY+Y+d2wNQf3/XFHsrENYQbGgGMELq0mMsFU6pLvQ02aCo
         JaJJnq4SMaAHSpclbeIrcaXz51BCbD2E6uktIPntN2mrhw8Du9eOndMM6ijMvH+PmfEG
         PYt2NPDjNtp75VdkB1aSKQhFEh0967qXrhbv4+u5OmEWZT4Ib0zOZPMupyJPAX0RjasZ
         ztlFHUr51rUIKEUg8HxWKKXjn5LhxT5FyQ96gPbiU866bgjvLwAmFJOKbPRDgaElLnJU
         /VqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794830456; x=1795435256;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=ZF7HrBQs9gmyFG+ch04rLRjeYwqvypVimJudKRwi3b+G+/i7Q/99pBbpfG5PI9BffV
         SmV4h/p4qM8UiCQEe0NEkSlZMBEUSBY/5lE2LVKCdTla7VNvt/HZeSnitNcDXCEkUw13
         R+N7iB20gmLRY0qrwdyNWaM1PMln4Ofc5lviNB8ixv05IY35BpsopDHOMrvlFUw3h5AR
         UH964Q9tfpihjSbtRYQYlr9QujPxEZrWIpgI6RyybyXljCoPyolrR2qRNWpC+ZnTrQ70
         UlQdU2wLV3+pSUcF/Q56b4qML9jfu9kKAOa7eXkmCT2Et3DFqyDxGHFw5PEuCVZZlGwT
         JWKQ==
X-Forwarded-Encrypted: i=1; AL+hErG/GEUS8zWvEKJtJJ7u+Y/a8oqFe8+27ZeoKWO3B2n3nYLuiqTO1wJ7avfUteaqrNB6pxeAdFt7qnXFeg==@lists.ozlabs.org
X-Gm-Message-State: APuU4Z+TXJxjc/0duG0RHTdYIQqgve4p2IWTSYnJTht1/L/hlICPF7Wu
	u3fFat4ODsRBqnBMRouUuQHkg16p+lPbv0h/IbeycUL3lHD8XL173K1zJJnU6TUEkOoAFJ/gOCC
	CuhcCmbEwEDzNOIwyvg==
X-Received: from wrso13.prod.google.com ([2002:a5d:474d:0:b0:493:3d97:6e88])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e007:0:20b0:48e:3697:708d with SMTP id ffacd0b85a97d-49c70ed8e41mr16698595f8f.12.1794830455230;
 Mon, 16 Nov 2026 04:00:55 -0800 (PST)
Date: Mon, 16 Nov 2026 12:00:53 +0000
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
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
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116120053.371591-1-aliceryhl@google.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
From: Alice Ryhl <aliceryhl@google.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:04:45PM +0100, Christian Brauner wrote:
> Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

