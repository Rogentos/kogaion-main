# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/menelkir/portage/app-benchmark/hardinfo/hardinfo-9999.ebuild,v 1.440 2010/05/31 10:20:14 menelkir Exp $

inherit git-2

EGIT_REPO_URI="git://github.com/lpereira/hardinfo.git"

DESCRIPTION="HardInfo can gather information about your system's hardware and operating system, perform benchmarks, and generate printable reports"
HOMEPAGE="http://hardinfo.berlios.de/HomePage"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0
	net-libs/libsoup"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}2

src_unpack() {
	subversion_src_unpack
	cd ${S}
	mv ${PN}2/* ./
}

src_compile() {
	econf || die "econf"
	emake || die "emake"
}

src_install() {
	emake DESTDIR=${D} install || die "einstall"
}
