# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/noad/noad-0.7.2-r2.ebuild,v 1.2 2011/04/06 17:33:09 idl0r Exp $

EAPI="3"

inherit eutils flag-o-matic autotools

DESCRIPTION="Mark commercial Breaks in VDR records"
HOMEPAGE="http://noad.heliohost.org/"
SRC_URI="http://noad.heliohost.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg imagemagick"

DEPEND="media-libs/libmpeg2
	ffmpeg? ( >=virtual/ffmpeg-0.4.8 )
	imagemagick? ( >=media-gfx/imagemagick-6.2.4.2-r1 )
	!media-plugins/vdr-markad"
RDEPEND="${DEPEND}"

src_prepare() {

	epatch "${FILESDIR}"/patches-0.7.x/"${P}"-hangcheck.diff
	epatch "${FILESDIR}"/patches-0.7.x/"${P}"-cflags.patch
	epatch "${FILESDIR}"/patches-0.7.x/"${P}"-libav.patch
	eautoreconf
	# UINT64_C is needed by ffmpeg headers
	append-flags -D__STDC_CONSTANT_MACROS

	if has_version ">=media-video/vdr-1.7.15"; then
		sed -e "s:2001:6419:" -i svdrpc.cpp
	fi
}

src_configure() {

	local=myconf
	use ffmpeg && myconf="--with-ffmpeg --with-ffmpeginclude=/usr/include"

	econf \
	${myconf} \
	$(use_with imagemagick magick) \
	--with-mpeginclude=/usr/include/mpeg2dec
#	--with-tools # fails on showindex, marcpics compile
}

src_install() {

	dobin noad
#       fix me later!
#       dobin noad showindex
#	use imagemagick && dobin markpics

	dodoc README INSTALL
	# example scripts are installed as dokumentation
	dodoc allnewnoad allnoad allnoadnice clearlogos noadifnew stat2html

	CONF_SOURCE="${FILESDIR}/0.7.1"
	newconfd "${CONF_SOURCE}"/confd_vdraddon.noad vdraddon.noad

	insinto /usr/share/vdr/record
	doins "${CONF_SOURCE}"/record-50-noad.sh

	insinto /usr/share/vdr/shutdown
	doins "${FILESDIR}"/pre-shutdown-15-noad.sh

	insinto /etc/vdr/reccmds
	doins "${CONF_SOURCE}"/reccmds.noad.conf

	exeinto /usr/share/vdr/bin
	doexe "${CONF_SOURCE}"/noad-reccmd
}

pkg_postinst() {

	elog
	elog "Congratulations, you have just installed noad!,"
	elog "To integrate noad in VDR you should do this:"
	elog
	elog "start and set Parameter in /etc/conf.d/vdraddon.noad"
	elog
	elog "Note: You can use here all pararmeters for noad,"
	elog "please look in the documentation of noad."
}
