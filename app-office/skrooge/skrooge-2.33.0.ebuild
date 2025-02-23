# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm kde.org

DESCRIPTION="Personal finances manager, aiming at being simple and intuitive"
HOMEPAGE="https://skrooge.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz
		https://dev.gentoo.org/~asturm/distfiles/${P}-cmake.patch.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="activities ofx"

# hangs + installs files (also requires KF5DesignerPlugin)
RESTRICT="test"

COMMON_DEPEND="
	>=app-crypt/qca-2.3.9:2[qt5(-)]
	dev-db/sqlcipher
	dev-libs/grantlee:5
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5=
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	activities? ( >=kde-plasma/plasma-activities-${KFMIN}:5 )
	ofx? ( dev-libs/libofx:= )
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
"
BDEPEND="
	dev-libs/libxslt
	virtual/pkgconfig
"

# Pending: https://invent.kde.org/office/skrooge/-/merge_requests/52
PATCHES=( "${WORKDIR}/${P}-cmake.patch" )

src_configure() {
	local mycmakeargs=(
		-DSKG_WEBENGINE=ON
		-DSKG_WEBKIT=OFF
		-DSKG_DESIGNER=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5Runner=ON
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package ofx LibOfx)
		-DSKG_BUILD_TEST=$(usex test)
	)

	ecm_src_configure
}

src_test() {
	local mycmakeargs=(
		-DSKG_BUILD_TEST=ON
	)
	ecm_src_test
}
