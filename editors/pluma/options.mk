# $NetBSD: options.mk,v 1.10 2019/06/30 13:34:40 gutteridge Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.pluma
PKG_SUPPORTED_OPTIONS=	enchant
PKG_SUGGESTED_OPTIONS=	enchant

.include "../../mk/bsd.options.mk"

PLIST_VARS+=	enchant python

.if !empty(PKG_OPTIONS:Menchant)
.include "../../textproc/enchant2/buildlink3.mk"
.include "../../textproc/iso-codes/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-spell
PLIST.enchant=	yes
.else
CONFIGURE_ARGS+=	--disable-spell
.endif

# The python option is logically impossible right now.  This option sets python
# 3.x as being incompatible, yet pluma depends on libpeas which itself sets 2.x
# as being incompatible, leaving us with no remaining choices.
.if !empty(PKG_OPTIONS:Mpython)
CONFIGURE_ARGS+=	--enable-python
USE_TOOLS+=	bash:run
REPLACE_PYTHON+=	plugins/externaltools/data/switch-c.tool.in
REPLACE_BASH+=	plugins/externaltools/data/search-recursive.tool.in
PLIST.python=	yes
PYTHON_VERSIONS_INCOMPATIBLE=	 36 37 # py-gtk2, also via py-gtksourceview
.include "../../devel/py-gobject/buildlink3.mk"
.include "../../x11/py-gtk2/buildlink3.mk"
.include "../../x11/py-gtksourceview/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-python
# XXX: Due to the mess described above, and the fact that python is required
# by the build process but is not python3 compatible, we need to override and
# use python2.7 explicitly.
TOOL_DEPENDS+=		python27-[0-9]*:../../lang/python27
PYTHONBIN=		${PREFIX}/bin/python2.7
.endif
