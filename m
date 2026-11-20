Received: from lists.ozlabs.org (lists.ozlabs.org [112.213.38.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7071A606A320
	for <linux-erofs@archiver.kernel.org>; Fri, 20 Nov 2026 12:24:02 +0000 (UTC)
Received: from boromir.ozlabs.org (localhost [127.0.0.1])
	by lists.ozlabs.org (Postfix) with ESMTP id 4jWDz50lXHz2yQl;
	Fri, 20 Nov 2026 23:24:01 +1100 (AEDT)
Authentication-Results: lists.ozlabs.org; arc=none smtp.remote-ip=165.204.217.251
ARC-Seal: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707; t=1795177441;
	cv=none; b=irVXbD/1B3JVHDi2CnWkJa/pm5saFW/0B0AbV+yqEHtoHuHNmV7SsX4pFW/XV3WtteCh42JtorDa7vL30TkAggPDj3IqYTF94SJqpqcdzK9x9OebzIUsOIyBDZOXvz4/TV0zAoCCSWJyI0wy1zk9fhPxNEg4KZiy0RVaV97ExbwF7PHntj5CMOVZ0J+oBmbkEvpG6ABLcF1duNBbtx/B/f/5hQeFmidI2fK7z/XwQZNSejB+kSkYtHHLAuxQsPf0UIhjp9USLvd/olsLbz8SGA//NKHBamJ9BxFLx6OP4nY7Xw51rpB/IkYYwnrnaDh9WPGdqGphQQKnXUO4kCM/Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=lists.ozlabs.org; s=201707;
	t=1795177441; c=relaxed/relaxed;
	bh=APffcVtOjBkP4hCMOBGuJfnYZEvna26cwsWN9sZxx14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gnftw/0KIUprcko455gNSW2O59mI/vrNLs0Ig6Sef6WCl60jFbnGgSOYmyjlNwSqpYQoTyqtntMB79m8sHAfsIJu69+avRtCrCrNg336D5cs8PbxRXpT4+gm7QTC+aDRBBufkBSyqmv7hG8f6R1WNsbjTOPT140WbUZjnksIYA51t0m8olwr/1zZoxeuAnWV4U0jUaoRx/KIdsPU4P4PqPrwsZikQ7yRzWliqpewh+oobvNqxofke1CTNhFJBW7cjyMrb0NgcJS6G6+rO+FynzPujfPfvS1BZ5tbunjOucV6nOOlkpTP/VveRNQf7hGWlOQo7wEH5oQHnKXQkCyIpg==
ARC-Authentication-Results: i=1; lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=none (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org) smtp.mailfrom=aocl-turin-03-9e62.amd.com
Authentication-Results: lists.ozlabs.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: lists.ozlabs.org; spf=none (no SPF record) smtp.mailfrom=aocl-turin-03-9e62.amd.com (client-ip=165.204.217.251; helo=aocl-turin-03-9e62.amd.com; envelope-from=amd@aocl-turin-03-9e62.amd.com; receiver=lists.ozlabs.org)
Received: from aocl-turin-03-9e62.amd.com (unknown [165.204.217.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lists.ozlabs.org (Postfix) with ESMTPS id 4jWDz42hrfz2xpt
	for <linux-erofs@lists.ozlabs.org>; Fri, 20 Nov 2026 23:23:59 +1100 (AEDT)
Received: by aocl-turin-03-9e62.amd.com (Postfix, from userid 1000)
	id 31AF417206FE; Fri, 20 Nov 2026 12:23:56 +0000 (UTC)
From: "S. Biplab Raut" <Biplab.Raut@amd.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>,
	linux-erofs@lists.ozlabs.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] lib/lz4: add KUnit tests for compression and decompression
Date: Fri, 20 Nov 2026 12:23:56 +0000
Message-ID: <20261120122356.2801415-1-Biplab.Raut@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e8235bd4-ad04-49d2-a5f6-f83463a8f8b6@samsung.com>
References: <e8235bd4-ad04-49d2-a5f6-f83463a8f8b6@samsung.com>
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
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Michal,

Thanks for running the suite on v3 and for taking the tests in.

I'm fine with you carrying my patch in v3 with the HC work-memory fix
for levels 10-12 via lz4hc_mem_compress(level).
I'll re-run the KUnit suite on v3 once it is on the list.

Thanks,
S. Biplab Raut

