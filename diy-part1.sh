#!/bin/bash
# ==============================================
# Phicomm K2P 32M 硬改适配
# 不删除原行，仅修改IMAGE_SIZE数值，完美适配你提供的源码
# ==============================================

# 同步修改DTS设备树，系统识别完整32M闪存
###### K2P-32M修改编译文件 ######
sed -i 's/15744k/31744k/g' target/linux/ramips/image/mt7621.mk
sed -i 's/"Phicomm K2P";/"Phicomm K2P-32M";/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i '/spi-max-frequency/a\\t\tbroken-flash-reset;' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i 's/<0xa0000 0xf60000>/<0xa0000 0x1f60000>/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts

# 移除不必要的语言包（节省空间）
find package -name "*zh-tw*" -type f -delete 2>/dev/null || true
find package -name "*zh_HK*" -type f -delete 2>/dev/null || true

# 添加Passwall源
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default

# 添加aliddns源
echo "src-git aliddns https://gitcode.com/gh_mirrors/lu/luci-app-aliddns;main" >> feeds.conf.default

# 添加SSR-Plus官方稳定源
#echo "src-git helloworld https://github.com/fw876/helloworld.git;master" >> feeds.conf.default
# 添加 aliddns
#echo 'src-git aliddns https://github.com/kenzok78/luci-app-aliddns' >> feeds.conf.default

# 删除官方 Argon 主题
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config 2>/dev/nul
# Argon主题 master 分支
echo "src-git argon https://github.com/jerrykuku/luci-theme-argon.git;master" >> feeds.conf.default
# Argon主题设置插件
echo "src-git argoncfg https://github.com/jerrykuku/luci-app-argon-config.git;master" >> feeds.conf.default

