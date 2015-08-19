# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils git-2

EGIT_BRANCH=kogaion
EGIT_REPO_URI="https://github.com/Rogentos/mintmenu.git"

DESCRIPTION="Advanced MATE menu"
HOMEPAGE="http://linuxmint.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

DEPEND="
	dev-lang/python:2.7
	dev-python/pygtk:2
	>=dev-python/pyxdg-0.25
	>=dev-python/python-xlib-0.14"
RDEPEND="
	>=mate-base/mate-desktop-1.8.0
	>=mate-base/mate-panel-1.8.0
	>=mate-base/mate-menus-1.8.0[python]
	>=x11-misc/mozo-1.8.0
	dev-python/python-xlib"

S="${WORKDIR}/${PN}"

src_install() {
	exeinto /usr/bin || die
	doexe usr/bin/${PN} || die

	insinto /usr/$(get_libdir) || die
	doins -r usr/lib/* || die
	fperms 755 /usr/$(get_libdir)/linuxmint/mintMenu/mintMenu.py || die
	fperms 755 /usr/$(get_libdir)/linuxmint/mintMenu/mintMenuConfig.py || die
	
	insinto /usr/share || die
	doins -r usr/share/* || die
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
