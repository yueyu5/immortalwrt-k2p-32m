#!/bin/bash
# ==============================================
# Phicomm K2P 32M 硬改适配
# 不删除原行，仅修改IMAGE_SIZE数值，完美适配你提供的源码
# ==============================================

# 同步修改DTS设备树，系统识别完整32M闪存
###### K2P-32M修改编译文件 ######
sed -i 's/15744k/32128k/g' target/linux/ramips/image/mt7621.mk
sed -i 's/"Phicomm K2P";/"Phicomm K2P-32M";/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i '/spi-max-frequency/a\\t\tbroken-flash-reset;' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i 's/<0xa0000 0xf60000>/<0xa0000 0x1f60000>/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts

#【核心】添加MTK官方闭源驱动Feed（驱动+LuCI界面全包含）
# 先清空重复行，避免冲突
sed -i '/mtk-openwrt-feeds/d' feeds.conf.default
echo "src-git mtk_wifi https://github.com/Nossiac/mtk-openwrt-feeds.git;master" >> feeds.conf.default

# 添加SSR-Plus官方稳定源
echo "src-git helloworld https://github.com/fw876/helloworld.git;master" >> feeds.conf.default

# SSR-Plus必需依赖：替换dnsmasq为full版本
sed -i 's/CONFIG_PACKAGE_dnsmasq=y/CONFIG_PACKAGE_dnsmasq=n/g' .config 2>/dev/null
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config
